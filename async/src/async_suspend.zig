const std = @import("std");
const expect = @import("std").testing.expect;

fn add(a: i32, b: i32) i64 {
    return a + b;
}

fn double(value: u8) u9 {
    suspend {
        resume @frame();
    }
    return value * 2;
}

fn callLater(comptime laterFn: fn () void, ms: u64) void {
    suspend {
        wakeupLater(@frame(), ms);
    }
    laterFn();
}

fn wakeupLater(frame: anyframe, ms: u64) void {
    std.time.sleep(ms * std.time.ns_per_ms);
    resume frame;
}

fn alarm() void {
    std.debug.print("Time's Up!\n", .{});
}

fn zero(comptime x: anytype) x {
    return 0;
}

fn awaiter(x: anyframe->f32) f32 {
    return nosuspend await x;
}

pub fn main() anyerror!void {
    var frame: @Frame(add) = async add(1, 2);
    std.log.info("add(1, 2) = {d}", .{await frame});
    var f = async double(1);
    std.log.info("double(1) = {d}", .{nosuspend await f});
    nosuspend callLater(alarm, 1000);
    var frame2 = async zero(f32);
    std.log.info("awaiter(zero(f32)) = {d}", .{awaiter(&frame2)});
}

test "@Frame" {
    var frame: @Frame(add) = async add(1, 2);
    try expect(await frame == 3);
}

test "@frame 1" {
    var f = async double(1);
    try expect(nosuspend await f == 2);
}

test "@frame 2" {
    nosuspend callLater(alarm, 1000);
}

test "anyframe->T" {
    var frame = async zero(f32);
    try expect(awaiter(&frame) == 0);
}
