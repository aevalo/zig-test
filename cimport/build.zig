const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("raylibtest", "src/raylibtest.zig");
    exe.linkSystemLibrary("raylib");
    exe.linkLibC();
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.install();

    const lib = b.addStaticLibrary("mathtest", "src/mathtest.zig");
    lib.setTarget(target);
    lib.setBuildMode(mode);
    lib.install();

    const test_exe = b.addExecutable("test", null);
    test_exe.addCSourceFile("src/test.c", &[_][]const u8{"-std=c99"});
    test_exe.linkLibrary(lib);
    test_exe.linkLibC();
    test_exe.setTarget(target);
    test_exe.setBuildMode(mode);
    test_exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const exe_tests = b.addTest("src/raylibtest.zig");
    exe_tests.setTarget(target);
    exe_tests.setBuildMode(mode);

    const lib_tests = b.addTest("src/mathtest.zig");
    lib_tests.setTarget(target);
    lib_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&exe_tests.step);
    test_step.dependOn(&lib_tests.step);
}
