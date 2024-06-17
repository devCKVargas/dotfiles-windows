Import-Module ".\functions.psm1"
CheckPwshInstallation

# Check for administrative privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Requesting administrative privileges..."
    Start-Process -Verb RunAs -FilePath 'pwsh' -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

Write-Host "============================================================================"
Write-Host "= This script will remove all 'elevated-' Scheduled tasks!                 ="
Write-Host "============================================================================"
Write-Host "Checking for 'elevated-' tasks..."

# Get tasks with 'elevated-' in their name
$tasks = Get-ScheduledTask | Where-Object { $_.TaskName -like 'elevated-*' }

if ($tasks) {
    foreach ($task in $tasks) {
        Write-Host "Deleting task: $($task.TaskName)"
        Unregister-ScheduledTask -TaskName $task.TaskName -Confirm:$false
    }
} else {
    Write-Host "No 'elevated-' tasks found."
}

pause
