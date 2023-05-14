stdout:=FileOpen("*", "w") ; for stdout

!Tab::
	Outputdebug, hi
	Loop 2 {
		Outputdebug, FIRST_LOOP

		WinGet windows, List
		Loop %windows%
		{
			Outputdebug, winST_LOOP
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
			outputdebug, %A_Index% %title%

			WinGet, style, style, ahk_id %id%
			if !(style & 0xC00000) ; if the window doesn't have a title bar
				continue

			if (f == True)
			{
				outputdebug, got the one I want to activate
				WinGetClass, Class, ahk_id %id%
				if (Class="Windows.UI.Core.CoreWindow")
				{
					WinActivate, ahk_id %id% ahk_class ApplicationFrameWindow
				} else {
					WinActivate, ahk_id %id%
				}

				f:=False
				outputdebug, bailing
				return
			}

			WinGet, Path, ProcessPath, ahk_id %id%
			if WinActive("ahk_id" id) {
				outputdebug, found the active %title%
				f:=True
			}
		}
	}
	outputdebug, am I done
return
