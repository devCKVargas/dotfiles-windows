# █▀▀ █░█ █▄░█ █▀▀ ▀█▀ █ █▀█ █▄░█ █▀
# █▀░ █▄█ █░▀█ █▄▄ ░█░ █ █▄█ █░▀█ ▄█
# Utility
function Test-CommandExists($command) {
    $exists = $null -ne (Get-Command $command -ErrorAction SilentlyContinue)
    return $exists
}

# Editor Configuration
$EDITOR = if (Test-CommandExists nvim) { 'nvim' }
            elseif (Test-CommandExists pvim) { 'pvim' }
            elseif (Test-CommandExists vim) { 'vim' }
            elseif (Test-CommandExists vi) { 'vi' }
            elseif (Test-CommandExists code) { 'code' }
            elseif (Test-CommandExists notepad++) { 'notepad++' }
            elseif (Test-CommandExists sublime_text) { 'sublime_text' }
            else { 'notepad' }
Set-Alias -Name nvim -Value $EDITOR
Set-Alias -Name vim -Value $EDITOR

$features = @{
    # Command Not Found requirements (*)
    modules      =
    "Terminal-Icons",
    "Microsoft.WinGet.Client", # *
    "PSReadLine", 
    "PowerShellGet"
    # Requirement
    experimental =
    "PSFeedbackProvider", # *
    "PSCommandNotFoundSuggestion" # *
    powertoys    =
    "Microsoft.Winget.CommandNotFound" # * PowerToys Command Not Found (pkg suggestion)
}
Import-Module $features.powertoys
$terminalIcons = $features.modules[0]

# Add PSGallery to Trusted PS Repository
if (-not (Get-PSRepository -Name PSGallery)) {
    try {
        Register-PSRepository -Name PSGallery -SourceLocation https://www.powershellgallery.com/api/v2/ -InstallationPolicy Trusted
    }
    catch {
        if (-not (Get-PSRepository -Name PSGallery)) {
            Register-PSRepository -Default -InstallationPolicy Trusted
        }
    }
}

# Install-Modules
foreach ($module in $features.modules) {
    if (-not (Get-InstalledModule -Name $module)) {
        Write-Host "Installing module: $($module)..."
        Install-Module -Name $module -AcceptLicense -SkipPublisherCheck
        # Import Terminal Icons module
        if ($module -eq $terminalIcons) {
            Import-Module -Name $module
        }
    }
}

# Enable Experimental Features
foreach ($feature in $features.experimental) {
    if (-not [ExperimentalFeature]::IsEnabled("$feature")) {
        Enable-ExperimentalFeature $feature
    }
}

function z { zoxide }
function lazyg($option, $messsage) { 
    git init
    git add $option
    git commit -m "$messsage"
}
function lg { lazygit }

# Enhanced Listing
function la { Get-ChildItem -Path . -Force | Format-Table -AutoSize }
function ll { Get-ChildItem -Path . -Force -Hidden | Format-Table -AutoSize }

# git
# function g($options) { git $options } # TEST
function gs($options) { git status $options }
function ga { git add . }
function gc($m) { git commit -m "$m" }
function gshow($commit) { git show $commit | bat -l rs } # TODO: fix when bat is missing
function glog { git log --oneline --decorate --graph --format=format:'%C(bold yellow)%h%C(reset) %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' }
# powershell profile
function update-profile { & $profile }
function edit-profile { nvim $profile }
function mkcd($dir) { mkdir $dir -Force; Set-Location $dir }

# System Utils
function export($name, $value) {
    set-item -force -path "env:$name" -value $value;
}
function df { get-volume }
function which($name) {
    Get-Command $name | Select-Object -ExpandProperty Definition
}
# History
function clearAllHistory {
    if (Test-Path (Get-PSReadLineOption).HistorySavePath) {
        $answer = Read-Host -Prompt "This will clear every history from all sessions. Are you sure? (Y/n)"
        if (-not $answer) { $answer = 'Y' }
        if ($answer -eq "Y" -or $answer -eq "y") {
            try {
                Remove-Item -Force ((Get-PSReadLineOption).HistorySavePath)
                Write-Host "History cleared!" -ForegroundColor Green 
                Write-Host "It will take effect on the next PowerShell restart" -ForegroundColor Yellow
            }
            catch {
                Write-Error "Could not clear history. $_"
            }
        }
        else {
            return $null
        }
    }
    else {
        Write-Host "No history found." -ForegroundColor Red
    }
}
function clearAllHistoryWindowsPS {
    $answer = Read-Host -Prompt "This will clear every history from all sessions (Windows PowerShell). Are you sure? (Y/n)"
    if (-not $answer) { $answer = 'Y' }
    if ($answer -eq "Y" -or $answer -eq "y") {
        try {
            [Microsoft.PowerShell.PSConsoleReadLine]::ClearHistory()
            Write-Host "History cleared!" -ForegroundColor Green 
            Write-Host "You might have to restart PowerShell for this to take effect." -ForegroundColor Yellow
        }
        catch {
            Write-Error "Could not clear history. $_"
        }
    }
    else {
        return $null
    }
}
