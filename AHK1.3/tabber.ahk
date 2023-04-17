#Requires AutoHotkey <2
#SingleInstance Force

; Lifted from: https://www.autohotkey.com/boards/viewtopic.php?p=227129#p227129
; Simple Alt-Tab replacement

!Tab::
	Menu, Windows, Add

	WinGet windows, List
	Loop %windows%
	{
		id := windows%A_Index%

		WinGetTitle title, ahk_id %id%
		if (title = "")
			continue

		WinGetClass class, ahk_id %id%
		if (class = "ApplicationFrameWindow")
		{
			WinGetText, text, ahk_id %id%
			if (text = "")
			{
				WinGet, style, style, ahk_id %id%
				if !(style = "0xB4CF0000") ; the window isn't minimized
					continue
			}
		}

		WinGet, style, style, ahk_id %id%
		if !(style & 0xC00000) ; if the window doesn't have a title bar
			continue

		WinGet, Path, ProcessPath, ahk_id %id%
		Menu, Windows, Add, %title%, Activate_Window
		try Menu, Windows, Icon, %title%, %Path%,, 0
		catch {
			; Unsure if this works, hasn't triggered yet
			msgbox, "Undocumented: KCH_1"
			Menu, Windows, Icon, %title%, %A_WinDir%\System32\SHELL32.dll, 3, 0
		}
	}
	Menu, Windows, Show
return

Activate_Window:
	SetTitleMatchMode, 3 ; exact match
	WinGetClass, Class, %A_ThisMenuItem%
	if (Class="Windows.UI.Core.CoreWindow") ; the minimized window has another class
	{
		; I currently do not know if this code is correct as I don't remember
		; which program this was required for. On my Surface I don't seem to
		; have any programs that triggers this.
		MsgBox, "Undocumented: KCH_2"
		WinActivate, %A_ThisMenuItem% ahk_class ApplicationFrameWindow
	} else
		WinActivate, %A_ThisMenuItem%
return
