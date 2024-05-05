oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/catppuccin_mocha.omp.json" | Invoke-Expression
Invoke-Expression (& { (zoxide init --cmd cd powershell | Out-String) })

# █▀▀ █░█ █▄░█ █▀▀ ▀█▀ █ █▀█ █▄░█ █▀
# █▀░ █▄█ █░▀█ █▄▄ ░█░ █ █▄█ █░▀█ ▄█
function lazy {
	lazygit
}
function gitShort {
	git
}


# ▄▀█ █░░ █ ▄▀█ █▀
# █▀█ █▄▄ █ █▀█ ▄█
# cd
Set-Alias towindowsrepo windowsRepoDir
Set-Alias torepo repoDir
Set-Alias codeWindowsRepo editWindows
# 
Set-Alias lg lazy
Set-Alias g gitShort
