const std = @import("std");
const windows = std.os.windows;
const registry = @import("registry.zig");
const utils = @import("utils.zig");

fn isFirstRun() bool {
    var hkey: windows.HKEY = undefined;
    const stat = windows.advapi32.RegOpenKeyExW(registry.HKEY_CURRENT_USER, utils.toComptimeWCHAR("Software\\IDAChooser"), 0, windows.KEY_READ, &hkey);
    defer _ = registry.RegCloseKey(hkey);
    return stat != 0;
}

fn getFileArch(file_name: []const u8) !u32 {
    var file = try std.fs.openFileAbsolute(file_name, .{});
    const file_reader = file.reader();
    defer file.close();
    try file.seekTo(0x3c);
    const offset = try file_reader.readIntLittle(u32);
    try file.seekTo(offset + 4);
    return try file_reader.readIntLittle(u16);
}

/// Caller owns the memory
fn getIDAPath(allocator: std.mem.Allocator) ![]const u8 {
    var cbData: windows.DWORD = 4096;
    const data = try allocator.allocSentinel(u16, cbData / 2, 0);
    std.mem.set(u16, data, 0);
    defer allocator.free(data);
    _ = registry.RegGetValueW(registry.HKEY_CURRENT_USER, utils.toComptimeWCHAR("Software\\IDAChooser"), utils.toComptimeWCHAR("Path"), 0x00000002, null, @ptrCast(*anyopaque, data), &cbData);
    const dataUtf8 = try std.unicode.utf16leToUtf8AllocZ(allocator, data[0..(cbData / 2 - 1)]);
    return dataUtf8;
}

fn setIDAPath(path: [:0]const u16) void {
    var hkey: windows.HKEY = undefined;
    defer _ = registry.RegCloseKey(hkey);
    _ = registry.RegCreateKeyExW(registry.HKEY_CURRENT_USER, utils.toComptimeWCHAR("Software\\IDAChooser"), 0, null, 0, windows.KEY_ALL_ACCESS, null, &hkey, null);
    const data_size_in_bytes = @intCast(u32, (path.len + 1) * @sizeOf(u16));
    _ = registry.RegSetValueExW(hkey, utils.toComptimeWCHAR("Path"), 0, registry.REG_SZ, @alignCast(1, std.mem.sliceAsBytes(path).ptr), data_size_in_bytes);
}

pub fn main() !void {
    var mem: [1024 * 10]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&mem);
    var arena = std.heap.ArenaAllocator.init(fba.allocator());
    defer arena.deinit();
    const allocator = arena.allocator();

    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();
    var args = try std.process.argsWithAllocator(allocator);
    defer args.deinit();
    const exe_name = args.next().?;

    if (isFirstRun()) {
        try stdout.writeAll("IDA Path: ");
        const raw_path = (try stdin.readUntilDelimiterOrEofAlloc(allocator, '\n', std.fs.MAX_PATH_BYTES)).?;
        const path = std.mem.trimRight(u8, raw_path, &std.ascii.whitespace);
        setIDAPath(try utils.toWCHAR(allocator, path));
    }

    var ida_path = try getIDAPath(allocator);
    if (try getFileArch(exe_name) == 0x8664) {
        ida_path = try std.mem.concat(allocator, u8, &.{ ida_path, "\\ida64.exe" });
    } else {
        ida_path = try std.mem.concat(allocator, u8, &.{ ida_path, "\\ida.exe" });
    }

    var child_process = std.ChildProcess.init(&.{ ida_path, exe_name }, allocator);
    try child_process.spawn();
}
