function InstallChocolatey {
	try {
		Set-ExecutionPolicy Bypass -Scope Process -Force
		[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
		Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
		return $true
	} catch {
		Write-Error "Failed to install Chocolatey: $($_.Exception.Message)"
		return $false
	}
}

function CheckChocolateyInstallation {
	$ChocolateyInstalled = Test-Path "C:\ProgramData\chocolatey\bin\choco.exe"
	if (-not $ChocolateyInstalled) {
		Write-Host "Chocolatey is not installed. Installing..." -ForegroundColor Yellow
		return (InstallChocolatey)
	}
	return $true
}

function InstallGsudo {
	Write-Information "Installing Gsudo..." -ForegroundColor Yellow
	try {
		winget install gerardog.gsudo --accept-source-agreements --accept-package-agreements -h --disable-interactivity
		return $true
	} catch {
		Write-Error "Failed to install Gsudo: $($_.Exception.Message)"
		return $false
	}
}

function CheckGsudoInstallation {
	$GsudoInstalled = Test-Path -Path "C:\Program Files\gsudo\Current\gsudo.exe"
	if (-not $GsudoInstalled) {
		Write-Host "Winget is not installed. Installing..." -ForegroundColor Yellow
		return (InstallGsudo)
	}
	return $true
}

function InstallWinget { 
	if (CheckChocolateyInstallation) {
		Write-Host "Installing winget via Chocolatey..." -ForegroundColor Yellow
		try {
			sudo choco install winget -y
			return $true
		} catch {
			Write-Error "Failed to install winget via Chocolatey: $($_.Exception.Message)"
			return $false
		}
	} 
	return $false
}

function InstallPwshViaWinget {
	Write-Host "Installing PowerShell 7 via Winget..." -ForegroundColor Yellow
	try {
		winget install Microsoft.PowerShell --accept-source-agreements --accept-package-agreements -h --disable-interactivity
    return $true
	} catch {
		Write-Error "Failed to install PowerShell 7 (pwsh) via winget: $($_.Exception.Message)"
		return $false
	}
}

function InstallPwshViaChocolatey {
	Write-Host "Installing PowerShell 7 via Chocolatey..." -ForegroundColor Yellow
	try {
		choco.exe install powershell-core -y
		return $true
	} catch {
		Write-Error "Failed to install PowerShell 7 (pwsh) via chocolatey: $($_.Exception.Message)"
		return $false
	}
}

function CheckWingetInstallation {
	$wingetInstalled = Test-Path -Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*\winget.exe"
	if (-not $wingetInstalled) {
		Write-Host "Winget is not installed. Installing..." -ForegroundColor Yellow
		return (InstallWinget)
	}
	return $true
	# Start-Process -FilePath "winget" -ArgumentList "upgrade" -NoNewWindow -Wait
}

function CheckPwshInstallation {
	$pwshInstalled = Test-Path "C:\Program Files\PowerShell\7\pwsh.exe"
	if (-not $pwshInstalled) {
		Write-Host "PowerShell 7 (pwsh) is not installed. Attempting to install..." -ForegroundColor Yellow
		return (InstallPwsh)
	}
	return $true
	# Start-Process -FilePath "pwsh" -ArgumentList "-NoExit" -NoNewWindow -Wait
}

function InstallPwsh { 
	if (CheckWingetInstallation) {
		return InstallPwshViaWinget
	}
	return InstallPwshViaChocolatey
}
