// Azazel builds a consumer of zig-gamedev's zmath that forces the whole library
// to compile (refAllDecls) and exercises the concrete SIMD API. zmath is a
// package dependency; no source is vendored. Lane 0.16.
package build

toolchain: zig: {
	lanes: ["0.16"]
	preferred: "0.16"
}

zmath_probe: #Module & {
	kind: "exe"
	root: "src/probe.zig"
	pkg_imports: [
		{alias: "zmath", package: "zmath", module: "root"},
	]
}
