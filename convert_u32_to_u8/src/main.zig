/// Convert unsigned 32 bit integer to an unsigned 8 bit integer
const std = @import("std");

pub fn main() !void {
    const old_num: u32 = 5;

    // convert u32 value to u8 value
    const new_num: u8 = @as(u8, old_num);

    // Prints to stderr
    std.debug.print("-- u32 value converted to u8 --\n", .{});
    std.debug.print("Number: {d}\n", .{new_num});
}
