# $env:USERNAME, $env:ProgramFiles, $env:APPDATA, etc...

#? Variables (current session only)
# $repoDir = Get-ChildItem -Path . -Filter 'dotfiles-windows' -Recurse -ErrorAction Stop
$repoDir = Get-Item -Path .\ | Select-Object -ExpandProperty Name
$confDir = $repoDir + '\conf\'
$confAppData = $confDir + '\AppData\'
$confLocalAppData = $confDir + '\LocalAppData\'
$confDocuments = $confDir + '\Documents\'
$confStartup = $confDir + '\Startup\'
$confTerminal = $confDir + '\terminal\settings.json'
$terminalWallpaper = $confDir + '\terminal\terminal-wallpaper\*'
$confOhMyPosh = $confDir + '\oh-my-posh\themes\*'
$confTaskSched = $confDir + '\task-scheduler\*'
$confSpicetify = $confDir + '\spicetify\*'
$confAltSnap = $confAppData + '\AltSnap\*'
$confqBittorent = $confAppData + '\qBittorent\*'
$confTrafficMonitor = $confLocalAppData + '\TrafficMonitor\*'
$confPowerShell = $confDocuments + '\PowerShell\*'
$confAHK = $confStartup + '\AHK\*'

#? ENV Path
# New paths to be added
$spotifyPath = "$env:APPDATA\Spotify\"
$wingetUIPath = "$env:ProgramFiles\WingetUI\"

# Get the current user PATH environment variable
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")

# Split the current PATH into an array of paths
$currentPathsArray = $currentPath -split ';'

# Initialize a list to hold unique paths
$newPathsList = [System.Collections.Generic.List[string]]::new()

# Add existing paths and clear blank paths in the list
foreach ($path in $currentPathsArray) {
    if (-not [string]::IsNullOrEmpty($path)) {
        $newPathsList.Add($path)
    }
}

function Add-PathIfNotExists {
    param (
        [string]$path,
        [System.Collections.Generic.List[string]]$pathList
    )
    if (-not $pathList.Contains($path)) {
        $pathList.Add($path)
    }
}

# Add the new paths if they don't already exist
Add-PathIfNotExists -path $spotifyPath -pathList $newPathsList
Add-PathIfNotExists -path $wingetUIPath -pathList $newPathsList

# Combine the list with semicolons
$newPath = [string]::Join(';', $newPathsList)

# Set the new PATH environment variable
[Environment]::SetEnvironmentVariable("Path", $newPath, "User")

#? function
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

#? spicetify
try {
    mkdir "$env:APPDATA\spicetify\Themes\test"
    if ($?){
        try {
            spicetify config inject_css 1
            spicetify config replace_colors 1
            spicetify config current_theme marketplace
            # TODO: add a check if current_apps already has either a marketplace || spicetify-marketplace
            spicetify config custom_apps marketplace
            msgSuccess
        }
        catch {
            msgError
        }
    }
} catch {
    msgError
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
