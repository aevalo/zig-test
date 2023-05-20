export fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "basic test" {
    const std = @import("std");
    try std.testing.expectEqual(10, 3 + 7);
}
