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
