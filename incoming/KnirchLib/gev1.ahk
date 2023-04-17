$F1::
Menu, Windows, Add
Menu, Windows, deleteAll
WinGet windows, List
Loop %windows%
{
	id := windows%A_Index%
	WinGetTitle title, ahk_id %id%
	If (title = "")
		continue
	WinGetClass class, ahk_id %id%
	If (class = "ApplicationFrameWindow")
	{
		WinGetText, text, ahk_id %id%
		If (text = "")
			continue
	}
	WinGet, style, style, ahk_id %id%
	if !(style & 0xC00000) ; if the window doesn't have a title bar
	{
		; If title not contains ...  ; add exceptions
		continue
	}
	WinGet, Path, ProcessPath, ahk_id %id%
	Menu, Windows, Add, %title%, Activate_Window
	 ; If  the executable file doesn't contain any icons (replace "this_class" with the class of that window)
    If (class  = "ApplicationFrameWindow") || (class  = "this_class")
        Menu, Windows, Icon, %title%, %A_WinDir%\System32\SHELL32.dll, 3, 0
    else
        Menu, Windows, Icon, %title%, %Path%,, 0
}
Menu, Windows, Show
return

Activate_Window:
	SetTitleMatchMode, 3
	WinActivate, %A_ThisMenuItem%
return
