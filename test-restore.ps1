Write-Host "
█▀█ █▀█ █░█░█ █▀▀ █▀█ █▀ █░█ █▀▀ █░░ █░░
█▀▀ █▄█ ▀▄▀▄▀ ██▄ █▀▄ ▄█ █▀█ ██▄ █▄▄ █▄▄ "

function restore-PowerShellProfile {
    $confDocuments = Get-ChildItem -Path . -Filter 'Documents' -Recurse -ErrorAction Stop
    $confPowerShell = $confDocuments.FullName + '\PowerShell\*'
    Write-Information "Restoring profile..."
    try {
        Copy-Item -Recurse -Force -Path $confPowerShell ~\Documents\PowerShell\
        if ($?) {
            Write-Host -ForegroundColor Green "✅ PowerShell profile: restored!"
        }
    } catch {
        Write-Error $_.Exception.Message
    }
}

if (-not (Test-Path ~\Documents\PowerShell\)) {
    Write-Warning " ⚠️ PowerShell directory not found.."
    Write-Information " Creating directory..."
    try {
        mkdir ~\Documents\PowerShell\
        if ($?){
            Write-Host -ForegroundColor Green " ✅ PowerShell user profile dir: created!"
            restore-PowerShellProfile
        }
    } catch {
        Write-Error $_.Exception.Message
    }
} else {
    Write-Warning " ⚠️ Directory already exists. Skipping creation."
    restore-PowerShellProfile
}