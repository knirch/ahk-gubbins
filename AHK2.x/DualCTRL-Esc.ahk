#Requires AutoHotkey >=2

; Converted from http://www.autohotkey.com/board/topic/103174-dual-function-control-key/

state := 0

$~*Ctrl:: {
	global state
	if !state
		state := (GetKeyState("Shift", "P") || GetKeyState("Alt", "P") || GetKeyState("LWin", "P") || GetKeyState("RWin", "P"))
}

$~ctrl up:: {
	global state
	if instr(A_PriorKey, "control") && !state
		send "{Esc}"
	state := 0
}
