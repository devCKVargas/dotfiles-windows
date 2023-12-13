oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/catppuccin_mocha.omp.json" | Invoke-Expression

# █▀▀ █░█ █▄░█ █▀▀ ▀█▀ █ █▀█ █▄░█ █▀
# █▀░ █▄█ █░▀█ █▄▄ ░█░ █ █▄█ █░▀█ ▄█
function windowsRepoDir {
	cd ~\github\windows\
}
function repoDir {
	cd ~\github\
}
function editWindows {
	cd ~\github\windows\ && code .
}
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
