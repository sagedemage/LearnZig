const std = @import("std");

pub fn main() !void {
    // create address
    const address_num: [4]u8 = [_]u8{ 127, 0, 0, 1 };

    // complete address
    const address = std.net.Address.initIp4(address_num, 80);

    // print the complete address
    std.debug.print("address: {any}\n", .{address});
}
