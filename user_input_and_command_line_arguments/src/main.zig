const std = @import("std");

pub fn main() !void {
    // General Purpose Allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.allocator();
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    switch (args.len) {
        3 => {
            const arg: u8 = args[1][0];
            if (arg == 'i') {
                std.debug.print("value: {s}\n", .{args[2]});
            } else {
                std.debug.print("Option does not exist!\n", .{});
            }
        },
        2 => {
            std.debug.print("Missing input value!\n", .{});
        },
        1 => {
            const stdin = std.io.getStdIn();

            std.debug.print("input: ", .{});
            const input = try stdin.reader().readUntilDelimiterAlloc(allocator, '\n', 1024);
            defer allocator.free(input);

            std.debug.print("value: {s}\n", .{input});
        },
        else => {
            std.debug.print("Too many command line arguments!\n", .{});
        },
    }
}
