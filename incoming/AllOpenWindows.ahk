#MaxThreadsPerHotkey 2
#SingleInstance Force
#persistent

#Include KnirchLib\Reloader.ahk

DetectHiddenText, On

WinGet,Windows,List
Loop,%Windows%
{
	this_id := "ahk_id " . Windows%A_Index%
	WinGetTitle,this_title,%this_id%
	OutputDebug 1; %this_title%:%this_id%
	WinGet,hWnd,, ahk_pid 26404
	OutputDebug 2; %this_id%
	OutputDebug 3; %hWnd%
	WinGetTitle,korv,%hWnd%
	korv = ,ahk_id 26404
	OutputDebug 4; %korv%
	; WinRestore, %this_title%
	; WinRestore, %this_title%
}

;; Wow, this crashed VirtualBox
;;
;;	WinGetTitle,this_title,%this_id%
;;	OutputDebug %this_title%:%this_id%
;;	WinRestore, %this_title%
;;	WinRestore, %this_title%
