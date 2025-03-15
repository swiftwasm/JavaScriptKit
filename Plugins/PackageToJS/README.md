# PackageToJS

A Swift Package Manager plugin that facilitates building and packaging Swift WebAssembly applications for JavaScript environments.

## Overview

PackageToJS is a command plugin for Swift Package Manager that simplifies the process of compiling Swift code to WebAssembly and generating the necessary JavaScript bindings. It's an essential tool for SwiftWasm projects, especially those using JavaScriptKit to interact with JavaScript from Swift.

## Features

- Build Swift packages for WebAssembly targets
- Generate JavaScript wrapper code for Swift WebAssembly modules
- Support for testing Swift WebAssembly code
- Diagnostic helpers for common build issues
- Options for optimization and debug information management

## Requirements

- Swift 6.0 or later
- A compatible WebAssembly SDK

## Internal Architecture

PackageToJS consists of several components:
- `PackageToJSPlugin.swift`: Main entry point for the Swift Package Manager plugin (Note that this file is not included when running unit tests for the plugin)
- `PackageToJS.swift`: Core functionality for building and packaging
- `MiniMake.swift`: Build system utilities
- `ParseWasm.swift`: WebAssembly binary parsing
- `Preprocess.swift`: Preprocessor for `./Templates` files

## Internal Testing

To run the unit tests for the `PackageToJS` plugin, use the following command:

```bash
swift test --package-path ./Plugins/PackageToJS
```

Please define the following environment variables when you want to run E2E tests:

- `SWIFT_SDK_ID`: Specifies the Swift SDK identifier to use
- `SWIFT_PATH`: Specifies the `bin` path to the Swift toolchain to use

