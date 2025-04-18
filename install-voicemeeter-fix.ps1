# Run the script as administrator in a new window
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	$scriptPath = $MyInvocation.MyCommand.Path
	Write-Host "Requesting administrative privileges..."
	if (Get-Command pwsh -ErrorAction SilentlyContinue) {
		Start-Process pwsh -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""
		# Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File", `"$scriptPath`"
	}
	else {
		Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""
	}
}

# Check if voicemeeter is install in Program Files(x86)
if (-not (Test-Path -Path "${env:ProgramFiles(x86)}\VB\Voicemeeter\voicemeeter.exe")) {
	Write-Host "Voicemeeter not found in: `"$env:ProgramFiles(x86)\VB\Voicemeeter\voicemeeter.exe`"" -ForegroundColor Red
	$prompt = Read-Host "Do you want to continue? (Y/n)"
	If ($prompt -eq 'y' -or $prompt -eq '') {
		Write-Host "Continuing..." -ForegroundColor Green
	}
	else {
		exit
	}
}

# Define the PowerShell script content to set audiodg.exe affinity
$psContent = @'
$Process = Get-Process audiodg -ErrorAction SilentlyContinue
if ($Process) {
	$Process.ProcessorAffinity = 1
	$Process.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::High
}
'@

# Save the PowerShell script to the user profile directory
$psScriptPath = "$env:USERPROFILE\set-audiodg-affinity.ps1"
Set-Content -Path $psScriptPath -Value $psContent

# Define the VBScript content to run the PowerShell script hidden
$vbScriptContent = @'
Set objShell = CreateObject("WScript.Shell")
objShell.Run "powershell.exe -ExecutionPolicy Bypass -File """ & WScript.Arguments(0) & """", 0, False
'@

# Save the VBScript to the user profile directory
$vbScriptPath = "$env:USERPROFILE\run-hidden.vbs"
Set-Content -Path $vbScriptPath -Value $vbScriptContent

# Remove old version of the scheduled task if present
schtasks /delete /f /tn audiodg-affinity
schtasks /delete /f /tn audiodg-affinity-recurring

# Create scheduled task to set audiodg.exe affinity on logon
schtasks /create /sc ONLOGON /tn audiodg-affinity /delay 0000:20 /tr "wscript.exe $vbScriptPath $psScriptPath" /rl HIGHEST

# Create recurring scheduled task to set audiodg.exe affinity every hour
schtasks /create /sc MINUTE /tn audiodg-affinity-recurring /mo 60 /tr "wscript.exe $vbScriptPath $psScriptPath" /rl HIGHEST

# Run the PowerShell script once to set the affinity for the current session
powershell.exe -ExecutionPolicy Bypass -File $psScriptPath

# Output completion message
Write-Host "INSTALLATION FINISHED!"
Write-Host "Note: Ignore 'Access is denied' in Windows Terminal in case you see it." -ForegroundColor Blue
Pause
