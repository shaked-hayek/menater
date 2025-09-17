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
