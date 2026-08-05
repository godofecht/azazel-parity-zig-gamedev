//! Builds the whole zmath library: refAllDecls forces every declaration to
//! compile, and the body exercises the concrete SIMD API so it is actually
//! codegen'd, not just analyzed.
const std = @import("std");
const zm = @import("zmath");

comptime {
    std.testing.refAllDecls(zm);
}

pub fn main() void {
    const a = zm.f32x4(1.0, 2.0, 3.0, 4.0);
    const b = zm.f32x4(5.0, 6.0, 7.0, 8.0);
    const m = zm.mul(zm.identity(), zm.translation(1, 2, 3));
    std.debug.print("zmath: dot4={d} m[3]={any}\n", .{ zm.dot4(a, b)[0], zm.vecToArr4(m[3]) });
}
