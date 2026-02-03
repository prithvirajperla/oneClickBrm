# One-Click BRM Deployment Utility

A modern, web-based utility designed to simplify OCI (Oracle Cloud Infrastructure) Terraform deployments for BRM. This tool provides a premium interface for variable management, real-time logging, and deployment progress tracking.

---

## 🚀 Features

- **Dynamic Form**: Auto-populated based on your `variable.tf` and current `.tfvars`.
- **Progress Tracking**: Real-time progress bar and milestone popups (Bastion, OKE, DB).
- **Automated Workflows**: One-click "Save & Plan" and "Destroy Resources".
- **Cross-Platform Support**: Optimized for Windows and Mac/Linux.
- **Clean Execution**: Automatically handles ANSI escape codes for clear terminal logs.

---

## 📋 Prerequisites

Before running the application, ensure you have the following requirements met:

### 1. Software Requirements
- **Node.js**: [Download and install Node.js](https://nodejs.org/) (v14.x or later).
- **Terraform**: [Download and install Terraform](https://www.terraform.io/downloads). Ensure the `terraform` executable is in your system **PATH**.
- **PowerShell** (Windows only): Used for the `manage.ps1` lifecycle script.

### 2. OCI Configuration (API Keys)
You need valid OCI API credentials. Ensure you have the following values ready:
- `user_ocid`: Your OCI user OCID.
- `tenancy_ocid`: Your OCI tenancy OCID.
- `fingerprint`: Fingerprint for your API key.
- `private_key_path`: Absolute path to your OCI API private key (`.pem`).

### 3. Cloud Infrastructure & Service Limits
The deployment uses specific OCI shapes. Ensure your tenancy has sufficient quota/service limits for:
- **Compute (Bastion & OKE)**: 
  - `VM.Standard.E4.Flex` (Example: 4 OCPUs, 16GB RAM for Bastion).
  - `VM.Standard.E5.Flex` or preferred shape for OKE Node Pool.
- **Database**: 
  - `VM.Standard2.1` or similar for DB System nodes.
- **Storage**: At least 256GB for Database and supplemental storage for File System (FSS).

### 4. Application Assets
- **Docker Registry**: Access credentials for the container registry hosting BRM images (Server, Username, Password/Auth Token).
- **OCIR Path**: The base URL for your Oracle Cloud Infrastructure Registry.

### 5. Local Setup
- **Network**: Port `3000` must be available on your localhost.
- **Internet Access**: Required for Terraform to download providers and for the utility to interact with OCI APIs.

---

## ⚡ Quick Setup (Windows)

For a fast installation of all prerequisites on Windows, open **PowerShell** as Administrator and run the following commands:

### 1. Install System Tools (via Winget)
```powershell
# Install Node.js
winget install OpenJS.NodeJS.LTS

# Install Terraform
winget install Hashicorp.Terraform

# Install OCI CLI (Optional but recommended)
winget install Oracle.OCI.CLI
```

### 2. Verify Installation
Restart your terminal and run:
```powershell
node -v
terraform -v
oci --version
```

---

### 1. Install Dependencies
Open your terminal in the project directory and run:
```powershell
npm install
```

### 2. Manage the Application
Use the provided PowerShell script (recommended for Windows users) to handle port conflicts and process management:

- **To Start/Restart**: 
  ```powershell
  .\manage.ps1 -Action start
  ```
- **To Stop**: 
  ```powershell
  .\manage.ps1 -Action stop
  ```

*Note: If you are on Mac/Linux, you can start manually with `node server.js`.*

### 3. Access the Web UI
Once started, navigate to:
**[http://localhost:3000](http://localhost:3000)**

---

## 📖 How to Deploy

1.  **OS Selection**: Choose your Operating System (Windows or Mac/Linux) at the top of the form.
2.  **Configuration**: Fill in your OCI details. Fields will **auto-fill** if you have existing values in `terraform.tfvars`.
3.  **Plan**: Click **Save & Plan**. The tool will:
    - Update your `.tfvars` file.
    - Set `TF_HTTP_TIMEOUT=900` for stable API connections.
    - Run `terraform init` and `terraform plan`.
4.  **Monitor**: Watch the **Execution Logs** and follow the **Progress Bar**. Popups will notify you as key resources (Bastion, OKE, DB) are successfully created.
5.  **Destroy**: Use the **Destroy Resources** button to tear down the infrastructure when no longer needed.

---

## 📁 Project Structure

- `/public`: Frontend assets (HTML, CSS, JS).
- `server.js`: Node.js backend handles Terraform execution and Socket.io streaming.
- `manage.ps1`: Lifecycle management script.
- `variable.tf`: Source of truth for deployment variables.
