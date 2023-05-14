; Start wfreerdp and move it to my second monitor.
; This was before dual monitor support worked as expected in virtualbox.
; If I recall correctly this has to be compiled to properly function with grouping.

#NoEnv
#NoTrayIcon
#Warn UseUnsetLocal, MsgBox
#Warn UseUnsetGlobal, MsgBox
#Warn LocalSameAsGlobal, MsgBox
#SingleInstance Force

#Include KnirchLib\WinHacks.ahk

; Register our application id
APPID := "Knirch.AHK.wFreeRDP"
SetWinAppID(APPID)

; Get monitor dimensions
SysGet, SecondMonitor, MonitorWorkArea, 2

; Start wfreerdp and group it with our application id
Run, C:\Users\knirc\Desktop\wfreerdp.exe /d:@2 /v:localhost /size:1920x1137 +grab-keyboard /smart-sizing
WinWaitActive, ahk_exe wfreerdp.exe
SetWinAppID(APPID)

; Move it onto the second monitor and maximize
WinMove, %SecondMonitorLeft%, %SecondMonitorTop%
WinMaximize,

; FFS, stop messing with my keyboard!
Loop {
	WinWaitNotActive, ahk_exe wfreerdp.exe
	SendInput {Ctrl up}{Shift up}{Alt up}{LWin up}{RWin up}
	WinWaitActive, ahk_exe wfreerdp.exe
}
