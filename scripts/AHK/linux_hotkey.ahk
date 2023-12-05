#Requires AutoHotkey v2.0

;===========Variables=========;
terminal := "wt"		; windows terminal
browser := "msedge"
editor := "code"

;==============APPS===========; 	#=WindowKey ; ^=Ctrl
#b::Run browser								; 	Super + B 						- launch msedge
#c::Run editor								; 	Super + C 						- launch vscode
#enter:: Run terminal					; 	Super + Enter 				- launch terminal
#NumpadEnter:: Run terminal		; 	Super + NumpadEnter 	- launch terminal
;============WINDOW===========;============================================
#q::Send "!{F4}"							; 	Super + Q							- close active window
^q::Send "!{F4}"							; 	Ctrl + Q							- close active window
#f::WinMaximize "A"						; 	Super + F							- maximize active window
#PgUp::WinMaximize "A"				; 	Super + PgUp					- maximize active window
#PgDn::WinMinimize "A"				; 	Super + PgDn					- minimize active window



;=============TODO============;
; ADD voicemeeter as volcontrol := "voicemeeter"
;
; fix: 👇 Toggle maximize window  
; #f:: ; Win + F
; {
;     WinGet, MX, MinMax, A
;     if (MX = 1) {
;         WinMinimize, A
;     } else {
;         WinRestore, A
;     }
;     return
; }