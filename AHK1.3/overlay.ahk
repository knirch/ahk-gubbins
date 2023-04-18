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

Battery := Gui()
Battery.Opt("+AlwaysOnTop -Caption +ToolWindow")  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
Battery.BackColor := "000000"  ; Can be any RGB color (it will be made transparent below).
Battery.SetFont("s16")  ; Set a large font size (32-point).
BatteryText := Battery.Add("Text", "r1 cLime", "XXXXX YYYYY")  ; XX & YY serve to auto-size the window.
; Make all pixels of this color transparent and make the text itself translucent (150):
;WinSetTransColor(Battery.BackColor " 255", Battery)
;WinSetTransColor(Battery.BackColor " 255", Battery)
SetTimer(UpdateBAT, 2000)
UpdateBAT()  ; Make the first update immediate rather than waiting for the timer.
Battery.Show("x0 y0 NoActivate")  ; NoActivate avoids deactivating the currently active window.

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
