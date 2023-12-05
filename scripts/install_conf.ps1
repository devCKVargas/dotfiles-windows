mkdir -Force ~\Appdata\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\ # Create windows terminal directory
Copy-Item -Recurse -Force .\conf\terminal\settings.json ~\Appdata\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\ # Install Windows Terminal settings
Copy-Item -Recurse -Force .\scripts\AHK\linux_hotkey.ahk '~\Appdata\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\' # Install linux_hotkey
