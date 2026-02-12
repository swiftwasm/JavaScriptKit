# Generating bindings from TypeScript

How to generate macro-annotated Swift bindings from a TypeScript declaration file (`bridge-js.d.ts`) so you don't have to write the Swift by hand.

## Overview

The BridgeJS plugin can read a `bridge-js.d.ts` file in your target and generate Swift code that uses the same macros as hand-written bindings (see <doc:Importing-JavaScript-into-Swift>).

The output is macro-annotated Swift; you can inspect the generated file at the following path to see exactly what was produced:

```
./build/plugins/outputs/<your package>/<target>/destination/BridgeJS/BridgeJS.Macros.swift
```

Use this workflow when you have existing TypeScript definitions or many APIs to bind.

> Important: This feature is still experimental. No API stability is guaranteed, and the API may change in future releases.

> Tip: You can quickly preview what interfaces will be exposed on the Swift/JavaScript/TypeScript sides using the [BridgeJS Playground](https://swiftwasm.org/JavaScriptKit/PlayBridgeJS/).

## How to generate bindings from TypeScript

### Step 1: Configure your package

Add the BridgeJS plugin and enable the Extern feature as described in <doc:Setting-up-BridgeJS>.

### Step 2: Create TypeScript definitions

Create a file named `bridge-js.d.ts` in your target source directory (e.g. `Sources/<target-name>/bridge-js.d.ts`). Declare the JavaScript APIs you want to use in Swift:

```typescript
export function consoleLog(message: string): void;
```

### Step 3: Build your package

Run:

```bash
swift package --swift-sdk $SWIFT_SDK_ID js
```

The plugin processes `bridge-js.d.ts`, generates Swift bindings (using the same macros as in <doc:Importing-JavaScript-into-Swift>), compiles to WebAssembly, and produces JavaScript glue in `.build/plugins/PackageToJS/outputs/`.

> Note: For larger projects, see <doc:Ahead-of-Time-Code-Generation>.

## Declaration mappings

### Functions

Each exported function becomes a top-level Swift function with `@JSFunction` and `throws(JSException)`.

@Row {
  @Column {
    ```typescript
    // TypeScript (bridge-js.d.ts)

    /** Returns the sum of two numbers. */
    export function sum(a: number, b: number): number;
    /**
     * Sets the document title.
     * @param title - The new title string
     */
    export function setDocumentTitle(title: string): void;
    ```
  }
  @Column {
    ```swift
    // Generated Swift

    /// Returns the sum of two numbers.
    @JSFunction func sum(a: Double, b: Double) throws(JSException) -> Double


    /// Sets the document title.
    /// - Parameter title: The new title string
    @JSFunction func setDocumentTitle(title: String) throws(JSException)
    ```
  }
}

### Global getters

Module-level `declare const` or top-level readonly bindings that reference a bridged type become a Swift global property with `@JSGetter`.

@Row {
  @Column {
    ```typescript
    // TypeScript (bridge-js.d.ts)
    /** [MDN Reference](https://developer.mozilla.org/docs/Web/API/Document) */
    export const document: Document;
    ```
  }
  @Column {
    ```swift
    // Generated Swift
    /// [MDN Reference](https://developer.mozilla.org/docs/Web/API/Document)
    @JSGetter var document: Document
    ```
  }
}

### Classes

A class becomes a Swift struct with `@JSClass`. The constructor becomes `init(...)` with `@JSFunction`. Properties become `@JSGetter`; writable properties also get `@JSSetter` as `set<Name>(_:)`. Methods become `@JSFunction`. Static methods become `static func` on the struct. All thunks throw `JSException` if the underlying JavaScript throws.

@Row {
  @Column {
    ```typescript
    // TypeScript (bridge-js.d.ts)
    export class Greeter {
        /** A readonly field is translated with `@JSGetter` */
        readonly id: number;

        /** A read-writable field is translated with `@JSGetter` and `@JSSetter` */
        message: string;

        /** A constructor */
        constructor(id: string, name: string);
        /** A method */
        greet(): string;
        /** A static method */
        static createDefault(greetingId: number, locale: string): string;
    }
    ```
  }
  @Column {
    ```swift
    // Generated Swift
    @JSClass struct Greeter {
        /// A readonly field is translated with `@JSGetter`
        @JSGetter var id: Double

        /// A read-writable field is translated with `@JSGetter` and `@JSSetter`
        @JSGetter var message: String
        @JSSetter func setMessage(_ newValue: String) throws(JSException)

        /// A constructor
        @JSFunction init(id: String, name: String) throws(JSException)
        /// A method
        @JSFunction func greet() throws(JSException) -> String
        @JSFunction static func createDefault(_ greetingId: Double, _ locale: String) throws(JSException) -> String
    }
    ```
  }
}

### Interfaces

An interface becomes a Swift struct with `@JSClass`. No constructor. Properties and methods are bridged the same way as for classes (`@JSGetter`, `@JSSetter`, `@JSFunction`). Instances are obtained from other calls (e.g. a function that returns the interface type).

@Row {
  @Column {
    ```typescript
    // TypeScript (bridge-js.d.ts)
    export interface HTMLElement {
      readonly innerText: string;
      className: string;

      appendChild(child: HTMLElement): void;
    }
    ```
  }
  @Column {
    ```swift
    // Generated Swift
    @JSClass struct HTMLElement {
        @JSGetter var innerText: String
        @JSGetter var className: String
        @JSSetter func setClassName(_ newValue: String) throws(JSException)
        @JSFunction func appendChild(_ child: HTMLElement) throws(JSException)
    }
    ```
  }
}

### Type aliases

Type aliases are resolved when generating Swift; the resolved shape is emitted, not a separate alias type.

- **Primitive alias** (e.g. `type UserId = string`): Replaced by the underlying Swift type (e.g. `String`) everywhere it is used.
- **Object-shaped alias** (e.g. `type User = { id: string; name: string }`): The generator emits a named Swift struct with that name and the corresponding `@JSClass` / getters / setters. No constructor; use is the same as for interfaces.

@Row {
  @Column {
    ```typescript
    // TypeScript (bridge-js.d.ts)
    export type UserId = string;
    export type User = {
      readonly id: UserId;
      name: string;
    };
    export function getUser(): User;
    ```
  }
  @Column {
    ```swift
    // Generated Swift (UserId inlined as String)
    @JSClass struct User {
        @JSGetter var id: String
        @JSGetter var name: String
        @JSSetter func setName(_ newValue: String) throws(JSException)
    }
    @JSFunction func getUser() throws(JSException) -> User
    ```
  }
}

### String enums

TypeScript enums with string literal values become Swift enums with `String` raw value and the appropriate BridgeJS protocol conformances. Usable as parameter and return types.

@Row {
  @Column {
    ```typescript
    // TypeScript (bridge-js.d.ts)
    export enum Theme {
        light = "light",
        dark = "dark",
    }


    export function setTheme(theme: Theme): void;
    export function getTheme(): Theme;
    ```
  }
  @Column {
    ```swift
    // Generated Swift
    enum Theme: String {
        case light = "light"
        case dark = "dark"
    }
    extension Theme: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {}

    @JSFunction func setTheme(_ theme: Theme) throws(JSException) -> Void
    @JSFunction func getTheme() throws(JSException) -> Theme
    ```
  }
}

## Type mappings

The following mappings apply to function parameters, return types, and class/interface properties.

### Primitives

| TypeScript | Swift |
|------------|-------|
| `number`   | `Double` |
| `string`   | `String` |
| `boolean`  | `Bool` |

These appear in the function and class examples above.

### Arrays

`T[]` and `Array<T>` → `[T]`.

@Row {
  @Column {
    ```typescript
    // TypeScript (bridge-js.d.ts)
    export function sumAll(values: number[]): number;
    export function getScores(): number[];
    export function getLabels(): string[];
    export function normalize(values: Array<number>): Array<number>;
    ```
  }
  @Column {
    ```swift
    // Generated Swift
    @JSFunction func sumAll(_ values: [Double]) throws(JSException) -> Double
    @JSFunction func getScores() throws(JSException) -> [Double]
    @JSFunction func getLabels() throws(JSException) -> [String]
    @JSFunction func normalize(_ values: [Double]) throws(JSException) -> [Double]
    ```
  }
}

### Optional and undefined

- **`T | null`** → Swift `Optional<T>` (e.g. `Optional<Double>`, `Optional<String>`, `Optional<SomeInterface>`).
- **`T | undefined`** or optional parameters → Swift `JSUndefinedOr<T>`.

@Row {
  @Column {
    ```typescript
    // TypeScript (bridge-js.d.ts)
    export function parseCount(value: number | null): number | null;
    export function parseLimit(value: number | undefined): number | undefined;
    export function scale(factor: number, offset: number | null): number;

    export interface Payload {}
    export class RequestOptions {
        body: Payload | null;

        headers: Payload | undefined;

    }
    ```
  }
  @Column {
    ```swift
    // Generated Swift
    @JSFunction func parseCount(_ value: Optional<Double>) throws(JSException) -> Optional<Double>
    @JSFunction func parseLimit(_ value: JSUndefinedOr<Double>) throws(JSException) -> JSUndefinedOr<Double>
    @JSFunction func scale(_ factor: Double, _ offset: Optional<Double>) throws(JSException) -> Double

    @JSClass struct Payload {}
    @JSClass struct RequestOptions {
        @JSGetter var body: Optional<Payload>
        @JSSetter func setBody(_ value: Optional<Payload>) throws(JSException)
        @JSGetter var headers: JSUndefinedOr<Payload>
        @JSSetter func setHeaders(_ value: JSUndefinedOr<Payload>) throws(JSException)
    }
    ```
  }
}

### Records (dictionaries)

`Record<string, V>` → Swift `[String: V]`. Supported value types: primitives, arrays, nested records, optional object types. Keys other than `string` (e.g. `Record<number, string>`) are unsupported; such parameters become `JSObject`.

@Row {
  @Column {
    ```typescript
    // TypeScript (bridge-js.d.ts)
    export function applyScores(scores: Record<string, number>): void;
    export function getMetadata(): Record<string, string>;
    export function getMatrix(value: Record<string, Record<string, number>>): Record<string, Record<string, number>>;
    export function getSeries(values: Record<string, number[]>): Record<string, number[]>;
    export function lookupByIndex(values: Record<number, string>): void;
    ```
  }
  @Column {
    ```swift
    // Generated Swift
    @JSFunction func applyScores(_ scores: [String: Double]) throws(JSException) -> Void
    @JSFunction func getMetadata() throws(JSException) -> [String: String]
    @JSFunction func getMatrix(_ value: [String: [String: Double]]) throws(JSException) -> [String: [String: Double]]
    @JSFunction func getSeries(_ values: [String: [Double]]) throws(JSException) -> [String: [Double]]
    @JSFunction func lookupByIndex(_ values: JSObject) throws(JSException) -> Void
    ```
  }
}

### Unbridged types (JSValue, JSObject)

Types that cannot be expressed in the bridge (e.g. `any`, unsupported generics, or `Record<number, string>`) are emitted as `JSValue` or `JSObject`.

@Row {
  @Column {
    ```typescript
    // TypeScript (bridge-js.d.ts)
    interface Animatable {
        animate(keyframes: any, options: any): any;
    }
    export function getAnimatable(): Animatable;
    ```
  }
  @Column {
    ```swift
    // Generated Swift
    @JSClass struct Animatable {
        @JSFunction func animate(_ keyframes: JSValue, _ options: JSValue) throws(JSException) -> JSValue
    }
    @JSFunction func getAnimatable() throws(JSException) -> Animatable
    ```
  }
}

## Name mapping

### Invalid or special property and type names

When a TypeScript name is not a valid Swift identifier (e.g. contains dashes, spaces, or starts with a number), or is a Swift keyword, the generator emits a Swift-safe name and uses `jsName` so the JavaScript binding remains correct. Classes whose names start with `$` are prefixed with `_` in Swift and get `@JSClass(jsName: "...")`.

@Row {
  @Column {
    ```typescript
    // TypeScript (bridge-js.d.ts)
    interface DOMTokenList {
        "data-attrib": number;

        "0": boolean;

        for: string;

        as(): void;
    }
    export class $jQuery {
        "call-plugin"(): void;
    }
    ```
  }
  @Column {
    ```swift
    // Generated Swift
    @JSClass struct DOMTokenList {
        @JSGetter(jsName: "data-attrib") var data_attrib: Double
        @JSSetter(jsName: "data-attrib") func setData_attrib(_ value: Double) throws(JSException)
        @JSGetter(jsName: "0") var _0: Bool
        @JSSetter(jsName: "0") func set_0(_ value: Bool) throws(JSException)
        @JSGetter var `for`: String
        @JSSetter func setFor(_ value: String) throws(JSException)
        @JSFunction func `as`() throws(JSException) -> Void
    }
    @JSClass(jsName: "$jQuery") struct _jQuery {
        @JSFunction(jsName: "call-plugin") func call_plugin() throws(JSException) -> Void
    }
    ```
  }
}

## Limitations

- No first-class support for async/Promise-returning functions;.
- No generic type parameter can appear on a bridged function signature.