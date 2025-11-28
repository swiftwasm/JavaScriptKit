# Profiling Memory Usage

Profile memory usage of your Swift applications running on JavaScript environment to identify memory leaks and understand memory allocation patterns.

## Overview

Memory profiling helps you understand how your application uses memory, identify memory leaks, and optimize memory allocation patterns. This guide covers tools and techniques for profiling memory usage in Swift applications running on JavaScript environment.

When profiling memory usage, start with JavaScript execution environment's heap profiler. If `WebAssembly.Memory` objects are the bottleneck, use specialized WebAssembly memory profilers that understand the Wasm instance's memory allocator.

## Chrome DevTools Heap Snapshots

Start by using Chrome DevTools' built-in heap profiler to understand overall memory usage in your application. See [Chrome DevTools documentation on heap snapshots](https://developer.chrome.com/docs/devtools/memory-problems/heap-snapshots) for detailed instructions.

## wasm-memprof

If `WebAssembly.Memory` objects are the bottleneck, JavaScript engine's default profiler typically doesn't track allocations within WebAssembly's memory space, so you won't get good insights. In such cases, use a profiler like [wasm-memprof](https://github.com/kateinoigakukun/wasm-memprof) that understands the Wasm instance's memory allocator.

wasm-memprof is a heap profiler specifically designed for WebAssembly applications. It provides detailed memory allocation tracking with Swift symbol demangling support, helping you identify memory leaks and understand memory usage patterns within WebAssembly's linear memory.

![wasm-memprof visualization](https://raw.githubusercontent.com/kateinoigakukun/wasm-memprof/main/docs/demo.png)

### Setup

Add wasm-memprof to your application before instantiating your Wasm program:

```javascript
import { WMProf } from "wasm-memprof";
import { SwiftDemangler } from "wasm-memprof/plugins/swift-demangler.js";

const swiftDemangler = SwiftDemangler.create();
globalThis.WebAssembly = WMProf.wrap(globalThis.WebAssembly, {
  demangler: swiftDemangler.demangle.bind(swiftDemangler),
});
```

Check the [wasm-memprof repository](https://github.com/kateinoigakukun/wasm-memprof) for detailed documentation and examples.
