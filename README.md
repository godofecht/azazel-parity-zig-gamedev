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

Clean-cache builds with dependencies pre-fetched, Apple Silicon, fastest of two runs.
`native` is zmath's own `zig build` (the package alone).

| Build | Clean build | Config |
|-------|-------------|--------|
| azazel | 4.9 s | `project.cue` — 12 lines · 423 B |
| zaza | 4.6 s | `build.zig` — 26 lines · 982 B |
| native (zmath's own `zig build` (the package alone)) | 3.8 s | — |

**Here azazel/zaza build the zmath package *and* a consumer on top, so they run a touch longer than building zmath by itself.**

