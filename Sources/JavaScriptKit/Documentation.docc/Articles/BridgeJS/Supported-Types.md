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

A generic type parameter constrained to `BridgedSwiftGenericBridgeable` is supported as a parameter or result type in both directions: an imported `@JSFunction` (see <doc:Importing-JS-Function>) and an exported `@JS` function (see <doc:Exporting-Swift-Function>). The types that satisfy that constraint are:

- `Bool`, `Float`, `Double`, `String`, and `JSValue`
- every fixed-width integer: `Int`, `UInt`, `Int8`/`Int16`/`Int32`/`Int64`, and `UInt8`/`UInt16`/`UInt32`/`UInt64`
- any `@JS` struct, `final @JS class`, or `@JS enum` (case, raw-value, or associated-value) defined in the same module as the generic function

You do not write the conformance by hand: marking a type `@JS` (or using a built-in primitive) is what makes it usable as the generic argument.

The generic parameter may be used bare (`T`) or wrapped in `[T]`, `T?`, or `[String: T]`. Other or nested wrappings (for example `[T?]`, `[[T]]`, or `[Int: T]`) are not supported. `JSObject` cannot be used as the generic argument; use `JSValue` instead.

## See Also

- <doc:Generating-from-TypeScript>
