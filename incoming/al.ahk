; solution borrowed from
; https://www.autohotkey.com/boards/viewtopic.php?t=62395

;# ahk_id 0x1907c2

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

	WinActivate, ahk_id %id%
	; sendinput, #{Left}
	; sendinput, #{Right}
	sendinput, #{Left}#{Right}
}
