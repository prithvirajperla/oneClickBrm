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

## � Prerequisites

Before running the application, ensure you have the following installed:

1.  **Node.js**: [Download and install Node.js](https://nodejs.org/) (v14.x or later).
2.  **Terraform**: [Download and install Terraform](https://www.terraform.io/downloads). Ensure `terraform` is in your system PATH.
3.  **OCI Account**: A valid OCI account with a configured user, region, and compartment.
4.  **OCI API Key**: You will need your `user_ocid`, `tenancy_ocid`, `fingerprint`, and the path to your private API key (`.pem`).

---

## 🛠️ Setup & Usage

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
