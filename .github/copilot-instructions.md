# JavaScriptKit Development Guide

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

## Project Overview

JavaScriptKit is a Swift framework that enables seamless interaction with JavaScript through WebAssembly. The project contains:

- **Main library**: Swift code that compiles to WebAssembly (`Sources/JavaScriptKit/`)
- **Runtime**: TypeScript runtime that provides the JavaScript bridge (`Runtime/`)
- **BridgeJS**: Plugin system for generating Swift bindings from TypeScript definitions (`Plugins/BridgeJS/`)
- **PackageToJS**: Plugin that packages Swift code as JavaScript modules (`Plugins/PackageToJS/`)
- **Examples**: Demonstrations of JavaScriptKit usage (`Examples/`)

## Getting Started

### Environment Setup

**CRITICAL**: Always use Swift 6.0.2 toolchain and matching WebAssembly SDK:

```bash
# Install Swift 6.0.2 toolchain
(
    SWIFT_TOOLCHAIN_CHANNEL=swift-6.0.2-release;
    SWIFT_TOOLCHAIN_TAG="swift-6.0.2-RELEASE";
    SWIFT_SDK_TAG="swift-wasm-6.0.2-RELEASE";
    SWIFT_SDK_CHECKSUM="6ffedb055cb9956395d9f435d03d53ebe9f6a8d45106b979d1b7f53358e1dcb4";
    
    # Download and install Swift
    curl -o "/tmp/swift.tar.gz" "https://download.swift.org/$SWIFT_TOOLCHAIN_CHANNEL/ubuntu2204/$SWIFT_TOOLCHAIN_TAG/$SWIFT_TOOLCHAIN_TAG-ubuntu22.04.tar.gz"
    tar -xzf /tmp/swift.tar.gz -C /tmp/
    sudo cp -r /tmp/$SWIFT_TOOLCHAIN_TAG-ubuntu22.04/usr/* /usr/local/
    
    # Install WebAssembly SDK
    swift sdk install "https://github.com/swiftwasm/swift/releases/download/$SWIFT_SDK_TAG/$SWIFT_SDK_TAG-wasm32-unknown-wasi.artifactbundle.zip" --checksum "$SWIFT_SDK_CHECKSUM"
)
```

### Bootstrap and Build Process

**Step 1**: Bootstrap dependencies (takes ~4 seconds):
```bash
make bootstrap
```

**Step 2**: Set SDK environment variable:
```bash
export SWIFT_SDK_ID=6.0.2-RELEASE-wasm32-unknown-wasi
```

**Step 3**: Build TypeScript runtime (takes ~3 seconds):
```bash
make regenerate_swiftpm_resources
```

## Core Development Commands

### Running Tests

**Unit tests** (takes ~40 seconds - NEVER CANCEL):
```bash
export SWIFT_SDK_ID=6.0.2-RELEASE-wasm32-unknown-wasi
make unittest
```
- **Timeout**: Set minimum 90 seconds
- Tests Swift code compiled to WebAssembly
- Requires `JAVASCRIPTKIT_EXPERIMENTAL_BRIDGEJS=1` environment variable

**PackageToJS plugin tests** (takes ~75 seconds - NEVER CANCEL):
```bash
swift test --package-path ./Plugins/PackageToJS
```
- **Timeout**: Set minimum 120 seconds
- Some tests may be skipped if environment variables are missing

**BridgeJS plugin tests** (takes ~90 seconds - NEVER CANCEL):
```bash
swift test --package-path ./Plugins/BridgeJS
```
- **Timeout**: Set minimum 150 seconds

**Update BridgeJS snapshot tests**:
```bash
UPDATE_SNAPSHOTS=1 swift test --package-path ./Plugins/BridgeJS
```

### Building Examples

**Build a specific example** (takes ~18 seconds):
```bash
cd Examples/Basic
export SWIFT_SDK_ID=6.0.2-RELEASE-wasm32-unknown-wasi
./build.sh release
```

**Build all examples**:
```bash
./Utilities/build-examples.sh
```

### BridgeJS Code Generation

**Generate BridgeJS code** (takes ~3 minutes 40 seconds - NEVER CANCEL):
```bash
./Utilities/bridge-js-generate.sh
```
- **Timeout**: Set minimum 300 seconds (5 minutes)
- **CRITICAL**: This downloads and builds swift-syntax dependencies on first run
- Required when changing TypeScript definitions or BridgeJS configuration

**Manual BridgeJS generation**:
```bash
env JAVASCRIPTKIT_EXPERIMENTAL_BRIDGEJS=1 swift package plugin --allow-writing-to-package-directory bridge-js
```

### Code Formatting

**Format Swift code** (takes <1 second):
```bash
./Utilities/format.swift
```

**Format TypeScript/JavaScript code** (takes <1 second):
```bash
npm run format
```

## Validation Workflows

**ALWAYS** perform these validation steps after making changes:

### 1. Basic Build Validation
```bash
# Bootstrap and build runtime
make bootstrap
make regenerate_swiftpm_resources

# Verify no uncommitted changes to runtime
git diff --exit-code Sources/JavaScriptKit/Runtime
```

### 2. Test Validation
```bash
# Run core unit tests
export SWIFT_SDK_ID=6.0.2-RELEASE-wasm32-unknown-wasi
make unittest

# Run plugin tests
swift test --package-path ./Plugins/PackageToJS
swift test --package-path ./Plugins/BridgeJS
```

### 3. Example Validation
```bash
cd Examples/Basic
export SWIFT_SDK_ID=6.0.2-RELEASE-wasm32-unknown-wasi
./build.sh release

# Test the built example
python3 -m http.server 8080 &
curl -s http://localhost:8080/index.html
kill %1
```

### 4. Code Format Validation
```bash
./Utilities/format.swift
npm run format
git diff --exit-code || echo "Formatting changes detected"
```

### 5. BridgeJS Validation (when needed)
```bash
./Utilities/bridge-js-generate.sh
git diff --exit-code || echo "BridgeJS generated files need updating"
```

## Working with Specific Components

### Runtime Development

**Location**: `Runtime/src/`
**Language**: TypeScript

When editing runtime TypeScript files:
1. Edit files in `Runtime/src/`
2. Run `make regenerate_swiftpm_resources`
3. Verify changes with `git diff Sources/JavaScriptKit/Runtime`

### BridgeJS Development

**Enable experimental features**:
```bash
export JAVASCRIPTKIT_EXPERIMENTAL_BRIDGEJS=1
```

**Key files**:
- `Plugins/BridgeJS/Sources/BridgeJSTool/` - Code generation tool
- `Tests/BridgeJSRuntimeTests/` - Test files with annotations
- `bridge-js.config.json` - Configuration files

### Swift Source Development

**Location**: `Sources/JavaScriptKit/`

**Key modules**:
- `JavaScriptKit` - Core library
- `JavaScriptEventLoop` - Async/await support
- `JavaScriptBigIntSupport` - BigInt interop
- `JavaScriptFoundationCompat` - Foundation compatibility

## Common Tasks Reference

### Repository Structure
```
.
├── Sources/                 # Swift source code
├── Runtime/                 # TypeScript runtime
├── Plugins/                 # Build plugins
├── Examples/               # Usage examples
├── Tests/                  # Test suites
├── Utilities/              # Build scripts
├── Makefile               # Main build targets
└── Package.swift          # Swift package definition
```

### Environment Variables
- `SWIFT_SDK_ID=6.0.2-RELEASE-wasm32-unknown-wasi` - Required for builds
- `JAVASCRIPTKIT_EXPERIMENTAL_BRIDGEJS=1` - Enables BridgeJS features
- `UPDATE_SNAPSHOTS=1` - Updates test snapshots

### Build Artifacts
- `.build/plugins/PackageToJS/outputs/` - Generated JavaScript packages
- `Runtime/lib/` - Compiled TypeScript runtime
- `Generated/` directories - BridgeJS generated code

## Troubleshooting

**Swift version mismatch errors**: Ensure using Swift 6.0.2 toolchain and matching SDK
**BridgeJS errors**: Set `JAVASCRIPTKIT_EXPERIMENTAL_BRIDGEJS=1`
**Missing wasm-opt warnings**: Optional optimization tool, builds still work
**SDK warnings**: Can be ignored, builds are still functional

## Performance Expectations

| Command | Time | Timeout |
|---------|------|---------|
| `make bootstrap` | ~4s | 30s |
| `make regenerate_swiftpm_resources` | ~3s | 30s |
| `make unittest` | ~40s | 90s |
| `./Utilities/bridge-js-generate.sh` | ~3m40s | 300s |
| `swift test --package-path ./Plugins/BridgeJS` | ~90s | 150s |
| Example builds | ~18s | 60s |
| Formatting | <1s | 10s |

**CRITICAL**: NEVER CANCEL long-running commands. Build times are normal and expected.