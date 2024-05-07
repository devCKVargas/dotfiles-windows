# $env:USERNAME, $env:ProgramFiles, $env:APPDATA, etc...

# Variables (current session only)
$confDir = Get-ChildItem -Path . -Filter 'conf' -Recurse -ErrorAction Stop
$confAppData = Get-ChildItem -Path . -Filter 'AppData' -Recurse -ErrorAction Stop
$confLocalAppData = Get-ChildItem -Path . -Filter 'LocalAppData' -Recurse -ErrorAction Stop
$confDocuments = Get-ChildItem -Path . -Filter 'Documents' -Recurse -ErrorAction Stop
$confStartup = Get-ChildItem -Path . -Filter 'Startup' -Recurse -ErrorAction Stop
$confTerminal = $confDir.FullName + '\terminal\settings.json'
$terminalWallpaper = $confDir.FullName + '\terminal\terminal-wallpaper\*'
$confOhMyPosh = $confDir.FullName + '\oh-my-posh\themes\*'
$confTaskSched = $confDir.FullName + '\task-scheduler\*'
$confSpicetify = $confDir.FullName + '\spicetify\*'
$confAltSnap = $confAppData.FullName + '\AltSnap\*'
$confqBittorent = $confAppData.FullName + '\qBittorent\*'
$confTrafficMonitor = $confLocalAppData.FullName + '\TrafficMonitor\*'
$confPowerShell = $confDocuments.FullName + '\PowerShell\*'
$confAHK = $confStartup.FullName + '\AHK\*'

# ENV Path
# $obsPath = "$env:ProgramFiles\obs-studio\bin\64bit"
# $newPath = "$env:Path;$spotifyPath;$obsPath" # combine paths
$spotifyPath = "$env:APPDATA\Spotify\"
$newPath = "$env:Path;$spotifyPath"
[Environment]::SetEnvironmentVariable("Path", $newPath, "User") # add Path to User ENV

# function
function msgSuccess {
    Write-Host -ForegroundColor Green "✅ Settings restored!"
}
function msgError {
    Write-Error $_.Exception.Message
    Write-Error "❌ There's an error while restoring settings."
}
function msgDirExist {
    Write-Warning "Directory already exists. Skipping creation."
}

# TODO: copy powershell
$terminalLocalConfDir = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\"
Write-Host "
█░█░█ █ █▄░█ █▀▄ █▀█ █░█░█ █▀  ▀█▀ █▀▀ █▀█ █▀▄▀█ █ █▄░█ ▄▀█ █░░
▀▄▀▄▀ █ █░▀█ █▄▀ █▄█ ▀▄▀▄▀ ▄█  ░█░ ██▄ █▀▄ █░▀░█ █ █░▀█ █▀█ █▄▄ "
Write-Information "👨‍💻Creating Windows Terminal directory..."
# Check if the directory already exists, else create dir 
if (-not (Test-Path $terminalLocalConfDir)) {
    Write-Warning "Windows terminal directory not found.."
    # Create Windows terminal directory
    Write-Information "Creating directory..."
    try {
        mkdir $terminalLocalConfDir
        mkdir $env:USERPROFILE\Pictures\Wallpapers\terminal\
        if ($?){
            Write-Information "Restoring settings..."
            # Restore settings 
            try {
                Copy-Item -Recurse -Force -Path $confTerminal $terminalLocalConfDir
                Copy-Item -Recurse -Force -Path $terminalWallpaper $env:USERPROFILE\Pictures\Wallpapers\terminal\
                if ($?){
                    msgSuccess
                }
            } catch {
                msgError
            }
        }
    } catch {
		msgError
    }
} else {
    msgDirExist
    # Restore settings 
    try {
        Write-Information "Restoring settings..."
        try {
            Copy-Item -Recurse -Force -Path $confTerminal $terminalLocalConfDir
            if ($?){
                msgSuccess
            }
        } catch {
            msgError
        }
    } catch {
		msgError
    }
}

Write-Host "
█▀█ █▀█ █░█░█ █▀▀ █▀█ █▀ █░█ █▀▀ █░░ █░░
█▀▀ █▄█ ▀▄▀▄▀ ██▄ █▀▄ ▄█ █▀█ ██▄ █▄▄ █▄▄ "
function restore-PowerShellProfile {
Write-Information "Restoring profile..."
    try {
        Copy-Item -Recurse -Force -Path $confPowerShell ~\Documents\PowerShell\
            if ($?) {
                msgSuccess
            }
    } catch {
        msgError
    }
}
# Check if the directory already exists, else create dir 
if (-not (Test-Path ~\Documents\PowerShell\)) {
    Write-Warning "PowerShell directory not found.."
    # Create Windows terminal directory
    Write-Information "Creating directory..."
    try {
        mkdir ~\Documents\PowerShell\
        # Restore settings 
        if ($?){
            restore-PowerShellProfile
        }
    } catch {
        msgError
    }
} else {
    # Restore settings 
    msgDirExist
    restore-PowerShellProfile
}

# TODO: copy powershell
Write-Host "
▄▀█ █░█ █▄▀
█▀█ █▀█ █░█ "
Write-Information "Restoring AHK to startup..."
try {
    Copy-Item -Recurse -Force -Path $confAHK '~\Appdata\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\'
} catch {
    msgError
}

if (-not (Test-Path ~\Documents\AHK\)) {
    Write-Warning "AHK directory not found.."
    Write-Information "Creating directory..."
    try {
        mkdir ~\Documents\AHK\
        if ($?){
            msgSuccess
            Write-Information "Restoring AHK settings..."
            try {
                Copy-Item -Recurse -Force -Path $confAHK ~\Documents\AHK\
                if ($?) {
                    msgSuccess
                }
            } catch {
                msgError
            }
        }
    } catch {
        msgError
    }
} else {
    msgDirExist
    Write-Information "Restoring settings..."
    try {
        Copy-Item -Recurse -Force -Path $confAHK ~\Documents\AHK\
        if ($?){
            msgSuccess
        }
    } catch {
        msgError
    }
}

Write-Host "
▀█▀ ▄▀█ █▀ █▄▀  █▀ █▀▀ █░█ █▀▀ █▀▄ █░█ █░░ █▀▀ █▀█
░█░ █▀█ ▄█ █░█  ▄█ █▄▄ █▀█ ██▄ █▄▀ █▄█ █▄▄ ██▄ █▀▄ "
if ($?) {
    Write-Information "HOW: Click Action > Import Task"
    Write-Information "HOW: Import from <repoDir>\conf\task-scheduler\<filename>.xml`n`n"
    # $openTaskScheduler = Read-Host -Prompt "Do you want to open Task Scheduler? (Y/n)"
    # if (-not $openTaskScheduler) { $openTaskScheduler = 'Y' }

    # if ($openTaskScheduler -eq 'Y' -or $openTaskScheduler -eq 'y') {
    #     Write-Information "Opening Task Scheduler..."
    #     taskschd.msc
    # }
}
