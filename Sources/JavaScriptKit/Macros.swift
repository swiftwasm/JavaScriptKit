/// Controls how Swift enums annotated with `@JS` are emitted to TypeScript.
/// - `const`: Emit the current BridgeJS style: a `const` object with literal members plus a type alias.
/// - `tsEnum`: Emit a TypeScript `enum` declaration (only valid for simple enums and raw-value enums with String or numeric raw types).
public enum JSEnumStyle: String {
    case const
    case tsEnum
}

/// A macro that exposes Swift functions, classes, and methods to JavaScript.
///
/// Apply this macro to Swift declarations that you want to make callable from JavaScript:
///
/// ```swift
/// // Export a function to JavaScript
/// @JS public func greet(name: String) -> String {
///     return "Hello, \(name)!"
/// }
///
/// // Export a class and its members
/// @JS class Counter {
///     private var count = 0
///
///     @JS init() {}
///
///     @JS func increment() {
///         count += 1
///     }
///
///     @JS func getValue() -> Int {
///         return count
///     }
/// }
/// ```
///
/// If you prefer to access through namespace-based syntax, you can use `namespace` parameter
///
/// Example:
///
/// ```swift
/// // Export a function to JavaScript with a custom namespace
/// @JS(namespace: "__Swift.Foundation.UUID") public func create() -> String {
///     UUID().uuidString
/// }
///
/// // Export a class with a custom namespace (note that only top level macro needs to specify the namespace)
/// @JS(namespace: "Utils.Greeters") class Greeter {
///     var name: String
///
///     @JS init(name: String) {
///         self.name = name
///     }
///
///     @JS func greet() -> String {
///         return "Hello, " + self.name + "!"
///     }
///
///     @JS func changeName(name: String) {
///         self.name = name
///     }
/// }
/// ```
/// And the corresponding TypeScript declaration will be generated as:
/// ```javascript
/// declare global {
///     namespace Utils {
///         namespace Greeters {
///             class Greeter {
///                 constructor(name: string);
///                 greet(): string;
///                 changeName(name: string): void;
///             }
///         }
///     }
///     namespace __Swift {
///         namespace Foundation {
///             namespace UUID {
///                 function create(): string;
///             }
///         }
///     }
/// }
/// ```
/// The above Swift class will be accessible in JavaScript as:
/// ```javascript
/// const greeter = new globalThis.Utils.Greeters.Greeter("World");
/// console.log(greeter.greet()); // "Hello, World!"
/// greeter.changeName("JavaScript");
/// console.log(greeter.greet()); // "Hello, JavaScript!"
///
/// const uuid = new globalThis.__Swift.Foundation.UUID.create(); // "1A83F0E0-F7F2-4FD1-8873-01A68CF79AF4"
/// ```
///
/// When you build your project with the BridgeJS plugin, these declarations will be
/// accessible from JavaScript, and TypeScript declaration files (`.d.ts`) will be
/// automatically generated to provide type safety.
///
/// For detailed usage information, see the article <doc:Exporting-Swift-to-JavaScript>.
///
/// - Parameter namespace: A dot-separated string that defines the namespace hierarchy in JavaScript.
///                        Each segment becomes a nested object in the resulting JavaScript structure.
/// - Parameter enumStyle: Controls how enums are emitted to TypeScript for this declaration:
///                        use `.const` (default) to emit a const object + type alias,
///                        or `.tsEnum` to emit a TypeScript `enum`.
///                        `.tsEnum` is supported for case enums and raw-value enums with String or numeric raw types.
///                        Bool raw-value enums are not supported with `.tsEnum` and will produce an error.
///
/// - Important: This feature is still experimental. No API stability is guaranteed, and the API may change in future releases.
@attached(peer)
public macro JS(namespace: String? = nil, enumStyle: JSEnumStyle = .const) = Builtin.ExternalMacro

/// A macro that generates a Swift getter that reads a value from JavaScript.
///
/// This macro is used by BridgeJS-generated Swift declarations.
///
/// - Parameter jsName: An optional string that specifies the name of the JavaScript property to read from.
///   If not provided, the Swift property name is used.
///
/// Example:
///
/// ```swift
/// @_spi(Experimental) import JavaScriptKit
///
/// @JSGetter var count: Int
///
/// struct Greeter {
///     @JSGetter var name: String
/// }
/// ```
@attached(accessor)
@_spi(Experimental)
public macro JSGetter(jsName: String? = nil) =
    #externalMacro(module: "BridgeJSMacros", type: "JSGetterMacro")

/// A macro that generates a Swift function body that writes a value to JavaScript.
///
/// This macro is used by BridgeJS-generated Swift declarations.
///
/// - Parameter jsName: An optional string that specifies the name of the JavaScript property to write to.
///   If not provided, automatically derived from the Swift property name. (e.g. "setName" -> "name")
///
/// Example:
///
/// ```swift
/// @_spi(Experimental) import JavaScriptKit
///
/// @JSSetter func setName(_ value: String) throws (JSException)
/// ```
@attached(body)
@_spi(Experimental)
public macro JSSetter(jsName: String? = nil) =
    #externalMacro(module: "BridgeJSMacros", type: "JSSetterMacro")

/// A macro that generates a Swift function body that calls a JavaScript function.
///
/// This macro is used by BridgeJS-generated Swift declarations.
///
/// Example:
///
/// ```swift
/// @_spi(Experimental) import JavaScriptKit
///
/// @JSFunction func greet() throws (JSException) -> String
/// @JSFunction init(_ name: String) throws (JSException)
/// ```
@attached(body)
@_spi(Experimental)
public macro JSFunction() =
    #externalMacro(module: "BridgeJSMacros", type: "JSFunctionMacro")

/// A macro that adds bridging members for a Swift type that represents a JavaScript class.
///
/// This macro is used by BridgeJS-generated Swift declarations.
///
/// Example:
///
/// ```swift
/// @_spi(Experimental) import JavaScriptKit
///
/// @JSClass
/// struct JsGreeter {
///     @JSGetter var name: String
///     @JSSetter func setName(_ value: String) throws (JSException)
///     @JSFunction init(_ name: String) throws (JSException)
///     @JSFunction func greet() throws (JSException) -> String
/// }
/// ```
@attached(member, names: arbitrary)
@attached(extension, conformances: _JSBridgedClass)
@_spi(Experimental)
public macro JSClass() =
    #externalMacro(module: "BridgeJSMacros", type: "JSClassMacro")
