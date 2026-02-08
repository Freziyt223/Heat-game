const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    // There is a big issue with b.StandardOptimizeOption(); as it doesn't let
    // you pass optimize correctly to dependencies, so we have to set it manually.
    // If you want to have it as option, check Engine's build.zig for an example of how to do it properly.
    const optimize = std.builtin.OptimizeMode.Debug;
    const engine_dep = b.dependency("engine", .{
        .target = target,
        .optimize = optimize,
        .enable_tracy = true
    });
    const Engine = @import("engine");
    // override engine config if necessary
    const config = Engine.config;
    // anything from engine's config can be overridden here, but it's not necessary for this example
    config.enable_tracy = true;
    // add the executable. It is required that you use an Engine's addExecutable with engine_dep.builder as an argument.
    const Exe = Engine.addExecutable(engine_dep.builder, .{
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
