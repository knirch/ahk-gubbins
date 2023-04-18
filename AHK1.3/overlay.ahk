; https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-getsystempowerstatus
; https://learn.microsoft.com/en-us/windows/win32/api/winbase/ns-winbase-system_power_status
; typedef struct _SYSTEM_POWER_STATUS {
;     BYTE  ACLineStatus;
;     BYTE  BatteryFlag;
;     BYTE  BatteryLifePercent;
;     BYTE  SystemStatusFlag;
;     DWORD BatteryLifeTime;
;     DWORD BatteryFullLifeTime;
;   } SYSTEM_POWER_STATUS, *LPSYSTEM_POWER_STATUS;

Battery := Gui("+AlwaysOnTop -Caption +ToolWindow")
Battery.MarginX := 1
Battery.MarginY := 1
Battery.BackColor := "000000"
Battery.SetFont("s12")
BatteryText := Battery.Add("Text", "left cLime", "9999 min")
; BatteryText := Battery.Add("Text", "right cLime", "9999 min")
WinSetTransColor(Battery.BackColor " 255", Battery)

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

getPower() {
    SYSTEM_POWER_STATUS := Buffer(12)
    DllCall("GetSystemPowerStatus", "ptr", SYSTEM_POWER_STATUS)
    return {
        ACLineStatus: NumGet(SYSTEM_POWER_STATUS, 0, "UChar"),
        BatteryFlag: NumGet(SYSTEM_POWER_STATUS, 1, "UChar"),
        BatteryLifePercent: NumGet(SYSTEM_POWER_STATUS, 2, "UChar"),
        SystemStatusFlag: NumGet(SYSTEM_POWER_STATUS, 3, "UChar"),
        BatteryLifeTime: NumGet(SYSTEM_POWER_STATUS, 4, "UInt"),
        BatteryFullLifeTime: NumGet(SYSTEM_POWER_STATUS, 8, "UInt")
    }
}

UpdateBAT(*) {
    BatteryText.Value := Round(getPower().BatteryLifeTime / 60) . " min"
}


; https://www.autohotkey.com/boards/viewtopic.php?p=50713&sid=b37af19156951a0adac45339a40cfbf7#p50713
