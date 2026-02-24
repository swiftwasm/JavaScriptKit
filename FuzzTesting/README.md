# BridgeJS Fuzz Testing

An operation-based fuzzer for [BridgeJS](../Plugins/BridgeJS/README.md). It generates random macro-annotated Swift code, compiles it through the full BridgeJS pipeline to WebAssembly, runs it in Node.js, and checks for crashes and value correctness.

## Quick Start

```bash
cd FuzzTesting
node src/cli.mjs run --iterations 20 --seed 0
```

Requires:
- Swift toolchain with Wasm support
- `SWIFT_SDK_ID` environment variable set (e.g. via `~/.profile`)
- Node.js ≥ 18

## How It Works

Each iteration:

1. **Smith** generates a random test case from an integer seed
2. **Emitter** produces a `main.swift` file and a `harness.mjs` file
3. **Runner** compiles via `swift package js`, then executes the harness in Node.js
4. **Tracker** records new failures to `FailCases/`, deduplicates by error fingerprint

The generated Swift contains both **imports** (`@JSFunction`, `@JSClass`) and **exports** (`@JS func`) with operation sequences that compose calls across the JS↔Swift boundary. The JS harness provides deterministic implementations for imports and asserts that exported functions return the expected values.

### Generated Code Example

```swift
// main.swift (generated)
import JavaScriptKit

@JSClass struct FuzzObj0 {
    @JSFunction init(_ a: Double, _ b: String) throws(JSException)
}

@JSFunction func jsFuzz0(_ a: String, _ b: String) throws(JSException) -> String

@JS func testFunc0(a: String, b: String) -> String {
    let v0 = try! jsFuzz0(a, b)   // callImport
    return v0                      // return
}

@JS func testFunc1(n: Double) -> Double {
    let v0 = try! FuzzObj0(n, "hi") // construct
    let v1: Double = 42.0            // literal
    return v1                        // return
}
```

This exercises the full pipeline: macro expansion → skeleton extraction → Swift codegen → Wasm compilation → JS glue generation → runtime execution.

## CLI Reference

### `run` — Start fuzzing

```
node src/cli.mjs run [options]
```

| Option | Default | Description |
|---|---|---|
| `--workers N` | `1` | Parallel workers (each with its own `.build/` cache) |
| `--iterations N` | `0` (unlimited) | Number of seeds to test |
| `--seed N` | `0` | Starting seed |
| `--max-depth N` | `3` | Type nesting depth (e.g. `Array<Optional<Int>>` is depth 2) |
| `--max-params N` | `4` | Max parameters per function |
| `--max-ops N` | `6` | Max operations per function body |
| `--on-failure PATH` | — | Hook script invoked on each new failure |
| `--timeout N` | `120` | Per-iteration timeout (seconds) |
| `--verbose` | — | Print build/run output |

With `--workers N` (N > 1), the fuzzer creates N worker directories under `Workers/`, each with its own SPM build cache. Jobs are dispatched to the next free worker. The first build is slow; subsequent iterations reuse the cache.

### `serve` — Run with web dashboard

```
node src/cli.mjs serve [--port 8000] [options]
```

Starts the fuzzer with a live web dashboard. Accepts all `run` options plus:

| Option | Default | Description |
|---|---|---|
| `--port N` | `8000` | HTTP port for the dashboard |

The dashboard provides:
- Real-time stats (iterations, failures, throughput)
- Type coverage heatmap
- Failure table with click-to-inspect detail modal (shows generated Swift, JS, and error output)
- SSE-powered live updates
- Pause/resume controls

API endpoints: `GET /api/status`, `GET /api/failures`, `GET /api/failures/:id`, `GET /api/coverage`, `GET /api/recent`, `GET /api/events` (SSE), `POST /api/control/pause`, `POST /api/control/resume`.

### `reproduce` — Re-run a failure

```
node src/cli.mjs reproduce FailCases/001-compile-error
```

Reads `seed.json` from the failure directory, regenerates the test case, builds, and runs with verbose output.

### `minimize` — Shrink a failure

```
node src/cli.mjs minimize FailCases/003-compile-error
```

Attempts to reduce a failure to a minimal reproducing test case by:
1. Removing test functions one at a time
2. Removing unused operations from function bodies
3. Pruning unused imported declarations

Each reduction is verified by rebuilding and checking that the same failure phase still occurs. The minimized result is written to `FailCases/003-compile-error-min/`.

## Architecture

```
src/
├── smith/            Random generation
│   ├── random.mjs        Seeded PRNG (mulberry32)
│   ├── type-smith.mjs    Random BridgeType (depth-limited recursive)
│   ├── decl-smith.mjs    Random @JSFunction/@JSClass declarations
│   ├── op-smith.mjs      Operation sequence generation
│   └── value-smith.mjs   Random JS values per type
│
├── emit/             Code emission
│   ├── swift-emitter.mjs     Operations → main.swift
│   ├── js-emitter.mjs        Operations → harness.mjs
│   └── project.mjs           SPM project setup
│
├── runner/           Build & execution
│   ├── build.mjs         swift package js orchestration
│   ├── execute.mjs       Node.js harness execution
│   ├── worker-pool.mjs   Parallel worker management
│   └── failures.mjs      Dedup, record, hook invocation
│
├── web/              Dashboard (serve mode)
│   ├── server.mjs        HTTP server + SSE + fuzzer orchestration
│   └── dashboard.mjs     Self-contained HTML dashboard
│
├── types.mjs         Shared JSDoc type definitions
└── cli.mjs           Entry point
```

### Operation Model

The core of the fuzzer is `OpSmith`, which generates operation sequences with a typed variable context — analogous to [wasm-smith](https://github.com/bytecodealliance/wasm-tools/tree/main/crates/wasm-smith)'s `CodeBuilder`. Each operation is chosen from valid candidates given the variables currently in scope.

v1 operations:

| Operation | Swift Output | What It Tests |
|---|---|---|
| `literal` | `let v0: Int = 42` | Value creation for any BridgeType |
| `callImport` | `let v1 = try! jsFunc(v0)` | Import call with args from scope |
| `construct` | `let v2 = try! FuzzObj(v0)` | Class construction, object passing |
| `return` | `return v0` | Export return value |

These compose into patterns like round-trips (`param → return`), transforms (`param → callImport → return`), object flow (`param → construct → callImport(obj) → return`), and chains (`callImport A → callImport B(result) → return`).

New operation kinds (method calls, property access, closures, async) are added by implementing a candidate generator in `validOperations()` plus emission in both emitters.

### Type Space

`TypeSmith` draws from all BridgeType variants with depth-limited recursion:

- **Leaf types**: `int`, `float`, `double`, `string`, `bool`, `jsObject`
- **Wrappers** (depth < maxDepth): `nullable(T)`, `array(T)`, `dictionary(T)`
- **Named**: `importedClass` (references a generated `@JSClass` declaration)

## Failure Handling

Failures are classified by phase:

| Phase | Meaning |
|---|---|
| `compile-error` | `swift package js` fails — codegen produced invalid Swift |
| `link-error` | Wasm instantiation fails — ABI mismatch between Swift/JS |
| `runtime-trap` | Wasm trap during execution |
| `runtime-error` | JS exception |
| `wrong-result` | No crash, but assertion mismatch |

Each new failure is saved to `FailCases/` (gitignored):

```
FailCases/001-compile-error/
├── seed.json          # { "seed": 42 }
├── main.swift         # The generated Swift file
├── harness.mjs        # The generated JS harness
├── error.txt          # Full error output
└── metadata.json      # Phase, fingerprint, timestamp, types involved
```

Duplicates are detected by fingerprinting `(phase + first meaningful error line)` with SHA-256.

### Failure Hooks

When `--on-failure` is set, the script is invoked for each **new** (non-duplicate) failure:

```bash
./hooks/on-new-failure.sh <fail-dir> <phase> <fingerprint>
# stdin = metadata.json
```

See [`hooks/on-new-failure.sh.example`](hooks/on-new-failure.sh.example) for examples (filing GitHub issues, starting fix agents, etc.).

## Determinism

Every test case is fully determined by its integer seed. Given the same seed and options, the fuzzer produces identical Swift and JS output. This means:

- Failures are reproducible: `node src/cli.mjs reproduce FailCases/001-compile-error`
- Runs are resumable: `--seed 100` picks up where `--seed 0 --iterations 100` left off
- No corpus needed — we generate structured programs, not mutated byte streams

## Performance

The first iteration is slow (~60–120s) because it compiles SwiftSyntax, JavaScriptKit, and all BridgeJS plugin code from scratch. Subsequent iterations reuse the `.build/` cache and only recompile the fuzz target module (~3–6s per iteration).

Tip: use `--max-depth 1` for faster initial runs that still cover all leaf types and simple wrappers.
