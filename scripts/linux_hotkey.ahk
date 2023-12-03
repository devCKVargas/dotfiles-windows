#Requires AutoHotkey v2.0

;===========Variables==========;
terminal := "wt"		; windows terminal
browser := "msedge"
editor := "code"

;===========APPS==========; ( #=WindowKey )
#b::Run browser								; 	launch msedge
#c::Run editor								; 	launch vscode
#enter:: Run terminal					; 	launch terminal
#NumpadEnter:: Run terminal		; 	launch terminal
;============WINDOW===========;
#q::Send "!{F4}"							; 	close active window | Simulate Alt + F4
#f::WinMaximize "A"						; 	maximize active window
#PgUp::WinMaximize "A"				; 	Same as 👆
#PgDn::WinMinimize "A"				; 	minimize active window



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