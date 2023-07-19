const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    const arg: u8 = args[1][0];

    switch (arg) {
        'h' => {
            std.debug.print("Help\n", .{});
        },
        'a' => {
            std.debug.print("All\n", .{});
        },
        else => {
            std.debug.print("None\n", .{});
        },
    }

    std.debug.print("Arguments: {s}\n", .{args});
}
