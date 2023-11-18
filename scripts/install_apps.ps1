### > irm https://massgrave.dev/get | iex             # Microsoft Activation Scripts (massgrave.dev)
### > iwr -useb https://christitus.com/win | iex      # WinUtil (ChrisTitusTech)

# █░█░█ █ █▄░█ █▀▀ █▀▀ ▀█▀   █▀▀ █ ▀▄▀ # Winget (FIX! Slow Download)
# ▀▄▀▄▀ █ █░▀█ █▄█ ██▄ ░█░   █▀░ █ █░█ # `winget settings`
#"network": {
#   "downloader": "wininet" // or "do" when (delivery optimization is enabled)
#},

# █▀▀ █░█ █▀█ █▀▀ █▀█ █░░ ▄▀█ ▀█▀ █▀▀ █▄█
# █▄▄ █▀█ █▄█ █▄▄ █▄█ █▄▄ █▀█ ░█░ ██▄ ░█░
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# █▀▀ █░█ █▀█ █▀▀ █▀█
# █▄▄ █▀█ █▄█ █▄▄ █▄█
choco install "winget" "eartrumpet" "traffic-monitor" "nerd-fonts-jetbrainsMono" "nerd-fonts-arimo" "nerd-fonts-meslo" "dotnet-all" "vcredist-all" "winfetch" "openal" -y
choco cache remove -y # clear chocolatey cache

# █░█░█ █ █▄░█ █▀▀ █▀▀ ▀█▀
# ▀▄▀▄▀ █ █░▀█ █▄█ ██▄ ░█░ # Update current apps
winget update --all -h --disable-interactivity ## --silent | -h

# █▀▄ █▀▀ █░█
# █▄▀ ██▄ ▀▄▀ # --source | -s (winget,msstore)
winget install "git" "github cli" "github desktop" "lazygit" "nodejs" "terminal" "powershell" "Microsoft Visual Studio Code" "figma" "imagemagick" "ResponsivelyApp" -s winget --accept-package-agreements --accept-source-agreements -h

# ▄▀█ █▀█ █▀█ █▀
# █▀█ █▀▀ █▀▀ ▄█
winget install "nvcleanstall"  "powertoys" "nilesoft shell" "caprine" "discord" "telegram" "megasync" "fdm" "canva" "ahk" "k-lite mega codec pack" "obs studio" "VLC media player" "winrar" "anydesk" "gpu-z" "f.lux" "afterburner" "superf4" "wingetUI" "oracle.JDK.18" "7-zip" "Alex313031.Thorium" "Microsoft XNA Framework Redistributable Refresh" "CPUID CPU-Z" -s winget --accept-package-agreements --accept-source-agreements -h