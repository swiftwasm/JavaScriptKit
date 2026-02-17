# AGENTS.md - JavaScriptKit

Instructions for AI coding agents contributing to JavaScriptKit.

## Project Overview

JavaScriptKit is a Swift framework for interacting with JavaScript from WebAssembly. The repository contains:

- **Core library** (`Sources/JavaScriptKit/`) - Swift-to-JavaScript interop via `JSObject`, `JSValue`, `JSClosure`, etc.
- **Companion libraries** (`Sources/JavaScriptEventLoop/`, `Sources/JavaScriptBigIntSupport/`, `Sources/JavaScriptFoundationCompat/`)
- **TypeScript Runtime** (`Runtime/src/`) - the JS-side runtime that manages object heaps, closures, and memory
- **BridgeJS codegen** - code generator for type-safe Swift-JS bindings using `@JS` macros (see Source Code Layout below)
- **PackageToJS plugin** (`Plugins/PackageToJS/`) - SwiftPM command plugin that compiles Swift to WebAssembly and generates a JS package
- **BridgeJS plugin** (`Plugins/BridgeJS/`) - SwiftPM build/command plugin for `@JS` annotation processing

**Important**: `Plugins/PackageToJS/` and `Plugins/BridgeJS/` are separate SwiftPM packages with their own `Package.swift`. They are not part of the root package's target graph. Test them with `--package-path`, not from the root.

## Prerequisites

- **OSS Swift toolchain** (not the Xcode-bundled one). Install via [swiftly](https://www.swift.org/install/). Verify with `which swiftc` - it must NOT point to `/usr/bin/swiftc` or a path inside `Xcode.app`.
- **Swift SDK for WebAssembly** matching the toolchain version. Install and verify:
    ```bash
    swift sdk list
    ```
    Set `SWIFT_SDK_ID` to the installed SDK ID (e.g., `swift-6.2.3-RELEASE_wasm`).
- **Node.js and npm**
- Run `make bootstrap` (runs `npm ci`) to install JS dependencies.

---

## Source Code Layout

BridgeJS code lives in two SwiftPM packages that share source files via symlinks:

**Canonical sources** are in `Plugins/BridgeJS/Sources/`. The root package's `Sources/BridgeJSTool/` contains symlinks pointing into the plugin package:

```
Sources/BridgeJSTool/
├── BridgeJSCore/       -> ../../Plugins/BridgeJS/Sources/BridgeJSCore
├── BridgeJSSkeleton/   -> ../../Plugins/BridgeJS/Sources/BridgeJSSkeleton
├── BridgeJSUtilities/  -> ../../Plugins/BridgeJS/Sources/BridgeJSUtilities
├── BridgeJSTool/       -> ../../Plugins/BridgeJS/Sources/BridgeJSTool
└── TS2Swift/           -> ../../Plugins/BridgeJS/Sources/TS2Swift
```

The root `Package.swift` compiles all symlinked sources as a single flat `BridgeJSTool` target. The `Plugins/BridgeJS/Package.swift` splits them into separate modular targets (`BridgeJSCore`, `BridgeJSSkeleton`, `BridgeJSLink`, `BridgeJSUtilities`, etc.) with proper dependency edges.

**BridgeJSLink exists only in the plugin package** - there is no symlink for it in `Sources/BridgeJSTool/`. The root package does not include BridgeJSLink code. Edit BridgeJSLink files at `Plugins/BridgeJS/Sources/BridgeJSLink/`.

### Quick Path Reference

| Component                                     | Canonical Path                                                |
| :-------------------------------------------- | :------------------------------------------------------------ |
| BridgeJSCore (parsing + Swift codegen)        | `Plugins/BridgeJS/Sources/BridgeJSCore/`                      |
| BridgeJSSkeleton (data models)                | `Plugins/BridgeJS/Sources/BridgeJSSkeleton/`                  |
| BridgeJSLink (JS/TS codegen)                  | `Plugins/BridgeJS/Sources/BridgeJSLink/`                      |
| BridgeJSUtilities (CodeFragmentPrinter, etc.) | `Plugins/BridgeJS/Sources/BridgeJSUtilities/`                 |
| TS2Swift (TypeScript -> Swift converter)      | `Plugins/BridgeJS/Sources/TS2Swift/`                          |
| Swift runtime intrinsics                      | `Sources/JavaScriptKit/BridgeJSIntrinsics.swift`              |
| Macro declarations                            | `Sources/JavaScriptKit/Macros.swift`                          |
| Snapshot tests                                | `Plugins/BridgeJS/Tests/BridgeJSToolTests/`                   |
| Test inputs                                   | `Plugins/BridgeJS/Tests/BridgeJSToolTests/Inputs/MacroSwift/` |
| Test snapshots                                | `Plugins/BridgeJS/Tests/BridgeJSToolTests/__Snapshots__/`     |

### Project Structure

```
Sources/JavaScriptKit/
├── BridgeJSIntrinsics.swift        # Swift-side lowering/lifting runtime
├── Macros.swift                    # @JS, @JSFunction, @JSGetter, @JSSetter, @JSClass
├── JSUndefinedOr.swift             # JSUndefinedOr<T> for T | undefined semantics
├── FundamentalObjects/             # JSObject, JSClosure, JSString, etc.
├── BasicObjects/                   # JSPromise, JSArray, JSDate, etc.
├── Runtime/                        # Compiled JS runtime (index.mjs, index.d.ts)
└── Documentation.docc/             # User-facing documentation

Plugins/BridgeJS/Sources/
├── BridgeJSCore/                   # Swift-side code generation
│   ├── SwiftToSkeleton.swift       # Parses @JS declarations -> ExportedSkeleton
│   ├── ExportSwift.swift           # Generates Swift thunk functions for exports
│   ├── ImportTS.swift              # Generates Swift bindings for imported JS APIs
│   ├── ClosureCodegen.swift        # Closure/callback marshaling code generation
│   └── TypeDeclResolver.swift      # Resolves Swift type names to declarations
├── BridgeJSSkeleton/               # Shared data models (BridgeType, skeletons)
├── BridgeJSLink/                   # JavaScript/TypeScript code generation
│   ├── BridgeJSLink.swift          # Main linker: combines skeletons -> .js/.d.ts
│   ├── JSGlueGen.swift             # IntrinsicJSFragment definitions for type conversion
│   └── JSIntrinsicRegistry.swift   # Registry for JS intrinsic helper functions
├── BridgeJSUtilities/              # Shared utilities
│   └── Utilities.swift             # CodeFragmentPrinter (indentation-aware output)
├── BridgeJSBuildPlugin/            # SwiftPM build plugin integration
├── BridgeJSCommandPlugin/          # SwiftPM command plugin interface
├── BridgeJSMacros/                 # Macro implementations (@JSFunction, etc.)
├── BridgeJSTool/                   # Main BridgeJS CLI tool
├── BridgeJSToolInternal/           # Internal tool for pipeline debugging
└── TS2Swift/                       # TypeScript .d.ts -> Swift macro source converter

Plugins/PackageToJS/
├── Package.swift                   # Separate SwiftPM package
├── Sources/                        # Plugin implementation
├── Templates/
│   ├── runtime.mjs                 # Compiled JS runtime (checked in)
│   ├── runtime.d.ts                # Compiled TS declarations (checked in)
│   └── instantiate.js              # Wasm instantiation with BridgeJS stubs
└── Tests/

Runtime/src/                        # TypeScript source for the JS runtime
├── index.ts                        # Main entry point
├── js-value.ts                     # JSValue representation
├── object-heap.ts                  # Object reference tracking
└── closure-heap.ts                 # Closure lifecycle management
```

---

## Architecture Overview

BridgeJS is a multi-stage code generation tool that creates type-safe Swift-JavaScript bindings for WebAssembly. It has two pipelines: **export** (Swift -> JS) and **import** (JS -> Swift).

### Pipeline Overview

```
Swift Source (.swift with @JS)     TypeScript Definitions (bridge-js.d.ts)
         |                                      |
         v                                      v
  SwiftToSkeleton                           TS2Swift
         |                                      |
         v                                      v
  ExportedSkeleton (JSON)              BridgeJS.Macros.swift
         |                                      |
         +---> ExportSwift ----+                |
         |                     |                v
         |              BridgeJS.swift    SwiftToSkeleton
         |              (Swift thunks)          |
         |                                      v
         +---> BridgeJSLink <--+--- ImportedModuleSkeleton
                    |
                    v
          bridge-js.js + bridge-js.d.ts
          (JS glue code + TS declarations)
```

### Key Principle: Skeleton as Intermediate Representation

The `BridgeJSSkeleton` JSON format is the central intermediate representation. It decouples parsing from code generation, allowing each stage to operate independently. The skeleton captures all API surface information (functions, classes, enums, structs, protocols) without language-specific implementation details.

### Macro System

Five macros are defined in `Sources/JavaScriptKit/Macros.swift`:

| Macro         | Role                           | Purpose                                                           |
| :------------ | :----------------------------- | :---------------------------------------------------------------- |
| `@JS`         | `@attached(peer)`              | Marks Swift declarations for **export** to JavaScript             |
| `@JSFunction` | `@attached(body)`              | Generates body that **calls** a JS function                       |
| `@JSGetter`   | `@attached(accessor)`          | Generates getter that **reads** a JS property                     |
| `@JSSetter`   | `@attached(body)`              | Generates body that **writes** to a JS property                   |
| `@JSClass`    | `@attached(member, extension)` | Adds `jsObject` property, init, and `_JSBridgedClass` conformance |

`@JS` is for exports. `@JSFunction`, `@JSGetter`, `@JSSetter`, and `@JSClass` are for imports and are implemented by macros in the `BridgeJSMacros` module.

### Generated JS Output Structure

The generated `bridge-js.js` exports a `createInstantiator` async function that returns three methods:

1. **`addImports(importObject, importsContext)`** - Registers JavaScript function handlers for Swift-imported APIs into the WebAssembly import object
2. **`setInstance(instance)`** - Stores the WebAssembly instance reference and sets up memory access
3. **`createExports(instance)`** - Creates JavaScript wrapper objects for all exported Swift APIs (classes, functions, enums, structs)

Within `createInstantiator`, temporary stacks (`tmpParamInts`, `tmpRetStrings`, etc.) are used for passing complex types between Swift and JavaScript through the WebAssembly boundary.

**Helper factory pattern**: Struct and enum helper factories (`__bjs_create<Name>Helpers`, `__bjs_create<Name>ValuesHelpers`) are defined inside `createInstantiator` scope because they need access to `_exports` and `swift`. They use a double-invocation pattern - the factory returns a function that creates the actual helper. Only enum/struct tag value constants (which are pure data) belong at module level as exports.

---

## Code Generation Pipeline

### Stage 1: SwiftToSkeleton (Parsing)

**File:** `Plugins/BridgeJS/Sources/BridgeJSCore/SwiftToSkeleton.swift`

Walks Swift source files using SwiftSyntax to find `@JS`-annotated declarations. Produces an `ExportedSkeleton` containing functions, classes, enums, structs, and protocols. The `lookupType(for:errors:)` method maps Swift type names to `BridgeType` enum cases (see `BridgeJSSkeleton.swift` for the full type definition). Uses `TypeDeclResolver` to resolve type aliases and custom type declarations.

### Stage 2a: ExportSwift (Swift Thunk Generation)

**File:** `Plugins/BridgeJS/Sources/BridgeJSCore/ExportSwift.swift`

Processes the `ExportedSkeleton` to generate Swift "thunk" functions - `@_cdecl`-exported functions callable from WebAssembly that bridge between the C-compatible Wasm ABI and native Swift types. Uses the `ExportedThunkBuilder` pattern to accumulate parameter lifting, return value lowering, and ABI signatures. Delegates to specialized codegens (`StructCodegen`, `EnumCodegen`, `ProtocolCodegen`) for type-specific helpers.

**Error handling**: When a function is marked `throws`, the generated thunk wraps the call in `do/catch`. If the Swift error has a JS object representation, it passes that object's ID via `_swift_js_throw()`. Otherwise, it wraps the error description in a `JSError`. The JS glue code checks for exceptions after each Wasm call and re-throws them.

**Async support**: Async exported functions are wrapped in `JSPromise.async { ... }`, returning the promise to JavaScript.

### Stage 2b: ImportTS (Import-Side Swift Codegen)

**File:** `Plugins/BridgeJS/Sources/BridgeJSCore/ImportTS.swift`

Processes an `ImportedModuleSkeleton` and generates Swift bridge code for calling JavaScript from Swift. Produces `@_extern(wasm)` declarations (with `#if arch(wasm32)` / `#else` stubs) and Swift wrapper functions.

The central class is `CallJSEmission`, a builder for a single "call JS from Swift" operation:

- `lowerParameter()` - converts Swift parameters into Wasm ABI form via `bridgeJSLowerParameter()`
- `call()` - emits the Wasm extern call, then injects `if let error = _swift_js_take_exception() { throw error }` for exception propagation
- `liftReturnValue()` - converts Wasm return into a Swift value via `bridgeJSLiftReturn()`
- `renderThunkDecl()` / `renderConstructorDecl()` - produce the complete Swift wrapper

`CallJSEmission` is also reused by `ClosureCodegen` to generate callback invocation handlers.

### Stage 3: BridgeJSLink (JS/TS Generation)

**File:** `Plugins/BridgeJS/Sources/BridgeJSLink/BridgeJSLink.swift`

Combines one or more `BridgeJSSkeleton` files and produces `bridge-js.js` (JavaScript glue) and `bridge-js.d.ts` (TypeScript declarations). Uses `IntrinsicJSFragment` definitions from `JSGlueGen.swift` for type-specific marshaling code. The `CodeFragmentPrinter` class (in `BridgeJSUtilities/Utilities.swift`) handles indentation-aware output for the generated JavaScript.

Each type needs up to four JS conversion directions (defined as `IntrinsicJSFragment` statics in `JSGlueGen.swift`):

| Direction        | Context    | What it does                                      |
| :--------------- | :--------- | :------------------------------------------------ |
| `lowerParameter` | JS -> Wasm | Converts a JS value into Wasm args for a call     |
| `liftReturn`     | Wasm -> JS | Converts Wasm return value(s) back to a JS value  |
| `liftParameter`  | Wasm -> JS | Converts Wasm args into JS values (for callbacks) |
| `lowerReturn`    | JS -> Wasm | Converts a JS return value into Wasm form         |

Additionally, types that appear in compound contexts need extra fragment definitions: `associatedValuePushPayload`/`associatedValuePopPayload` for associated value enum payloads, and `structFieldLower`/`structFieldRaise` for struct fields.

### Closure Lifecycle

**File:** `Plugins/BridgeJS/Sources/BridgeJSCore/ClosureCodegen.swift`

For each unique closure signature, generates:

- An `@_extern(wasm)` `invoke_js_callback` function (Swift calling a JS callback)
- An `@_extern(wasm)` `make_swift_closure` function (JS wrapping a Swift closure)
- An `@_expose(wasm)` `invoke_swift_closure` handler (JS calling back into Swift)
- A helper enum with `bridgeJSLift` for converting JS callback IDs to Swift closures

Swift closures are heap-allocated in a `_BridgeJSTypedClosureBox<Signature>` (defined in `JSClosure.swift`). The box is retained via `Unmanaged.passRetained` when passed to JS. Two release paths exist:

- **Manual**: `JSTypedClosure.release()` unregisters from `FinalizationRegistry` and releases the box
- **Automatic**: When the JS function is GC'd, `FinalizationRegistry` calls `bjs_release_swift_closure` to release the box

---

## WebAssembly ABI and Type System

### BridgeType

The canonical type representation is the `BridgeType` enum in `Plugins/BridgeJS/Sources/BridgeJSSkeleton/BridgeJSSkeleton.swift`. Cases include:

- **Primitives**: `int`, `uint`, `float`, `double`, `string`, `bool`, `void`
- **JS types**: `jsObject(String?)`, `jsValue`
- **Swift types**: `swiftHeapObject(String)`, `swiftProtocol(String)`, `swiftStruct(String)`
- **Pointer types**: `unsafePointer(UnsafePointerType)`
- **Enum types**: `caseEnum`, `rawValueEnum`, `associatedValueEnum`, `namespaceEnum`
- **Container types**: `nullable(BridgeType, JSOptionalKind)`, `array(BridgeType)`, `dictionary(BridgeType)`, `closure(ClosureSignature, useJSTypedClosure:)`

### Type Mapping (Swift to TypeScript to Wasm)

The full type mapping table is maintained in `Plugins/BridgeJS/README.md`. Key mappings:

| Swift Type          | TypeScript Type         | Wasm Core Type         |
| :------------------ | :---------------------- | :--------------------- |
| `Int`, `UInt`       | `number`                | `i32`                  |
| `Int64`, `UInt64`   | `bigint`                | `i64`                  |
| `Float`             | `number`                | `f32`                  |
| `Double`            | `number`                | `f64`                  |
| `Bool`              | `boolean`               | `i32`                  |
| `String`            | `string`                | varies (see ABI)       |
| `JSObject`          | `any`                   | `i32` (object ID)      |
| `JSValue`           | `any`                   | stack (kind + payload) |
| `@JS class`         | interface + constructor | pointer (`i32`)        |
| `@JS struct`        | interface               | fields via stack       |
| `@JS enum` (case)   | const + tag type        | `i32`                  |
| `@JS enum` (assoc.) | discriminated union     | tag + stack            |
| `@JS protocol`      | interface               | `i32` (wrapper)        |
| `Optional<T>`       | `T \| null`             | depends on T           |
| `JSUndefinedOr<T>`  | `T \| undefined`        | depends on T           |
| `(T) -> U`          | `(arg: T) => U`         | `i32` (boxed)          |
| `Array<T>`          | `T[]`                   | stack                  |
| `Dictionary<K, V>`  | `{ [key: K]: V }`       | stack                  |

`JSUndefinedOr<T>` (in `Sources/JavaScriptKit/JSUndefinedOr.swift`) represents `T | undefined` in JavaScript, as opposed to `Optional<T>` which maps to `T | null`. Both share the same wire format (isSome flag + value) via the `_BridgedAsOptional` protocol. The distinction is handled in the JS glue code.

### ABI Strategies

Swift types cross the WebAssembly boundary using one of three strategies, defined by protocol conformances in `Sources/JavaScriptKit/BridgeJSIntrinsics.swift`. Understanding which strategy a type uses is essential when adding new types or debugging marshaling issues.

**1. Value return** (`_BridgedSwiftTypeLoweredIntoSingleWasmCoreType`) - Types that map to a single Wasm core type (`i32`, `f32`, `f64`, or pointer). The thunk's return type is that core type. Used by: `Bool`, `Int`, `UInt`, `Float`, `Double`, `JSObject`, `_BridgedSwiftHeapObject`, `_BridgedSwiftCaseEnum`, closures, pointers.

**2. Stack ABI** (`_BridgedSwiftStackType` + `_BridgedSwiftTypeLoweredIntoVoidType`) - Types that can't fit in a single Wasm value. Fields are pushed onto typed stacks (`_swift_js_push_i32`, `_swift_js_push_f64`, etc.) and the thunk returns `Void`. JS pops the stacks in reverse (LIFO) order. Used by: `@JS struct`, associated value enums, `Array`, `Dictionary`, `JSValue`, and `String` (for return values only).

**3. Side channel** (`_BridgedSwiftOptionalScalarBridge` / `_BridgedSwiftOptionalScalarSideChannelBridge`) - Dedicated intrinsic pairs for optional scalar types. Swift calls type-specific intrinsics like `_swift_js_return_optional_bool(isSome, value)` and `_swift_js_get_optional_int_presence()`. JS reads from reserved side-channel variables (`tmpRetOptionalBool`, etc.). Used by: `Bool?`, `Int?`, `Float?`, `Double?`, `String?`, `JSObject?`, optional heap objects.

There is also `_BridgedSwiftGenericOptionalStackType` for optionals of stack-based types (`Array?`, `Dictionary?`, struct optionals) that use the generic stack-based Optional ABI. And `_BridgedSwiftDictionaryStackType` for dictionary-specific stack operations.

**Design principle**: Prefer abstracting type marshaling into `BridgeJSIntrinsics.swift` protocol conformances. Generated Swift thunks should call `bridgeJSLowerReturn()`, `bridgeJSLiftParameter()`, etc. rather than inlining conversion logic. Only expand the generated glue code if the conversion genuinely can't be expressed as an intrinsic method.

Note that a single type can use **different strategies for parameters vs. returns**. For example, `String` parameters use value return ABI (pass bytes pointer + length as two `i32` args), but `String` returns use the stack ABI (`bridgeJSLowerReturn()` calls `_swift_js_return_string` and returns `Void`).

### Parameter Passing Conventions

| Type                  | JS -> Wasm (lower)                                       | Wasm -> JS (lift)                                                        |
| :-------------------- | :------------------------------------------------------- | :----------------------------------------------------------------------- |
| `int`, `bool`         | Direct `i32`                                             | Direct `i32`                                                             |
| `float`               | Direct `f32`                                             | Direct `f32`                                                             |
| `double`              | Direct `f64`                                             | Direct `f64`                                                             |
| `string`              | UTF-8 bytes retained in `swift.memory`, pass ID + length | Swift calls `swift_js_return_string(ptr, len)` intrinsic                 |
| `swiftHeapObject`     | Raw pointer as `i32`                                     | Pointer returned, JS wraps in `SwiftHeapObject` + `FinalizationRegistry` |
| `jsObject`            | Object ID from `swift.memory.retain()` as `i32`          | Object ID returned, JS calls `swift.memory.getObject()`                  |
| `swiftStruct`         | Fields pushed to typed stacks                            | Fields pushed to stacks, JS pops and reconstructs                        |
| `associatedValueEnum` | Tag + payload fields pushed to stacks                    | Tag + payload fields pushed to stacks                                    |
| `closure`             | Boxed, handle passed as `i32`                            | Box pointer passed, JS wraps in callable                                 |
| `optional(T)`         | Presence flag + value via side channels                  | Side-channel intrinsics (`swift_js_return_optional_*`)                   |

Complex types (structs, arrays, dictionaries, associated value enum payloads) use typed stacks: `tmpParamInts`/`tmpRetInts`, `tmpParamF32s`/`tmpRetF32s`, `tmpParamF64s`/`tmpRetF64s`, `tmpParamPointers`/`tmpRetPointers`, `tmpRetStrings`, `tmpRetTag`. Swift pushes fields in order; JavaScript pops them (LIFO). Both sides must agree on the push/pop sequence.

### Memory Management

- **Swift classes**: Live on Swift heap. JS holds pointer wrapped in `SwiftHeapObject` with `FinalizationRegistry` for automatic cleanup. Optional `release()` for deterministic deallocation.
- **JSObjects**: Live in JS heap, tracked via `swift.memory.heap`. Swift holds integer ID. Reference counted via `retain`/`release`.
- **Structs/Enums**: Copy semantics - data serialized across boundary. No cleanup needed.
- **Closures**: Boxed in `_BridgeJSTypedClosureBox`, released via `FinalizationRegistry` or manual `release()`.

### Error Handling

**Export side** (Swift throws -> JS catches): Generated thunks wrap throwing calls in `do/catch`. On error, Swift calls `_swift_js_throw(objectId)` which stores the exception ID in JS-side global state. The JS glue code checks this after the Wasm call returns and re-throws it as a JavaScript exception. If the Swift error has no JS object representation, it's wrapped in a `JSError(message:)`.

**Import side** (JS throws -> Swift catches): After every imported JS call, the generated thunk checks `_swift_js_take_exception()`. If an exception was pending, it clears the slot and throws a `JSException`. This is how JS exceptions propagate into Swift `throws(JSException)` functions.

---

## Workflows

### Before Committing

Always run the relevant checks before committing. CI enforces all of these and will reject PRs that fail.

**Always (for any change):**

```bash
./Utilities/format.swift          # Format all Swift code
```

**If you changed `Sources/` or `Tests/` (core library):**

```bash
make unittest SWIFT_SDK_ID=$SWIFT_SDK_ID
```

**If you changed `Runtime/src/*.ts`:**

```bash
npx prettier --write Runtime/src                  # Format TypeScript
make regenerate_swiftpm_resources                  # Rebuild compiled JS
# Commit the regenerated files in both:
#   Plugins/PackageToJS/Templates/runtime.{mjs,d.ts}
#   Sources/JavaScriptKit/Runtime/index.{mjs,d.ts}
```

**If you changed BridgeJS codegen (`Plugins/BridgeJS/Sources/`) or `Sources/BridgeJSTool/`:**

```bash
swift test --package-path ./Plugins/BridgeJS       # Run BridgeJS tests
./Utilities/bridge-js-generate.sh                  # Regenerate pre-generated files
npm run check:bridgejs-dts                         # Validate TypeScript declarations
# Commit regenerated Generated/ files
```

**If you changed `Plugins/PackageToJS/`:**

```bash
swift test --package-path ./Plugins/PackageToJS
```

### Core Library Changes

**What**: Changes to `Sources/JavaScriptKit/`, `Sources/JavaScriptEventLoop/`, `Sources/JavaScriptBigIntSupport/`, `Sources/JavaScriptFoundationCompat/`, or their C shim targets (`Sources/_CJavaScriptKit/`, etc.).

**Build and test**:

```bash
make unittest SWIFT_SDK_ID=$SWIFT_SDK_ID
```

This builds for WebAssembly and runs tests via Node.js.

**Key patterns in the codebase**:

- **Dual-implementation pattern**: Most low-level functions have a wasm32 implementation and a non-wasm stub:

    ```swift
    #if arch(wasm32)
    @_extern(wasm, module: "bjs", name: "swift_js_throw")
    private func _swift_js_throw_extern(_ id: Int32)
    #else
    private func _swift_js_throw_extern(_ id: Int32) {
        _onlyAvailableOnWasm()
    }
    #endif
    ```

    When adding new `@_extern(wasm)` functions, always add the `#else` stub so the code compiles on non-wasm platforms.

- **`@_spi(BridgeJS)`**: Internal APIs used by BridgeJS-generated code. These are public but hidden from normal consumers.

- **`@_extern(wasm, module: "bjs")`**: WebAssembly imports from the BridgeJS JavaScript runtime. Adding new ones requires a matching stub in `Plugins/PackageToJS/Templates/instantiate.js` (see "Adding BridgeJS Intrinsics" below).

### Runtime (TypeScript) Changes

**What**: Changes to the JavaScript runtime that runs alongside WebAssembly modules.

**Source files**: `Runtime/src/*.ts`

**After editing TypeScript, regenerate the compiled JavaScript**:

```bash
make regenerate_swiftpm_resources
```

This compiles the TypeScript and copies the output to:

- `Plugins/PackageToJS/Templates/runtime.mjs` and `runtime.d.ts`
- `Sources/JavaScriptKit/Runtime/index.mjs` and `index.d.ts`

**All compiled files are checked into version control.** Always commit the regenerated output alongside your TypeScript changes. CI verifies both locations are in sync.

**Test** by running `make unittest` (which exercises the runtime through the Swift test suite).

### BridgeJS Codegen Changes

**What**: Changes to BridgeJS code generator sources in `Plugins/BridgeJS/Sources/` (which are also visible via symlinks in `Sources/BridgeJSTool/`).

**Test**:

```bash
swift test --package-path ./Plugins/BridgeJS
```

This runs both the TS2Swift Vitest suite and the Swift codegen/link tests.

**Fast iteration on TS2Swift only**:

```bash
cd Plugins/BridgeJS/Sources/TS2Swift/JavaScript && npm test
```

**Updating snapshot tests** when expected output changes:

```bash
UPDATE_SNAPSHOTS=1 swift test --package-path ./Plugins/BridgeJS
```

### Adding BridgeJS Intrinsics

When adding new `@_extern(wasm, module: "bjs")` functions to `Sources/JavaScriptKit/BridgeJSIntrinsics.swift`, you must also add corresponding stub entries to `Plugins/PackageToJS/Templates/instantiate.js` in the `importObject["bjs"]` object. This allows packages that don't use BridgeJS-generated code to instantiate successfully.

### Updating Pre-generated BridgeJS Files

This repository contains pre-generated BridgeJS files (in `Generated/` directories) that are checked into version control. When you change TypeScript definitions, BridgeJS configuration, or the BridgeJS code generator itself, regenerate them:

```bash
./Utilities/bridge-js-generate.sh
```

This runs the BridgeJS tool in AoT mode on several targets (BridgeJSRuntimeTests, BridgeJSGlobalTests, Benchmarks, PlayBridgeJS). Commit the regenerated files.

### PackageToJS Plugin Changes

**What**: Changes to `Plugins/PackageToJS/`.

**Test**:

```bash
swift test --package-path ./Plugins/PackageToJS
```

---

## Code Style and Patterns

- **swift-format** is configured via `.swift-format`: 4-space indentation, 120-character line length
- **Formatting utility**: `./Utilities/format.swift`
- **Prettier** for TypeScript: `npx prettier --write Runtime/src`
- Follow standard Swift naming conventions
- Keep code self-documenting through clear naming
- Use `/// ` doc comments only when they add value beyond what the signature communicates
- Do not add inline comments to explain obvious code
- Do not add comments, docstrings, or type annotations to code that was not changed

### BridgeJS Naming Conventions

| Context               | Pattern                           | Example                              |
| :-------------------- | :-------------------------------- | :----------------------------------- |
| ABI function name     | `bjs_<Context>_<name>`            | `bjs_MathUtils_multiply`             |
| ABI static function   | `bjs_<Context>_static_<name>`     | `bjs_Calculator_static_square`       |
| ABI deinit            | `bjs_<Class>_deinit`              | `bjs_MathUtils_deinit`               |
| Enum values const     | `<Name>Values`                    | `CalculatorValues`                   |
| Struct helper factory | `__bjs_create<Name>Helpers`       | `__bjs_createPointHelpers`           |
| Enum helper factory   | `__bjs_create<Name>ValuesHelpers` | `__bjs_createAPIResultValuesHelpers` |
| JS wrapper import     | `bjs_<Class>_wrap`                | `bjs_MathUtils_wrap`                 |

---

## Testing Infrastructure

### Snapshot Tests

**Location:** `Plugins/BridgeJS/Tests/BridgeJSToolTests/`

Tests the code generation pipeline by comparing generated output against expected snapshots.

**Test flow:**

1. Swift input file in `Inputs/MacroSwift/` directory (e.g., `EnumAssociatedValue.swift`)
2. `BridgeJSCodegenTests` runs `SwiftToSkeleton` + `ExportSwift` - compares against `__Snapshots__/BridgeJSCodegenTests/<Name>.swift` and `<Name>.json`
3. `BridgeJSLinkTests` runs `SwiftToSkeleton` + `BridgeJSLink` - compares against `__Snapshots__/BridgeJSLinkTests/<Name>.js` and `<Name>.d.ts`

**When snapshots fail:**

- `.actual` files are written next to expected files
- Compare: `diff Expected.js Expected.js.actual`
- To update: copy `.actual` over expected file, or set `UPDATE_SNAPSHOTS=1`
- Delete stale `.actual` files before running tests to avoid confusion: `find Plugins/BridgeJS/Tests -name "*.actual" -delete`

**Adding a new snapshot test:**

1. Create or modify input file in `Inputs/MacroSwift/` (e.g., `MyNewType.swift`)
2. Run `swift test --package-path Plugins/BridgeJS`
3. Tests will fail with `.actual` files containing generated output
4. Review `.actual` files for correctness
5. Copy `.actual` files to replace expected snapshots

### E2E Tests

**Location:**

- Swift: `Tests/BridgeJSRuntimeTests/ExportAPITests.swift`
- JavaScript: `Tests/prelude.mjs`

Tests the full roundtrip: Swift code -> generated bindings -> WebAssembly compilation -> JavaScript execution.

**Run:**

```bash
swift build --package-path ./Plugins/BridgeJS --product BridgeJSTool && \
  ./Utilities/bridge-js-generate.sh && \
  make unittest SWIFT_SDK_ID=$SWIFT_SDK_ID
```

Note: Snapshot tests use system Swift (`swift test --package-path Plugins/BridgeJS`). E2E tests require Wasm Swift toolchain + `SWIFT_SDK_ID`.

---

## Steps to Add a New Type

### 1. Define the Type (BridgeJSSkeleton.swift)

If adding a new `BridgeType` case, add it to the enum in `Plugins/BridgeJS/Sources/BridgeJSSkeleton/BridgeJSSkeleton.swift`. Add `mangleTypeName`, `abiReturnType`, and any other computed properties.

### 2. Validation (SwiftToSkeleton.swift)

Update `lookupType(for:errors:)` to recognize the Swift type and map it to your `BridgeType`. Update any validation switches that restrict where types can appear (parameters, return types, associated value payloads, etc.). Search for `switch` statements over `BridgeType` to find all places that need updating.

### 3. Swift Codegen (ExportSwift.swift)

Add parameter lifting and return value lowering code in `ExportedThunkBuilder`. If the type needs special handling (like structs or enums), create a specialized codegen class.

### 4. JS Codegen - Fragments (JSGlueGen.swift)

Add `IntrinsicJSFragment` definitions in `Plugins/BridgeJS/Sources/BridgeJSLink/JSGlueGen.swift` for up to four directions: `lowerParameter`, `liftReturn`, `liftParameter`, `lowerReturn`. If the type appears as an associated value enum payload, also update `associatedValuePushPayload` and `associatedValuePopPayload`. If it appears as a struct field, also update `structFieldLower` and `structFieldRaise`.

### 5. JS Codegen - Linker (BridgeJSLink.swift)

If the type needs new helper infrastructure (like struct/enum helpers), update `collectLinkData()`, `generateJavaScript(data:)`, and the `createExports` section in `Plugins/BridgeJS/Sources/BridgeJSLink/BridgeJSLink.swift`.

### 6. TypeScript Declarations (BridgeJSLink.swift)

Update `generateTypeScript(data:)` to emit proper TypeScript type for the new type.

### 7. Swift Runtime (BridgeJSIntrinsics.swift)

If the type needs new intrinsic functions for stack communication, add Swift-side `@_extern(wasm)` declarations with non-wasm stubs, and add corresponding `bjs[...]` handlers in `BridgeJSLink.swift`.

### 8. Snapshot Tests

Add Swift declarations using the new type to an appropriate `Inputs/MacroSwift/` file (or create a new one). Run snapshot tests and review `.actual` files.

### 9. E2E Tests

Add Swift test types/functions to `Tests/BridgeJSRuntimeTests/ExportAPITests.swift` and JavaScript assertions to `Tests/prelude.mjs`. Regenerate bindings and run E2E tests.

### 10. Documentation

Update the feature table in `Sources/JavaScriptKit/Documentation.docc/Articles/BridgeJS/Exporting-Swift/` or the type mapping in `Plugins/BridgeJS/README.md`.

---

## Debug Utilities

`BridgeJSToolInternal` (in `Plugins/BridgeJS/Sources/BridgeJSToolInternal/`) exposes individual pipeline stages for inspecting intermediate output:

```bash
# Build the tool first
swift build --package-path ./Plugins/BridgeJS --product BridgeJSTool

# Parse Swift and emit skeleton JSON
cat MyFile.swift | ./Plugins/BridgeJS/.build/debug/BridgeJSToolInternal emit-skeleton -

# Emit Swift thunks from skeleton
cat skeleton.json | ./Plugins/BridgeJS/.build/debug/BridgeJSToolInternal emit-swift-thunks -

# Emit JS glue from skeleton
cat skeleton.json | ./Plugins/BridgeJS/.build/debug/BridgeJSToolInternal emit-js -

# Emit TypeScript declarations from skeleton
cat skeleton.json | ./Plugins/BridgeJS/.build/debug/BridgeJSToolInternal emit-dts -
```

---

## Common Pitfalls

- **NEVER remove `.build` folder**: Builds are incremental and not stale. If you encounter build errors, fix the actual code issue. Removing `.build` wastes time on unnecessary rebuilds and does not solve underlying code problems.
- **Toolchain**: Use an OSS Swift toolchain installed via swiftly, not the Xcode-bundled one.
- **Missing `SWIFT_SDK_ID`**: `make unittest` requires this. Run `swift sdk list` to find your installed SDK ID.
- **Missing intrinsic stubs**: New `@_extern(wasm, module: "bjs")` functions in `BridgeJSIntrinsics.swift` need matching stubs in `Plugins/PackageToJS/Templates/instantiate.js`.
- **Stack order matters**: Swift and JavaScript must push/pop fields in matching order. Swift pushes in field order; JavaScript pops in reverse (LIFO). Always verify push/pop sequences match between `ExportSwift.swift` and `JSGlueGen.swift`.
- **tmpRetTag overwrite**: Nested associated value enums as payloads are not supported because the inner enum's `bridgeJSLowerReturn()` overwrites `tmpRetTag` used by the outer enum.
- **Shared snapshots**: Changes to the helper factory signature or `addImports` intrinsics affect ALL snapshot test files, not just the one you're modifying. Expect many snapshot files to need updating when changing shared infrastructure.
