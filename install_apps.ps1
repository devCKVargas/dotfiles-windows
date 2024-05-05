$restoreConfScriptFile = 'restore_conf.ps1'
$confWinget = '.\conf\winget\*'

# Winget (Slow download fix)
# open settings using $ winget settings
Write-Host "
	█░█░█ █ █▄░█ █▀▀ █▀▀ ▀█▀   █▀▀ █ ▀▄▀
	▀▄▀▄▀ █ █░▀█ █▄█ ██▄ ░█░   █▀░ █ █░█ "
Write-Information "Setting wininet as network downloader..."

if (Test-Path $confWinget) {
	try { 
		Copy-Item -Recurse -Force -Path $confWinget ~\Appdata\Local\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\
		if ($?) {
			Write-Host -ForegroundColor Green "wininet set!"
		}
	} catch {
		Write-Error $_.Exception.Message
	}
} else {
	Write-Error "Directory $confWinget does not exist."
}

# ===============================================================
Write-Information "Installing gsudo..."
winget install gerardog.gsudo --accept-source-agreements --accept-package-agreements -h --disable-interactivity

# ===============================================================
$hasOverride = Read-Host -Prompt "Enable Installer Hash Override? (Y/n)"
if (-not $hasOverride) { $hasOverride = 'Y' }

if ($hasOverride -eq 'Y' -or $hasOverride -eq 'y') {
	try {
		gsudo winget settings --enable InstallerHashOverride
		if ($?) {
			Write-Host -ForegroundColor Green "Hash Override enabled!"
		}
	} catch {
		Write-Error $_.Exception.Message
	}
} else {
	Write-Host -ForegroundColor Red "Denied! Hash Override remains disabled!"
}

Write-Host "
	█▀▀ █░█ █▀█ █▀▀ █▀█ █░░ ▄▀█ ▀█▀ █▀▀ █▄█ package
	█▄▄ █▀█ █▄█ █▄▄ █▄█ █▄▄ █▀█ ░█░ ██▄ ░█░ manager "

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# ===============================================================
$updateChoco = Read-Host -Prompt "Update installed apps? (Y/n)"
if (-not $updateChoco) { $updateChoco = 'Y' }

if ($updateChoco -eq 'Y' -or $updateChoco -eq 'y') {
	Write-Information "
	+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+
	|U|p|d|a|t|i|n|g| |c|h|o|c|o|l|a|t|e|y| |a|p|p|s|
	+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+
"
	try {
		gsudo	choco upgrade all -y
		if ($?){
			Write-Host -Foreground Green "Done! Double check for any errors."
		}
	} catch {
		Write-Error $_.Exception.Message
	}
} else {
	Write-Warning "Skipping updates."
}

# ===============================================================
$installChoco = Read-Host -Prompt "Install choco apps? (Y/n)"
if (-not $installChoco) { $installChoco = 'Y' }

if ($installChoco -eq 'Y' -or $installChoco -eq 'y') {
	Write-Host "
	+-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+
	|I|n|s|t|a|l|l|i|n|g| |c|h|o|c|o|l|a|t|e|y| |a|p|p|s|
	+-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+ "
	try {
		gsudo choco install -y "winget" "traffic-monitor" "nerd-fonts-jetbrainsMono" "nerd-fonts-arimo" "nerd-fonts-meslo" "winfetch" "openal" "nilesoft-shell" "amd-ryzen-chipset" "imagemagick" "realtek-hd-audio-driver" "spicetify-marketplace" "tldr-plusplus"
		if ($?){
			Write-Host -Foreground Green "Done! Double check for any errors."
		}
	} catch {
		Write-Error $_.Exception.Message
	}
} else {
	Write-Warning "Skipping Chocolatey apps."
}
	
# ===============================================================
$clearChocoCache = Read-Host -Prompt "Clear cache? (Y/n)"
if (-not $clearChocoCache) { $clearChocoCache = 'Y' }

if ($clearChocoCache -eq 'Y' -or $clearChocoCache -eq 'y') {
	try {
		gsudo choco cache remove -y
		if ($?){
			Write-Host -Foreground Green "Chocolatey cache cleared!"
		}
	} catch {
		Write-Error $_.Exception.Message
	}
} else {
	Write-Host -Foreground Yellow "Denied! Cache not cleared."
}

Write-Host "
	█░█░█ █ █▄░█ █▀▀ █▀▀ ▀█▀
	▀▄▀▄▀ █ █░▀█ █▄█ ██▄ ░█░"

$updateWinget = Read-Host -Prompt "Update installed apps? (Y/n)"
if (-not $updateWinget) { $updateWinget = 'Y' }

if ($updateWinget -eq 'Y' -or $updateWinget -eq 'y') {
	Write-Host "
	+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+ +-+-+-+-+
	|U|p|d|a|t|i|n|g| |w|i|n|g|e|t| |a|p|p|s|
	+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+ +-+-+-+-+ "

	try {
		winget update --all --accept-source-agreements --accept-package-agreements -h --disable-interactivity ## --silent | -h
		if ($?){
			Write-Host -ForegroundColor Green "winget apps updated! Check for any errors."
		}
	} catch {
		Write-Error $_.Exception.Message
	}
} else {
	Write-Warning "Skipping updates."
}

# █▀▄ █▀▀ █░█ # --source -s 
# █▄▀ ██▄ ▀▄▀ # (winget,msstore)
$installWingetAppsDev = Read-Host -Prompt "Install Dev apps? (Y/n)"
if (-not $installWingetAppsDev) { $installWingetAppsDev = 'Y' }

if ($installWingetAppsDev -eq 'Y' -or $installWingetAppsDev -eq 'y') {
	Write-Host "
	+-+-+-+-+-+-+-+-+-+-+ +-+-+-+ +-+-+-+-+
	|I|n|s|t|a|l|l|i|n|g| |d|e|v| |a|p|p|s|
	+-+-+-+-+-+-+-+-+-+-+ +-+-+-+ +-+-+-+-+ "
	try {
		winget install "Git.Git" "GitHub.cli" "GitHub.GitHubDesktop" "JesseDuffield.lazygit" "OpenJS.NodeJS" "Microsoft.WindowsTerminal" "Microsoft.PowerShell" "Microsoft.VisualStudioCode" "Figma.Figma" "ResponsivelyApp.ResponsivelyApp" "BurntSushi.ripgrep.MSVC" "JanDeDobbeleer.OhMyPosh" "AdrienAllard.FileConverter" "Google.PlatformTools" "ajeetdsouza.zoxide" "junegunn.fzf" -s winget --accept-package-agreements --accept-source-agreements -h
		if ($?){
			Write-Host -ForegroundColor Green "winget dev apps installed! Check for any errors."
		}
	}
	catch {
		Write-Error $_.Exception.Message
	}
	
	Write-Host -Foreground Green "
	+-+-+-+-+-+
	|D|o|n|e|!|
	+-+-+-+-+-+ "

} else {
	Write-Warning "Skipping Dev apps."
}

# ▄▀█ █▀█ █▀█ █▀ # Winget
# █▀█ █▀▀ █▀▀ ▄█ # Source: Winget 
$installWingetApps = Read-Host -Prompt "Install apps? (Y/n)"
if (-not $installWingetApps) { $updateChoco = 'Y' }

if ($installWingetApps -eq 'Y' -or $installWingetApps -eq 'y') {
	Write-Host "
	+-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+ +-+-+-+-+
	|I|n|s|t|a|l|l|i|n|g| |w|i|n|g|e|t| |a|p|p|s|
	+-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+ +-+-+-+-+ "
	try {
		winget install "nvcleanstall" "powertoys" "AltSnap" "caprine" "discord" "telegram" "megasync" "fdm" "canva" "ahk" "k-lite mega codec pack" "obs studio" "VLC media player" "winrar" "anydesk" "gpu-z" "f.lux" "afterburner" "superf4" "wingetUI" "oracle.JDK.18" "7-zip" "Microsoft XNA Framework Redistributable Refresh" "CPUID CPU-Z" "sharex" "ookla.speedtest.CLI" "spotify.spotify" "spicetify.spicetify" "Appest.TickTick" "NextDNS.NextDNS.Desktop" "capcut" "qbittorrent.qbittorrent" "th-ch.YouTubeMusic" "IObit.IObitUnlocker" "Microsoft.DotNet.DesktopRuntime.3_1" "Microsoft.DotNet.DesktopRuntime.5" "Microsoft.DotNet.DesktopRuntime.6" "Microsoft.DotNet.DesktopRuntime.7" "Microsoft.DotNet.DesktopRuntime.8" "abbodi1406.vcredist" "univrsal.tuna" -s winget --accept-package-agreements --accept-source-agreements -h
		if ($?){
			Write-Host -ForegroundColor Green "winget apps installed! Check for any errors."
		}
	}
	catch {
		Write-Error $_.Exception.Message
	}
} else {
	Write-Warning "Skipping apps."
}

# █░█ █░█░█ █▀█   ▄▀█ █▀█ █▀█ █▀ # Winget
# █▄█ ▀▄▀▄▀ █▀▀   █▀█ █▀▀ █▀▀ ▄█ # source: msstore
$installWingetAppsUWP = Read-Host -Prompt "Install MS apps? (Y/n)"
if (-not $installWingetAppsUWP) { $installWingetAppsUWP = 'Y' }
½
if ($installWingetAppsUWP -eq 'Y' -or $installWingetAppsUWP -eq 'y') {
	Write-Host "
	+-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+ +-+-+-+-+
	|I|n|s|t|a|l|l|i|n|g| |M|S|S|t|o|r|e| |a|p|p|s|
	+-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+ +-+-+-+-+ "
	try {
		winget install "eartrumpet" "Microsoft To Do" "KDE Connect" "Messenger" -s msstore --accept-package-agreements --accept-source-agreements -h
		if ($?){
			Write-Host -ForegroundColor Green "UWP(MSStore) apps installed! Check for any errors."
		}
	}
	catch {
		Write-Error $_.Exception.Message
	}
} else {
	Write-Warning "Skipping Microsoft apps."
}

Write-Host "
	█▀█ █▀▀ █▀ ▀█▀ █▀█ █▀█ █▀▀   █▀▀ █▀█ █▄░█ █▀▀
	█▀▄ ██▄ ▄█ ░█░ █▄█ █▀▄ ██▄   █▄▄ █▄█ █░▀█ █▀░ "

$restoreConf = Read-Host -Prompt "Finishing setup. Would you like to restore available configurations? (Y/n)"
if (-not $restoreConf) { $restoreConf = 'Y' }

if ($restoreConf -eq 'Y' -or $restoreConf -eq 'y') {
    Write-Information "🔧 Restoring configs..."

    try {
		$restoreConfScript = Get-ChildItem -Path . -Filter $restoreConfScriptFile -Recurse -ErrorAction Stop
		# Check if the script is found
    if ($restoreConfScript) {
        Write-Host -ForegroundColor Green "Found restore_conf.ps1 at $($restoreConfScript.FullName)"
        . $restoreConfScript.FullName
    } else {
        throw "Script not found"
    }
		} catch {
			Write-Error $_.Exception.Message
		}

} else {
    Write-Warning "Skipping configs."
    Write-Host -ForegroundColor Green "Setup done!"
}
