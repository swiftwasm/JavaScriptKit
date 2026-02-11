import SwiftBasicFormat
import SwiftSyntax
import SwiftSyntaxBuilder
#if canImport(BridgeJSSkeleton)
import BridgeJSSkeleton
#endif
#if canImport(BridgeJSUtilities)
import BridgeJSUtilities
#endif

/// Imports TypeScript declarations and generates Swift bridge code
///
/// This struct processes TypeScript definition files (.d.ts) and generates:
/// 1. Swift code to call the JavaScript functions from Swift
/// 2. Skeleton files that define the structure of the imported APIs
///
/// The generated skeletons will be used by ``BridgeJSLink`` to generate
/// JavaScript glue code and TypeScript definitions.
public struct ImportTS {
    public let progress: ProgressReporting
    public private(set) var skeleton: ImportedModuleSkeleton
    private let moduleName: String

    public init(progress: ProgressReporting, moduleName: String, skeleton: ImportedModuleSkeleton) {
        self.progress = progress
        self.moduleName = moduleName
        self.skeleton = skeleton
    }

    /// Finalizes the import process and generates Swift code
    public func finalize() throws -> String? {
        var decls: [DeclSyntax] = []

        for skeleton in self.skeleton.children {
            try withSpan("Render Global Getters") {
                for getter in skeleton.globalGetters {
                    let getterDecls = try renderSwiftGlobalGetter(getter, topLevelDecls: &decls)
                    decls.append(contentsOf: getterDecls)
                }
            }
            try withSpan("Render Functions") {
                for function in skeleton.functions {
                    let thunkDecls = try renderSwiftThunk(function, topLevelDecls: &decls)
                    decls.append(contentsOf: thunkDecls)
                }
            }
            try withSpan("Render Types") {
                for type in skeleton.types {
                    let typeDecls = try renderSwiftType(type, topLevelDecls: &decls)
                    decls.append(contentsOf: typeDecls)
                }
            }
        }
        if decls.isEmpty {
            // No declarations to import
            return nil
        }

        return withSpan("Format Import Glue") {
            let format = BasicFormat()
            return decls.map { $0.formatted(using: format).description }.joined(separator: "\n\n")
        }
    }

    func renderSwiftGlobalGetter(
        _ getter: ImportedGetterSkeleton,
        topLevelDecls: inout [DeclSyntax]
    ) throws -> [DeclSyntax] {
        let builder = CallJSEmission(moduleName: moduleName, abiName: getter.abiName(context: nil))
        try builder.call(returnType: getter.type)
        try builder.liftReturnValue(returnType: getter.type)
        topLevelDecls.append(builder.renderImportDecl())
        return [
            builder.renderThunkDecl(
                name: "_$\(getter.name)_get",
                parameters: [],
                returnType: getter.type
            )
            .with(\.leadingTrivia, Self.renderDocumentation(documentation: getter.documentation))
        ]
    }

    class CallJSEmission {
        let abiName: String
        let moduleName: String
        let context: BridgeContext

        var body = CodeFragmentPrinter()
        var abiParameterForwardings: [String] = []
        var abiParameterSignatures: [(name: String, type: WasmCoreType)] = []
        var abiReturnType: WasmCoreType?
        // Track destructured variable names for multiple lowered parameters
        var destructuredVarNames: [String] = []
        // Stack-lowered parameters should be evaluated in reverse order to match LIFO stacks
        var stackLoweringStmts: [String] = []
        // Values to extend lifetime during call
        var valuesToExtendLifetimeDuringCall: [String] = []

        init(moduleName: String, abiName: String, context: BridgeContext = .importTS) {
            self.moduleName = moduleName
            self.abiName = abiName
            self.context = context
        }

        func lowerParameter(param: Parameter) throws {
            let loweringInfo = try param.type.loweringParameterInfo(context: context)

            switch param.type {
            case .closure(let signature, useJSTypedClosure: false):
                let jsTypedClosureType = BridgeType.closure(signature, useJSTypedClosure: true).swiftType
                body.write("let \(param.name) = \(jsTypedClosureType)(\(param.name))")
                // The just created JSObject is not owned by the caller unlike those passed in parameters,
                // so we need to extend its lifetime during the call to ensure the JSObject.id is valid.
                valuesToExtendLifetimeDuringCall.append(param.name)
            default:
                break
            }
            let initializerExpr = ExprSyntax("\(raw: param.name).bridgeJSLowerParameter()")

            if loweringInfo.loweredParameters.isEmpty {
                stackLoweringStmts.insert("let _ = \(initializerExpr)", at: 0)
                return
            }

            // Generate destructured variable names for all lowered parameters
            let destructuredNames = loweringInfo.loweredParameters.map {
                "\(param.name)\($0.name.capitalizedFirstLetter)"
            }

            // Always add destructuring statement to body (unified for single and multiple)
            let pattern: String
            if destructuredNames.count == 1 {
                pattern = destructuredNames[0]
            } else {
                pattern = "(" + destructuredNames.joined(separator: ", ") + ")"
            }

            body.write("let \(pattern) = \(initializerExpr)")
            destructuredVarNames.append(contentsOf: destructuredNames)

            // Add to signatures and forwardings (unified for both single and multiple)
            for (index, (paramName, type)) in loweringInfo.loweredParameters.enumerated() {
                // For single parameter, use param.name; for multiple, use constructed name
                let abiParamName: String
                if loweringInfo.loweredParameters.count == 1 {
                    abiParamName = param.name
                } else {
                    abiParamName = "\(param.name)\(paramName.capitalizedFirstLetter)"
                }
                abiParameterSignatures.append((abiParamName, type))

                // Always use destructured variable in call without labels
                // Swift allows omitting labels when they match parameter names
                abiParameterForwardings.append(destructuredNames[index])
            }
        }

        func call(returnType: BridgeType) throws {
            let liftingInfo: BridgeType.LiftingReturnInfo = try returnType.liftingReturnInfo(context: context)
            for stmt in stackLoweringStmts {
                body.write(stmt.description)
            }

            let assign =
                (returnType == .void || returnType.usesSideChannelForOptionalReturn() || liftingInfo.valueToLift == nil)
                ? "" : "let ret = "
            let callExpr = "\(abiName)(\(abiParameterForwardings.joined(separator: ", ")))"

            if !valuesToExtendLifetimeDuringCall.isEmpty {
                body.write(
                    "\(assign)withExtendedLifetime((\(valuesToExtendLifetimeDuringCall.joined(separator: ", ")))) {"
                )
                body.indent {
                    body.write(callExpr)
                }
                body.write("}")
            } else {
                body.write("\(assign)\(callExpr)")
            }

            // Add exception check for ImportTS context
            if context == .importTS {
                body.write("if let error = _swift_js_take_exception() { throw error }")
            }
        }

        func liftReturnValue(returnType: BridgeType) throws {
            let liftingInfo = try returnType.liftingReturnInfo(context: context)

            if returnType == .void {
                abiReturnType = nil
                return
            }

            if returnType.usesSideChannelForOptionalReturn() {
                // Side channel returns: extern function returns Void, value is retrieved via side channel
                abiReturnType = nil
                body.write("return \(returnType.swiftType).bridgeJSLiftReturnFromSideChannel()")
            } else {
                abiReturnType = liftingInfo.valueToLift
                let liftExpr: String
                switch returnType {
                case .closure(let signature, _):
                    liftExpr = "_BJS_Closure_\(signature.mangleName).bridgeJSLift(ret)"
                default:
                    if liftingInfo.valueToLift != nil {
                        liftExpr = "\(returnType.swiftType).bridgeJSLiftReturn(ret)"
                    } else {
                        liftExpr = "\(returnType.swiftType).bridgeJSLiftReturn()"
                    }
                }
                body.write("return \(liftExpr)")
            }
        }

        func assignThis(returnType: BridgeType) {
            guard case .jsObject = returnType else {
                preconditionFailure("assignThis can only be called with a jsObject return type")
            }
            abiReturnType = .i32
            body.write("self.jsObject = JSObject(id: UInt32(bitPattern: ret))")
        }

        func renderImportDecl() -> DeclSyntax {
            let signature = SwiftSignatureBuilder.buildABIFunctionSignature(
                abiParameters: abiParameterSignatures,
                returnType: abiReturnType
            )

            let printer = CodeFragmentPrinter()
            SwiftCodePattern.buildWasmConditionalCompilationDecls(
                printer: printer,
                wasmDecl: { printer in
                    SwiftCodePattern.buildExternFunctionDecl(
                        printer: printer,
                        moduleName: moduleName,
                        abiName: abiName,
                        functionName: abiName,
                        signature: signature
                    )
                },
                elseDecl: { printer in
                    printer.write(
                        multilineString: """
                            fileprivate func \(abiName)\(signature) {
                                fatalError("Only available on WebAssembly")
                            }
                            """
                    )
                }
            )
            return "\(raw: printer.lines.joined(separator: "\n"))"
        }

        func renderThunkDecl(name: String, parameters: [Parameter], returnType: BridgeType) -> DeclSyntax {
            let printer = CodeFragmentPrinter()
            let effects = Effects(isAsync: false, isThrows: true)
            let signature = SwiftSignatureBuilder.buildFunctionSignature(
                parameters: parameters,
                returnType: returnType,
                effects: effects,
                useWildcardLabels: true
            )
            printer.write("func \(name.backtickIfNeeded())\(signature) {")
            printer.indent {
                printer.write(lines: body.lines)
            }
            printer.write("}")
            return "\(raw: printer.lines.joined(separator: "\n"))"
        }

        func renderConstructorDecl(parameters: [Parameter]) -> DeclSyntax {
            let printer = CodeFragmentPrinter()
            let effects = Effects(isAsync: false, isThrows: true)
            let parameterClause = SwiftSignatureBuilder.buildParameterClause(
                parameters: parameters,
                useWildcardLabels: true
            )
            let effectSpecifiers = SwiftSignatureBuilder.buildEffectSpecifiers(effects: effects)
            printer.write("init\(parameterClause)\(effectSpecifiers.map { " \($0)" } ?? "") {")
            printer.indent {
                printer.write(lines: body.lines)
            }
            printer.write("}")
            return "\(raw: printer.lines.joined(separator: "\n"))"
        }
    }

    private static func thunkName(function: ImportedFunctionSkeleton) -> String {
        "_$\(function.name)"
    }

    private static func thunkName(type: ImportedTypeSkeleton, method: ImportedFunctionSkeleton) -> String {
        "_$\(type.name)_\(method.name)"
    }

    private static func thunkName(type: ImportedTypeSkeleton) -> String {
        "_$\(type.name)_init"
    }

    private static func thunkName(
        type: ImportedTypeSkeleton,
        propertyName: String,
        operation: String
    )
        -> String
    {
        "_$\(type.name)_\(propertyName)_\(operation)"
    }

    func renderSwiftThunk(
        _ function: ImportedFunctionSkeleton,
        topLevelDecls: inout [DeclSyntax]
    ) throws -> [DeclSyntax] {
        let builder = CallJSEmission(moduleName: moduleName, abiName: function.abiName(context: nil))
        for param in function.parameters {
            try builder.lowerParameter(param: param)
        }
        try builder.call(returnType: function.returnType)
        try builder.liftReturnValue(returnType: function.returnType)
        topLevelDecls.append(builder.renderImportDecl())
        return [
            builder.renderThunkDecl(
                name: Self.thunkName(function: function),
                parameters: function.parameters,
                returnType: function.returnType
            )
            .with(\.leadingTrivia, Self.renderDocumentation(documentation: function.documentation))
        ]
    }

    func renderSwiftType(_ type: ImportedTypeSkeleton, topLevelDecls: inout [DeclSyntax]) throws -> [DeclSyntax] {
        let selfParameter = Parameter(label: nil, name: "self", type: .jsObject(nil))
        var decls: [DeclSyntax] = []

        func renderMethod(method: ImportedFunctionSkeleton) throws -> [DeclSyntax] {
            let builder = CallJSEmission(moduleName: moduleName, abiName: method.abiName(context: type))
            try builder.lowerParameter(param: selfParameter)
            for param in method.parameters {
                try builder.lowerParameter(param: param)
            }
            try builder.call(returnType: method.returnType)
            try builder.liftReturnValue(returnType: method.returnType)
            topLevelDecls.append(builder.renderImportDecl())
            return [
                builder.renderThunkDecl(
                    name: Self.thunkName(type: type, method: method),
                    parameters: [selfParameter] + method.parameters,
                    returnType: method.returnType
                )
            ]
        }

        func renderStaticMethod(method: ImportedFunctionSkeleton) throws -> [DeclSyntax] {
            let abiName = method.abiName(context: type, operation: "static")
            let builder = CallJSEmission(moduleName: moduleName, abiName: abiName)
            for param in method.parameters {
                try builder.lowerParameter(param: param)
            }
            try builder.call(returnType: method.returnType)
            try builder.liftReturnValue(returnType: method.returnType)
            topLevelDecls.append(builder.renderImportDecl())
            return [
                builder.renderThunkDecl(
                    name: Self.thunkName(type: type, method: method),
                    parameters: method.parameters,
                    returnType: method.returnType
                )
            ]
        }

        func renderConstructorDecl(constructor: ImportedConstructorSkeleton) throws -> [DeclSyntax] {
            let builder = CallJSEmission(moduleName: moduleName, abiName: constructor.abiName(context: type))
            for param in constructor.parameters {
                try builder.lowerParameter(param: param)
            }
            try builder.call(returnType: .jsObject(nil))
            try builder.liftReturnValue(returnType: .jsObject(nil))
            topLevelDecls.append(builder.renderImportDecl())
            return [
                builder.renderThunkDecl(
                    name: Self.thunkName(type: type),
                    parameters: constructor.parameters,
                    returnType: .jsObject(nil)
                )
            ]
        }

        func renderGetterDecl(getter: ImportedGetterSkeleton) throws -> DeclSyntax {
            let builder = CallJSEmission(
                moduleName: moduleName,
                abiName: getter.abiName(context: type)
            )
            try builder.lowerParameter(param: selfParameter)
            try builder.call(returnType: getter.type)
            try builder.liftReturnValue(returnType: getter.type)
            topLevelDecls.append(builder.renderImportDecl())
            return DeclSyntax(
                builder.renderThunkDecl(
                    name: Self.thunkName(type: type, propertyName: getter.name, operation: "get"),
                    parameters: [selfParameter],
                    returnType: getter.type
                )
            )
        }

        func renderSetterDecl(setter: ImportedSetterSkeleton) throws -> DeclSyntax {
            let builder = CallJSEmission(
                moduleName: moduleName,
                abiName: setter.abiName(context: type)
            )
            let newValue = Parameter(label: nil, name: "newValue", type: setter.type)
            try builder.lowerParameter(param: selfParameter)
            try builder.lowerParameter(param: newValue)
            try builder.call(returnType: .void)
            topLevelDecls.append(builder.renderImportDecl())
            // Use functionName if available (has lowercase first char), otherwise derive from name
            let propertyNameForThunk: String
            if let functionName = setter.functionName, functionName.hasSuffix("_set") {
                // Extract base name from functionName (e.g., "any_set" -> "any")
                propertyNameForThunk = String(functionName.dropLast(4))
            } else {
                // Lowercase first character of property name for thunk
                propertyNameForThunk = setter.name.prefix(1).lowercased() + setter.name.dropFirst()
            }
            return builder.renderThunkDecl(
                name: Self.thunkName(type: type, propertyName: propertyNameForThunk, operation: "set"),
                parameters: [selfParameter, newValue],
                returnType: .void
            )
        }
        if let constructor = type.constructor {
            decls.append(contentsOf: try renderConstructorDecl(constructor: constructor))
        }

        for method in type.staticMethods {
            decls.append(contentsOf: try renderStaticMethod(method: method))
        }

        for getter in type.getters {
            decls.append(try renderGetterDecl(getter: getter))
        }

        for setter in type.setters {
            decls.append(try renderSetterDecl(setter: setter))
        }

        for method in type.methods {
            decls.append(contentsOf: try renderMethod(method: method))
        }

        return decls
    }

    static func renderDocumentation(documentation: String?) -> Trivia {
        guard let documentation = documentation else {
            return Trivia()
        }
        let lines = documentation.split { $0.isNewline }
        return Trivia(pieces: lines.flatMap { [TriviaPiece.docLineComment("/// \($0)"), .newlines(1)] })
    }

    static func buildAccessorEffect(throws: Bool, async: Bool) -> AccessorEffectSpecifiersSyntax {
        return AccessorEffectSpecifiersSyntax(
            asyncSpecifier: `async` ? .keyword(.async) : nil,
            throwsClause: `throws`
                ? ThrowsClauseSyntax(
                    throwsSpecifier: .keyword(.throws),
                    leftParen: .leftParenToken(),
                    type: IdentifierTypeSyntax(name: .identifier("JSException")),
                    rightParen: .rightParenToken()
                ) : nil
        )
    }
}

/// Unified utility for building Swift function signatures using SwiftSyntax
///
/// This struct eliminates code duplication by providing a single source of truth
/// for generating Swift function signatures across ImportTS, ExportSwift, and
/// other code generators.
struct SwiftSignatureBuilder {
    /// Builds a complete function signature from parameters, return type, and effects
    ///
    /// - Parameters:
    ///   - parameters: Array of Parameter structs for Swift function signatures
    ///   - returnType: The return type of the function
    ///   - effects: Optional effects (async/throws)
    /// - Returns: A FunctionSignatureSyntax node
    static func buildFunctionSignature(
        parameters: [Parameter],
        returnType: BridgeType,
        effects: Effects? = nil,
        useWildcardLabels: Bool = false
    ) -> String {
        let parameterClause = buildParameterClause(parameters: parameters, useWildcardLabels: useWildcardLabels)
        let effectSpecifiers = effects.flatMap { buildEffectSpecifiers(effects: $0) }
        let returnClause = buildReturnClause(returnType: returnType)
        var out = ""
        out += parameterClause
        if let effectSpecifiers {
            out += " \(effectSpecifiers)"
        }
        out += returnClause
        return out
    }

    /// Builds a function signature for ABI/extern functions using WasmCoreType parameters
    ///
    /// - Parameters:
    ///   - abiParameters: Array of (name, WasmCoreType) tuples for ABI signatures
    ///   - returnType: The return type as WasmCoreType (nil for Void)
    ///   - effects: Optional effects (async/throws)
    /// - Returns: A FunctionSignatureSyntax node
    static func buildABIFunctionSignature(
        abiParameters: [(name: String, type: WasmCoreType)],
        returnType: WasmCoreType?,
        effects: Effects? = nil
    ) -> String {
        var out = ""
        out += buildABIParameterClause(abiParameters: abiParameters)
        if let effects = effects, let effectSpecifiers = buildEffectSpecifiers(effects: effects) {
            out += " \(effectSpecifiers)"
        }
        out += buildABIReturnClause(returnType: returnType)
        return out
    }

    /// Builds a parameter clause from an array of Parameter structs
    ///
    /// - Parameters:
    ///   - parameters: Array of Parameter structs
    ///   - useWildcardLabels: If true, all parameters use wildcard labels ("_ name: Type").
    ///     If false, handles parameter labels:
    ///     - If label == name: single identifier (e.g., "count: Int")
    ///     - If label != name: labeled parameter (e.g., "label count: Int")
    ///     - If label == nil: wildcard label (e.g., "_ count: Int")
    static func buildParameterClause(
        parameters: [Parameter],
        useWildcardLabels: Bool = false
    ) -> String {
        var out = "("
        out += parameters.map { param in
            let label = param.label ?? param.name
            let paramType = buildParameterTypeSyntax(from: param.type)

            if useWildcardLabels {
                // Always use wildcard labels: "_ name: Type"
                return "_ \(param.name): \(paramType)"
            } else if label == param.name {
                // External label same as parameter name: "count: Int"
                return "\(param.name): \(paramType)"
            } else if param.label == nil {
                // No label specified: use wildcard "_ name: Type"
                return "_ \(param.name): \(paramType)"
            } else {
                // External label differs: "label count: Int"
                return "\(label) \(param.name): \(paramType)"
            }
        }.joined(separator: ", ")
        out += ")"
        return out
    }

    /// Builds a parameter clause for ABI/extern functions
    ///
    /// All parameters use wildcard labels: "_ name: Type"
    static func buildABIParameterClause(
        abiParameters: [(name: String, type: WasmCoreType)]
    ) -> String {
        "("
            + abiParameters.map { param in
                "_ \(param.name): \(param.type.swiftType)"
            }.joined(separator: ", ") + ")"
    }

    /// Builds a return clause from a BridgeType
    ///
    /// Always returns a ReturnClauseSyntax, including for Void types
    /// (to match original behavior that explicitly includes "-> Void")
    static func buildReturnClause(returnType: BridgeType) -> String {
        return " -> \(returnType.swiftType)"
    }

    /// Builds a return clause for ABI/extern functions
    ///
    /// Returns nil for Void (when returnType is nil), otherwise returns a ReturnClauseSyntax
    static func buildABIReturnClause(returnType: WasmCoreType?) -> String {
        guard let returnType = returnType else {
            return " -> Void"
        }
        return " -> \(returnType.swiftType)"
    }

    /// Builds effect specifiers (async/throws) from an Effects struct
    ///
    /// Uses JSException as the thrown error type for throws clauses
    static func buildEffectSpecifiers(effects: Effects) -> String? {
        guard effects.isAsync || effects.isThrows else {
            return nil
        }
        var items: [String] = []
        if effects.isAsync { items.append("async") }
        if effects.isThrows { items.append("throws(JSException)") }
        return items.joined(separator: " ")
    }

    /// Builds a TypeSyntax node from a BridgeType
    ///
    /// Converts BridgeType to its Swift type representation as a TypeSyntax node
    static func buildTypeSyntax(from type: BridgeType) -> String {
        return type.swiftType
    }

    /// Builds a parameter type syntax from a BridgeType.
    static func buildParameterTypeSyntax(from type: BridgeType) -> String {
        switch type {
        case .closure(_, useJSTypedClosure: false):
            return "@escaping \(type.swiftType)"
        default:
            return buildTypeSyntax(from: type)
        }
    }
}

enum SwiftCodePattern {
    /// Builds a conditional compilation block with #if arch(wasm32) and #else fatalError
    static func buildWasmConditionalCompilation(
        printer: CodeFragmentPrinter,
        wasmBody: (_ printer: CodeFragmentPrinter) -> Void
    ) {
        printer.write("#if arch(wasm32)")
        wasmBody(printer)
        printer.write("#else")
        printer.write("fatalError(\"Only available on WebAssembly\")")
        printer.write("#endif")
    }

    /// Builds a conditional compilation block with #if arch(wasm32) and #else for declarations
    static func buildWasmConditionalCompilationDecls(
        printer: CodeFragmentPrinter,
        wasmDecl: (_ printer: CodeFragmentPrinter) -> Void,
        elseDecl: (_ printer: CodeFragmentPrinter) -> Void
    ) {
        printer.write("#if arch(wasm32)")
        wasmDecl(printer)
        printer.write("#else")
        elseDecl(printer)
        printer.write("#endif")
    }

    /// Builds the @_extern attribute for WebAssembly extern function declarations
    /// Builds an @_extern function declaration (no body, just the declaration)
    static func buildExternFunctionDecl(
        printer: CodeFragmentPrinter,
        moduleName: String,
        abiName: String,
        functionName: String,
        signature: String
    ) {
        printer.write(buildExternAttribute(moduleName: moduleName, abiName: abiName))
        printer.write("fileprivate func \(functionName)\(signature)")
    }

    /// Builds the standard @_expose and @_cdecl attributes for WebAssembly-exposed functions
    static func buildExposeAttributes(abiName: String) -> String {
        return """
            @_expose(wasm, "\(abiName)")
            @_cdecl("\(abiName)")
            """
    }

    /// Builds a function declaration with @_expose/@_cdecl attributes and conditional compilation
    static func buildExposedFunctionDecl(
        abiName: String,
        signature: String,
        body: (CodeFragmentPrinter) -> Void
    ) -> DeclSyntax {
        let printer = CodeFragmentPrinter()
        printer.write(buildExposeAttributes(abiName: abiName))
        printer.write("public func _\(abiName)\(signature) {")
        printer.indent {
            buildWasmConditionalCompilation(printer: printer, wasmBody: body)
        }
        printer.write("}")
        return "\(raw: printer.lines.joined(separator: "\n"))"
    }

    /// Builds the @_extern attribute for WebAssembly extern function declarations
    static func buildExternAttribute(moduleName: String, abiName: String) -> String {
        return "@_extern(wasm, module: \"\(moduleName)\", name: \"\(abiName)\")"
    }
}

extension BridgeType {
    struct LoweringParameterInfo {
        let loweredParameters: [(name: String, type: WasmCoreType)]

        static let bool = LoweringParameterInfo(loweredParameters: [("value", .i32)])
        static let int = LoweringParameterInfo(loweredParameters: [("value", .i32)])
        static let float = LoweringParameterInfo(loweredParameters: [("value", .f32)])
        static let double = LoweringParameterInfo(loweredParameters: [("value", .f64)])
        static let string = LoweringParameterInfo(loweredParameters: [("value", .i32)])
        static let jsObject = LoweringParameterInfo(loweredParameters: [("value", .i32)])
        static let jsValue = LoweringParameterInfo(loweredParameters: [
            ("kind", .i32),
            ("payload1", .i32),
            ("payload2", .f64),
        ])
        static let void = LoweringParameterInfo(loweredParameters: [])
    }

    func loweringParameterInfo(context: BridgeContext = .importTS) throws -> LoweringParameterInfo {
        switch self {
        case .bool: return .bool
        case .int, .uint: return .int
        case .float: return .float
        case .double: return .double
        case .string: return .string
        case .jsObject: return .jsObject
        case .jsValue: return .jsValue
        case .void: return .void
        case .closure:
            // Swift closure is passed to JS as a JS function reference.
            return LoweringParameterInfo(loweredParameters: [("funcRef", .i32)])
        case .unsafePointer:
            return LoweringParameterInfo(loweredParameters: [("pointer", .pointer)])
        case .swiftHeapObject:
            return LoweringParameterInfo(loweredParameters: [("pointer", .pointer)])
        case .swiftProtocol:
            throw BridgeJSCoreError("swiftProtocol is not supported in imported signatures")
        case .caseEnum:
            switch context {
            case .importTS:
                throw BridgeJSCoreError("Enum types are not yet supported in TypeScript imports")
            case .exportSwift:
                return LoweringParameterInfo(loweredParameters: [("value", .i32)])
            }
        case .rawValueEnum(_, let rawType):
            let wasmType = rawType.wasmCoreType ?? .i32
            return LoweringParameterInfo(loweredParameters: [("value", wasmType)])
        case .associatedValueEnum:
            switch context {
            case .importTS:
                throw BridgeJSCoreError("Enum types are not yet supported in TypeScript imports")
            case .exportSwift:
                return LoweringParameterInfo(loweredParameters: [("caseId", .i32)])
            }
        case .swiftStruct:
            switch context {
            case .importTS:
                // Swift structs are bridged as JS objects (object IDs) in imported signatures.
                return LoweringParameterInfo(loweredParameters: [("objectId", .i32)])
            case .exportSwift:
                return LoweringParameterInfo(loweredParameters: [])
            }
        case .namespaceEnum:
            throw BridgeJSCoreError("Namespace enums cannot be used as parameters")
        case .nullable(let wrappedType, _):
            let wrappedInfo = try wrappedType.loweringParameterInfo(context: context)
            var params = [("isSome", WasmCoreType.i32)]
            params.append(contentsOf: wrappedInfo.loweredParameters)
            return LoweringParameterInfo(loweredParameters: params)
        case .array, .dictionary:
            return LoweringParameterInfo(loweredParameters: [])
        }
    }

    struct LiftingReturnInfo {
        let valueToLift: WasmCoreType?

        static let bool = LiftingReturnInfo(valueToLift: .i32)
        static let int = LiftingReturnInfo(valueToLift: .i32)
        static let float = LiftingReturnInfo(valueToLift: .f32)
        static let double = LiftingReturnInfo(valueToLift: .f64)
        static let string = LiftingReturnInfo(valueToLift: .i32)
        static let jsObject = LiftingReturnInfo(valueToLift: .i32)
        static let jsValue = LiftingReturnInfo(valueToLift: nil)
        static let void = LiftingReturnInfo(valueToLift: nil)
    }

    func liftingReturnInfo(
        context: BridgeContext = .importTS
    ) throws -> LiftingReturnInfo {
        switch self {
        case .bool: return .bool
        case .int, .uint: return .int
        case .float: return .float
        case .double: return .double
        case .string: return .string
        case .jsObject: return .jsObject
        case .jsValue: return .jsValue
        case .void: return .void
        case .closure:
            // JS returns a callback ID for closures, which Swift lifts to a typed closure.
            return LiftingReturnInfo(valueToLift: .i32)
        case .unsafePointer:
            return LiftingReturnInfo(valueToLift: .pointer)
        case .swiftHeapObject:
            return LiftingReturnInfo(valueToLift: .pointer)
        case .swiftProtocol:
            throw BridgeJSCoreError("swiftProtocol is not supported in imported signatures")
        case .caseEnum:
            switch context {
            case .importTS:
                throw BridgeJSCoreError("Enum types are not yet supported in TypeScript imports")
            case .exportSwift:
                return LiftingReturnInfo(valueToLift: .i32)
            }
        case .rawValueEnum(_, let rawType):
            let wasmType = rawType.wasmCoreType ?? .i32
            return LiftingReturnInfo(valueToLift: wasmType)
        case .associatedValueEnum:
            switch context {
            case .importTS:
                throw BridgeJSCoreError("Enum types are not yet supported in TypeScript imports")
            case .exportSwift:
                return LiftingReturnInfo(valueToLift: .i32)
            }
        case .swiftStruct:
            switch context {
            case .importTS:
                // Swift structs are bridged as JS objects (object IDs) in imported signatures.
                return LiftingReturnInfo(valueToLift: .i32)
            case .exportSwift:
                return LiftingReturnInfo(valueToLift: nil)
            }
        case .namespaceEnum:
            throw BridgeJSCoreError("Namespace enums cannot be used as return values")
        case .nullable(let wrappedType, _):
            let wrappedInfo = try wrappedType.liftingReturnInfo(context: context)
            return LiftingReturnInfo(valueToLift: wrappedInfo.valueToLift)
        case .array, .dictionary:
            return LiftingReturnInfo(valueToLift: nil)
        }
    }
}

extension String {
    func backtickIfNeeded() -> String {
        return self.isValidSwiftIdentifier(for: .variableName) ? self : "`\(self)`"
    }
}
