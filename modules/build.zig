const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const table_helper = b.createModule(.{
        .source_file = .{ .path = "libs/table-helper/table-helper.zig" }
    });

    // Zig package
    // pub const my_pkg = std.build.Pkg{
    //     .name = "earcut",
    //     .source = .{ .path = "src/main.zig" },
    // };

    // Zig module
    // const my_module = b.createModule(.{
    //     .source_file = .{ .path = "src/main.zig" },
    //     .dependencies = &.{
    //         .{ .name = "core", .module = core.module(b) },
    //         .{ .name = "ecs", .module = ecs.module(b) },
    //         .{ .name = "sysaudio", .module = sysaudio.module(b) },
    //     },
    // });

    const exe = b.addExecutable(.{
        .name = "modules",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    exe.addModule("table-helper", table_helper);
    b.installArtifact(exe);
    _ = b.addRunArtifact(exe);

    const exe_tests = b.addTest(.{
        .name = "modules unit tests",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&exe_tests.step);
    _ = b.addRunArtifact(exe_tests);
}
