const express = require('express');
const http = require('http');
const { Server } = require('socket.io');
const { spawn } = require('child_process');
const fs = require('fs');
const path = require('path');
const bodyParser = require('body-parser');

const app = express();
const server = http.createServer(app);
const io = new Server(server);
const PORT = process.env.PORT || 3000;

let currentProcess = null;
let logHistory = [];
let currentStatus = 'idle';
let isProgressVisible = false;

let isCollectingPods = false;
let podSummaryBuffer = [];

const emitLog = (message) => {
    logHistory.push(message);
    io.emit('log', message);

    const messageLines = message.split('\n');
    for (const msg of messageLines) {
        if (!msg.trim()) continue;

        // Start collecting when we see the beginning of the JSON object
        if (msg.includes('module.compute.null_resource.display_pods (remote-exec): {')) {
            isCollectingPods = true;
            podSummaryBuffer = ['{'];
            continue;
        }

        if (isCollectingPods) {
            // Stop collecting when the resource creation completes
            if (msg.includes('module.compute.null_resource.display_pods: Creation complete')) {
                isCollectingPods = false;
                try {
                    const fullJson = podSummaryBuffer.join('');
                    const podData = JSON.parse(fullJson);

                    // Transform K8s JSON to a simple format for the frontend
                    const summary = podData.items.map(pod => {
                        const name = pod.metadata.name;
                        const ready = pod.status.containerStatuses ?
                            `${pod.status.containerStatuses.filter(s => s.ready).length}/${pod.status.containerStatuses.length}` : '0/0';
                        const status = pod.status.phase;
                        const restarts = pod.status.containerStatuses ?
                            pod.status.containerStatuses.reduce((acc, s) => acc + s.restartCount, 0) : 0;
                        const age = pod.metadata.creationTimestamp; // Simplified age for now

                        return { name, ready, status, restarts, age };
                    });

                    io.emit('pod-summary', JSON.stringify(summary));
                } catch (e) {
                    console.error('Failed to parse pod JSON:', e);
                    // Fallback or emit error? 
                    // Just emit the raw buffer if parsing fails for some reason
                    io.emit('pod-summary', 'Error: Failed to parse pod status JSON');
                }
            } else {
                const match = msg.match(/module\.compute\.null_resource\.display_pods \(remote-exec\):\s*(.*)/);
                if (match && match[1]) {
                    podSummaryBuffer.push(match[1]);
                }
            }
        }
    }
};

const setStatus = (status) => {
    currentStatus = status;
    io.emit('status', status);
};

const setProgressVisibility = (visible) => {
    isProgressVisible = visible;
    io.emit('progress-visibility', visible);
};

const clearLogs = () => {
    logHistory = [];
    isCollectingPods = false;
    podSummaryBuffer = [];
    io.emit('clear-logs');
};

app.use(bodyParser.json());
app.use(express.static('public'));

// Helper to update .tfvars file
const updateTfVars = (vars) => {
    let content = '';
    const ignoreKeys = vars.useOciCli ? ['user_ocid', 'tenancy_ocid', 'fingerprint', 'private_key_path', 'region'] : [];

    for (const [key, value] of Object.entries(vars)) {
        if (key === 'useOciCli') continue;
        if (ignoreKeys.includes(key)) continue;

        if (value !== undefined && value !== null && value !== '') {
            content += `${key} = "${value}"\n`;
        }
    }
    fs.writeFileSync(path.join(__dirname, 'terraform.tfvars'), content);
};

// Helper to parse OCI config
const getOciCliConfig = () => {
    const configPath = path.join(process.env.HOME || process.env.USERPROFILE, '.oci', 'config');
    if (!fs.existsSync(configPath)) return null;
    const content = fs.readFileSync(configPath, 'utf-8');
    const vars = {};
    let inDefault = false;
    content.split('\n').forEach(line => {
        line = line.trim();
        if (line === '[DEFAULT]') inDefault = true;
        else if (line.startsWith('[') && line.endsWith(']')) inDefault = false;
        else if (inDefault && line.includes('=')) {
            const [key, ...rest] = line.split('=');
            vars[key.trim()] = rest.join('=').trim();
        }
    });
    return vars;
};

// Terraform command execution with real-time streaming
const runTerraform = (socket, args, env = process.env) => {
    const tf = spawn('terraform', args, { env });
    currentProcess = tf;

    tf.stdout.on('data', (data) => {
        emitLog(data.toString());
    });

    tf.stderr.on('data', (data) => {
        emitLog(`ERROR: ${data.toString()}`);
    });

    tf.on('close', (code) => {
        emitLog(`Process finished with code ${code}`);
        setStatus(code === 0 ? 'success' : 'failure');
        currentProcess = null;
    });
};

// Helper to parse .tfvars file
const parseTfVars = () => {
    const filePath = path.join(__dirname, 'terraform.tfvars');
    if (!fs.existsSync(filePath)) return {};
    const content = fs.readFileSync(filePath, 'utf-8');
    const vars = {};
    const lines = content.split('\n');
    lines.forEach(line => {
        const match = line.match(/^\s*(\w+)\s*=\s*"([^"]*)"/);
        if (match) {
            vars[match[1]] = match[2];
        }
    });
    return vars;
};

io.on('connection', (socket) => {
    console.log('Client connected');

    // Send existing state to client on connection
    socket.emit('tfvars', parseTfVars());
    socket.emit('log-history', logHistory);
    socket.emit('status', currentStatus);
    socket.emit('progress-visibility', isProgressVisible);

    socket.on('plan', (vars) => {
        clearLogs();
        emitLog('--- Starting Plan ---');
        try {
            updateTfVars(vars);
            emitLog('terraform.tfvars updated.');

            const timeoutEnv = { ...process.env, TF_HTTP_TIMEOUT: '900' };
            setStatus('running');
            setProgressVisibility(false);
            if (vars.useOciCli) {
                const ociConfig = getOciCliConfig();
                if (ociConfig) {
                    timeoutEnv.TF_VAR_user_ocid = ociConfig.user;
                    timeoutEnv.TF_VAR_tenancy_ocid = ociConfig.tenancy;
                    timeoutEnv.TF_VAR_fingerprint = ociConfig.fingerprint;
                    timeoutEnv.TF_VAR_private_key_path = ociConfig.key_file.replace('~', process.env.HOME || process.env.USERPROFILE);
                    timeoutEnv.TF_VAR_region = ociConfig.region;
                    socket.emit('log', 'Using OCI CLI default config via environment variables.');
                } else {
                    socket.emit('log', 'ERROR: OCI config file not found. Falling back to defaults.');
                }
            }

            const timeoutLog = vars.os_type === 'windows' ? 'set TF_HTTP_TIMEOUT=900' : 'export TF_HTTP_TIMEOUT=900';
            socket.emit('log', `Running: ${timeoutLog}`);

            socket.emit('log', 'Running: terraform init');
            const init = spawn('terraform', ['init', '-no-color'], { env: timeoutEnv });
            currentProcess = init;
            init.stdout.on('data', (data) => emitLog(data.toString()));
            init.stderr.on('data', (data) => emitLog(`ERROR: ${data.toString()}`));
            init.on('close', (code) => {
                currentProcess = null;
                if (code === 0) {
                    runTerraform(io, ['plan', '-no-color'], timeoutEnv);
                } else {
                    emitLog('terraform init failed.');
                    setStatus('failure');
                }
            });
        } catch (err) {
            socket.emit('log', `Error: ${err.message}`);
            socket.emit('status', 'failure');
        }
    });

    socket.on('deploy', (vars) => {
        clearLogs();
        emitLog('--- Starting Deployment (Apply) ---');
        try {
            updateTfVars(vars);
            emitLog('terraform.tfvars updated.');

            const timeoutEnv = { ...process.env, TF_HTTP_TIMEOUT: '900' };
            setStatus('running');
            setProgressVisibility(true);

            if (vars.useOciCli) {
                const ociConfig = getOciCliConfig();
                if (ociConfig) {
                    timeoutEnv.TF_VAR_user_ocid = ociConfig.user;
                    timeoutEnv.TF_VAR_tenancy_ocid = ociConfig.tenancy;
                    timeoutEnv.TF_VAR_fingerprint = ociConfig.fingerprint;
                    timeoutEnv.TF_VAR_private_key_path = ociConfig.key_file.replace('~', process.env.HOME || process.env.USERPROFILE);
                    timeoutEnv.TF_VAR_region = ociConfig.region;
                    emitLog('Using OCI CLI default config via environment variables.');
                } else {
                    emitLog('ERROR: OCI config file not found. Falling back to defaults.');
                }
            }

            const timeoutLog = vars.os_type === 'windows' ? 'set TF_HTTP_TIMEOUT=900' : 'export TF_HTTP_TIMEOUT=900';
            emitLog(`Running: ${timeoutLog}`);

            emitLog('Running: terraform init');
            const init = spawn('terraform', ['init', '-no-color'], { env: timeoutEnv });
            currentProcess = init;
            init.stdout.on('data', (data) => emitLog(data.toString()));
            init.stderr.on('data', (data) => emitLog(`ERROR: ${data.toString()}`));
            init.on('close', (code) => {
                currentProcess = null;
                if (code === 0) {
                    runTerraform(io, ['apply', '-auto-approve', '-no-color'], timeoutEnv);
                } else {
                    emitLog('terraform init failed.');
                    setStatus('failure');
                }
            });
        } catch (err) {
            socket.emit('log', `Error: ${err.message}`);
            socket.emit('status', 'failure');
        }
    });

    socket.on('destroy', (vars) => {
        clearLogs();
        emitLog('--- Starting Destruction ---');
        try {
            updateTfVars(vars);
            emitLog('terraform.tfvars updated.');

            const timeoutEnv = { ...process.env, TF_HTTP_TIMEOUT: '900' };
            setStatus('running');
            setProgressVisibility(true);

            if (vars.useOciCli) {
                const ociConfig = getOciCliConfig();
                if (ociConfig) {
                    timeoutEnv.TF_VAR_user_ocid = ociConfig.user;
                    timeoutEnv.TF_VAR_tenancy_ocid = ociConfig.tenancy;
                    timeoutEnv.TF_VAR_fingerprint = ociConfig.fingerprint;
                    timeoutEnv.TF_VAR_private_key_path = ociConfig.key_file.replace('~', process.env.HOME || process.env.USERPROFILE);
                    timeoutEnv.TF_VAR_region = ociConfig.region;
                    emitLog('Using OCI CLI default config via environment variables.');
                } else {
                    emitLog('ERROR: OCI config file not found. Falling back to defaults.');
                }
            }

            const timeoutLog = vars.os_type === 'windows' ? 'set TF_HTTP_TIMEOUT=900' : 'export TF_HTTP_TIMEOUT=900';
            emitLog(`Running: ${timeoutLog}`);

            emitLog('Running: terraform init');
            const init = spawn('terraform', ['init', '-no-color'], { env: timeoutEnv });
            currentProcess = init;
            init.stdout.on('data', (data) => emitLog(data.toString()));
            init.stderr.on('data', (data) => emitLog(`ERROR: ${data.toString()}`));
            init.on('close', (code) => {
                currentProcess = null;
                if (code === 0) {
                    runTerraform(io, ['destroy', '-auto-approve', '-no-color'], timeoutEnv);
                } else {
                    emitLog('terraform init failed.');
                    setStatus('failure');
                }
            });
        } catch (err) {
            emitLog(`Error: ${err.message}`);
            setStatus('failure');
        }
    });

    socket.on('kill', () => {
        if (currentProcess) {
            const pid = currentProcess.pid;
            const command = process.platform === 'win32'
                ? `taskkill /F /T /PID ${pid}`
                : `kill -9 ${pid}`;

            emitLog(`Force Killing process...`);
            emitLog(`Running command: ${command}`);

            const killExec = spawn(process.platform === 'win32' ? 'taskkill' : 'kill',
                process.platform === 'win32' ? ['/F', '/T', '/PID', pid] : ['-9', pid]);

            killExec.on('close', (code) => {
                emitLog(`Kill command finished with code ${code}`);
                currentProcess = null;
                setStatus('failure');
            });
        } else {
            socket.emit('log', 'No active Terraform process to kill.');
        }
    });

    socket.on('stop', () => {
        if (currentProcess) {
            emitLog('Attempting to stop Terraform gracefully (SIGINT)...');
            // Sending SIGINT is the same as Ctrl+C
            currentProcess.kill('SIGINT');

            // On Windows, child_process.kill('SIGINT') might just terminate.
            // But Terraform handles the interrupt specifically to clean up.
            emitLog('Signal SIGINT sent. Waiting for Terraform to clean up state...');
        } else {
            emitLog('No active Terraform process to stop.');
        }
    });
});

server.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
