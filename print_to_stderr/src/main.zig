/// Print to stderr
const std = @import("std");

pub fn main() !void {
    // Prints String to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("Hello {s}!\n", .{"Samuel"});

    // Prints Decimal to stderr
    std.debug.print("There are {d} eggs in the basket.\n", .{5});
}
