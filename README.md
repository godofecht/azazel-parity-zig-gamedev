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


## Build process & what can be optimized

Both build roots stage the pinned upstream with `fetch.sh` into a git-ignored
`vendor/` (a `curl` for single-file slices, a shallow clone for source trees) —
no upstream sources are committed. Then:

- **azazel**: `sh gen_build_spec.sh` runs CUE and emits `build_spec.zig` (the
  build declared as data), then `zig build` compiles it. The CUE step is
  memoized — it re-runs only when the model changes (~0.20s → ~0.01s otherwise).
- **zaza**: `zig build` drives the standard Zig build graph directly.

### What actually makes it faster

Measured across the corpus (clean vs warm builds):

| Lever | Speedup | Note |
|-------|---------|------|
| Content-addressed cache (rebuild) | **89×** | 14.2s → 0.16s; Zig has it, both inherit it |
| Incremental (edit one file) | **10.8×** | 14.2s → 1.32s; deps stay cached |
| CI dependency cache | **2×** | cold 13.3s → warm 6.6s; this repo's CI caches `~/.cache/zig` |
| Memoized CUE codegen | **20×** | azazel's only overhead, gone |
| Parallelism (many cores) | **1.1×** | marginal — shared `std` + startup dominate |
| GPU | none | compilation is branchy, sequential, dependency-ordered |

The instinct to parallelize like a C++ build doesn't transfer: Zig is one
mostly-single-threaded compile per artifact with a fast self-hosted backend and a
shared `std` that caches. **For Zig, caching is the lever, not parallelism.**

The real frontier is *residency*: a resident compile server that keeps the
InternPool hot and recompiles only changed declarations, plus in-place binary
patching (Zig's roadmap) and a shared content-addressed cache. azazel's
build-as-data is positioned for it — the build is a query, and the cache key is
computable from the pinned model without running the compiler. Full write-up and
the cross-repo comparison: the [corpus dashboard](https://claude.ai/code/artifact/8c37ee83-b358-4351-a1e0-eb02ec0aedd4).
