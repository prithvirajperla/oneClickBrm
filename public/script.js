const socket = io();

// Motivational Quotes
const quotes = [
    "The best way to predict the future is to invent it.",
    "Small steps lead to big destinations.",
    "Automate the boring stuff so you can do the amazing stuff.",
    "Your hard work will pay off, just keep going.",
    "Excellence is not an act, but a habit.",
    "Success is the sum of small efforts, repeated day-in and day-out."
];

const quoteElement = document.getElementById('random-quote');
quoteElement.textContent = `"${quotes[Math.floor(Math.random() * quotes.length)]}"`;

// UI Elements
const logsContainer = document.getElementById('logs-container');
const statusIndicator = document.getElementById('status-indicator');
const progressBar = document.getElementById('progress-bar');
const progressText = document.getElementById('progress-text');
const progressContainer = document.getElementById('progress-container');
const popupOverlay = document.getElementById('popup-overlay');
const popupContainer = document.getElementById('popup-container');

// Auto-fill logic
socket.on('tfvars', (vars) => {
    for (const [key, value] of Object.entries(vars)) {
        const input = document.getElementById(key);
        if (input) {
            input.value = value;
        }
    }
});

// Popup logic
const showPopup = (title, message) => {
    popupContainer.innerHTML = `
        <h4>${title}</h4>
        <p>${message}</p>
        <button class="popup-close">Close</button>
    `;
    popupOverlay.style.display = 'block';
    popupContainer.style.display = 'block';

    popupContainer.querySelector('.popup-close').addEventListener('click', () => {
        popupOverlay.style.display = 'none';
        popupContainer.style.display = 'none';
    });
};

// Progress logic
const updateProgress = (percent) => {
    progressBar.style.width = `${percent}%`;
    progressText.textContent = `${percent}%`;
};

const checkLogsForProgress = (message) => {
    if (message.includes("module.compute.oci_core_instance.bastion: Creation complete after")) {
        updateProgress(20);
        showPopup("Bastion VM Deployed", "The Bastion Host is now up and running.");
    } else if (message.includes("module.compute.oci_containerengine_node_pool.node_pool: Creation complete after")) {
        updateProgress(40);
        showPopup("OKE Deployed", "The Oracle Kubernetes Engine node pool has been created.");
    } else if (message.includes("module.db.oci_database_db_system.db_vm: Creation complete")) {
        updateProgress(70);
        showPopup("Database is Deployed", "Your OCI DB System is now active.");
    } else if (message.includes("Terraform has been successfully initialized!")) {
        updateProgress(50);
    } else if (message.includes("Apply complete!") || message.includes("Process finished with code 0")) {
        updateProgress(100);
        if (message.includes("Apply complete!")) {
            showPopup("BRM Deployed", "Full deployment is finished successfully!");
        }
    }
};

// Log Handling
const appendLog = (message) => {
    const entry = document.createElement('div');
    entry.className = 'log-entry';
    entry.textContent = message;
    logsContainer.appendChild(entry);
    logsContainer.scrollTop = logsContainer.scrollHeight;
    checkLogsForProgress(message);
};

socket.on('log', (message) => {
    appendLog(message);
});

socket.on('status', (status) => {
    statusIndicator.className = `status-indicator ${status}`;
});

// Action Handlers
document.getElementById('plan-btn').addEventListener('click', () => {
    const formData = new FormData(document.getElementById('variable-form'));
    const vars = {};
    formData.forEach((value, key) => {
        vars[key] = value;
    });

    logsContainer.innerHTML = '';
    statusIndicator.className = 'status-indicator running';
    progressContainer.style.display = 'none'; // Plan doesn't need the progress bar
    updateProgress(0);
    socket.emit('plan', vars);
});

document.getElementById('deploy-btn').addEventListener('click', () => {
    const formData = new FormData(document.getElementById('variable-form'));
    const vars = {};
    formData.forEach((value, key) => {
        vars[key] = value;
    });

    logsContainer.innerHTML = '';
    statusIndicator.className = 'status-indicator running';
    progressContainer.style.display = 'block'; // Show progress bar for actual deployment
    updateProgress(0);
    socket.emit('deploy', vars);
});

// CIDR helpers
const ipToLong = (ip) => {
    return ip.split('.').reduce((long, octet) => (long << 8) + parseInt(octet, 10), 0) >>> 0;
};

const longToIp = (long) => {
    return [(long >>> 24) & 0xFF, (long >>> 16) & 0xFF, (long >>> 8) & 0xFF, long & 0xFF].join('.');
};

const calculateCidrSubnet = (baseCidr, newBits, netNum) => {
    try {
        const [ip, mask] = baseCidr.split('/');
        const prefix = parseInt(mask, 10);
        const newPrefix = prefix + newBits;

        if (newPrefix > 32) throw new Error("New prefix exceeds 32 bits");

        const baseLong = ipToLong(ip);
        const shift = 32 - newPrefix;
        const subnetLong = baseLong | (netNum << shift);

        return `${longToIp(subnetLong)}/${newPrefix}`;
    } catch (e) {
        return "Invalid Calculation";
    }
};

const subnetConfigs = [
    { name: "Bastion Subnet", bits: 12, num: 0 },
    { name: "Application Subnet", bits: 4, num: 1 },
    { name: "Database Subnet", bits: 4, num: 2 },
    { name: "Loadbalancer Subnet", bits: 12, num: 3 },
    { name: "Storage Subnet", bits: 11, num: 4 },
    { name: "OKE Subnet", bits: 12, num: 5 }
];

document.getElementById('preview-subnets-btn').addEventListener('click', () => {
    const vcnCidr = document.getElementById('vcn_cidr').value;
    const errorEl = document.getElementById('cidr-error');
    const detailsEl = document.getElementById('subnet-details');
    const tableBody = document.getElementById('subnet-table-body');

    if (!vcnCidr.match(/^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\/\d{1,2}$/)) {
        errorEl.textContent = "Please enter a valid CIDR (e.g., 10.0.0.0/16)";
        detailsEl.style.display = 'none';
        return;
    }

    errorEl.textContent = "";
    tableBody.innerHTML = "";

    subnetConfigs.forEach(config => {
        const result = calculateCidrSubnet(vcnCidr, config.bits, config.num);
        const row = `
            <tr>
                <td>${config.name}</td>
                <td><strong>${result}</strong></td>
                <td>cidrsubnet(vcn, ${config.bits}, ${config.num})</td>
            </tr>
        `;
        tableBody.insertAdjacentHTML('beforeend', row);
    });

    detailsEl.style.display = 'block';
});

document.getElementById('close-subnets-btn').addEventListener('click', () => {
    document.getElementById('subnet-details').style.display = 'none';
});

document.getElementById('destroy-btn').addEventListener('click', () => {
    if (confirm('Are you sure you want to destroy all resources?')) {
        logsContainer.innerHTML = '';
        statusIndicator.className = 'status-indicator running';
        progressContainer.style.display = 'block';
        updateProgress(0);
        socket.emit('destroy');
    }
});
