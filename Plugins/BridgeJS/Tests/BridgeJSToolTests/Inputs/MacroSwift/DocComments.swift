/// Returns a greeting for a user.
/// - Parameters:
///   - name: The user's name.
///   - greeting: The greeting word to use.
/// - Returns: The composed greeting message.
@JS func greet(name: String, greeting: String = "Hello") -> String {
    return "\(greeting), \(name)!"
}

/// Adds two numbers together.
/// - Parameter a: The first addend.
/// - Parameter b: The second addend.
/// - Returns: The sum of the inputs.
@JS func add(a: Int, b: Int) -> Int { a + b }

///
/// Has blank doc lines around the summary; boundaries should be trimmed.
///
@JS func trimmed() {}

/**
 * Says hello to the world.
 *
 * Demonstrates that block doc comments are supported too.
 */
@JS func hello() {}

/// Parses an integer from text.
/// - Parameter text: The text to parse.
/// - Returns: The parsed integer.
/// - Throws: A `JSException` when the text is not a valid integer.
@JS func parseInt(text: String) throws(JSException) -> Int { 0 }

/// A greeter that keeps the target name.
@JS class Greeter {
    /// The configured name.
    @JS var name: String

    /// Create a greeter.
    /// - Parameter name: The name to greet.
    @JS init(name: String) {
        self.name = name
    }

    /// Returns a greeting for the configured name.
    /// - Returns: The greeting message.
    @JS func greet() -> String {
        return "Hello, " + self.name + "!"
    }
}

/// A 2D point in space.
@JS struct Point {
    /// The horizontal position.
    let x: Double
    /// The vertical position.
    let y: Double
}

/// A primary color channel.
@JS enum Color {
    case red
    case green
    case blue

    /// The default channel.
    @JS static var fallback: String { "red" }

    /// Returns the canonical name for a channel label.
    /// - Parameter label: The raw label.
    /// - Returns: The canonical channel name.
    @JS static func canonical(label: String) -> String { label }
}

/// Receives lifecycle callbacks.
@JS protocol Listener {
    /// The listener's display name.
    var name: String { get }

    /// Called when an event fires.
    /// - Parameter id: The event identifier.
    func onEvent(id: Int)
}

/// Doubles a value, in a namespace.
/// - Parameter value: The value to double.
/// - Returns: Twice the input.
@JS(namespace: "MathUtils") func double(value: Int) -> Int { value * 2 }

/// Returns the JSDoc terminator */ embedded mid-sentence.
@JS func terminator() -> String { "*/" }
