#Requires AutoHotkey v2.0

; Variables
browser := "msedge"
editor := "code"

; Keybindings ( #=WindowKey )
#q::Send "!{F4}" ; Simulate Alt + F4
#b::Run browser
#c::Run editor
