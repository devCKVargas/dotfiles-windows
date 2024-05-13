#34de4b3d-13a8-4540-b76d-b9e8d3851756 PowerToys CommandNotFound module

Import-Module "C:\Users\devck\AppData\Local\PowerToys\WinUI3Apps\..\WinGetCommandNotFound.psd1"
#34de4b3d-13a8-4540-b76d-b9e8d3851756

oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/catppuccin_mocha.omp.json" | Invoke-Expression

if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init --cmd cd powershell | Out-String) })
} else {
    Write-Host "zoxide command not found. Attempting to install via winget..."
    try {
        winget install -e --id ajeetdsouza.zoxide
        Write-Host "zoxide installed successfully. Initializing..."
        Invoke-Expression (& { (zoxide init powershell | Out-String) })
    } catch {
        Write-Error "Failed to install zoxide. Error: $_"
    }
}

if (-not (Get-Module -ListAvailable -Name Terminal-Icons)) {
    Install-Module -Name Terminal-Icons -Scope CurrentUser -Force -SkipPublisherCheck
}
Import-Module -Name Terminal-Icons

# █▀▀ █░█ █▄░█ █▀▀ ▀█▀ █ █▀█ █▄░█ █▀
# █▀░ █▄█ █░▀█ █▄▄ ░█░ █ █▄█ █░▀█ ▄█
# Utility
function Test-CommandExists {
    param($command)
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
Set-Alias -Name vim -Value $EDITOR

# ▄▀█ █░░ █ ▄▀█ █▀
# █▀█ █▄▄ █ █▀█ ▄█
function z { zoxide }
function lazy { lazygit }
function lg { lazygit }

# Enhanced Listing
function la { Get-ChildItem -Path . -Force | Format-Table -AutoSize }
function ll { Get-ChildItem -Path . -Force -Hidden | Format-Table -AutoSize }

# git
function g { git }
function gs { git status }
function ga { git add . }
function gc {
    param($m) git commit -m "$m"
}
function glogs { git log --oneline --decorate --graph --format=format:'%C(bold yellow)%h%C(reset) %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' }

# powershell profile
function reload-profile { & $profile }
function edit-profile { vim $PROFILE }
function mkcd { 
    param($dir)
    mkdir $dir -Force;
    Set-Location $dir }

# System Utils
function export($name, $value) {
    set-item -force -path "env:$name" -value $value;
}
function df { get-volume }
function which($name) {
    Get-Command $name | Select-Object -ExpandProperty Definition
}
