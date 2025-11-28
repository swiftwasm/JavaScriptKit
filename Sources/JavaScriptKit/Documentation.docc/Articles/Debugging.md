# Debugging

Debug your Swift applications running on JavaScript environment using DWARF-based debugging tools, including Chrome DevTools extensions and command-line debuggers.

## Overview

These debugging tools are DWARF-based, so you need to build your application with DWARF sections enabled.

Build your application with debug configuration using:

```bash
swift package --swift-sdk $SWIFT_SDK_ID js -c debug
```

Alternatively, you can omit the `-c debug` flag since the `js` plugin builds with debug configuration by default:

```bash
swift package --swift-sdk $SWIFT_SDK_ID js
```

## Chrome DevTools

When debugging a web browser application, Chrome DevTools provides a powerful debugging environment. It allows you to set breakpoints and step through your Swift source code at the source level.

There are two DWARF extensions available for Chrome DevTools: an enhanced extension specifically designed for Swift, and the official C/C++ extension. For Swift development, the enhanced extension is recommended.

> Important: The two extensions cannot coexist. You must use only one extension at a time.

### Enhanced DWARF Extension for Swift

For the best Swift debugging experience, use the enhanced DWARF extension that provides:

- Breakpoint setting and Swift code inspection
- Human-readable call stack frames
- Swift variable value inspection

![Chrome DevTools with Swift support](chrome-devtools-swift.png)

To install this enhanced extension:

1. If you have the official "C/C++ DevTools Support (DWARF)" extension installed, uninstall it first
2. Download the extension ZIP file from [GitHub Releases](https://github.com/GoodNotes/devtools-frontend/releases/tag/swift-0.2.3.0)
3. Go to `chrome://extensions/` and enable "Developer mode"
4. Drag and drop the downloaded ZIP file into the page

When you close and reopen the DevTools window, DevTools will suggest reloading itself to apply settings.

> Note: There is a known issue where some JavaScriptKit types like `JSObject` and `JSValue` are not shown in pretty format in the variables view.

### Official DWARF Extension

Alternatively, you can use the official [`C/C++ DevTools Support (DWARF)`](https://goo.gle/wasm-debugging-extension) extension. However, it has limitations for Swift development:

- Function names in the stack trace are mangled (you can demangle them using `swift demangle` command)
- Variable inspection is unavailable since Swift depends on its own mechanisms instead of DWARF's structure type feature

![Chrome DevTools](chrome-devtools.png)

See [the DevTools team's official introduction](https://developer.chrome.com/blog/wasm-debugging-2020) for more details about the extension.
