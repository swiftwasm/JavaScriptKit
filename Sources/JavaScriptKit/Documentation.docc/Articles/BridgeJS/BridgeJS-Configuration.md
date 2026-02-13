# BridgeJS Configuration

Configure BridgeJS behavior using bridge-js.config.json and bridge-js.config.local.json files.

## Overview

> Important: This feature is still experimental. No API stability is guaranteed, and the API may change in future releases.

BridgeJS supports configuration through JSON configuration files that allow you to customize various aspects of the build process and tool behavior.

The configuration system supports two complementary files:
- `bridge-js.config.json` - Base configuration (checked into version control)
- `bridge-js.config.local.json` - Local overrides (intended to be ignored by git, for developer-specific settings)

## Configuration Loading

### File Locations

Configuration files should be placed in your Swift package target directory, typically alongside your `bridge-js.d.ts` file:

```
Sources/
  YourTarget/
    bridge-js.d.ts
    bridge-js.config.json          # Base config (commit to git)
    bridge-js.config.local.json    # Local config (add to .gitignore)
    main.swift
```

### Loading Order

BridgeJS loads and merges configuration files in the following order:

1. **`bridge-js.config.json`** - Base configuration
2. **`bridge-js.config.local.json`** - Local overrides

Later files override settings from earlier files. This allows teams to commit a base configuration while allowing individual developers to customize their local environment.

## Configuration Options

### `exposeToGlobal`

Controls whether exported Swift APIs are exposed to the JavaScript global namespace (`globalThis`).

When `true`, exported functions, classes, and namespaces are available via `globalThis` in JavaScript. When `false`, they are only available through the exports object returned by `createExports()`.
Using Exports provides better module isolation and support multiple WebAssembly instances in the same JavaScript context.

Example:

```json
{
  "exposeToGlobal": true
}
```

**With `exposeToGlobal: true`:**

```javascript
// APIs available on globalThis
const greeter = new globalThis.MyModule.Greeter("World");
console.log(greeter.greet()); // "Hello, World!"

// Also available via exports
const greeter2 = new exports.MyModule.Greeter("Alice");
```

**With `exposeToGlobal: false` (default):**

```javascript
// APIs only available via exports
const greeter = new exports.MyModule.Greeter("World");

// globalThis.MyModule is undefined
```

### `tools`

Specify custom paths for external executables. This is particularly useful when working in environments like Xcode where the system PATH may not be inherited, or when you need to use a specific version of tools for your project.

Currently supported tools:

- `node` - Node.js runtime (required for TypeScript processing)

Example:

```json
{
  "tools": {
    "node": "/usr/local/bin/node"
  }
}
```

BridgeJS resolves tool paths in the following priority order:

1. **Configuration files** (`bridge-js.config.local.json` > `bridge-js.config.json`)
2. **Environment variables** (`JAVASCRIPTKIT_NODE_EXEC`)
3. **System PATH lookup**
