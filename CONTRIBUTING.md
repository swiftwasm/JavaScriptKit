# Contributing to JavaScriptKit

Thank you for considering contributing to JavaScriptKit! We welcome contributions of all kinds and value your time and effort.

## Getting Started

### Reporting Issues
- If you find a bug, have a feature request, or need help, please [open an issue](https://github.com/swiftwasm/JavaScriptKit/issues).
- Provide as much detail as possible:
  - Steps to reproduce the issue
  - Expected vs. actual behavior
  - Relevant error messages or logs

### Setting Up the Development Environment
1. Clone the repository:
   ```bash
   git clone https://github.com/swiftwasm/JavaScriptKit.git
   cd JavaScriptKit
   ```

2. Install **OSS** Swift toolchain via `swiftly`
3. Install Swift SDK for Wasm corresponding to the Swift version:
    ```bash
    (
      set -eo pipefail; \
      V="$(swiftc --version | head -n1)"; \
      TAG="$(curl -sL "https://raw.githubusercontent.com/swiftwasm/swift-sdk-index/refs/heads/main/v1/tag-by-version.json" | jq -e -r --arg v "$V" '.[$v] | .[-1]')"; \
      curl -sL "https://raw.githubusercontent.com/swiftwasm/swift-sdk-index/refs/heads/main/v1/builds/$TAG.json" | \
      jq -r '.["swift-sdks"]["wasm32-unknown-wasip1"] | "swift sdk install \"\(.url)\" --checksum \"\(.checksum)\""' | sh -x
    );
    export SWIFT_SDK_ID=$(
      V="$(swiftc --version | head -n1)"; \
      TAG="$(curl -sL "https://raw.githubusercontent.com/swiftwasm/swift-sdk-index/refs/heads/main/v1/tag-by-version.json" | jq -e -r --arg v "$V" '.[$v] | .[-1]')"; \
      curl -sL "https://raw.githubusercontent.com/swiftwasm/swift-sdk-index/refs/heads/main/v1/builds/$TAG.json" | \
      jq -r '.["swift-sdks"]["wasm32-unknown-wasip1"]["id"]'
    )
    ```
4. Install dependencies:
   ```bash
   make bootstrap
   ```

### Running Tests

Unit tests running on WebAssembly:

```bash
make unittest
```

Tests for `PackageToJS` plugin:

```bash
swift test --package-path ./Plugins/PackageToJS
```

Tests for `BridgeJS` plugin:

```bash
swift test --package-path ./Plugins/BridgeJS
```

This runs both the TS2Swift Vitest suite (TypeScript `.d.ts` -> Swift macro output) and the Swift codegen/link tests. For fast iteration on the ts2swift tool only, run Vitest directly:

```bash
cd Plugins/BridgeJS/Sources/TS2Swift/JavaScript && npm test
```

To update snapshot test files when expected output changes:

```bash
UPDATE_SNAPSHOTS=1 swift test --package-path ./Plugins/BridgeJS
```

### Editing `./Runtime` directory

The `./Runtime` directory contains the JavaScript runtime that interacts with the JavaScript environment and Swift code.
The runtime is written in TypeScript and is checked into the repository as compiled JavaScript files.
To make changes to the runtime, you need to edit the TypeScript files and regenerate the JavaScript files by running:

```bash
make regenerate_swiftpm_resources
```

### Working with BridgeJS

BridgeJS is a Swift Package Manager plugin that automatically generates Swift bindings from TypeScript definitions. This repository contains pre-generated files created by BridgeJS in AoT (Ahead of Time) mode that are checked into version control.

To update these pre-generated files, use the utility script:

```bash
./Utilities/bridge-js-generate.sh
```

This script runs the BridgeJS plugin in AoT mode (`swift package bridge-js`) on several SwiftPM packages in this repository.

Run this script when you've made changes to:
- TypeScript definitions
- BridgeJS configuration
- BridgeJS code generator itself

These changes require updating the pre-generated Swift bindings committed to the repository.

**Adding new BridgeJS intrinsics:**

If you add new `@_extern(wasm, module: "bjs")` functions to [`BridgeJSIntrinsics.swift`](Sources/JavaScriptKit/BridgeJSIntrinsics.swift), also add corresponding stub entries to [`Plugins/PackageToJS/Templates/instantiate.js`](Plugins/PackageToJS/Templates/instantiate.js) in the `importObject["bjs"]` object. This allows packages without BridgeJS-generated code to instantiate successfully.

## Support
If you have any questions or need assistance, feel free to reach out via [GitHub Issues](https://github.com/swiftwasm/JavaScriptKit/issues) or [Discord](https://discord.gg/ashJW8T8yp).
