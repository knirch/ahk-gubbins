#Requires AutoHotkey >=2
#SingleInstance Force

#Include KnirchLib\Reloader.ahk
#Include KnirchLib\PowerInfo.ahk

Battery := Gui("+AlwaysOnTop -Caption +ToolWindow")
Battery.MarginX := 10
Battery.MarginY := 10
Battery.BackColor := "Black"
Battery.SetFont("s9", "Consolas Bold")
BatteryText := Battery.Add("Text", "left cWhite", "9999 min")
WinSetTransColor(Battery.BackColor " 200", Battery)

SetTimer(UpdateBAT, 2000)
UpdateBAT()
Battery.Show("x0 y0 NoActivate")

;; Align to right
; Battery.Opt("-DPIScale")
; Battery.GetPos(,, &width,)
; Battery.Move(A_ScreenWidth - width)

; Align to bottom
Battery.Opt("-DPIScale")
Battery.GetPos(, , , &height)
Battery.Move(, A_ScreenHeight - height)
Battery.opt("+DPIScale")

UpdateBAT(*) {
    BatteryText.Value := Round(getPower().BatteryLifeTime / 60) . " min"
    ; In case it gets covered by something like the taskbar
    WinMoveTop(Battery)
}

; https://www.autohotkey.com/boards/viewtopic.php?p=50713&sid=b37af19156951a0adac45339a40cfbf7#p50713
