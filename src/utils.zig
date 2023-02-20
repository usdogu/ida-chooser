const std = @import("std");

pub fn toWCHAR(allocator: std.mem.Allocator, str: []const u8) ![:0]const u16 {
    return try std.unicode.utf8ToUtf16LeWithNull(allocator, str);
}

pub fn toComptimeWCHAR(comptime str: []const u8) [:0]const u16 {
    return std.unicode.utf8ToUtf16LeStringLiteral(str);
}