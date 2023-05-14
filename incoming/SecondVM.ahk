;@Ahk2Exe-SetMainIcon Terminal.ico
#NoEnv
#NoTrayIcon
#Warn UseUnsetLocal, MsgBox
#Warn UseUnsetGlobal, MsgBox
#Warn LocalSameAsGlobal, MsgBox
#SingleInstance Force

; Looks like a finalized version of Mover.ahk

#Include KnirchLib\WinHacks.ahk
#Include KnirchLib\Reloader.ahk

; Register our application id
APPID := "Knirch.AHK.wFreeRDP"

; 2023-04-16:
; comment below seems to indicate that the appid above wasn't kept when compiled?
; Is the appid tied to the destination of the .exe or the source of the .ahk?

; Seems the compiled file had another idea when it appeared on the taskbar
APPID := "C:\Users\knirc\Desktop\Knirch AHK Things\SecondVM.exe"

;; TODO: Can I save the window id somewhere so that
;; restarts wouldn't depend on a title?
WindowTitle := "VM@2"

RDPExe = D:\Downloads\wfreerdp.exe
RDPArguments =
(Join`s LTrim Comments
	/t:%WindowTitle%
	; VirtualBox doesn't care about the username or password, but they have
	; to be included or FreeRDP will ask for credentials
	/u:''
	/p:''
	/d:@2
	/v:localhost
	; TODO: Figure out how I came up with this size
	; looks like window spy size right now is main monitor scaling applied
	/size:1920x1137
	+grab-keyboard
	/smart-sizing
)

; ========================================
SetWinAppID(APPID)

; Start wfreerdp and group it with our application id
if ! WinExist(WindowTitle) {
	Run, %RDPExe% %RDPArguments%
	WinWaitActive, ahk_exe wfreerdp.exe
}
SetWinAppID(APPID)

; Only maximized normal window, this is for UseTitle hack
WinGet, ismax, MinMax
if (ismax == 0){
	; Get monitor dimensions
	SysGet, SecondMonitor, MonitorWorkArea, 2
	; Move it onto the second monitor and maximize
	WinMove, %SecondMonitorLeft%, %SecondMonitorTop%
	WinMaximize,
}

; Attempt at resetting stuck modifiers when wfreerdp loses focus
Loop {
	outputdebug, waiting to lose focus
	WinWaitNotActive,
	SendInput {Ctrl up}{Shift up}{Alt up}{LWin up}{RWin up}
	outputdebug, waiting to gain focus
	WinWaitActive,
}
