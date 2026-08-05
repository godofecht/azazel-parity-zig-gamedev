const std = @import("std");

// A pure-Zig corpus slice: zig-gamedev's zmath consumed through the standard
// Zig build graph Zaza is built on. zmath has no C/C++ sources, so Zaza's C/C++
// target DSL does not apply — a Zig library is declared, imported, and run.
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const zmath = b.dependency("zmath", .{ .target = target, .optimize = optimize });

    const exe = b.addExecutable(.{
        .name = "zmath_consumer",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    exe.root_module.addImport("zmath", zmath.module("root"));
    b.installArtifact(exe);

    const run = b.addRunArtifact(exe);
    const run_step = b.step("run", "Build the zmath consumer and run it");
    run_step.dependOn(&run.step);
}
