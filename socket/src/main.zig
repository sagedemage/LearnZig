/// Server
const std = @import("std");

pub fn main() !void {
    // Create server
    var server = std.net.StreamServer.init(.{});
    defer server.deinit();

    // Listener
    try server.listen(std.net.Address.parseIp("127.0.0.1", 8080) catch unreachable);
    defer server.close();

    // Print the Listen Address of the Server
    std.debug.print("Listening at {any}\n", .{server.listen_address});

    while (true) {
        // Accept for connections
        const conn = try server.accept();
        defer conn.stream.close();

        var buf: [1024]u8 = undefined;

        // Read the buffer
        const msg_size = try conn.stream.read(buf[0..]);

        // Print the message
        std.debug.print("{s}\n", .{buf[0..msg_size]});
    }
}
