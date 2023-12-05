# Install Windows Terminal settings
mkdir ~\Appdata\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\
Copy-Item -Recurse -Force .\conf\terminal\settings.json ~\Appdata\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\

# Install linux_hotkey
Copy-Item -Recurse -Force .\scripts\AHK\linux_hotkey.ahk '~\Appdata\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\'