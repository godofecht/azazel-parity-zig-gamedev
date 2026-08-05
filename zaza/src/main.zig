//! Consumer of zig-gamedev's zmath, built through the standard Zig build graph
//! that Zaza is built on. zmath is pure Zig, so Zaza's C/C++ target DSL does not
//! apply; the Zig build system it provides consumes the package directly.
const std = @import("std");
const zm = @import("zmath");

pub fn main() void {
    const a = zm.f32x4(1.0, 2.0, 3.0, 4.0);
    const b = zm.f32x4(5.0, 6.0, 7.0, 8.0);
    const d = zm.dot4(a, b)[0];
    std.debug.print("zaza+zmath: dot4 = {d}\n", .{d});
    if (d != 70.0) std.process.exit(1);
}
