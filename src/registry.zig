const std = @import("std");
const windows = std.os.windows;

pub extern "advapi32" fn RegCloseKey(hKey: windows.HKEY) callconv(windows.WINAPI) windows.LSTATUS;
pub extern "advapi32" fn RegGetValueW(hKey: windows.HKEY, lpSubKey: windows.LPCWSTR, lpValue: windows.LPCWSTR, dwFlags: windows.DWORD, pdwType: ?*windows.DWORD, pvData: windows.PVOID, pcbData: *windows.DWORD) callconv(windows.WINAPI) windows.LSTATUS;
pub extern "advapi32" fn RegCreateKeyExW(hkey: windows.HKEY, lpSubKey: windows.LPCWSTR, Reserved: windows.DWORD, lpClass: ?windows.LPWSTR, dwOptions: windows.DWORD, samDesired: windows.REGSAM, lpSecurityAttributes: ?*anyopaque, phkResult: *windows.HKEY, lpdwDisposition: ?*windows.DWORD) callconv(windows.WINAPI) windows.LSTATUS;
pub extern "advapi32" fn RegSetValueExW(
    hKey: windows.HKEY,
    lpValueName: ?windows.LPCWSTR,
    Reserved: windows.DWORD,
    dwType: windows.DWORD,
    lpData: [*]const windows.BYTE,
    cbData: windows.DWORD,
) callconv(windows.WINAPI) windows.LSTATUS;

pub const HKEY_CURRENT_USER = @intToPtr(windows.HKEY, 0x80000001);
pub const SCS_32BIT_BINARY = 0;
pub const SCS_64BIT_BINARY = 6;
pub const REG_SZ = 1;
