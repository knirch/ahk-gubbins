#Requires AutoHotkey >=2
#SingleInstance Force

; Lifted from: https://www.autohotkey.com/boards/viewtopic.php?p=227129#p227129
; Simple Alt-Tab replacement

!Tab:: {
	windowMenu := Menu()
	for id in WinGetList() {

		wTitle := WinGetTitle(id)
		if (wTitle = "")
			continue

		if (WinGetClass(id) = "ApplicationFrameWindow")
			if (WinGetText(id) = "")
				if (WinGetStyle(id) != "0xB4CF0000") ; the window isn't minimized
					continue

		; if the window doesn't have a title bar
		if !(WinGetStyle(id) & 0xC00000)
			continue

		windowMenu.Add(wTitle, Activate_Window)
		try windowMenu.SetIcon(wTitle, WinGetProcessPath(id), , 0)
		catch {
			; Unsure if this works, hasn't triggered yet
			msgbox("Undocumented: KCH_1")
			windowMenu.SetIcon(wTitle, A_WinDir . "\System32\SHELL32.dll", 3, 0)
		}
	}
	windowMenu.Show()
}

Activate_Window(itemName, itemPos, MyMenu) {
	SetTitleMatchMode 3 ; exact match
	if (WinGetClass(itemName) = "Windows.UI.Core.CoreWindow") ; the minimized window has another class
	{
		; I currently do not know if this code is correct as I don't remember
		; which program this was required for. On my Surface I don't seem to
		; have any programs that triggers this.
		MsgBox("Undocumented: KCH_2")
		WinActivate itemName . " ahk_class ApplicationFrameWindow"
	} else
		WinActivate itemName
}
