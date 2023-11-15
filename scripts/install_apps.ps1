### > irm https://massgrave.dev/get | iex             # Microsoft Activation Scripts (massgrave.dev)
### > iwr -useb https://christitus.com/win | iex      # WinUtil (ChrisTitusTech)

### Winget (FIX! Slow Download)
# `winget settings` add
# "network": {
#    "downloader": "wininet" // or "do" when (delivery optimization is enabled)
# }

### Install chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

### Install apps (chocolatey)
choco install "winget" "dotnet-all" "vcredist-all" "eartrumpet" "traffic-monitor" "nerd-fonts-jetbrainsMono" "nerd-fonts-arimo" "nerd-fonts-meslo" -y

### Update current apps (winget)
winget update --all -h --disable-interactivity ## --silent | -h

### Install apps (winget)		# --source | -s (winget,msstore)
winget install "git" "github cli" "github desktop" "lazygit" "nodejs" "terminal" "powershell" "powertoys" "traffic monitor" "nilesoft shell" "caprine" "discord" "telegram" "megasync" "fdm" "ahk" "k-lite mega codec pack" "obs studio" "VLC media player" "winrar" "anydesk" "gpu-z" "f.lux" "afterburner" "nvcleanstall" "superf4" "wingetUI" "oracle.JDK.18" "7-zip" "Alex313031.Thorium" --id "cpuidcpu-z.taichi" -s winget --accept-package-agreements --accept-source-agreements -h

choco cache remove -y # clear chocolatey cache

# App list
### Chocolatey pkgs
# "winget" (winget-cli)
# "dotnet-all" (.NET runtimes)
# "vcredist-all" (Visual C++ runtimes)
# "eartrumpet" (Volume Control)
# "traffic-monitor" (Network Speed monitor)
# "nerd-fonts-jetbrainsMono" (font) 
# "nerd-fonts-arimo" (font)
# "nerd-fonts-meslo" (font)
### Winget pkgs
# "git"
# "github clig"
# "github desktop"
# "nodejs"
# "terminal"
# "powershell" (powershell7)
# "powertoys"
# "traffic monitor"
# "caprine" (Messenger)
# "discord"
# "telegram"
# "megasync"
# "fdm" (free download manager)
# "ahk" (AutoHotKey)
# "k-lite mega codec pack"
# "obs studio"
# "VLC media player"
# "winrar"
# "anydesk"
# "gpu-z"
# "f.lux"
# "afterburner"
# "nvcleanstall"
# "superf4"
# "wingetUI"
# "oracle.JDK.18" (Java JDK 18)
# "7-zip"
# "Alex313031.Thorium" (Thorium Browser)
# --id "cpuidcpu-z.taichi" (CPU-Z version Taichi)