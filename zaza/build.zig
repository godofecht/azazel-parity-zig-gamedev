const std = @import("std");
// Consumer of zmath that forces the whole library to compile and exercises the
// concrete SIMD API, through the standard Zig build graph.
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
    b.step("run", "Build and run the zmath consumer").dependOn(&run.step);
}
