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
        _ = try server.accept();
    }
}
