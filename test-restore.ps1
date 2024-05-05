Write-Host @"
	█▀█ █▀▀ █▀ ▀█▀ █▀█ █▀█ █▀▀   █▀▀ █▀█ █▄░█ █▀▀
	█▀▄ ██▄ ▄█ ░█░ █▄█ █▀▄ ██▄   █▄▄ █▄█ █░▀█ █▀░
"@

$restoreConfScriptFile = "restore_conf.ps1"

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
