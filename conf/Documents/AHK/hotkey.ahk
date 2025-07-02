#Requires AutoHotkey v2.0

^#r::{															; 	Reload Script Dialog ; Ctrl + Super + R
	if MsgBox("Reload the script?",, "Y/N") = "Yes"
		Reload
}

; █░█ ▄▀█ █▀█
; ▀▄▀ █▀█ █▀▄
terminal := "wt"			; windows terminal
browser := "msedge"
editor := "code"
spotify := "spotify"
currentYear := A_YYYY ; i.e. 2023
currentMonth := A_MM	; i.e. 12
screenshotFolder := "D:\--ShareX--\Screenshots\" . currentYear . "-" . currentMonth

; ▄▀█ █▀█ █▀█ █▀	Note:
; █▀█ █▀▀ █▀▀ ▄█	# WindowKey, ^ Ctrl, ! Alt
; WINDOWS TERMINAL
#enter:: Run terminal								; 	Super + Enter 						-	launch terminal
#NumpadEnter:: Run terminal					; 	Super + NumpadEnter 			-	launch terminal
^#enter::Run '*RunAs "' terminal '"'
^#NumpadEnter::Run '*RunAs "' terminal '"'
#b::Run browser											; 	Super + B 								-	launch msedge
#c::Run editor											; 	Super + C 								-	launch vscode
#^!s:: Run spotify									; 	Ctrl + Super + Alt + S 		-	launch spotify
;	launch spotify (Ctrl + Super + Alt + S)
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

; █░█░█ █ █▄░█ █▀▄ █▀█ █░█░█
; ▀▄▀▄▀ █ █░▀█ █▄▀ █▄█ ▀▄▀▄▀	ToolTip "Window is Maximized"
#q::Send "!{F4}"										; 	Super + Q									-	close active window
^q::Send "!{F4}"										; 	Ctrl + Q									-	close active window(Disabled)
#f::{ 															;		Super + F									-	toggle maximize active window
	ActWinState:=WinGetMinMax("A")
	if(ActWinState > 0){
		WinRestore "A"
	} else WinMaximize "A"
}
#PgUp::{ 														; 	Super + PgUp							-	toggle maximize active window
	ActWinState:=WinGetMinMax("A")
	if(ActWinState > 0){
		WinRestore "A"
	} else WinMaximize "A"
}
#PgDn::{														;		Super + PgDn  						-	toggle unmaximize active window
	ActWinState:=WinGetMinMax("A")
	if(ActWinState > 0){
		WinRestore "A"
	} else WinMinimize "A"
}
#+x:: Run screenshotFolder					; 	Super + Shift + X					-	open ShareX screenshot folder

; TODO: ADD voicemeeter as volcontrol := "voicemeeter"
