const log = @import("std").log;
const expect = @import("std").testing.expect;

fn func3() u32 {
    return 5;
}

pub fn main() anyerror!void {
    var frame = async func3();
    log.info("frame = {d}", .{await frame});
}

test "async / await" {
    var frame = async func3();
    try expect(await frame == 5);
}
