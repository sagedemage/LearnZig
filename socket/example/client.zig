/// Client
const std = @import("std");

pub fn main() !void {
    const client_msg = "Hello";

    // Create server
    const server_address = std.net.Address.initIp4([4]u8{ 127, 0, 0, 1 }, 8080);
    const conn = try std.net.tcpConnectToAddress(server_address);
    defer conn.close();

    _ = try conn.write(client_msg);

    var buf: [1024]u8 = undefined;
    _ = try conn.read(buf[0..]);
}
