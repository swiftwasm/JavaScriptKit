# Profiling Performance Issues

Profile your Swift applications running on JavaScript environment to identify performance bottlenecks using Chrome DevTools and other profiling tools.

## Overview

Profiling helps you understand where your application spends time. This guide covers tools and techniques for profiling Swift applications running on JavaScript environment, focusing on performance profiling. For memory profiling, see <doc:Profiling-Memory-Usage>.

## Chrome DevTools Performance Tab

Chrome DevTools provides a built-in Performance profiler that can help you identify performance bottlenecks in your WebAssembly application. See [Chrome DevTools documentation on performance profiling](https://developer.chrome.com/docs/devtools/performance) for detailed instructions.

![Chrome DevTools Performance Tab](chrome-devtools-perf.png)

> Note: WebAssembly function names may appear mangled in the performance timeline. You can use `swift demangle` to decode them, or use the enhanced DWARF extension mentioned in <doc:Debugging> for better symbol resolution.

### V8 Compilation Pipeline Considerations

When DevTools is open, V8's WebAssembly compilation pipeline behaves differently:

- **With DevTools open**: V8 replaces optimized TurboFan code with unoptimized Liftoff code for debugging purposes. This means performance measurements taken while DevTools is open will not reflect actual production performance.

- **With Performance tab recording**: When you click the "Record" button in the Performance tab, code gets recompiled with TurboFan again for profiling. However, the initial tier-down to Liftoff when DevTools opens can still affect measurements.

> Important: Do not measure FPS or performance metrics while DevTools is open, as the results will not be representative of actual production performance. Close DevTools before taking performance measurements, or use the Performance tab's recording feature which recompiles code appropriately for profiling.

See [V8's WebAssembly compilation pipeline documentation](https://v8.dev/docs/wasm-compilation-pipeline#debugging) for more details.

## Performance Best Practices

### Build Configuration

For profiling, use a release build with debug information. You have two options:

**DWARF mode** (recommended for easier symbol resolution):

```bash
swift package --swift-sdk $SWIFT_SDK_ID js -c release --debug-info-format dwarf
```

DWARF mode preserves DWARF structures, which may disable some wasm-opt optimizations. This can result in performance characteristics that differ from actual release builds. However, the DevTools extension can automatically demangle function names, making results easier to read.

**Name section mode** (recommended for accurate performance characteristics):

```bash
swift package --swift-sdk $SWIFT_SDK_ID js -c release --debug-info-format name
```

Name section mode uses WebAssembly's [name section](https://webassembly.github.io/spec/core/appendix/custom.html#name-section) and applies the same optimizations as regular release builds, providing more accurate performance characteristics. However, you'll need to manually demangle function names using `swift demangle` when analyzing results.

> Note: The limitation of name section mode requiring manual demangling may be alleviated in the future through improvements to the DevTools extension.
