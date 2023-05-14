#MaxThreadsPerHotkey 2
#SingleInstance Force
#persistent

; #Include KnirchLib\Reloader.ahk

DetectHiddenText, On

WinGet,Windows,List
Loop,%Windows%
{
	this_id := "ahk_id " . Windows%A_Index%
	WinGetTitle,this_title,%this_id%
	WinGet,hWnd,, %this_id%
	WinGet,kof,ProcessName, %this_id%
	OutputDebug this_title=%this_title% this_id=%this_id% hwnd=%hwnd% kof=%kof%
	WinGetTitle,korv,ahk_id %hWnd%
	OutputDebug hwnd_title:%korv%
	FileAppend, "exllllt", *
}
