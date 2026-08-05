//! Consumer of the zig-gamedev zmath package (module "root"), built by Azazel
//! via pkg_imports. Exercises a few SIMD ops so zmath actually compiles.
const std = @import("std");
const zm = @import("zmath");

pub fn main() void {
    const a = zm.f32x4(1.0, 2.0, 3.0, 4.0);
    const b = zm.f32x4(5.0, 6.0, 7.0, 8.0);
    const d = zm.dot4(a, b)[0];
    std.debug.print("azazel+zmath: dot4 = {d}\n", .{d});
    if (d != 70.0) std.process.exit(1);
}
