const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = std.builtin.OptimizeMode.ReleaseSmall;
    const engine_dep = b.dependency("engine", .{
        .target = target,
        .optimize = optimize,
        .enable_tracy = true
    });
    const Exe = @import("engine").addExecutable(engine_dep.builder, .{
        .name = "SimpleIO",
        .user_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{.{.name = "Engine", .module = engine_dep.module("Engine")}},
            //.strip = true,
        }),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(Exe);
}
