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

## See Also

- <doc:Generating-from-TypeScript>
