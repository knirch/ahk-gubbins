; MouseMove, 100, 100, 0

#Include JSON.ahk

; https://github.com/FuPeiJiang/VD.ahk/blob/class_VD/_VD.ahk

; hmm ^^ this should be able to extract guid, guid should be able to be matched against
; the json to get the layout, then query something else for the dimensions?

; Im an idiot, the dimensions are not available in any of the fancyzones configs.
; An idiotic idea is to create an invisible window and then move it to the next zone...

; currenlt desktop (NOT VIRTUAL!)
; source https://stackoverflow.com/questions/47778700/how-can-autohotkey-detect-which-virtual-desktop-youre-on

; Current desktop UUID appears to be in HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SessionInfo\1\VirtualDesktops
RegRead, cur, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SessionInfo\1\VirtualDesktops, CurrentVirtualDesktop
RegRead, all, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops, VirtualDesktopIDs
RegRead, a, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops, VirtualDesktopIDs
ix := floor(InStr(all,cur) / strlen(cur))
msgbox current desktop index: %ix% %all%
msgbox %a%

;; can I guid this?

exit
;;

f=c:\users\tnilsson\appdata\local\microsoft\powertoys\fancyzones\applied-layouts.json

FileRead, text, %f%
value := JSON.Load( text )

ObjToString(obj)
{
	if (!IsObject(obj))
		return obj
	str := "`n{"
	for key, value in obj
		str .= "`n" key ": " ObjToString(value) ","
	return str "`n}"
}

outputdebug,=======================================================

outputdebug, % ObjToString(value)

exit

for each, obj in value["applied-layouts"] {
	outputdebug, % ObjToString(each)
	outputdebug, % ObjToString(obj)
	loop %each% {
		hh:=IsObject(obj)
		; outputdebug eh %hh% % obj[1]
		; msgbox % obj[1]
		; msgbox % value["applied-layouts"][1]
	}
}
