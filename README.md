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

| Build | What it does | Config size |
|-------|--------------|-------------|
| azazel | consumes `zmath` (module root) via a CUE `pkg_imports` model | `project.cue`, 12 lines |
| zaza | consumes `zmath` via the standard Zig build graph | `build.zig`,       26 lines |

Both reach the same package the same way underneath (`b.dependency("zmath")`).
The difference is the surface: azazel states the import as data; zaza writes the
few lines of Zig build graph directly.
