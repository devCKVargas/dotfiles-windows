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

$tasksDir = ".\conf\task-scheduler"
# Get all XML files in the current directory that start with 'elevated-'
$xmlFiles = Get-ChildItem -Path $tasksDir -Filter 'elevated-*.xml'

# Get existing scheduled tasks
$existingTasks = Get-ScheduledTask | Where-Object { $_.TaskName -like 'elevated-*' }

# Get existing task base names
$existingBaseNames = $existingTasks.TaskName

# Check if all tasks already exist
$allTasksExist = $true
foreach ($file in $xmlFiles) {
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
    if ($existingBaseNames -notcontains $baseName) {
        $allTasksExist = $false
        break
    }
}

function availableTask {
    if ($existingBaseNames.Count -gt 0) {
        Write-Host "Existing tasks:"
        foreach ($task in $existingBaseNames) {
            Write-Host $task
        }
    }
}

$xmlFilesCurrated = Get-ChildItem -Path $tasksDir -Filter 'elevated-*.xml' | ForEach-Object { $_.BaseName -replace '^elevated-' }
$expectedCount = $xmlFilesCurrated.Count
$expectedFiles = $xmlFilesCurrated -join ', '
Write-Host "$expectedCount XML found: $expectedFiles"

availableTask
Write-Host "All tasks exist? $allTasksExist"

if ($allTasksExist) {
    Write-Host "All scheduled tasks already exist" -ForegroundColor Yellow
} else {
    # Create tasks for those that don't exist
    foreach ($file in $xmlFiles) {
        $baseName = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
        if ($existingBaseNames -notcontains $baseName) {
            Write-Host "Creating scheduled task for $baseName" -ForegroundColor Blue
            schtasks.exe /CREATE /XML $file.FullName /TN "$baseName" > $Null
            if ($LASTEXITCODE -eq 0) {
                Write-Host "$baseName task created!" -ForegroundColor Green
            } else {
                Write-Host "Failed to create scheduled task for $baseName" -ForegroundColor Red
            }
        }
    }
}

pause
