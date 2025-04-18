Import-Module ".\functions.psm1" # CheckGsudoInstallation

# Ensure the application source file exists
$appSource = "test-apps.txt"
If (-not (Test-Path $appSource)) {
	Write-Host "Error: $appSource not found." -ForegroundColor Red
	exit
}

# Read applications from the source file
$apps = Get-Content $appSource
$installMethod = "winget"
$applications = @()

foreach ($line in $apps) {
	# Trim the line to remove leading and trailing whitespace
	$trimmedLine = $line.Trim()

	# Skip empty lines
	if ($trimmedLine -eq "") {
		continue
	}

	# Check for category indications
	if ($trimmedLine.StartsWith("#")) {
		if ($trimmedLine.Contains("choco")) {
			$installMethod = "choco"
		}
		elseif ($trimmedLine.Contains("UWP")) {
			$installMethod = "msstore"
		}
		else {
			$installMethod = "winget"
		}
		continue
	}

	# Skip lines that do not start with an text character
	if ($trimmedLine -notmatch "^[a-zA-Z]") {
		continue
	}

	# Add the application to the list
	$applications += @{ Name = $trimmedLine; Method = $installMethod }
}

# AMD Ryzen CPUs only: install AMD Ryzen Chipset
if (Get-CimInstance Win32_Processor | Select-Object Name, Manufacturer | where-object { $_.Name -match "Ryzen" `
			-and $_.Manufacturer -match "AuthenticAMD" }) {
	gsudo choco install amd-ryzen-chipset -y
}

# Install applications
foreach ($app in $applications) {
	if ($app.Method -eq "winget") {
		if ((winget search $app.Name) -match $app.Name) {
			Write-Host "🪟 winget: found $($app.Name)!" -ForegroundColor Blue
			gsudo winget install $app.Name -h -s winget --accept-package-agreements --accept-source-agreements # --scope machine TODO: maybe add a check if scope isn't set in winget settings
		}
		else {
			Write-Host "Missing $($app.Name)`nProceeding..." -Foreground Yellow
		}
	}
 elseif ($app.Method -eq "choco") {
		if (-not (Test-Admin)) {
			Write-Host "Requesting admin permission..." -ForegroundColor Yellow
			if (-not (CheckGsudoInstallation)) {
				Write-Host "Failed to install gsudo. Try running the script as admin." -ForegroundColor Red
				# TODO: run as admin natively
				# TODO: or create runAsAdmin function
				Write-Host "Exiting..." -ForegroundColor Yellow
				exit
			}
		}
		if ((choco search $app.Name) -match $app.Name) {
			Write-Host "🍫 choco: found $($app.Name)!" -ForegroundColor Blue
			gsudo "choco install $($app.Name) -y"
		}
		else {
			Write-Host "Missing $($app.Name)`nProceeding..." -Foreground Yellow
		}
	}
	else {
		if ((choco search $app.Name) -match $app.Name) {
			gsudo winget install $app.name -h -s msstore --accept-package-agreements --accept-source-agreements
		}
		else {
			Write-Host "Missing $($app.Name)`nProceeding..." -Foreground Yellow
		}
	}
}

# TODO: call debloat here
# sudo winget uninstall Microsoft.Teams.Classic --purge --all-versions # remove microsoft teams

