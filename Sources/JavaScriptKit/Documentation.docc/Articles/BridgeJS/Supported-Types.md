# TypeScript and Swift Type Mapping

Use this page as a quick reference for how common TypeScript types appear in Swift when importing, and how exported Swift types surface on the TypeScript side.

## Type mapping

| TypeScript type | Swift type |
|:--|:--|
| `number` | `Double` |
| `string` | `String` |
| `boolean` | `Bool` |
| `T[]` | `[T]` |
| TODO | `Dictionary<K, V>` |
| `T \| undefined` | TODO |
| `T \| null` | `Optional<T>` |
| `Promise<T>` | `JSPromise` |
| `any` / `unknown` / `object` | `JSObject` |
| Other types | `JSObject` |
