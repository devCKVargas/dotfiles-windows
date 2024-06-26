# █▀▀ █░█ █▄░█ █▀▀ ▀█▀ █ █▀█ █▄░█ █▀
# █▀░ █▄█ █░▀█ █▄▄ ░█░ █ █▄█ █░▀█ ▄█
# Utility
function Test-CommandExists($command) {
    $exists = $null -ne (Get-Command $command -ErrorAction SilentlyContinue)
    return $exists
}
function PkgMissingSuggestion($pkg, $pkgID) {
    Write-Host "$pkg is not installed" -ForegroundColor Yellow
    Write-Host " ➤ winget install --id $pkgID" -ForegroundColor Green
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

function hist {
    # hist (command)
    $find = $args
    Write-Host "Full history:"
    $historyPath = (Get-PSReadlineOption).HistorySavePath
    $history = Get-Content $historyPath | Where-Object { $_ -like "*$find*" } | Get-Unique # | more
    
    $index = 1
    foreach ($line in $history) {
        Write-Host "${index}: $line"
        $index++
    }
}

if (Test-CommandExists oh-my-posh) {
    oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/catppuccin_mocha.omp.json" | Invoke-Expression
}
else {
    PkgMissingSuggestion "oh-my-posh" "gerardog.gsudo"
}

# Ctrl + T; access current path
# Ctrl + R; access previous history, insert the command into the current line, but will not execute
# ALT + C; cd into directory
# Ref: https://github.com/kelleyma49/PSFzf?tab=readme-ov-file#psreadline-integration
if (Test-CommandExists fzf) {
    #     $ENV:FZF_DEFAULT_OPTS=@"
    # --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796
    # --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6
    # --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796
    # "@
    
    # $env:FZF_DEFAULT_OPTS='--preview "bat --color=always --style=numbers --line-range=:500 {}' # TODO: fix when bat is missing
    # TODO: fix bat preview with fzf || PsFzf CTRL T
    if (Test-CommandExists Set-PsFzfOption) {
        # replace 'Ctrl+t' and 'Ctrl+r' with your preferred bindings:
        Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
        # Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion } # replace the standard tab completion
    }
    else {
        try {
            Install-Module -Name PSFzf
        }
        catch {
            Write-Error "PsFzf error: $_"
        }
    }
}

function installCatppuccinBat {
    $batConfigDir = & bat --config-dir
    $batConfigFile = & bat --config-file
    $themeUrl = "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme"
    $themeName = "Catppuccin Mocha"
    $themeFilePath = "$batConfigDir/themes/$themeName.tmTheme"
    
    if (-not (Test-Path $batConfigDir)) {
        mkdir $batConfigDir -Force
    }
    
    if (-not (Test-Path $themeFilePath) -or (-not (Get-Content $batConfigFile | Select-String $themeName))) {
        try {
            if (-not (Test-CommandExists "wget")) {
                try {
                    winget install JernejSimoncic.Wget -Force
                }
                catch {
                    Write-Error $_
                }
            }
            wget -P "$batConfigDir/themes" $themeUrl
            if ($?) {
                bat cache --build
                $env:BAT_THEME = $themeName
                if (-not (Test-Path $batConfigFile)) {
                    Write-Host --theme='"'$themeName'"' >> $batConfigFile
                }
                else {
                    if (-not (Get-Content $batConfigFile | Select-String $themeName)) {
                        Write-Host --theme='"'$themeName'"' >> $batConfigFile
                    }
                }
            }
        }
        catch {
            Write-Error $_
        }
    }
}

if (Test-CommandExists bat) {
    installCatppuccinBat
}
else {
    PkgMissingSuggestion "bat" "sharkdp.bat"
}

if (Test-CommandExists gsudo) {
    Import-Module "gsudoModule"
    Set-Alias -Name "sudo" -Value "gsudo"
    if (-not (gsudo config CacheMode | Select-String "Auto")) {
        gsudo config CacheMode Auto # https://gerardog.github.io/gsudo/docs/credentials-cache#cache-modes
    }
}
else {
    PkgMissingSuggestion "gsudo" "gerardog.gsudo"
}

if (Test-CommandExists zoxide) {
    $env:_ZO_ECHO = '1' #print the matched directory before navigating to it
    Invoke-Expression (& { (zoxide init --cmd cd powershell | Out-String) })
}
else {
    Write-Host "zoxide command not found. Attempting to install via winget..."
    try {
        winget install --id ajeetdsouza.zoxide
        if ($?) {
            Write-Host "zoxide installed successfully. Initializing..."
            Invoke-Expression (& { (zoxide init powershell | Out-String) })
        }
    }
    catch {
        Write-Error "Failed to install zoxide. Error: $_"
    }
}