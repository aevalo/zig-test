const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const suspend_resume = b.addExecutable("suspend_resume", "src/suspend_resume.zig");
    suspend_resume.setTarget(target);
    suspend_resume.setBuildMode(mode);
    suspend_resume.install();

    const suspend_resume_tests = b.addTest("src/suspend_resume.zig");
    suspend_resume_tests.setTarget(target);
    suspend_resume_tests.setBuildMode(mode);

    const async_await = b.addExecutable("async_await", "src/async_await.zig");
    async_await.setTarget(target);
    async_await.setBuildMode(mode);
    async_await.install();

    const async_await_tests = b.addTest("src/async_await.zig");
    async_await_tests.setTarget(target);
    async_await_tests.setBuildMode(mode);

    const async_suspend = b.addExecutable("async_suspend", "src/async_suspend.zig");
    async_suspend.setTarget(target);
    async_suspend.setBuildMode(mode);
    async_suspend.install();

    const async_suspend_tests = b.addTest("src/async_suspend.zig");
    async_suspend_tests.setTarget(target);
    async_suspend_tests.setBuildMode(mode);

    const event_loop = b.addExecutable("event_loop", "src/event_loop.zig");
    event_loop.setTarget(target);
    event_loop.setBuildMode(mode);
    event_loop.install();

    const event_loop_tests = b.addTest("src/event_loop.zig");
    event_loop_tests.setTarget(target);
    event_loop_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&suspend_resume_tests.step);
    test_step.dependOn(&async_await_tests.step);
    test_step.dependOn(&async_suspend_tests.step);
    test_step.dependOn(&event_loop_tests.step);
}
