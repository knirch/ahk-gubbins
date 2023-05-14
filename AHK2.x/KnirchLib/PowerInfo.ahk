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
