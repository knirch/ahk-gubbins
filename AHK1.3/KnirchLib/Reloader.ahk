;@Ahk2Exe-IgnoreBegin

ReloadOnFileChange(file) {
	static lastFileContent := ""
	if (lastFileContent == "") {
		fileread lastFileContent, %file%
	}

	fileread newFileContent, %A_ScriptFullPath%
	if (newFileContent != lastFileContent) {
		lastFileContent := newFileContent
		OutputDebug, %A_Now%: script updated; reloading %A_ScriptFullPath%
		Reload
	}
}

reload_monitor := Func("ReloadOnFileChange").Bind(A_ScriptFullPath)
setTimer, % reload_monitor, 1000

;@Ahk2Exe-IgnoreEnd
