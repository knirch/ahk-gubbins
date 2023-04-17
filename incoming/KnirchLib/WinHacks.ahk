VTable(p, i) {
	return NumGet(NumGet(p + 0) + i * A_PtrSize)
}

IPropertyStore_GetCount(pstore, ByRef count) {
	return DllCall(VTable(pstore, 3), "ptr", pstore, "uintp", count)
}

IPropertyStore_GetValue(pstore, pkey, pvalue) {
	return DllCall(VTable(pstore, 5), "ptr", pstore, "ptr", pkey, "ptr", pvalue)
}

IPropertyStore_SetValue(pstore, pkey, pvalue) {
	return DllCall(VTable(pstore, 6), "ptr", pstore, "ptr", pkey, "ptr", pvalue)
}

SetWinAppID(appid, winhwnd:="") {
	; winhwnd is optional, it will try to use the last found window or
	; fall through to the programs own id.

	; DLL code borrowed from;
	; https://www.autohotkey.com/board/topic/76498-dllcall-strange-results-when-used-within-an-objects-method/
	; and https://github.com/wyagd001/MyScript/blob/93d5aa110057b486d62dc0b6c610c2e528ac9d29/Lib/WinApi.ahk#L210

	; "Last Found Window"
	if (winhwnd == "") {
		WinGet, winhwnd, ID
		if (winhwnd == "") {
			winhwnd := GetOwnHWND()
		}
	}

	try {
		pstore := 0

		VarSetCapacity(IID_IPropertyStore, 16)
		DllCall("ole32.dll\CLSIDFromString", "wstr", "{886d8eeb-8cf2-4446-8d02-cdba1dbdcf99}", "ptr", &IID_IPropertyStore)

		VarSetCapacity(PKEY_AppUserModel_ID, 20)
		DllCall("ole32.dll\CLSIDFromString", "wstr", "{9F4C2855-9F79-4B39-A8D0-E1D42DE1D5F3}", "ptr", &PKEY_AppUserModel_ID)
		NumPut(5, PKEY_AppUserModel_ID, 16, "int")

		DllCall("shell32.dll\SHGetPropertyStoreForWindow", "ptr", winhwnd, "ptr", &IID_IPropertyStore, "ptrp", pstore)

		VarSetCapacity(variant, 8 + 2 * A_PtrSize, 0)
		NumPut(31, variant, 0, "short")
		NumPut(&appid, variant, 8)

		IPropertyStore_SetValue(pstore, &PKEY_AppUserModel_ID, &variant)
	} catch e
		throw e
}

GetOwnHWND() {
	if (A_DetectHiddenWindows == "Off") {
		DetectHiddenWindows, on
		ret := WinExist("Ahk_PID " DllCall("GetCurrentProcessId"))
		DetectHiddenWindows, off
	} else {
		ret := WinExist("Ahk_PID " DllCall("GetCurrentProcessId"))
	}
	return ret
}
