#Requires AutoHotkey v2.0

; Reload Script Dialog (Ctrl + Super + R)
^#r::{
	if MsgBox("Reload the script?",, "Y/N") = "Yes"
		Reload
}

; █░█ ▄▀█ █▀█
; ▀▄▀ █▀█ █▀▄
terminal := "wt" ; windows terminal
browser := "msedge"
editor := "code"
spotify := "spotify"
currentYear := A_YYYY ; i.e. 2023
currentMonth := A_MM ; i.e. 12
screenshotFolder := "D:\ShareX\Screenshots\" . currentYear . "-" . currentMonth

; ▄▀█ █▀█ █▀█ █▀	Note:
; █▀█ █▀▀ █▀▀ ▄█	# WindowKey, ^ Ctrl, ! Alt

#enter::Run terminal ; launch terminal (Super + Enter)

#NumpadEnter::Run terminal ; launch terminal (Super + NumpadEnter)

; Run terminal (Elevated)
^#enter::Run '*RunAs "' terminal '"'
^#NumpadEnter::Run '*RunAs "' terminal '"'

#b::Run browser ; launch msedge (Super + B)

#c::Run(editor, , "Hide") ; launch vscode (Super + C)

; launch spotify (Ctrl + Super + Alt + S)
#^!s:: {
    exeName := "Spotify.exe"
    spotifyPath := EnvGet("APPDATA") "\Spotify\" exeName

    if WinExist("ahk_exe " exeName) {
        WinActivate("ahk_exe " exeName)
        return
    }

    if FileExist(spotifyPath) {
        spotifyDir := StrReplace(spotifyPath, "\" exeName)

        ; Get only the user PATH from registry
        try userPath := RegRead("HKCU\Environment", "Path")
        catch {
            userPath := ""
        }

        ; Avoid duplicate if already in PATH
        if !InStr(userPath, spotifyDir) {
            newPath := userPath (SubStr(userPath, -1) = ";" || userPath = "" ? "" : ";") spotifyDir
            RegWrite newPath, "REG_SZ", "HKCU\Environment", "Path"

            ; Broadcast PATH update to system
            DllCall("SendMessageTimeout", "Ptr", 0xFFFF, "UInt", 0x1A, "Ptr", 0, "Str", "Environment", "UInt", 0x2, "UInt", 5000, "PtrP", 0)

            MsgBox "Spotify folder added to your user PATH. Restart Explorer or terminal to apply.", "PATH Updated", 64
        }

        Run spotifyPath
    } else {
        MsgBox "Spotify.exe not found in %APPDATA%\Spotify", "Error", 48
    }
}

; launch UnigetUI(WingetUI) (Super + W)
#w:: {
    exeName := "UniGetUI.exe"
    localAppData := EnvGet("LOCALAPPDATA")
    programFiles := EnvGet("ProgramFiles")

    possiblePaths := [
        localAppData "\Programs\UniGetUI\" exeName,
        programFiles "\UniGetUI\" exeName
    ]

    if WinExist("ahk_exe " exeName) {
        WinActivate("ahk_exe " exeName)
        return
    }

    for exePath in possiblePaths {
				; Avoid duplicate if already in PATH
        if FileExist(exePath) {
            exeDir := StrReplace(exePath, "\" exeName)

            ; Read ONLY the user PATH
            try userPath := RegRead("HKCU\Environment", "Path")
            catch {
                userPath := ""
            }

            if !InStr(userPath, exeDir) {
                newPath := userPath (userPath = "" || SubStr(userPath, -1) = ";" ? "" : ";") exeDir
                RegWrite newPath, "REG_SZ", "HKCU\Environment", "Path"

                ; Broadcast updated env to the system
                DllCall("SendMessageTimeout", "Ptr", 0xFFFF, "UInt", 0x1A, "Ptr", 0, "Str", "Environment", "UInt", 0x2, "UInt", 5000, "PtrP", 0)

                MsgBox "UniGetUI folder added to your user PATH. Restart Explorer or terminal to apply.", "PATH Updated", 64
            }

            Run exePath
            return
        }
    }

    MsgBox "UniGetUI.exe not found in known locations.", "Error", 48
}

#z::Run "zen"	;	launch zen browser (Super + Z)

; █░█░█ █ █▄░█ █▀▄ █▀█ █░█░█
; ▀▄▀▄▀ █ █░▀█ █▄▀ █▄█ ▀▄▀▄▀

; close active window (Super + Q)
#q::Send "!{F4}"

; close active window (Ctrl + Q) (Disabled)
; ^q::Send "!{F4}"

toggleWinState(mode := "maximize") {
    if (WinGetMinMax("A") > 0)
        WinRestore "A"
    else if (mode = "maximize")
        WinMaximize "A"
    else if (mode = "minimize")
        WinMinimize "A"
}

#f::toggleWinState("maximize")  ;	maximize active window (Super + F) (toggle)
#PgUp::toggleWinState("maximize")   ;	maximize active window (Super + PgUp) (toggle)
#PgDn::toggleWinState("minimize")   ;	minimize active window (Super + PgDn)

;	open ShareX screenshot folder (Super + Shift + X)
#+x:: Run screenshotFolder

; TODO: ADD voicemeeter as volcontrol := "voicemeeter"
