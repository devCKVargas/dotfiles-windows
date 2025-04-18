# Define the directory containing the INF file and cursor files
$infDir = ".\conf\cursor\Bibata-Modern-Ice-Large-Windows-v2.0.7"
$infFile = "install.inf"
$infPath = Join-Path -Path $infDir -ChildPath $infFile

# Check if the directory exists
if (Test-Path $infDir -PathType Container) {
	# Check if the INF file exists
	if (Test-Path $infPath -PathType Leaf) {
		# Change to the directory containing the INF file
		Set-Location -Path $infDir

		# Run the command to install the INF file
		Write-Host "Installing cursor theme..."
		$result = Start-Process -FilePath "rundll32.exe" -ArgumentList "setupapi.dll,InstallHinfSection DefaultInstall 128 $infFile" -NoNewWindow -Wait -PassThru

		# Check if the process completed successfully
		if ($result.ExitCode -eq 0) {
			Write-Host "Cursor theme installed successfully."
		}
		else {
			Write-Host "Cursor theme installation failed with exit code $($result.ExitCode)." -ForegroundColor Red
		}
	}
	else {
		Write-Host "INF file not found. Please check the path and try again." -ForegroundColor Red
	}
}
else {
	Write-Host "Directory not found. Please check the path and try again." -ForegroundColor Red
}
