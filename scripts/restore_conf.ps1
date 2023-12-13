Write-Host "
█░█░█ █ █▄░█ █▀▄ █▀█ █░█░█ █▀  ▀█▀ █▀▀ █▀█ █▀▄▀█ █ █▄░█ ▄▀█ █░░
▀▄▀▄▀ █ █░▀█ █▄▀ █▄█ ▀▄▀▄▀ ▄█  ░█░ ██▄ █▀▄ █░▀░█ █ █░▀█ █▀█ █▄▄ "
Write-Host -ForegroundColor Blue "👨‍💻Creating Windows Terminal directory..."
# Check if the folder already exists
if (-not (Test-Path ~\Appdata\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\)) {
    # Create Windows terminal directory
    mkdir ~\Appdata\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\

    if ($?) {
        Write-Host -ForegroundColor Green " ✅ SUCCESS: Windows terminal settings directory created"
        Write-Host -ForegroundColor Blue " Restoring settings..."

        # Restore settings
        Copy-Item -Recurse .\conf\terminal\settings.json ~\Appdata\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\

        if ($?) {
            Write-Host -ForegroundColor Green " ✅ SUCCESS: Windows Terminal settings restored"
        } else {
            Write-Host -ForegroundColor Red " ❌ FAILED: Couldn't copy Windows Terminal settings. 📖 Read 👆"
        }
    } else {
        Write-Host -ForegroundColor Red " ❌ FAILED: Couldn't create Windows terminal settings directory. 📖 Read 👆"
    }
} else {
    Write-Host -ForegroundColor Yellow " ⚠️ Directory already exists. Skipping creation."
    Write-Host -ForegroundColor Blue " Restoring settings..."

    # Restore settings
    Copy-Item -Recurse .\conf\terminal\settings.json ~\Appdata\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\

    if ($?) {
        Write-Host -ForegroundColor Green " ✅ SUCCESS: Windows Terminal settings restored"
    } else {
        Write-Host -ForegroundColor Red " ❌ FAILED: Couldn't copy Windows Terminal settings. 📖 Read 👆"
    }
}


Write-Host "
█▀█ █▀█ █░█░█ █▀▀ █▀█ █▀ █░█ █▀▀ █░░ █░░
█▀▀ █▄█ ▀▄▀▄▀ ██▄ █▀▄ ▄█ █▀█ ██▄ █▄▄ █▄▄ "
if (-not (Test-Path ~\Documents\PowerShell\)) {
    mkdir ~\Documents\PowerShell\
    if ($?) {
        Write-Host -ForegroundColor Green " ✅ SUCCESS: PowerShell profile directory created"
        Write-Host -ForegroundColor Blue " Restoring profile..."
        Copy-Item -Recurse .\conf\PowerShell\* ~\Documents\PowerShell\
    } else { 
        Write-Host -ForegroundColor Green " ❌ FAILED: Couldn't create PowerShell profile directory. 📖 Read 👆"
    }
} else {
    Write-Host -ForegroundColor Yellow " ⚠️ Directory already exists. Skipping creation."
    Write-Host -ForegroundColor Blue " Restoring profile..."
    Copy-Item -Recurse .\conf\PowerShell\* ~\Documents\PowerShell\
    Write-Host -ForegroundColor Blue " ✅ SUCCESS: PowerShell profile restored"
}

Write-Host "
▄▀█ █░█ █▄▀
█▀█ █▀█ █░█ "

Copy-Item -Recurse .\scripts\AHK\linux_hotkey.ahk '~\Appdata\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\'

if ($?) {
    Write-Host -ForegroundColor Green " ✅ SUCCESS: AHK to Startup"
} else {
    Write-Host -ForegroundColor Red " ❌ FAILED: Couldn't copy AHK to Startup 📖 Read 👆"
}

Write-Host "
▀█▀ ▄▀█ █▀ █▄▀  █▀ █▀▀ █░█ █▀▀ █▀▄ █░█ █░░ █▀▀ █▀█
░█░ █▀█ ▄█ █░█  ▄█ █▄▄ █▀█ ██▄ █▄▀ █▄█ █▄▄ ██▄ █▀▄ "
if ($?) {
    $openTaskScheduler = Read-Host -Prompt "Do you want to open Task Scheduler? (Y/n)"
    if (-not $openTaskScheduler) { $openTaskScheduler = 'Y' }

    if ($openTaskScheduler -eq 'Y' -or $openTaskScheduler -eq 'y') {
        Write-Host -ForegroundColor Blue "Opening Task Scheduler..."
        Write-Host -ForegroundColor Yellow "`n`nHOW: Click Action > Import Task"
        Write-Host -ForegroundColor Yellow "HOW: Import from <repoDir>\conf\task-scheduler\<filename>.xml`n`n"
        taskschd.msc
    }
}
