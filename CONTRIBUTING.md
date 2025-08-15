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

2. Install **OSS** Swift toolchain (not the one from Xcode):
    <details>
    <summary>For macOS users</summary>

    ```bash
    (
        SWIFT_TOOLCHAIN_CHANNEL=swift-6.0.2-release;
        SWIFT_TOOLCHAIN_TAG="swift-6.0.2-RELEASE";
        SWIFT_SDK_TAG="swift-wasm-6.0.2-RELEASE";
        SWIFT_SDK_CHECKSUM="6ffedb055cb9956395d9f435d03d53ebe9f6a8d45106b979d1b7f53358e1dcb4";
        pkg="$(mktemp -d)/InstallMe.pkg"; set -ex;
        curl -o "$pkg" "https://download.swift.org/$SWIFT_TOOLCHAIN_CHANNEL/xcode/$SWIFT_TOOLCHAIN_TAG/$SWIFT_TOOLCHAIN_TAG-osx.pkg";
        installer -pkg "$pkg" -target CurrentUserHomeDirectory;
        export TOOLCHAINS="$(plutil -extract CFBundleIdentifier raw ~/Library/Developer/Toolchains/$SWIFT_TOOLCHAIN_TAG.xctoolchain/Info.plist)";
        swift sdk install "https://github.com/swiftwasm/swift/releases/download/$SWIFT_SDK_TAG/$SWIFT_SDK_TAG-wasm32-unknown-wasi.artifactbundle.zip" --checksum "$SWIFT_SDK_CHECKSUM";
    )
    ```

    </details>

    <details>
    <summary>For Linux users</summary>
    Install Swift 6.0.2 by following the instructions on the <a href="https://www.swift.org/install/linux/tarball/">official Swift website</a>.

    ```bash
    (
        SWIFT_SDK_TAG="swift-wasm-6.0.2-RELEASE";
        SWIFT_SDK_CHECKSUM="6ffedb055cb9956395d9f435d03d53ebe9f6a8d45106b979d1b7f53358e1dcb4";
        swift sdk install "https://github.com/swiftwasm/swift/releases/download/$SWIFT_SDK_TAG/$SWIFT_SDK_TAG-wasm32-unknown-wasi.artifactbundle.zip" --checksum "$SWIFT_SDK_CHECKSUM";
    )
    ```

    </details>

3. Install dependencies:
   ```bash
   make bootstrap
   ```

### Running Tests

Unit tests running on WebAssembly:

```bash
make unittest SWIFT_SDK_ID=wasm32-unknown-wasi
```

Tests for `PackageToJS` plugin:

```bash
swift test --package-path ./Plugins/PackageToJS
```

Tests for `BridgeJS` plugin:

```bash
swift test --package-path ./Plugins/BridgeJS
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

## Support
If you have any questions or need assistance, feel free to reach out via [GitHub Issues](https://github.com/swiftwasm/JavaScriptKit/issues) or [Discord](https://discord.gg/ashJW8T8yp).
