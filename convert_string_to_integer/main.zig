/// Conversion from String to Integer
const std = @import("std");

pub fn main() !void {
    const string_num = "5";

    // Convert a string to an integer
    const number = try std.fmt.parseInt(i32, string_num, 10);

    // Print the number to stderr
    std.debug.print("Number: {d}\n", .{number});
}
