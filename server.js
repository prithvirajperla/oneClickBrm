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

    tf.stdout.on('data', (data) => {
        socket.emit('log', data.toString());
    });

    tf.stderr.on('data', (data) => {
        socket.emit('log', `ERROR: ${data.toString()}`);
    });

    tf.on('close', (code) => {
        socket.emit('log', `Process finished with code ${code}`);
        socket.emit('status', code === 0 ? 'success' : 'failure');
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

    // Send existing tfvars to client on connection
    socket.emit('tfvars', parseTfVars());

    socket.on('plan', (vars) => {
        socket.emit('log', '--- Starting Plan ---');
        try {
            updateTfVars(vars);
            socket.emit('log', 'terraform.tfvars updated.');

            const timeoutEnv = { ...process.env, TF_HTTP_TIMEOUT: '900' };
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
            init.stdout.on('data', (data) => socket.emit('log', data.toString()));
            init.stderr.on('data', (data) => socket.emit('log', `ERROR: ${data.toString()}`));
            init.on('close', (code) => {
                if (code === 0) {
                    runTerraform(socket, ['plan', '-no-color'], timeoutEnv);
                } else {
                    socket.emit('log', 'terraform init failed.');
                    socket.emit('status', 'failure');
                }
            });
        } catch (err) {
            socket.emit('log', `Error: ${err.message}`);
            socket.emit('status', 'failure');
        }
    });

    socket.on('deploy', (vars) => {
        socket.emit('log', '--- Starting Deployment (Apply) ---');
        try {
            updateTfVars(vars);
            socket.emit('log', 'terraform.tfvars updated.');

            const timeoutEnv = { ...process.env, TF_HTTP_TIMEOUT: '900' };
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
            init.stdout.on('data', (data) => socket.emit('log', data.toString()));
            init.stderr.on('data', (data) => socket.emit('log', `ERROR: ${data.toString()}`));
            init.on('close', (code) => {
                if (code === 0) {
                    runTerraform(socket, ['apply', '-auto-approve', '-no-color'], timeoutEnv);
                } else {
                    socket.emit('log', 'terraform init failed.');
                    socket.emit('status', 'failure');
                }
            });
        } catch (err) {
            socket.emit('log', `Error: ${err.message}`);
            socket.emit('status', 'failure');
        }
    });

    socket.on('destroy', () => {
        socket.emit('log', '--- Starting Destruction ---');
        const timeoutEnv = { ...process.env, TF_HTTP_TIMEOUT: '900' };
        runTerraform(socket, ['destroy', '-auto-approve', '-no-color'], timeoutEnv);
    });
});

server.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
