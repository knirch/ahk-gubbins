;@Ahk2Exe-IgnoreBegin

ReloadOnFileChange(file) {
	static lastFileContent := ""
	if (lastFileContent == "")
		lastFileContent := fileread(file)

	newFileContent := fileread(file)
	if (newFileContent != lastFileContent) {
		lastFileContent := newFileContent
		OutputDebug(A_Now . ": script updated; reloading " . file)
		Reload
	}
}

reload_monitor := ReloadOnFileChange.Bind(A_ScriptFullPath)
setTimer reload_monitor, 1000

;@Ahk2Exe-IgnoreEnd
