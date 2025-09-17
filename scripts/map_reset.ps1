# Reset VM to latest "Map Published" snapshot

$vmrun = "C:\Program Files (x86)\VMware\VMware Workstation\vmrun.exe"
$vmxPath = "C:\VMs\Windows Server 2022 - ArcGIS\Windows Server 2022 - ArcGIS.vmx"
$snapshotName = "Map published"

Write-Host "Reverting VM to snapshot '$snapshotName'..."

# Stop VM if running
$runningVMs = & "$vmrun" list
if ($runningVMs -match [regex]::Escape($vmxPath)) {
    Write-Host "Stopping VM before revert..."
    & "$vmrun" stop "$vmxPath" hard
}

# Revert snapshot
& "$vmrun" revertToSnapshot "$vmxPath" "$snapshotName"

# Start VM again
& "$vmrun" start "$vmxPath" nogui

Write-Host "VM reverted to snapshot '$snapshotName' and restarted."
