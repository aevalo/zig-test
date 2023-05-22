const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const inline_assembly = b.addExecutable("inline_assembly", "src/inline_assembly.zig");
    inline_assembly.setTarget(target);
    inline_assembly.setBuildMode(mode);
    inline_assembly.install();

    const inline_assembly_tests = b.addTest("src/inline_assembly.zig");
    inline_assembly_tests.setTarget(target);
    inline_assembly_tests.setBuildMode(mode);

    const test_global_assembly = b.addExecutable("test_global_assembly", "src/test_global_assembly.zig");
    test_global_assembly.setTarget(target);
    test_global_assembly.setBuildMode(mode);
    test_global_assembly.install();

    const test_global_assembly_tests = b.addTest("src/test_global_assembly.zig");
    test_global_assembly_tests.setTarget(target);
    test_global_assembly_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&inline_assembly_tests.step);
    test_step.dependOn(&test_global_assembly_tests.step);
}
