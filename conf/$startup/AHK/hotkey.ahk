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