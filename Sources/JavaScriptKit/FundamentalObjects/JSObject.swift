import _CJavaScriptKit

/// `JSObject` represents an object in JavaScript and supports dynamic member lookup.
/// Any member access like `object.foo` will dynamically request the JavaScript and Swift
/// runtime bridge library for a member with the specified name in this object.
///
/// And this object supports to call a member method of the object.
///
/// e.g.
/// ```swift
/// let document = JSObject.global.document.object!
/// let divElement = document.createElement!("div")
/// ```
///
/// The lifetime of this object is managed by the JavaScript and Swift runtime bridge library with
/// reference counting system.
@dynamicMemberLookup
public class JSObject: Equatable, ExpressibleByDictionaryLiteral {
    internal static var constructor: JSFunction { _constructor.wrappedValue }
    private static let _constructor = LazyThreadLocal(initialize: { JSObject.global.Object.function! })

    @usableFromInline
    internal var _id: JavaScriptObjectRef

    #if compiler(>=6.1) && _runtime(_multithreaded)
    package let ownerTid: Int32
    #endif

    @_spi(JSObject_id)
    @_spi(BridgeJS)
    @inlinable
    public var id: JavaScriptObjectRef { _id }

    @_spi(JSObject_id)
    @_spi(BridgeJS)
    public init(id: JavaScriptObjectRef) {
        self._id = id
        #if compiler(>=6.1) && _runtime(_multithreaded)
        self.ownerTid = swjs_get_worker_thread_id_cached()
        #endif
    }

    /// Creates an empty JavaScript object.
    public convenience init() {
        self.init(id: swjs_create_object())
    }

    /// Creates a new object with the key-value pairs in the dictionary literal.
    ///
    /// - Parameter elements: A variadic list of key-value pairs where all keys are strings
    public convenience required init(dictionaryLiteral elements: (String, JSValue)...) {
        self.init()
        for (key, value) in elements { self[key] = value }
    }

    /// Asserts that the object is being accessed from the owner thread.
    ///
    /// - Parameter hint: A string to provide additional context for debugging.
    ///
    /// NOTE: Accessing a `JSObject` from a thread other than the thread it was created on
    /// is a programmer error and will result in a runtime assertion failure because JavaScript
    /// object spaces are not shared across threads backed by Web Workers.
    private func assertOnOwnerThread(hint: @autoclosure () -> String) {
        #if compiler(>=6.1) && _runtime(_multithreaded)
        precondition(
            ownerTid == swjs_get_worker_thread_id_cached(),
            "JSObject is being accessed from a thread other than the owner thread: \(hint())"
        )
        #endif
    }

    /// Asserts that the two objects being compared are owned by the same thread.
    private static func assertSameOwnerThread(lhs: JSObject, rhs: JSObject, hint: @autoclosure () -> String) {
        #if compiler(>=6.1) && _runtime(_multithreaded)
        precondition(
            lhs.ownerTid == rhs.ownerTid,
            "JSObject is being accessed from a thread other than the owner thread: \(hint())"
        )
        #endif
    }

    #if !hasFeature(Embedded)
    /// Returns the `name` member method binding this object as `this` context.
    ///
    /// e.g.
    /// ```swift
    /// let document = JSObject.global.document.object!
    /// let divElement = document.createElement!("div")
    /// ```
    ///
    /// - Parameter name: The name of this object's member to access.
    /// - Returns: The `name` member method binding this object as `this` context.
    @_disfavoredOverload
    public subscript(_ name: String) -> ((ConvertibleToJSValue...) -> JSValue)? {
        guard let function = self[name].function else { return nil }
        return { (arguments: ConvertibleToJSValue...) in
            function(this: self, arguments: arguments)
        }
    }

    /// Returns the `name` member method binding this object as `this` context.
    ///
    /// e.g.
    /// ```swift
    /// let document = JSObject.global.document.object!
    /// let divElement = document.createElement!("div")
    /// ```
    ///
    /// - Parameter name: The name of this object's member to access.
    /// - Returns: The `name` member method binding this object as `this` context.
    @_disfavoredOverload
    public subscript(_ name: JSString) -> ((ConvertibleToJSValue...) -> JSValue)? {
        guard let function = self[name].function else { return nil }
        return { (arguments: ConvertibleToJSValue...) in
            function(this: self, arguments: arguments)
        }
    }

    /// A convenience method of `subscript(_ name: String) -> ((ConvertibleToJSValue...) -> JSValue)?`
    /// to access the member through Dynamic Member Lookup.
    @_disfavoredOverload
    public subscript(dynamicMember name: String) -> ((ConvertibleToJSValue...) -> JSValue)? {
        self[name]
    }
    #endif

    /// A convenience method of `subscript(_ name: String) -> JSValue`
    /// to access the member through Dynamic Member Lookup.
    public subscript(dynamicMember name: String) -> JSValue {
        get { self[name] }
        set { self[name] = newValue }
    }

    /// Access the `name` member dynamically through JavaScript and Swift runtime bridge library.
    /// - Parameter name: The name of this object's member to access.
    /// - Returns: The value of the `name` member of this object.
    public subscript(_ name: String) -> JSValue {
        get {
            assertOnOwnerThread(hint: "reading '\(name)' property")
            return getJSValue(this: self, name: JSString(name))
        }
        set {
            assertOnOwnerThread(hint: "writing '\(name)' property")
            setJSValue(this: self, name: JSString(name), value: newValue)
        }
    }

    /// Access the `name` member dynamically through JavaScript and Swift runtime bridge library.
    /// - Parameter name: The name of this object's member to access.
    /// - Returns: The value of the `name` member of this object.
    public subscript(_ name: JSString) -> JSValue {
        get {
            assertOnOwnerThread(hint: "reading '<<JSString>>' property")
            return getJSValue(this: self, name: name)
        }
        set {
            assertOnOwnerThread(hint: "writing '<<JSString>>' property")
            setJSValue(this: self, name: name, value: newValue)
        }
    }

    /// Access the `index` member dynamically through JavaScript and Swift runtime bridge library.
    /// - Parameter index: The index of this object's member to access.
    /// - Returns: The value of the `index` member of this object.
    public subscript(_ index: Int) -> JSValue {
        get {
            assertOnOwnerThread(hint: "reading '\(index)' property")
            return getJSValue(this: self, index: Int32(index))
        }
        set {
            assertOnOwnerThread(hint: "writing '\(index)' property")
            setJSValue(this: self, index: Int32(index), value: newValue)
        }
    }

    /// Access the `symbol` member dynamically through JavaScript and Swift runtime bridge library.
    /// - Parameter symbol: The name of this object's member to access.
    /// - Returns: The value of the `name` member of this object.
    public subscript(_ name: JSSymbol) -> JSValue {
        get {
            assertOnOwnerThread(hint: "reading '<<JSSymbol>>' property")
            return getJSValue(this: self, symbol: name)
        }
        set {
            assertOnOwnerThread(hint: "writing '<<JSSymbol>>' property")
            setJSValue(this: self, symbol: name, value: newValue)
        }
    }

    #if !hasFeature(Embedded)
    /// A modifier to call methods as throwing methods capturing `this`
    ///
    ///
    /// ```javascript
    /// const animal = {
    ///   validateAge: function() {
    ///     if (this.age < 0) {
    ///       throw new Error("Invalid age");
    ///     }
    ///   }
    /// }
    /// ```
    ///
    /// ```swift
    /// let animal = JSObject.global.animal.object!
    /// try animal.throwing.validateAge!()
    /// ```
    public var throwing: JSThrowingObject {
        JSThrowingObject(self)
    }
    #endif

    // MARK: - Function Call Support
    
    #if !hasFeature(Embedded)
    /// Call this object as a function with given `arguments` and binding given `this` as context.
    /// - Parameters:
    ///   - this: The value to be passed as the `this` parameter to this function.
    ///   - arguments: Arguments to be passed to this function.
    /// - Returns: The result of this call.
    @discardableResult
    public func callAsFunction(this: JSObject, arguments: [ConvertibleToJSValue]) -> JSValue {
        invokeNonThrowingJSFunction(arguments: arguments, this: this).jsValue
    }

    /// Call this object as a function with given `arguments`.
    /// - Parameters:
    ///   - arguments: Arguments to be passed to this function.
    /// - Returns: The result of this call.
    @discardableResult
    public func callAsFunction(arguments: [ConvertibleToJSValue]) -> JSValue {
        invokeNonThrowingJSFunction(arguments: arguments).jsValue
    }

    /// A variadic arguments version of `callAsFunction`.
    @discardableResult
    public func callAsFunction(this: JSObject, _ arguments: ConvertibleToJSValue...) -> JSValue {
        self.callAsFunction(this: this, arguments: arguments)
    }

    /// A variadic arguments version of `callAsFunction`.
    @discardableResult
    public func callAsFunction(_ arguments: ConvertibleToJSValue...) -> JSValue {
        self.callAsFunction(arguments: arguments)
    }

    /// Instantiate an object from this object as a constructor.
    ///
    /// Guaranteed to return an object because either:
    ///
    /// - a. the constructor explicitly returns an object, or
    /// - b. the constructor returns nothing, which causes JS to return the `this` value, or
    /// - c. the constructor returns undefined, null or a non-object, in which case JS also returns `this`.
    ///
    /// - Parameter arguments: Arguments to be passed to this constructor function.
    /// - Returns: A new instance of this constructor.
    public func new(arguments: [ConvertibleToJSValue]) -> JSObject {
        arguments.withRawJSValues { rawValues in
            rawValues.withUnsafeBufferPointer { bufferPointer in
                JSObject(id: swjs_call_new(self.id, bufferPointer.baseAddress!, Int32(bufferPointer.count)))
            }
        }
    }

    /// A variadic arguments version of `new`.
    public func new(_ arguments: ConvertibleToJSValue...) -> JSObject {
        new(arguments: arguments)
    }
    #endif

    @discardableResult
    public func callAsFunction(arguments: [JSValue]) -> JSValue {
        invokeNonThrowingJSFunction(arguments: arguments).jsValue
    }

    public func new(arguments: [JSValue]) -> JSObject {
        arguments.withRawJSValues { rawValues in
            rawValues.withUnsafeBufferPointer { bufferPointer in
                JSObject(id: swjs_call_new(self.id, bufferPointer.baseAddress!, Int32(bufferPointer.count)))
            }
        }
    }

    // MARK: - Function Invocation Helper Methods
    
    final func invokeNonThrowingJSFunction(arguments: [JSValue]) -> RawJSValue {
        arguments.withRawJSValues { invokeNonThrowingJSFunction(rawValues: $0) }
    }

    final func invokeNonThrowingJSFunction(arguments: [JSValue], this: JSObject) -> RawJSValue {
        arguments.withRawJSValues { invokeNonThrowingJSFunction(rawValues: $0, this: this) }
    }

    #if !hasFeature(Embedded)
    final func invokeNonThrowingJSFunction(arguments: [ConvertibleToJSValue]) -> RawJSValue {
        arguments.withRawJSValues { invokeNonThrowingJSFunction(rawValues: $0) }
    }

    final func invokeNonThrowingJSFunction(arguments: [ConvertibleToJSValue], this: JSObject) -> RawJSValue {
        arguments.withRawJSValues { invokeNonThrowingJSFunction(rawValues: $0, this: this) }
    }
    #endif

    final private func invokeNonThrowingJSFunction(rawValues: [RawJSValue]) -> RawJSValue {
        rawValues.withUnsafeBufferPointer { [id] bufferPointer in
            let argv = bufferPointer.baseAddress
            let argc = bufferPointer.count
            var payload1 = JavaScriptPayload1()
            var payload2 = JavaScriptPayload2()
            let resultBitPattern = swjs_call_function_no_catch(
                id,
                argv,
                Int32(argc),
                &payload1,
                &payload2
            )
            let kindAndFlags = JavaScriptValueKindAndFlags(bitPattern: resultBitPattern)
            assert(!kindAndFlags.isException)
            let result = RawJSValue(kind: kindAndFlags.kind, payload1: payload1, payload2: payload2)
            return result
        }
    }

    final private func invokeNonThrowingJSFunction(rawValues: [RawJSValue], this: JSObject) -> RawJSValue {
        rawValues.withUnsafeBufferPointer { [id] bufferPointer in
            let argv = bufferPointer.baseAddress
            let argc = bufferPointer.count
            var payload1 = JavaScriptPayload1()
            var payload2 = JavaScriptPayload2()
            let resultBitPattern = swjs_call_function_with_this_no_catch(
                this.id,
                id,
                argv,
                Int32(argc),
                &payload1,
                &payload2
            )
            let kindAndFlags = JavaScriptValueKindAndFlags(bitPattern: resultBitPattern)
            #if !hasFeature(Embedded)
            assert(!kindAndFlags.isException)
            #endif
            let result = RawJSValue(kind: kindAndFlags.kind, payload1: payload1, payload2: payload2)
            return result
        }
    }

    /// Return `true` if this value is an instance of the passed `constructor` function.
    /// - Parameter constructor: The constructor function to check.
    /// - Returns: The result of `instanceof` in the JavaScript environment.
    public func isInstanceOf(_ constructor: JSFunction) -> Bool {
        assertOnOwnerThread(hint: "calling 'isInstanceOf'")
        return swjs_instanceof(id, constructor.id)
    }

    static let _JS_Predef_Value_Global: JavaScriptObjectRef = 1

    /// A `JSObject` of the global scope object.
    /// This allows access to the global properties and global names by accessing the `JSObject` returned.
    public static var global: JSObject { return _global.wrappedValue }
    private static let _global = LazyThreadLocal(initialize: {
        JSObject(id: _JS_Predef_Value_Global)
    })

    deinit {
        #if compiler(>=6.1) && _runtime(_multithreaded)
        if ownerTid != swjs_get_worker_thread_id_cached() {
            // If the object is not owned by the current thread
            swjs_release_remote(ownerTid, id)
            return
        }
        #endif
        swjs_release(id)
    }

    /// Returns a Boolean value indicating whether two values point to same objects.
    ///
    /// - Parameters:
    ///   - lhs: A object to compare.
    ///   - rhs: Another object to compare.
    public static func == (lhs: JSObject, rhs: JSObject) -> Bool {
        assertSameOwnerThread(lhs: lhs, rhs: rhs, hint: "comparing two JSObjects for equality")
        return lhs.id == rhs.id
    }

    public static func construct(from value: JSValue) -> Self? {
        switch value {
        case .boolean,
            .string,
            .number,
            .null,
            .undefined:
            return nil
        case .object(let object):
            return object as? Self
        case .function(let function):
            return function as? Self
        case .symbol(let symbol):
            return symbol as? Self
        case .bigInt(let bigInt):
            return bigInt as? Self
        }
    }

    public var jsValue: JSValue {
        .object(self)
    }
}

extension JSObject: CustomStringConvertible {
    public var description: String { self.toString!().string! }
}

extension JSObject: Hashable {
    /// Hashes the essential components of this value by feeding them into the
    /// given hasher.
    ///
    /// - Parameter hasher: The hasher to use when combining the components
    ///   of this instance.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

#if !hasFeature(Embedded)
/// A `JSObject` wrapper that enables throwing method calls capturing `this`.
/// Exceptions produced by JavaScript functions will be thrown as `JSValue`.
@dynamicMemberLookup
public class JSThrowingObject {
    private let base: JSObject
    public init(_ base: JSObject) {
        self.base = base
    }

    /// Returns the `name` member method binding this object as `this` context.
    /// - Parameter name: The name of this object's member to access.
    /// - Returns: The `name` member method binding this object as `this` context.
    @_disfavoredOverload
    public subscript(_ name: String) -> ((ConvertibleToJSValue...) throws -> JSValue)? {
        guard let function = base[name].function?.throws else { return nil }
        return { [base] (arguments: ConvertibleToJSValue...) in
            try function(this: base, arguments: arguments)
        }
    }

    /// A convenience method of `subscript(_ name: String) -> ((ConvertibleToJSValue...) throws -> JSValue)?`
    /// to access the member through Dynamic Member Lookup.
    @_disfavoredOverload
    public subscript(dynamicMember name: String) -> ((ConvertibleToJSValue...) throws -> JSValue)? {
        self[name]
    }
}
#endif

#if hasFeature(Embedded)
// Overloads of `JSObject.subscript(_ name: String) -> ((ConvertibleToJSValue...) -> JSValue)?`
// for 0 through 7 arguments for Embedded Swift.
//
// These are required because the `ConvertibleToJSValue...` subscript is not
// available in Embedded Swift due to lack of support for existentials.
//
// NOTE: Once Embedded Swift supports parameter packs/variadic generics, we can
// replace all of these with a single method that takes a generic pack.
extension JSObject {
    @_disfavoredOverload
    public subscript(dynamicMember name: String) -> (() -> JSValue)? {
        self[name].function.map { function in
            { function(this: self) }
        }
    }

    @_disfavoredOverload
    public subscript<A0: ConvertibleToJSValue>(dynamicMember name: String) -> ((A0) -> JSValue)? {
        self[name].function.map { function in
            { function(this: self, $0) }
        }
    }

    @_disfavoredOverload
    public subscript<
        A0: ConvertibleToJSValue,
        A1: ConvertibleToJSValue
    >(dynamicMember name: String) -> ((A0, A1) -> JSValue)? {
        self[name].function.map { function in
            { function(this: self, $0, $1) }
        }
    }

    @_disfavoredOverload
    public subscript<
        A0: ConvertibleToJSValue,
        A1: ConvertibleToJSValue,
        A2: ConvertibleToJSValue
    >(dynamicMember name: String) -> ((A0, A1, A2) -> JSValue)? {
        self[name].function.map { function in
            { function(this: self, $0, $1, $2) }
        }
    }

    @_disfavoredOverload
    public subscript<
        A0: ConvertibleToJSValue,
        A1: ConvertibleToJSValue,
        A2: ConvertibleToJSValue,
        A3: ConvertibleToJSValue
    >(dynamicMember name: String) -> ((A0, A1, A2, A3) -> JSValue)? {
        self[name].function.map { function in
            { function(this: self, $0, $1, $2, $3) }
        }
    }

    @_disfavoredOverload
    public subscript<
        A0: ConvertibleToJSValue,
        A1: ConvertibleToJSValue,
        A2: ConvertibleToJSValue,
        A3: ConvertibleToJSValue,
        A4: ConvertibleToJSValue
    >(dynamicMember name: String) -> ((A0, A1, A2, A3, A4) -> JSValue)? {
        self[name].function.map { function in
            { function(this: self, $0, $1, $2, $3, $4) }
        }
    }

    @_disfavoredOverload
    public subscript<
        A0: ConvertibleToJSValue,
        A1: ConvertibleToJSValue,
        A2: ConvertibleToJSValue,
        A3: ConvertibleToJSValue,
        A4: ConvertibleToJSValue,
        A5: ConvertibleToJSValue
    >(dynamicMember name: String) -> ((A0, A1, A2, A3, A4, A5) -> JSValue)? {
        self[name].function.map { function in
            { function(this: self, $0, $1, $2, $3, $4, $5) }
        }
    }

    @_disfavoredOverload
    public subscript<
        A0: ConvertibleToJSValue,
        A1: ConvertibleToJSValue,
        A2: ConvertibleToJSValue,
        A3: ConvertibleToJSValue,
        A4: ConvertibleToJSValue,
        A5: ConvertibleToJSValue,
        A6: ConvertibleToJSValue
    >(dynamicMember name: String) -> ((A0, A1, A2, A3, A4, A5, A6) -> JSValue)? {
        self[name].function.map { function in
            { function(this: self, $0, $1, $2, $3, $4, $5, $6) }
        }
    }
    
    // MARK: - Embedded Swift Function Call Overloads
    
    @discardableResult
    public func callAsFunction(this: JSObject) -> JSValue {
        invokeNonThrowingJSFunction(arguments: [], this: this).jsValue
    }

    @discardableResult
    public func callAsFunction(this: JSObject, _ arg0: some ConvertibleToJSValue) -> JSValue {
        invokeNonThrowingJSFunction(arguments: [arg0.jsValue], this: this).jsValue
    }

    @discardableResult
    public func callAsFunction(
        this: JSObject,
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue
    ) -> JSValue {
        invokeNonThrowingJSFunction(arguments: [arg0.jsValue, arg1.jsValue], this: this).jsValue
    }

    @discardableResult
    public func callAsFunction(
        this: JSObject,
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue
    ) -> JSValue {
        invokeNonThrowingJSFunction(arguments: [arg0.jsValue, arg1.jsValue, arg2.jsValue], this: this).jsValue
    }

    @discardableResult
    public func callAsFunction(
        this: JSObject,
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue,
        _ arg3: some ConvertibleToJSValue
    ) -> JSValue {
        invokeNonThrowingJSFunction(arguments: [arg0.jsValue, arg1.jsValue, arg2.jsValue, arg3.jsValue], this: this)
            .jsValue
    }

    @discardableResult
    public func callAsFunction(
        this: JSObject,
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue,
        _ arg3: some ConvertibleToJSValue,
        _ arg4: some ConvertibleToJSValue
    ) -> JSValue {
        invokeNonThrowingJSFunction(
            arguments: [arg0.jsValue, arg1.jsValue, arg2.jsValue, arg3.jsValue, arg4.jsValue],
            this: this
        ).jsValue
    }

    @discardableResult
    public func callAsFunction(
        this: JSObject,
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue,
        _ arg3: some ConvertibleToJSValue,
        _ arg4: some ConvertibleToJSValue,
        _ arg5: some ConvertibleToJSValue
    ) -> JSValue {
        invokeNonThrowingJSFunction(
            arguments: [arg0.jsValue, arg1.jsValue, arg2.jsValue, arg3.jsValue, arg4.jsValue, arg5.jsValue],
            this: this
        ).jsValue
    }

    @discardableResult
    public func callAsFunction(
        this: JSObject,
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue,
        _ arg3: some ConvertibleToJSValue,
        _ arg4: some ConvertibleToJSValue,
        _ arg5: some ConvertibleToJSValue,
        _ arg6: some ConvertibleToJSValue
    ) -> JSValue {
        invokeNonThrowingJSFunction(
            arguments: [
                arg0.jsValue, arg1.jsValue, arg2.jsValue, arg3.jsValue, arg4.jsValue, arg5.jsValue, arg6.jsValue,
            ],
            this: this
        ).jsValue
    }

    @discardableResult
    public func callAsFunction(this: JSObject, arguments: [JSValue]) -> JSValue {
        invokeNonThrowingJSFunction(arguments: arguments, this: this).jsValue
    }

    @discardableResult
    public func callAsFunction() -> JSValue {
        invokeNonThrowingJSFunction(arguments: []).jsValue
    }

    @discardableResult
    public func callAsFunction(_ arg0: some ConvertibleToJSValue) -> JSValue {
        invokeNonThrowingJSFunction(arguments: [arg0.jsValue]).jsValue
    }

    @discardableResult
    public func callAsFunction(
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue
    ) -> JSValue {
        invokeNonThrowingJSFunction(arguments: [arg0.jsValue, arg1.jsValue]).jsValue
    }

    @discardableResult
    public func callAsFunction(
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue
    ) -> JSValue {
        invokeNonThrowingJSFunction(arguments: [arg0.jsValue, arg1.jsValue, arg2.jsValue]).jsValue
    }

    @discardableResult
    public func callAsFunction(
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue,
        _ arg3: some ConvertibleToJSValue
    ) -> JSValue {
        invokeNonThrowingJSFunction(arguments: [arg0.jsValue, arg1.jsValue, arg2.jsValue, arg3.jsValue]).jsValue
    }

    @discardableResult
    public func callAsFunction(
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue,
        _ arg3: some ConvertibleToJSValue,
        _ arg4: some ConvertibleToJSValue
    ) -> JSValue {
        invokeNonThrowingJSFunction(arguments: [arg0.jsValue, arg1.jsValue, arg2.jsValue, arg3.jsValue, arg4.jsValue])
            .jsValue
    }

    @discardableResult
    public func callAsFunction(
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue,
        _ arg3: some ConvertibleToJSValue,
        _ arg4: some ConvertibleToJSValue,
        _ arg5: some ConvertibleToJSValue
    ) -> JSValue {
        invokeNonThrowingJSFunction(arguments: [
            arg0.jsValue, arg1.jsValue, arg2.jsValue, arg3.jsValue, arg4.jsValue, arg5.jsValue,
        ]).jsValue
    }

    @discardableResult
    public func callAsFunction(
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue,
        _ arg3: some ConvertibleToJSValue,
        _ arg4: some ConvertibleToJSValue,
        _ arg5: some ConvertibleToJSValue,
        _ arg6: some ConvertibleToJSValue
    ) -> JSValue {
        invokeNonThrowingJSFunction(arguments: [
            arg0.jsValue, arg1.jsValue, arg2.jsValue, arg3.jsValue, arg4.jsValue, arg5.jsValue, arg6.jsValue,
        ]).jsValue
    }

    public func new() -> JSObject {
        new(arguments: [])
    }

    public func new(_ arg0: some ConvertibleToJSValue) -> JSObject {
        new(arguments: [arg0.jsValue])
    }

    public func new(
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue
    ) -> JSObject {
        new(arguments: [arg0.jsValue, arg1.jsValue])
    }

    public func new(
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue
    ) -> JSObject {
        new(arguments: [arg0.jsValue, arg1.jsValue, arg2.jsValue])
    }

    public func new(
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue,
        _ arg3: some ConvertibleToJSValue
    ) -> JSObject {
        new(arguments: [arg0.jsValue, arg1.jsValue, arg2.jsValue, arg3.jsValue])
    }

    public func new(
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue,
        _ arg3: some ConvertibleToJSValue,
        _ arg4: some ConvertibleToJSValue
    ) -> JSObject {
        new(arguments: [arg0.jsValue, arg1.jsValue, arg2.jsValue, arg3.jsValue, arg4.jsValue])
    }

    public func new(
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue,
        _ arg3: some ConvertibleToJSValue,
        _ arg4: some ConvertibleToJSValue,
        _ arg5: some ConvertibleToJSValue
    ) -> JSObject {
        new(arguments: [arg0.jsValue, arg1.jsValue, arg2.jsValue, arg3.jsValue, arg4.jsValue, arg5.jsValue])
    }

    public func new(
        _ arg0: some ConvertibleToJSValue,
        _ arg1: some ConvertibleToJSValue,
        _ arg2: some ConvertibleToJSValue,
        _ arg3: some ConvertibleToJSValue,
        _ arg4: some ConvertibleToJSValue,
        _ arg5: some ConvertibleToJSValue,
        _ arg6: some ConvertibleToJSValue
    ) -> JSObject {
        new(arguments: [
            arg0.jsValue, arg1.jsValue, arg2.jsValue, arg3.jsValue, arg4.jsValue, arg5.jsValue, arg6.jsValue,
        ])
    }
}
#endif
