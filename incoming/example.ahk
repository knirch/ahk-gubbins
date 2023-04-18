; Not my code. Need source reference.
;; looks like the base I used for WinHacks...

; Detect any DllCall errors.
try {

    VarSetCapacity(IID_IPropertyStore, 16)
    DllCall("ole32.dll\CLSIDFromString", "wstr", "{886d8eeb-8cf2-4446-8d02-cdba1dbdcf99}", "ptr", &IID_IPropertyStore)

    VarSetCapacity(PKEY_AppUserModel_ID, 20)
    DllCall("ole32.dll\CLSIDFromString", "wstr", "{9F4C2855-9F79-4B39-A8D0-E1D42DE1D5F3}", "ptr", &PKEY_AppUserModel_ID)
    NumPut(5, PKEY_AppUserModel_ID, 16, "int")

    Appid := "test"
    hwnd := A_ScriptHwnd

    hr := DllCall("shell32.dll\SHGetPropertyStoreForWindow", "ptr", hwnd
        , "ptr", &IID_IPropertyStore, "ptrp", pstore)

    VarSetCapacity(variant, 8+2*A_PtrSize, 0)
    NumPut(31, variant, 0, "short") ; VT_LPWSTR
    NumPut(&Appid, variant, 8)

    hr := IPropertyStore_SetValue(pstore, &PKEY_AppUserModel_ID, &variant)

    ; Try swapping the two below around:
    hr1 := DllCall(vt(pstore,3), "ptr", pstore, "uintp", count1)
    hr2 := IPropertyStore_GetCount(pstore, count2)
    MsgBox % count1 " " count2

    ; Retrieve the property to prove that count=0 is incorrect:
    VarSetCapacity(getpv, 24, 0)
    hr := IPropertyStore_GetValue(pstore, &PKEY_AppUserModel_ID, &getpv)
    pvtype := NumGet(getpv,0,"ushort")
    pvvalue := pvtype=31 ? StrGet(NumGet(getpv,8)) : NumGet(getpv,8)
    MsgBox result: %hr% type: %pvtype% value: %pvvalue%

    ; MSDN: "A window's properties must be removed before the window is closed.
    ;        If this is not done, the resources used by those properties are not
    ;        returned to the system."
    VarSetCapacity(variant, 8+2*A_PtrSize, 0)
    IPropertyStore_SetValue(pstore, &PKEY_AppUserModel_ID, &variant)

} catch e
    throw e
ExitApp

vt(p, i) {
    return NumGet(NumGet(p+0)+i*A_PtrSize)
}

IPropertyStore_GetCount(pstore, ByRef count) {
    return DllCall(vt(pstore, 3), "ptr", pstore, "uintp", count)
}

IPropertyStore_GetValue(pstore, pkey, pvalue) {
    return DllCall(vt(pstore, 5), "ptr", pstore, "ptr", pkey, "ptr", pvalue)
}

IPropertyStore_SetValue(pstore, pkey, pvalue) {
    return DllCall(vt(pstore, 6), "ptr", pstore, "ptr", pkey, "ptr", pvalue)
}
