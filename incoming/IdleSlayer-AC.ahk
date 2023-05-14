#MaxThreadsPerHotkey 2
#SingleInstance Force
#persistent

#Include KnirchLib\Reloader.ahk

Tab::
	if toggle
		OutputDebug, %A_Now%: toggled off for %win%

	toggle:=!toggle

	if toggle {
		win := WinExist("A")
		OutputDebug, %A_Now%: toggled on for %win%
	}

	while toggle {
		ControlSend, , Hello, ahk_id %win%
		Sleep 100
	}

return
