/// Server
const std = @import("std");
const net = std.net;
const fs = std.fs;
const os = std.os;

pub fn main() !void {
    // Create server
    var server = net.StreamServer.init(.{});
    defer server.deinit();

    // Listener
    try server.listen(net.Address.parseIp("127.0.0.1", 8080) catch unreachable);

    // Print the Listen Address of the Server
    std.debug.print("Listening at {any}\n", .{server.listen_address});

    while (true) {
        // Accept
        const conn = try server.accept();
        defer conn.stream.close();

        const server_msg = "Good bye";

        var buf: [1024]u8 = undefined;
        _ = try conn.stream.read(buf[0..]);

        //const msg_size = try conn.stream.read(buf[0..]);
        std.debug.print("{any}\n", .{buf[0]});

        _ = try conn.stream.write(server_msg);
    }
}
