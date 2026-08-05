# azazel-parity-zig-gamedev

[zig-gamedev's zmath](https://github.com/zig-gamedev/zmath) — a pure-Zig SIMD
math library — built two ways, to prove and compare
[azazel](https://github.com/godofecht/azazel) and
[zaza](https://github.com/godofecht/zaza).

- **azazel** builds a consumer of the `zmath` package (module `root`) declared
  as a CUE model, via `pkg_imports`.
- **zaza** consumes `zmath` through the standard Zig build graph it is built on.

zmath is a package dependency; neither build vendors its source.

## Pinned upstream

| | |
|---|---|
| Package | https://github.com/zig-gamedev/zmath |
| Commit | `3a5955b2b72cd081563fbb084eff05bffd1e3fbb` (zmath 0.11.0-dev) |
| Zig | 0.16.0 |

## Build it

```sh
cd azazel && sh gen_build_spec.sh && zig build && ./zig-out/bin/zmath_probe
cd zaza  && zig build run
```

Both print `dot4 = 70`, the dot product of two f32x4 vectors, which means
zmath's SIMD code compiled and ran.

## Comparison

Clean-cache builds, deps pre-fetched, Apple Silicon, fastest of two runs.
Here `native` is zmath compiling itself (`zig build test`, which builds the whole
library and runs its tests).

| Build | Clean build | Config |
|-------|-------------|--------|
| azazel | 4.8 s | `project.cue` — 12 lines |
| zaza | 4.6 s | `build.zig` — 26 lines |
| native (zmath `zig build test`) | 3.8 s | — |

**This is the one repo where azazel and zaza are slower than native, and honestly
so: zmath is consumed as a package, so each build runs zmath's own `build.zig`
*and then* compiles a consumer that forces the whole library to compile. You
cannot build a package faster than the package builds itself. The "faster than
native" cases (libxev, libvaxis, tigerbeetle) are the ones where azazel/zaza
build a scoped slice of a much larger project.**

