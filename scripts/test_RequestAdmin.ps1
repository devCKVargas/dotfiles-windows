function Request-Admin {
    param (
        [scriptblock]$ScriptBlock
    )

    $params = @{
        FilePath = 'pwsh.exe'
        Verb = 'RunAs'
        Wait = $true
    }

    if ($ScriptBlock) {
        $params['ArgumentList'] = "-ExecutionPolicy Bypass -Command & {$ScriptBlock}"
    }

    try {
        Start-Process @params -ErrorAction Stop
    }
    catch {
        if ($_.Exception.Message -match 'The operation was canceled by the user') {
            Write-Host -ForegroundColor Yellow "Admin request denied. Exiting gracefully."
        }
        else {
            throw $_  # Re-throw the exception if it's not a user cancellation
        }
    }
}


# Use the Request-Admin function with ScriptPath
$hasOverride = Read-Host -Prompt "Enable Installer Hash Override? (Y/n)"
if (-not $hasOverride) { $hasOverride = 'Y' }

if ($hasOverride -eq 'Y' -or $hasOverride -eq 'y') {
    # Request Admin permission
		Request-Admin -ScriptBlock {
			winget settings --enable InstallerHashOverride
			Write-Host -ForegroundColor Green "Hash Override Enabled"
    }
} else {
    Write-Host -ForegroundColor Yellow "Denied."
}

# Use the Request-Admin function with ScriptBlock
$updateChoco = Read-Host -Prompt "Update installed apps? (Y/n)"
if (-not $updateChoco) { $updateChoco = 'Y' }

if ($updateChoco -eq 'Y' -or $updateChoco -eq 'y') {
    # Request Admin permission
    Request-Admin -ScriptBlock {
        Write-Host "Updating Chocolatey apps..."
        choco upgrade all -y
    }
} else {
    Write-Host -ForegroundColor Yellow "Skipping updates."
}

Write-Host -ForegroundColor Green "
+-+-+-+-+-+
|D|o|n|e|!|
+-+-+-+-+-+ "
