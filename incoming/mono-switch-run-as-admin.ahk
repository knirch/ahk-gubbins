#NoEnv
#persistent
SetWorkingDir %A_ScriptDir%
#SingleInstance force

#Include KnirchLib\Reloader.ahk

;;;; ;; copied from https://github.com/jNizM/AHK_Scripts/blob/master/src/process_thread_handle_module/IsProcessElevated.ahk
;;;; IsProcessElevated(ProcessID) {
;;;;     if !(hProcess := DllCall("OpenProcess", "uint", 0x1000, "int", 0, "uint", ProcessID, "ptr"))
;;;;         throw Exception("OpenProcess failed", -1)
;;;;     if !(DllCall("advapi32\OpenProcessToken", "ptr", hProcess, "uint", 0x0008, "ptr*", hToken))
;;;;         throw Exception("OpenProcessToken failed", -1), DllCall("CloseHandle", "ptr", hProcess)
;;;;     if !(DllCall("advapi32\GetTokenInformation", "ptr", hToken, "int", 20, "uint*", IsElevated, "uint", 4, "uint*", size))
;;;;         throw Exception("GetTokenInformation failed", -1), DllCall("CloseHandle", "ptr", hToken) && DllCall("CloseHandle", "ptr", hProcess)
;;;;     return IsElevated, DllCall("CloseHandle", "ptr", hToken) && DllCall("CloseHandle", "ptr", hProcess)
;;;; }
;;;; 
;;;; MsgBox % IsProcessElevated(DllCall("GetCurrentProcessId"))
;;;; ; 0 => Process is not elevated
;;;; ; 1 => Process is elevated


; Elevate current script, it needs administrator to restart audiosrv

;; from ahk manual: https://www.autohotkey.com/docs/v1/lib/Run.htm#RunAs
full_command_line := DllCall("GetCommandLine", "str")
if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)")) {
    try {
        if A_IsCompiled
            Run *RunAs "%A_ScriptFullPath%" /restart
        else
            Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
    }
    ExitApp
}


RegRead, mono, HKCU\SOFTWARE\Microsoft\Multimedia\Audio, AccessibilityMonoMixState

;; 1 == mono mixdown enabled; speaker.ico
;; 0 == mono mixdown disabled; headphones.ico

ico_mono := "speaker-2-64.ico"
ico_stereo := "headphones-3-64.ico"

if (mono == 0) {
	ico := ico_stereo
} else {
	ico := ico_mono
}

Menu, Tray, NoStandard
Menu, Tray, Add , Exit, Quit
Menu, Tray, Add , Switch, switchMode
Menu, Tray, Default, Switch
Menu, Tray, Click, 1
Menu, Tray, Icon , %ico%,, 1
Return

switchMode:
	mono:=!mono
	if (mono == 0) {
		ico := ico_stereo
	} else {
		ico := ico_mono
	}
	RegWrite, REG_DWORD, HKCU\SOFTWARE\Microsoft\Multimedia\Audio, AccessibilityMonoMixState, %mono%
	RunWait,sc stop "Audiosrv",,hide


	RunWaitOne(command) {
		; Source: https://www.autohotkey.com/docs/v1/lib/Run.htm#StdOut
		; WshShell object: http://msdn.microsoft.com/en-us/library/aew9yb99
		shell := ComObjCreate("WScript.Shell")
		; Execute a single command via cmd.exe
		exec := shell.Exec(ComSpec " /C " command)
		; Read and return the command's output
		return exec.StdOut.ReadAll()
	}

	; If service hasn't reached state STOPPED, the 'sc start' command will fail.
	; force wait until it has properly stopped.
	loop {
		sleep, 500
	} until RegExMatch(RunWaitOne("sc query Audiosrv"), ".*STATE.*STOPPED.*")

	RunWait,sc start "Audiosrv",,hide
	Menu, Tray, Icon , %ico%
Return

Quit:
ExitApp
Return
