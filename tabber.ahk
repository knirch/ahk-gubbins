; solution borrowed from
; https://www.autohotkey.com/boards/viewtopic.php?t=62395

;; idea: alt-tab, but do not show a window, just iterate over the windows and
;; find the activated one, then one step further and select that one.

!Tab::
	Menu, Windows, Add
	Menu, Windows, deleteAll

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
		{
			; If title not contains ... ; add exceptions
			continue
		}

		WinGet, Path, ProcessPath, ahk_id %id%
		Menu, Windows, Add, %title%, Activate_Window
		try {
			Menu, Windows, Icon, %title%, %Path%,, 0
		} catch {
			Menu, Windows, Icon, %title%, %A_WinDir%\System32\SHELL32.dll, 3, 0
		}
	}
	Menu, Windows, Show
return

Activate_Window:
	SetTitleMatchMode, 3
	WinGetClass, Class, %A_ThisMenuItem%
	if (Class="Windows.UI.Core.CoreWindow") ; the minimized window has another class
		WinActivate, %A_ThisMenuItem% ahk_class ApplicationFrameWindow
	else
		WinActivate, %A_ThisMenuItem%
return
