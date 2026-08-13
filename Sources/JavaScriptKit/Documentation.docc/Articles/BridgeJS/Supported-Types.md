# Supported Types

Swift types and their JavaScript/TypeScript equivalents at the BridgeJS boundary.

## Swift and JavaScript type mapping

| Swift type | JavaScript | TypeScript |
|:--|:--|:--|
| `Int`, `UInt`, `Double`, `Float` | number | `number` |
| `String` | string | `string` |
| `Bool` | boolean | `boolean` |
| `Void` | - | `void` |
| `[T]` | array | `T[]` |
| `[String: T]` | object | `Record<string, T>` |
| `Optional<T>` | `null` or `T` | `T \| null` |
| ``JSUndefinedOr`` `<T>` | `undefined` or `T` | `T \| undefined` |
| ``JSObject`` | object | `object` |
| ``JSValue`` | any | `any` |
| ``JSTypedArray`` `<T>` | TypedArray | `Uint8Array`, `Float32Array`, etc. |

### TypedArray mapping

When using `JSTypedArray<T>` (or convenience typealiases) in `@JS` signatures, the TypeScript type maps to the corresponding JavaScript TypedArray:

| Swift | TypeScript |
|:--|:--|
| `JSTypedArray<UInt8>` / `JSUint8Array` | `Uint8Array` |
| `JSTypedArray<Int32>` / `JSInt32Array` | `Int32Array` |
| `JSTypedArray<Float>` / `JSFloat32Array` | `Float32Array` |
| `JSTypedArray<Double>` / `JSFloat64Array` | `Float64Array` |

See <doc:Exporting-Swift-Array> for usage details.

## Generic type parameters

An imported `@JSFunction` can be generic over a type parameter constrained to `BridgedSwiftGenericBridgeable` (see <doc:Importing-JS-Function>); exported `@JS` functions cannot yet. The constraint is satisfied by all supported primitives, `String`, `JSValue`, and any `@JS` struct, `@JS` enum, or `final @JS class`, including ones from another linked module. Do not write the conformance by hand; marking the type `@JS` is what provides it, together with the JavaScript side of the bridge.

## See Also

- <doc:Generating-from-TypeScript>
