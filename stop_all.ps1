# ===== SETTINGS =====
$vmrun = "C:\Program Files (x86)\VMware\VMware Workstation\vmrun.exe"
$vmxPath = "C:\VMs\Windows Server 2022 - ArcGIS\Windows Server 2022 - ArcGIS.vmx"

# ===== Stop Flask and React =====
Write-Host "Stopping Flask (python) and React (node)..."
Stop-Process -Name "python" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "node" -Force -ErrorAction SilentlyContinue

# ===== Stop MongoDB =====
Write-Host "Stopping MongoDB service..."
$mongoService = Get-Service -Name "MongoDB" -ErrorAction SilentlyContinue
if ($mongoService -and $mongoService.Status -eq "Running") {
    Stop-Service "MongoDB"
    Write-Host "MongoDB stopped."
} else {
    Write-Host "MongoDB not running."
}

# ===== Suspend VM =====
Write-Host "Suspending VM..."
try {
    & "$vmrun" suspend "$vmxPath" nogui
    Write-Host "VM suspended."
} catch {
    Write-Host "Could not suspend VM: $($_.Exception.Message)"
}

# ===== Close all PowerShell windows including this one =====
Write-Host "Closing all open PowerShell windows..."

# Get all PowerShell processes
$psProcesses = Get-Process -Name "powershell" -ErrorAction SilentlyContinue
$pwsProcesses = Get-Process -Name "pwsh" -ErrorAction SilentlyContinue  # if you use PowerShell 7+

# Kill them all except the current one
foreach ($p in $psProcesses) {
    if ($p.Id -ne $PID) {
        Stop-Process -Id $p.Id -Force
    }
}

foreach ($p in $pwsProcesses) {
    if ($p.Id -ne $PID) {
        Stop-Process -Id $p.Id -Force
    }
}

# Finally, close this script's own shell
Stop-Process -Id $PID -Force
