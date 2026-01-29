# BridgeJS calling convention

This document explains the calling convention for function calls crossing the JS and Swift boundaries.

This document focuses sync calling convention. Async calling convention can be easily derived from it.

## Calling Swift function from JS

Basic flow is:
1. Lower each parameter P into LoweredRepr (`i32 | i64 | f32 | f64 | Tuple[LoweredRepr..] | Variadic`)

## FAQ

### Why not just adopt [Canonical ABI](https://github.com/WebAssembly/component-model/blob/main/design/mvp/CanonicalABI.md)?

- We don't need language agnostic-y
  - They are paying lots of cost (complexity, performance efficiency)
- We leverage the advantage of knowing both side languages