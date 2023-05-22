const log = @import("std").log;
const expect = @import("std").testing.expect;

var foo: i32 = 1;

fn func() void {
    foo += 1;
    suspend {}
    foo += 1;
}

var bar: i32 = 1;

fn func2() void {
    bar += 1;
    suspend {}
    bar += 1;
}

pub fn main() anyerror!void {
    log.info("foo = {d}, bar = {d}", .{ foo, bar });
    var frame = async func();
    _ = frame;
    log.info("foo = {d}, bar = {d}", .{ foo, bar });
    var frame2 = async func2();
    resume frame2;
    log.info("foo = {d}, bar = {d}", .{ foo, bar });
}

test "suspend with no resume" {
    var frame = async func();
    _ = frame;
    try expect(foo == 2);
}

test "suspend with resume" {
    var frame = async func2();
    resume frame;
    try expect(bar == 3);
}
