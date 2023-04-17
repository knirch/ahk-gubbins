; #MaxThreadsPerHotkey 2
#SingleInstance Force
#persistent

#Include %A_ScriptDir%\KnirchLib\Reloader.ahk
SetTimer, RobloxAC, 10000

; WinMove, ahk_exe RobloxPlayerBeta.exe, , , , 200, 200 ; This is what you asked for!
return

RobloxAC:
	WinWait, ahk_exe RobloxPlayerBeta.exe
	WinGet, old_window, ID, A
	BlockInput, On

	WinActivate
	WinWaitActive
	Send, {e down}
	Send, {e up}
	WinSet, Bottom
	WinActivate, ahk_id %old_window%

	BlockInput, Off
return
