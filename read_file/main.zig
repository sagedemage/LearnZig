/// Reading a file
const std = @import("std");
const io = std.io;

pub fn main() !void {
    // Open a file
    var file = try std.fs.cwd().openFile("read_file/text.txt", .{});

    // Close the file
    defer file.close();

    // Reads the file
    var input_stream = file.reader();

    // buffer
    var buffer: [1024]u8 = undefined;

    while (try input_stream.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        // Prints each line to stderr
        std.debug.print("{s}\n", .{line});
    }
}
