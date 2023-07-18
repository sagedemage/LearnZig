const std = @import("std");

pub fn main() !void {
    // Standard Input
    const stdin = std.io.getStdIn();

    // Get user input
    std.debug.print("input: ", .{});

    var buf: [1024]u8 = undefined;
    const size = try stdin.read(buf[0..]);

    // Print the value of the input
    std.debug.print("value: {s}\n", .{buf[0..size]});
}
