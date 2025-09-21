# ===== SETTINGS =====
$vmrun = "C:\Program Files (x86)\VMware\VMware Workstation\vmrun.exe"
$vmxPath = "C:\VMs\Windows Server 2022 - ArcGIS\Windows Server 2022 - ArcGIS.vmx"

$flaskFolder = "app\menater-server"
$reactFolder = "app\menater-app"

$appUrl = "http://localhost:3000"

# ===== Set Paths =====
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$flaskPath = Join-Path $scriptPath $flaskFolder
$reactPath = Join-Path $scriptPath $reactFolder

# ===== Start VM =====
Write-Host "Checking if VM is running..."
$runningVMs = & "$vmrun" list

if ($runningVMs -notmatch [regex]::Escape($vmxPath)) {
    Write-Host "Starting VM..."
    & "$vmrun" start "$vmxPath" nogui
} else {
    Write-Host "VM already running."
}

# ===== Start MongoDB =====
Write-Host "Ensuring MongoDB service is running..."
$mongoService = Get-Service -Name "MongoDB" -ErrorAction SilentlyContinue
if ($mongoService -and $mongoService.Status -ne "Running") {
    Start-Service "MongoDB"
    Write-Host "MongoDB started."
} elseif ($mongoService) {
    Write-Host "MongoDB already running."
} else {
    Write-Host "MongoDB service not found! (Check if installed as service)"
}

# ===== Start Flask Server =====
Write-Host "Starting Flask server..."
Stop-Process -Name "python" -Force -ErrorAction SilentlyContinue
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$flaskPath'; python app.py" -WindowStyle Minimized

# ===== Start React App =====
Write-Host "Starting React app..."
Stop-Process -Name "node" -Force -ErrorAction SilentlyContinue
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$reactPath'; serve -s build" -WindowStyle Minimized

# ===== Open Browser ignoring SSL cert =====
Write-Host "Opening browser..."
# Chrome
$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
Start-Process $chromePath "--ignore-certificate-errors $appUrl"

Write-Host "All services started."
