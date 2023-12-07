# █░█░█ █ █▄░█ █▀▄ █▀█ █░█░█ █▀  ▀█▀ █▀▀ █▀█ █▀▄▀█ █ █▄░█ ▄▀█ █░░
# ▀▄▀▄▀ █ █░▀█ █▄▀ █▄█ ▀▄▀▄▀ ▄█  ░█░ ██▄ █▀▄ █░▀░█ █ █░▀█ █▀█ █▄▄
Write-Host -ForegroundColor Blue "👨‍💻Creating Windows Terminal directory..."
# Check if the folder already exists
if (-not (Test-Path ~\Appdata\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\)) {
    # Create Windows terminal directory
    mkdir ~\Appdata\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\

    if ($?) {
        Write-Host -ForegroundColor Green " ✅ SUCCESS: Windows terminal settings directory created"
        Write-Host -ForegroundColor Blue "Restoring settings..."

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
}

# ▄▀█ █░█ █▄▀
# █▀█ █▀█ █░█
Copy-Item -Recurse .\scripts\AHK\linux_hotkey.ahk '~\Appdata\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\'

if ($?) {
    Write-Host -ForegroundColor Green " ✅ SUCCESS: AHK to Startup"
} else {
    Write-Host -ForegroundColor Red " ❌ FAILED: Couldn't copy AHK to Startup 📖 Read 👆"
}

# ▀█▀ ▄▀█ █▀ █▄▀  █▀ █▀▀ █░█ █▀▀ █▀▄ █░█ █░░ █▀▀ █▀█
# ░█░ █▀█ ▄█ █░█  ▄█ █▄▄ █▀█ ██▄ █▄▀ █▄█ █▄▄ ██▄ █▀▄
# ▶ Copy AltSnap(Elevated) to System32\Tasks
Copy-Item -Recurse .\conf\task-scheduler\elevated_AltSnap C:\windows\System32\Tasks\

if ($?) {
    Write-Host -ForegroundColor Green " ✅ SUCCESS: copied AltSnap(Elevated) to %windir%\System32\Tasks\"
    $openTaskScheduler = Read-Host -Prompt "Do you want to open Task Scheduler? (y/N)"

    if ($openTaskScheduler -eq 'Y' -or $openTaskScheduler -eq 'y') {
        Write-Host -ForegroundColor Blue "Opening Task Scheduler..."
        taskschd.msc # Import w/ taskschd.msc
    }
} else {
    Write-Host -ForegroundColor Red "❌ FAILED: Couldn't copy AltSnap(Elevated) to %windir%\System32\Tasks\ 📖 Read 👆"
}
