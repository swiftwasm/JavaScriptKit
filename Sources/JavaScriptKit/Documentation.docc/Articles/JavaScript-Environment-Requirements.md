# JavaScript Environment Requirements

Understand the JavaScript features required by JavaScriptKit and ensure your target environment supports them.

## Required JavaScript Features

The JavaScript package produced by the JavaScriptKit packaging plugin requires the following JavaScript features:

- [`FinalizationRegistry`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/FinalizationRegistry#browser_compatibility)
- [WebAssembly BigInt to i64 conversion in JS API](https://caniuse.com/wasm-bigint)

## Browser Compatibility

These JavaScript features are supported in the following browsers:

- Chrome 85+ (August 2020)
- Firefox 79+ (July 2020)
- Desktop Safari 14.1+ (April 2021)
- Mobile Safari 14.5+ (April 2021)
- Edge 85+ (August 2020)
- Node.js 15.0+ (October 2020)

Older browsers will not be able to run applications built with JavaScriptKit unless polyfills are provided.

## Handling Missing Features

### FinalizationRegistry

When using JavaScriptKit in environments without `FinalizationRegistry` support, you can:

1. Build with the opt-out flag: `-Xswiftc -DJAVASCRIPTKIT_WITHOUT_WEAKREFS`
2. Then manually manage memory by calling `release()` on all `JSClosure` instances:

```swift
let closure = JSClosure { args in
    // Your code here
    return .undefined
}

// Use the closure...

// Then release it when done
#if JAVASCRIPTKIT_WITHOUT_WEAKREFS
closure.release()
#endif
```

### WebAssembly BigInt Support

If you need to work with 64-bit integers in JavaScript, ensure your target environment supports WebAssembly BigInt conversions. For environments that don't support this feature, you'll need to avoid importing `JavaScriptBigIntSupport`
