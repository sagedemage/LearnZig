/// Conversion from String to Integer
const std = @import("std");

const Point = struct {
    x: i32,
    y: i32,
};

pub fn main() !void {
    var p = Point{
        .x = 1,
        .y = 2,
    };

    std.debug.print("X value of the point: {d}\n", .{p.x});
    std.debug.print("Y value of the point: {d}\n", .{p.y});
}
