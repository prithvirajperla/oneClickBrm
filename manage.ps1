param (
    [Parameter(Mandatory=$true)]
    [ValidateSet("start", "stop", "restart")]
    $Action
)

$Port = 3000

function Stop-App {
    Write-Host "Checking for processes on port $Port..." -ForegroundColor Cyan
    $Process = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess -First 1
    if ($Process) {
        Write-Host "Stopping process $Process..." -ForegroundColor Yellow
        Stop-Process -Id $Process -Force
        Write-Host "Application stopped." -ForegroundColor Green
    } else {
        Write-Host "No application found running on port $Port." -ForegroundColor Gray
    }
}

function Start-App {
    Stop-App
    Write-Host "Starting application..." -ForegroundColor Cyan
    Start-Process -NoNewWindow -FilePath "node" -ArgumentList "server.js"
    Write-Host "Application started! Access it at http://localhost:$Port" -ForegroundColor Green
}

switch ($Action) {
    "start" { Start-App }
    "stop" { Stop-App }
    "restart" { Start-App }
}
