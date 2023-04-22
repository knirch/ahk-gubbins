#MaxThreadsPerHotkey 2
#SingleInstance Force
#persistent

#Include KnirchLib\Reloader.ahk

Tab::
	if toggle
		OutputDebug, %A_Now%: toggled off for %win%

	toggle:=!toggle

	While toggle {
		Send e
		; MouseClick, left
		Sleep 1000
		; Sleep 100
		; Sleep 10
	}

return
