
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


# ▄▀█ █░░ █ ▄▀█ █▀
# █▀█ █▄▄ █ █▀█ ▄█
# cd
Set-Alias towindowsrepo windowsRepoDir
Set-Alias torepo repoDir
Set-Alias codeWindowsRepo editWindows
# 
Set-Alias lg lazy
