# Set OCI Terraform Environment Variables from Config
# This script reads the DEFAULT profile from ~/.oci/config and sets TF_VAR_* environment variables.

$ociConfigPath = Join-Path $HOME ".oci\config"
if (-not (Test-Path $ociConfigPath)) {
    Write-Error "OCI config file not found at $ociConfigPath"
    return
}

$config = Get-Content $ociConfigPath
$vars = @{}
$inDefault = $false

foreach ($line in $config) {
    $line = $line.Trim()
    if ($line -eq "[DEFAULT]") {
        $inDefault = $true
        continue
    }
    elseif ($line.StartsWith("[") -and $line.EndsWith("]")) {
        $inDefault = $false
        continue
    }

    if ($inDefault -and $line -match "^(\w+)\s*=\s*(.*)$") {
        $key = $Matches[1]
        $value = $Matches[2]
        $vars[$key] = $value
    }
}

if ($vars.Count -eq 0) {
    Write-Warning "No variables found in [DEFAULT] profile of OCI config."
    return
}

# Mapping OCI config keys to Terraform variable names
$mapping = @{
    "user"      = "TF_VAR_user_ocid"
    "tenancy"   = "TF_VAR_tenancy_ocid"
    "fingerprint" = "TF_VAR_fingerprint"
    "key_file"  = "TF_VAR_private_key_path"
    "region"    = "TF_VAR_region"
}

foreach ($key in $mapping.Keys) {
    if ($vars.ContainsKey($key)) {
        $envVar = $mapping[$key]
        $val = $vars[$key]
        
        # Handle home directory expansion in key_file path
        if ($key -eq "key_file" -and $val.StartsWith("~")) {
            $val = $val.Replace("~", $HOME)
        }

        [System.Environment]::SetEnvironmentVariable($envVar, $val, [System.EnvironmentVariableTarget]::Process)
        Write-Host "Set $envVar = $val" -ForegroundColor Green
    }
    else {
        Write-Warning "Key '$key' not found in OCI config [DEFAULT] profile."
    }
}

Write-Host "`nEnvironment variables set for the current session." -ForegroundColor Cyan
