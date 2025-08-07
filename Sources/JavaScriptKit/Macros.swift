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
/// When you build your project with the BridgeJS plugin, these declarations will be
/// accessible from JavaScript, and TypeScript declaration files (`.d.ts`) will be
/// automatically generated to provide type safety.
///
/// For detailed usage information, see the article <doc:Exporting-Swift-to-JavaScript>.
///
/// - Important: This feature is still experimental. No API stability is guaranteed, and the API may change in future releases.
@attached(peer)
public macro JS() = Builtin.ExternalMacro

/// A macro that exposes Swift functions, classes, and methods to JavaScript.
/// Additionally defines namespaces defined by `namespace` parameter
///
/// Apply this macro to Swift declarations that you want to make callable from JavaScript:
///
/// ```swift
/// // Export a function to JavaScript with a custom namespace
/// @JS("__Swift.Foundation.UUID") public func create() -> String {
///     UUID().uuidString
/// }
/// 
/// // Export a class with a custom namespace (note that each method needs to specify the namespace)
/// @JS("Utils.Greeters") class Greeter {
///     var name: String
///
///     @JS("Utils.Greeters") init(name: String) {
///         self.name = name
///     }
///     
///     @JS("Utils.Greeters") func greet() -> String {
///         return "Hello, " + self.name + "!"
///     }
///     
///     @JS("Utils.Greeters") func changeName(name: String) {
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
/// - Parameter namespace: A dot-separated string that defines the namespace hierarchy in JavaScript.
///                        Each segment becomes a nested object in the resulting JavaScript structure.
///
/// - Important: This feature is still experimental. No API stability is guaranteed, and the API may change in future releases.
@attached(peer)
public macro JS(_ namespace: String) = Builtin.ExternalMacro
