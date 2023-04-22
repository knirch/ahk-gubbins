;#MaxThreadsPerHotkey 2
#SingleInstance Force
#Persistent

#Include %A_ScriptDir%\KnirchLib\Reloader.ahk


Tab::
	if toggle{
		OutputDebug, %A_Now%: toggled off for %win%
	}

	toggle:=!toggle

	if toggle {
		win := WinExist("A")
		OutputDebug, %A_Now%: toggled on for %win%
	}

	while toggle {
		ControlSend,,n, ahk_id %win%
		Sleep 60
	}
return
