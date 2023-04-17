#MaxThreadsPerHotkey 2
; #SingleInstance Force
; #persistent

; #Include KnirchLib\Reloader.ahk

WinWait, ahk_exe RobloxPlayerBeta.exe
WinActivate
WinWaitActive, ahk_exe RobloxPlayerBeta.exe
Send, d
outputdebug well hello
exit

;; https://www.autohotkey.com/docs/KeyList.htm#modifier

^Tab::
	if toggle {
		OutputDebug, %A_Now%: toggled off for %win%
	}

	toggle := !toggle

	while toggle {
		WinGet, window_list, List, ahk_exe RobloxPlayerBeta.exe
		loop, %window_list% {
			window := % window_list%A_Index%
			if WinActive("ahk_id" window) {
				BlockInput, On

				WinGet, old_window, ID, A
				WinActivate, ahk_id %window%
				Sleep, 100

				Send, {Space Down}
				Sleep, 50
				Send, {Space Up}

				WinSet, Bottom,, ahk_id %window%
				WinActivate, ahk_id %old_window%

				BlockInput, Off
			}
			sleep 1000
		}

		;; ControlSend // Send simulated keystrokes to a window or control
		; ControlSend, ,e
		if WinExist("Roblox") {
			ControlSend, ahk_parent, {Space down}, Roblox
			sleep 100
			ControlSend, ahk_parent, {Space iup}, Roblox
			Send {Space}
			OutputDebug "yaaay"
		} else {
			OutputDebug "poop"
		}
		Sleep 1000
		; Send e
	}

return
