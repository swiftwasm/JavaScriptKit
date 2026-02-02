import SwiftBasicFormat
import SwiftSyntax
import SwiftSyntaxBuilder
#if canImport(BridgeJSSkeleton)
import BridgeJSSkeleton
#endif
#if canImport(BridgeJSUtilities)
import BridgeJSUtilities
#endif

/// Exports Swift functions and classes to JavaScript
///
/// This class processes Swift source files to find declarations marked with `@JS`
/// and generates:
/// 1. Swift glue code to call the Swift functions from JavaScript
/// 2. Skeleton files that define the structure of the exported APIs
///
/// The generated skeletons will be used by ``BridgeJSLink`` to generate
/// JavaScript glue code and TypeScript definitions.
public class ExportSwift {
    let progress: ProgressReporting
    let moduleName: String
    private let exposeToGlobal: Bool
    private var skeleton: ExportedSkeleton
    private var sourceFiles: [(sourceFile: SourceFileSyntax, inputFilePath: String)] = []

    public init(progress: ProgressReporting, moduleName: String, skeleton: ExportedSkeleton) {
        self.progress = progress
        self.moduleName = moduleName
        self.exposeToGlobal = skeleton.exposeToGlobal
        self.skeleton = skeleton
    }

    /// Finalizes the export process and generates the bridge code
    ///
    /// - Parameters:
    ///   - exposeToGlobal: Whether to expose exported APIs to the global namespace (default: false)
    /// - Returns: A tuple containing the generated Swift code and a skeleton
    /// describing the exported APIs
    public func finalize() throws -> String? {
        guard let outputSwift = try renderSwiftGlue() else {
            return nil
        }
        return outputSwift
    }

    func renderSwiftGlue() throws -> String? {
        var decls: [DeclSyntax] = []

        let protocolCodegen = ProtocolCodegen()
        for proto in skeleton.protocols {
            decls.append(contentsOf: try protocolCodegen.renderProtocolWrapper(proto, moduleName: moduleName))
        }

        let enumCodegen = EnumCodegen()
        for enumDef in skeleton.enums {
            if let enumHelpers = enumCodegen.renderEnumHelpers(enumDef) {
                decls.append(enumHelpers)
            }

            for staticMethod in enumDef.staticMethods {
                decls.append(try renderSingleExportedFunction(function: staticMethod))
            }

            for staticProperty in enumDef.staticProperties {
                decls.append(
                    contentsOf: try renderSingleExportedProperty(
                        property: staticProperty,
                        context: .enumStatic(enumDef: enumDef)
                    )
                )
            }
        }

        let structCodegen = StructCodegen()
        for structDef in skeleton.structs {
            decls.append(contentsOf: structCodegen.renderStructHelpers(structDef))
            decls.append(contentsOf: try renderSingleExportedStruct(struct: structDef))
        }

        for function in skeleton.functions {
            decls.append(try renderSingleExportedFunction(function: function))
        }
        for klass in skeleton.classes {
            decls.append(contentsOf: try renderSingleExportedClass(klass: klass))
        }
        let format = BasicFormat()
        return decls.map { $0.formatted(using: format).description }.joined(separator: "\n\n")
    }

    class ExportedThunkBuilder {
        var body: [CodeBlockItemSyntax] = []
        var liftedParameterExprs: [ExprSyntax] = []
        var parameters: [Parameter] = []
        var abiParameterSignatures: [(name: String, type: WasmCoreType)] = []
        var abiReturnType: WasmCoreType?
        var externDecls: [DeclSyntax] = []
        let effects: Effects

        init(effects: Effects) {
            self.effects = effects
        }

        private func append(_ item: CodeBlockItemSyntax) {
            var item = item
            // Add a newline for items after the first one
            if !self.body.isEmpty {
                item = item.with(\.leadingTrivia, .newline)
            }
            self.body.append(item)
        }

        func liftParameter(param: Parameter) throws {
            parameters.append(param)
            let liftingInfo = try param.type.liftParameterInfo()
            let argumentsToLift: [String]
            if liftingInfo.parameters.count == 1 {
                argumentsToLift = [param.name]
            } else {
                argumentsToLift = liftingInfo.parameters.map { (name, _) in param.name + name.capitalizedFirstLetter }
            }

            let typeNameForIntrinsic: String
            let liftingExpr: ExprSyntax

            switch param.type {
            case .closure(let signature):
                typeNameForIntrinsic = param.type.swiftType
                liftingExpr = ExprSyntax("_BJS_Closure_\(raw: signature.mangleName).bridgeJSLift(\(raw: param.name))")
            case .swiftStruct(let structName):
                typeNameForIntrinsic = structName
                liftingExpr = ExprSyntax("\(raw: structName).bridgeJSLiftParameter()")
            case .array:
                typeNameForIntrinsic = param.type.swiftType
                liftingExpr = StackCodegen().liftExpression(for: param.type)
            case .optional(let wrappedType):
                if case .array(let elementType) = wrappedType {
                    let arrayLift = StackCodegen().liftArrayExpression(elementType: elementType)
                    let isSomeParam = argumentsToLift[0]
                    let swiftTypeName = elementType.swiftType
                    typeNameForIntrinsic = "Optional<[\(swiftTypeName)]>"
                    liftingExpr = ExprSyntax(
                        """
                        {
                            if \(raw: isSomeParam) == 0 {
                                return Optional<[\(raw: swiftTypeName)]>.none
                            } else {
                                return \(arrayLift)
                            }
                        }()
                        """
                    )
                } else if case .swiftProtocol(let protocolName) = wrappedType {
                    let wrapperName = "Any\(protocolName)"
                    typeNameForIntrinsic = "Optional<\(wrapperName)>"
                    liftingExpr = ExprSyntax(
                        "\(raw: typeNameForIntrinsic).bridgeJSLiftParameter(\(raw: argumentsToLift.joined(separator: ", ")))"
                    )
                } else {
                    typeNameForIntrinsic = "Optional<\(wrappedType.swiftType)>"
                    liftingExpr = ExprSyntax(
                        "\(raw: typeNameForIntrinsic).bridgeJSLiftParameter(\(raw: argumentsToLift.joined(separator: ", ")))"
                    )
                }
            case .swiftProtocol(let protocolName):
                let wrapperName = "Any\(protocolName)"
                typeNameForIntrinsic = wrapperName
                liftingExpr = ExprSyntax(
                    "\(raw: wrapperName).bridgeJSLiftParameter(\(raw: argumentsToLift.joined(separator: ", ")))"
                )
            default:
                typeNameForIntrinsic = param.type.swiftType
                liftingExpr = ExprSyntax(
                    "\(raw: typeNameForIntrinsic).bridgeJSLiftParameter(\(raw: argumentsToLift.joined(separator: ", ")))"
                )
            }

            liftedParameterExprs.append(liftingExpr)
            for (name, type) in zip(argumentsToLift, liftingInfo.parameters.map { $0.type }) {
                abiParameterSignatures.append((name, type))
            }
        }

        private func removeFirstLiftedParameter() -> (parameter: Parameter, expr: ExprSyntax) {
            let parameter = parameters.removeFirst()
            let expr = liftedParameterExprs.removeFirst()
            return (parameter, expr)
        }

        private func renderCallStatement(callee: ExprSyntax, returnType: BridgeType) -> CodeBlockItemSyntax {
            let labeledParams = zip(parameters, liftedParameterExprs).map { param, expr in
                LabeledExprSyntax(label: param.label, expression: expr)
            }
            var callExpr: ExprSyntax =
                "\(raw: callee)(\(raw: labeledParams.map { $0.description }.joined(separator: ", ")))"
            if effects.isAsync {
                callExpr = ExprSyntax(
                    AwaitExprSyntax(awaitKeyword: .keyword(.await).with(\.trailingTrivia, .space), expression: callExpr)
                )
            }
            if effects.isThrows {
                callExpr = ExprSyntax(
                    TryExprSyntax(
                        tryKeyword: .keyword(.try).with(\.trailingTrivia, .space),
                        expression: callExpr
                    )
                )
            }

            if effects.isAsync, returnType != .void {
                return CodeBlockItemSyntax(item: .init(StmtSyntax("return \(raw: callExpr).jsValue")))
            }

            if returnType == .void {
                return CodeBlockItemSyntax(item: .init(ExpressionStmtSyntax(expression: callExpr)))
            } else {
                switch returnType {
                case .swiftProtocol(let protocolName):
                    let wrapperName = "Any\(protocolName)"
                    return CodeBlockItemSyntax(
                        item: .init(DeclSyntax("let ret = \(raw: callExpr) as! \(raw: wrapperName)"))
                    )
                case .optional(let wrappedType):
                    if case .swiftProtocol(let protocolName) = wrappedType {
                        let wrapperName = "Any\(protocolName)"
                        return CodeBlockItemSyntax(
                            item: .init(
                                DeclSyntax("let ret = (\(raw: callExpr)).flatMap { $0 as? \(raw: wrapperName) }")
                            )
                        )
                    } else {
                        return CodeBlockItemSyntax(item: .init(DeclSyntax("let ret = \(raw: callExpr)")))
                    }
                default:
                    return CodeBlockItemSyntax(item: .init(DeclSyntax("let ret = \(raw: callExpr)")))
                }
            }
        }

        func call(name: String, returnType: BridgeType) {
            generateParameterLifting()
            let item = renderCallStatement(callee: "\(raw: name)", returnType: returnType)
            append(item)
        }

        func callStaticProperty(name: String, returnType: BridgeType) {
            if returnType == .void {
                append("\(raw: name)")
            } else {
                switch returnType {
                case .swiftProtocol(let protocolName):
                    let wrapperName = "Any\(protocolName)"
                    append("let ret = \(raw: name) as! \(raw: wrapperName)")
                case .optional(let wrappedType):
                    if case .swiftProtocol(let protocolName) = wrappedType {
                        let wrapperName = "Any\(protocolName)"
                        append("let ret = \(raw: name).flatMap { $0 as? \(raw: wrapperName) }")
                    } else {
                        append("let ret = \(raw: name)")
                    }
                default:
                    append("let ret = \(raw: name)")
                }
            }
        }

        func callMethod(methodName: String, returnType: BridgeType) {
            let (_, selfExpr) = removeFirstLiftedParameter()
            generateParameterLifting()
            let item = renderCallStatement(
                callee: "\(raw: selfExpr).\(raw: methodName)",
                returnType: returnType
            )
            append(item)
        }

        /// Generates intermediate variables for stack-using parameters if needed for LIFO compatibility
        private func generateParameterLifting() {
            let stackParamIndices = parameters.enumerated().compactMap { index, param -> Int? in
                switch param.type {
                case .swiftStruct, .optional(.swiftStruct),
                    .associatedValueEnum, .optional(.associatedValueEnum),
                    .array:
                    return index
                default:
                    return nil
                }
            }

            guard stackParamIndices.count > 1 else { return }

            for index in stackParamIndices.reversed() {
                let param = parameters[index]
                let expr = liftedParameterExprs[index]
                let varName = "_tmp_\(param.name)"

                append("let \(raw: varName) = \(expr)")
                liftedParameterExprs[index] = ExprSyntax(DeclReferenceExprSyntax(baseName: .identifier(varName)))
            }
        }

        func callPropertyGetter(propertyName: String, returnType: BridgeType) {
            let (_, selfExpr) = removeFirstLiftedParameter()
            if returnType == .void {
                append("\(raw: selfExpr).\(raw: propertyName)")
            } else {
                switch returnType {
                case .swiftProtocol(let protocolName):
                    let wrapperName = "Any\(protocolName)"
                    append("let ret = \(raw: selfExpr).\(raw: propertyName) as! \(raw: wrapperName)")
                case .optional(let wrappedType):
                    if case .swiftProtocol(let protocolName) = wrappedType {
                        let wrapperName = "Any\(protocolName)"
                        append("let ret = \(raw: selfExpr).\(raw: propertyName).flatMap { $0 as? \(raw: wrapperName) }")
                    } else {
                        append("let ret = \(raw: selfExpr).\(raw: propertyName)")
                    }
                default:
                    append("let ret = \(raw: selfExpr).\(raw: propertyName)")
                }
            }
        }

        func callPropertySetter(propertyName: String) {
            let (_, selfExpr) = removeFirstLiftedParameter()
            let (_, newValueExpr) = removeFirstLiftedParameter()
            append("\(raw: selfExpr).\(raw: propertyName) = \(raw: newValueExpr)")
        }

        func callStaticPropertySetter(klassName: String, propertyName: String) {
            let (_, newValueExpr) = removeFirstLiftedParameter()
            append("\(raw: klassName).\(raw: propertyName) = \(raw: newValueExpr)")
        }

        func lowerReturnValue(returnType: BridgeType) throws {
            if effects.isAsync {
                // Async functions always return a Promise, which is a JSObject
                try _lowerReturnValue(returnType: .jsObject(nil))
            } else {
                try _lowerReturnValue(returnType: returnType)
            }
        }

        private func _lowerReturnValue(returnType: BridgeType) throws {
            let loweringInfo = try returnType.loweringReturnInfo()
            abiReturnType = loweringInfo.returnType
            if returnType == .void {
                return
            }
            if effects.isAsync {
                // The return value of async function (T of `(...) async -> T`) is
                // handled by the JSPromise.async, so we don't need to do anything here.
                return
            }

            switch returnType {
            case .closure(let signature):
                append("return _BJS_Closure_\(raw: signature.mangleName).bridgeJSLower(ret)")
            case .array, .optional(.array):
                let stackCodegen = StackCodegen()
                for stmt in stackCodegen.lowerStatements(for: returnType, accessor: "ret", varPrefix: "ret") {
                    append(stmt)
                }
            default:
                append("return ret.bridgeJSLowerReturn()")
            }
        }

        func render(abiName: String) -> DeclSyntax {
            let body: CodeBlockItemListSyntax
            if effects.isAsync {
                body = """
                    let ret = JSPromise.async {
                        \(CodeBlockItemListSyntax(self.body))
                    }.jsObject
                    return ret.bridgeJSLowerReturn()
                    """
            } else if effects.isThrows {
                body = """
                    do {
                        \(CodeBlockItemListSyntax(self.body))
                    } catch let error {
                        if let error = error.thrownValue.object {
                            withExtendedLifetime(error) {
                                _swift_js_throw(Int32(bitPattern: $0.id))
                            }
                        } else {
                            let jsError = JSError(message: String(describing: error))
                            withExtendedLifetime(jsError.jsObject) {
                                _swift_js_throw(Int32(bitPattern: $0.id))
                            }
                        }
                        \(raw: returnPlaceholderStmt())
                    }
                    """
            } else {
                body = CodeBlockItemListSyntax(self.body)
            }
            // Build function signature using SwiftSignatureBuilder
            let signature = SwiftSignatureBuilder.buildABIFunctionSignature(
                abiParameters: abiParameterSignatures,
                returnType: abiReturnType
            )

            // Build function declaration using helper function
            let funcDecl = SwiftCodePattern.buildExposedFunctionDecl(
                abiName: abiName,
                signature: signature,
                body: body
            )

            return DeclSyntax(funcDecl)
        }

        private func returnPlaceholderStmt() -> String {
            switch abiReturnType {
            case .i32: return "return 0"
            case .i64: return "return 0"
            case .f32: return "return 0.0"
            case .f64: return "return 0.0"
            case .pointer: return "return UnsafeMutableRawPointer(bitPattern: -1).unsafelyUnwrapped"
            case .none: return "return"
            }
        }
    }

    /// Context for property rendering that determines call behavior and ABI generation
    private enum PropertyRenderingContext {
        case enumStatic(enumDef: ExportedEnum)
        case classStatic(klass: ExportedClass)
        case classInstance(klass: ExportedClass)
        case structStatic(structDef: ExportedStruct)

        var isStatic: Bool {
            switch self {
            case .enumStatic, .classStatic, .structStatic:
                return true
            case .classInstance:
                return false
            }
        }

        var className: String {
            switch self {
            case .enumStatic(let enumDef):
                return enumDef.name
            case .classStatic(let klass), .classInstance(let klass):
                return klass.name
            case .structStatic(let structDef):
                return structDef.name
            }
        }

        func callName(for property: ExportedProperty) -> String {
            switch self {
            case .enumStatic(let enumDef):
                return property.callName(prefix: enumDef.swiftCallName)
            case .classStatic, .classInstance:
                return property.callName()
            case .structStatic(let structDef):
                return property.callName(prefix: structDef.swiftCallName)
            }
        }
    }

    /// Renders getter and setter Swift thunk code for a property in any context
    /// This unified function eliminates duplication between enum static, class static, and class instance property rendering
    private func renderSingleExportedProperty(
        property: ExportedProperty,
        context: PropertyRenderingContext
    ) throws -> [DeclSyntax] {
        var decls: [DeclSyntax] = []

        let callName = context.callName(for: property)
        let className = context.className
        let isStatic = context.isStatic

        let getterBuilder = ExportedThunkBuilder(effects: Effects(isAsync: false, isThrows: false, isStatic: isStatic))

        if !isStatic {
            try getterBuilder.liftParameter(
                param: Parameter(label: nil, name: "_self", type: .swiftHeapObject(className))
            )
        }

        if isStatic {
            getterBuilder.callStaticProperty(name: callName, returnType: property.type)
        } else {
            getterBuilder.callPropertyGetter(propertyName: callName, returnType: property.type)
        }

        try getterBuilder.lowerReturnValue(returnType: property.type)
        decls.append(getterBuilder.render(abiName: property.getterAbiName(className: className)))

        // Generate property setter if not readonly
        if !property.isReadonly {
            let setterBuilder = ExportedThunkBuilder(
                effects: Effects(isAsync: false, isThrows: false, isStatic: isStatic)
            )

            // Lift parameters based on property type
            if !isStatic {
                // Instance properties need _self parameter
                try setterBuilder.liftParameter(
                    param: Parameter(label: nil, name: "_self", type: .swiftHeapObject(className))
                )
            }

            try setterBuilder.liftParameter(
                param: Parameter(label: "value", name: "value", type: property.type)
            )

            if isStatic {
                let klassName = callName.components(separatedBy: ".").dropLast().joined(separator: ".")
                setterBuilder.callStaticPropertySetter(klassName: klassName, propertyName: property.name)
            } else {
                setterBuilder.callPropertySetter(propertyName: callName)
            }

            try setterBuilder.lowerReturnValue(returnType: .void)
            decls.append(setterBuilder.render(abiName: property.setterAbiName(className: className)))
        }

        return decls
    }

    func renderSingleExportedFunction(function: ExportedFunction) throws -> DeclSyntax {
        let builder = ExportedThunkBuilder(effects: function.effects)
        for param in function.parameters {
            try builder.liftParameter(param: param)
        }

        if function.effects.isStatic, let staticContext = function.staticContext {
            let callName: String
            switch staticContext {
            case .className(let baseName), .enumName(let baseName), .structName(let baseName):
                callName = "\(baseName).\(function.name)"
            case .namespaceEnum:
                if let namespace = function.namespace, !namespace.isEmpty {
                    callName = "\(namespace.joined(separator: ".")).\(function.name)"
                } else {
                    callName = function.name
                }
            }
            builder.call(name: callName, returnType: function.returnType)
        } else {
            builder.call(name: function.name, returnType: function.returnType)
        }

        try builder.lowerReturnValue(returnType: function.returnType)
        return builder.render(abiName: function.abiName)
    }

    func renderSingleExportedStruct(struct structDef: ExportedStruct) throws -> [DeclSyntax] {
        var decls: [DeclSyntax] = []

        if let constructor = structDef.constructor {
            let builder = ExportedThunkBuilder(effects: constructor.effects)
            for param in constructor.parameters {
                try builder.liftParameter(param: param)
            }
            builder.call(name: structDef.swiftCallName, returnType: .swiftStruct(structDef.swiftCallName))
            try builder.lowerReturnValue(returnType: .swiftStruct(structDef.swiftCallName))
            decls.append(builder.render(abiName: constructor.abiName))
        }

        for property in structDef.properties where property.isStatic {
            decls.append(
                contentsOf: try renderSingleExportedProperty(
                    property: property,
                    context: .structStatic(structDef: structDef)
                )
            )
        }

        for method in structDef.methods {
            let builder = ExportedThunkBuilder(effects: method.effects)

            if method.effects.isStatic {
                for param in method.parameters {
                    try builder.liftParameter(param: param)
                }
                builder.call(name: "\(structDef.swiftCallName).\(method.name)", returnType: method.returnType)
            } else {
                try builder.liftParameter(
                    param: Parameter(label: nil, name: "_self", type: .swiftStruct(structDef.swiftCallName))
                )
                for param in method.parameters {
                    try builder.liftParameter(param: param)
                }
                builder.callMethod(
                    methodName: method.name,
                    returnType: method.returnType
                )
            }

            try builder.lowerReturnValue(returnType: method.returnType)
            decls.append(builder.render(abiName: method.abiName))
        }

        return decls
    }

    /// # Example
    ///
    /// Given the following Swift code:
    ///
    /// ```swift
    /// @JS class Greeter {
    ///     var name: String
    ///
    ///     @JS init(name: String) {
    ///         self.name = name
    ///     }
    ///
    ///     @JS func greet() -> String {
    ///         return "Hello, \(name)!"
    ///     }
    /// }
    /// ```
    ///
    /// The following Swift glue code will be generated:
    ///
    /// ```swift
    /// @_expose(wasm, "bjs_Greeter_init")
    /// @_cdecl("bjs_Greeter_init")
    /// public func _bjs_Greeter_init(nameBytes: Int32, nameLen: Int32) -> UnsafeMutableRawPointer {
    ///     let name = String(unsafeUninitializedCapacity: Int(nameLen)) { b in
    ///         _swift_js_init_memory(nameBytes, b.baseAddress.unsafelyUnwrapped)
    ///         return Int(nameLen)
    ///     }
    ///     let ret = Greeter(name: name)
    ///     return Unmanaged.passRetained(ret).toOpaque()
    /// }
    ///
    /// @_expose(wasm, "bjs_Greeter_greet")
    /// @_cdecl("bjs_Greeter_greet")
    /// public func _bjs_Greeter_greet(pointer: UnsafeMutableRawPointer) -> Void {
    ///     let _self = Unmanaged<Greeter>.fromOpaque(pointer).takeUnretainedValue()
    ///     var ret = _self.greet()
    ///     return ret.withUTF8 { ptr in
    ///         _swift_js_return_string(ptr.baseAddress, Int32(ptr.count))
    ///     }
    /// }
    /// @_expose(wasm, "bjs_Greeter_deinit")
    /// @_cdecl("bjs_Greeter_deinit")
    /// public func _bjs_Greeter_deinit(pointer: UnsafeMutableRawPointer) {
    ///     Unmanaged<Greeter>.fromOpaque(pointer).release()
    /// }
    /// ```
    func renderSingleExportedClass(klass: ExportedClass) throws -> [DeclSyntax] {
        var decls: [DeclSyntax] = []

        if let constructor = klass.constructor {
            let builder = ExportedThunkBuilder(effects: constructor.effects)
            for param in constructor.parameters {
                try builder.liftParameter(param: param)
            }
            builder.call(name: klass.swiftCallName, returnType: BridgeType.swiftHeapObject(klass.name))
            try builder.lowerReturnValue(returnType: BridgeType.swiftHeapObject(klass.name))
            decls.append(builder.render(abiName: constructor.abiName))
        }
        for method in klass.methods {
            let builder = ExportedThunkBuilder(effects: method.effects)

            if method.effects.isStatic {
                for param in method.parameters {
                    try builder.liftParameter(param: param)
                }
                builder.call(name: "\(klass.swiftCallName).\(method.name)", returnType: method.returnType)
            } else {
                try builder.liftParameter(
                    param: Parameter(label: nil, name: "_self", type: BridgeType.swiftHeapObject(klass.swiftCallName))
                )
                for param in method.parameters {
                    try builder.liftParameter(param: param)
                }
                builder.callMethod(
                    methodName: method.name,
                    returnType: method.returnType
                )
            }
            try builder.lowerReturnValue(returnType: method.returnType)
            decls.append(builder.render(abiName: method.abiName))
        }

        // Generate property getters and setters
        for property in klass.properties {
            if property.isStatic {
                decls.append(
                    contentsOf: try renderSingleExportedProperty(
                        property: property,
                        context: .classStatic(klass: klass)
                    )
                )
            } else {
                decls.append(
                    contentsOf: try renderSingleExportedProperty(
                        property: property,
                        context: .classInstance(klass: klass)
                    )
                )
            }
        }

        do {
            let funcDecl = SwiftCodePattern.buildExposedFunctionDecl(
                abiName: "bjs_\(klass.name)_deinit",
                signature: SwiftSignatureBuilder.buildABIFunctionSignature(
                    abiParameters: [("pointer", .pointer)],
                    returnType: nil
                ),
                body: CodeBlockItemListSyntax {
                    "Unmanaged<\(raw: klass.swiftCallName)>.fromOpaque(pointer).release()"
                }
            )
            decls.append(DeclSyntax(funcDecl))
        }

        // Generate ConvertibleToJSValue extension
        decls.append(contentsOf: renderConvertibleToJSValueExtension(klass: klass))

        return decls
    }

    /// Generates a ConvertibleToJSValue extension for the exported class
    ///
    /// # Example
    ///
    /// For a class named `Greeter`, this generates:
    ///
    /// ```swift
    /// extension Greeter: ConvertibleToJSValue, _BridgedSwiftHeapObject {
    ///     var jsValue: JSValue {
    ///         return JSObject(id: UInt32(bitPattern: _bjs_Greeter_wrap(Unmanaged.passRetained(self).toOpaque())))
    ///     }
    /// }
    /// @_extern(wasm, module: "MyModule", name: "bjs_Greeter_wrap")
    /// fileprivate func _bjs_Greeter_wrap(_: UnsafeMutableRawPointer) -> Int32
    /// ```
    func renderConvertibleToJSValueExtension(klass: ExportedClass) -> [DeclSyntax] {
        let wrapFunctionName = "_bjs_\(klass.name)_wrap"
        let externFunctionName = "bjs_\(klass.name)_wrap"

        // If the class has an explicit access control, we need to add it to the extension declaration.
        let accessControl = klass.explicitAccessControl.map { "\($0) " } ?? ""
        let extensionDecl: DeclSyntax = """
            extension \(raw: klass.swiftCallName): ConvertibleToJSValue, _BridgedSwiftHeapObject {
                \(raw: accessControl)var jsValue: JSValue {
                    return .object(JSObject(id: UInt32(bitPattern: \(raw: wrapFunctionName)(Unmanaged.passRetained(self).toOpaque()))))
                }
            }
            """
        // Build common function signature
        let funcSignature = SwiftSignatureBuilder.buildABIFunctionSignature(
            abiParameters: [("pointer", .pointer)],
            returnType: .i32
        )

        // Build extern function declaration (no body)
        let externFuncDecl = SwiftCodePattern.buildExternFunctionDecl(
            moduleName: moduleName,
            abiName: externFunctionName,
            functionName: wrapFunctionName,
            signature: funcSignature
        )

        // Build stub function declaration (with fatalError body)
        let stubFuncDecl = FunctionDeclSyntax(
            modifiers: DeclModifierListSyntax {
                DeclModifierSyntax(name: .keyword(.fileprivate))
            },
            funcKeyword: .keyword(.func),
            name: .identifier(wrapFunctionName),
            signature: funcSignature,
            body: CodeBlockSyntax {
                "fatalError(\"Only available on WebAssembly\")"
            }
        )

        // Use helper function for conditional compilation
        let externDecl = DeclSyntax(
            SwiftCodePattern.buildWasmConditionalCompilationDecls(
                wasmDecl: DeclSyntax(externFuncDecl),
                elseDecl: DeclSyntax(stubFuncDecl)
            )
        )
        return [extensionDecl, externDecl]
    }
}

// MARK: - StackCodegen

/// Helper for stack-based lifting and lowering operations.
struct StackCodegen {
    /// Generates an expression to lift a value from the parameter stack.
    /// - Parameter type: The BridgeType to lift
    /// - Returns: An ExprSyntax representing the lift expression
    func liftExpression(for type: BridgeType) -> ExprSyntax {
        switch type {
        case .string, .int, .uint, .bool, .float, .double,
            .jsObject, .swiftStruct, .swiftHeapObject:
            return "\(raw: type.swiftType).bridgeJSLiftParameter()"
        case .unsafePointer:
            return "\(raw: type.swiftType).bridgeJSLiftParameter()"
        case .swiftProtocol(let protocolName):
            return "Any\(raw: protocolName).bridgeJSLiftParameter(_swift_js_pop_i32())"
        case .caseEnum:
            return "\(raw: type.swiftType).bridgeJSLiftParameter(_swift_js_pop_i32())"
        case .rawValueEnum(_, let rawType):
            switch rawType {
            case .string:
                return
                    "\(raw: type.swiftType).bridgeJSLiftParameter(_swift_js_pop_i32(), _swift_js_pop_i32())"
            case .float:
                return "\(raw: type.swiftType).bridgeJSLiftParameter(_swift_js_pop_f32())"
            case .double:
                return "\(raw: type.swiftType).bridgeJSLiftParameter(_swift_js_pop_f64())"
            case .bool, .int, .int32, .int64, .uint, .uint32, .uint64:
                return "\(raw: type.swiftType).bridgeJSLiftParameter(_swift_js_pop_i32())"
            }
        case .associatedValueEnum:
            return "\(raw: type.swiftType).bridgeJSLiftParameter(_swift_js_pop_i32())"
        case .optional(let wrappedType):
            return liftOptionalExpression(wrappedType: wrappedType)
        case .array(let elementType):
            return liftArrayExpression(elementType: elementType)
        case .closure:
            return "JSObject.bridgeJSLiftParameter()"
        case .void, .namespaceEnum:
            return "()"
        }
    }

    func liftArrayExpression(elementType: BridgeType) -> ExprSyntax {
        switch elementType {
        case .int, .uint, .float, .double, .string, .bool,
            .jsObject, .swiftStruct, .caseEnum, .swiftHeapObject,
            .unsafePointer, .rawValueEnum, .associatedValueEnum:
            return "[\(raw: elementType.swiftType)].bridgeJSLiftParameter()"
        case .swiftProtocol(let protocolName):
            return "[Any\(raw: protocolName)].bridgeJSLiftParameter()"
        case .optional, .array, .closure:
            return liftArrayExpressionInline(elementType: elementType)
        case .void, .namespaceEnum:
            fatalError("Invalid array element type: \(elementType)")
        }
    }

    private func liftArrayExpressionInline(elementType: BridgeType) -> ExprSyntax {
        let elementLift = liftExpression(for: elementType)
        let swiftTypeName = elementType.swiftType
        return """
            {
                let __count = Int(_swift_js_pop_i32())
                var __result: [\(raw: swiftTypeName)] = []
                __result.reserveCapacity(__count)
                for _ in 0..<__count {
                    __result.append(\(elementLift))
                }
                __result.reverse()
                return __result
            }()
            """
    }

    private func liftOptionalExpression(wrappedType: BridgeType) -> ExprSyntax {
        switch wrappedType {
        case .string, .int, .uint, .bool, .float, .double, .jsObject,
            .swiftStruct, .swiftHeapObject, .caseEnum, .associatedValueEnum, .rawValueEnum:
            return "Optional<\(raw: wrappedType.swiftType)>.bridgeJSLiftParameter()"
        case .array(let elementType):
            let arrayLift = liftArrayExpression(elementType: elementType)
            let swiftTypeName = elementType.swiftType
            return """
                {
                    let __isSome = _swift_js_pop_i32()
                    if __isSome == 0 {
                        return Optional<[\(raw: swiftTypeName)]>.none
                    } else {
                        return \(arrayLift)
                    }
                }()
                """
        case .void, .namespaceEnum, .closure, .optional, .unsafePointer, .swiftProtocol:
            fatalError("Invalid optional wrapped type: \(wrappedType)")
        }
    }

    /// Generates statements to lower/push a value onto the stack.
    /// - Parameters:
    ///   - type: The BridgeType to lower
    ///   - accessor: The expression to access the value (e.g., "self.name" or "paramName")
    ///   - varPrefix: A unique prefix for intermediate variables
    /// - Returns: An array of CodeBlockItemSyntax representing the lowering statements
    func lowerStatements(
        for type: BridgeType,
        accessor: String,
        varPrefix: String
    ) -> [CodeBlockItemSyntax] {
        switch type {
        case .string, .int, .uint, .bool, .float, .double:
            return ["\(raw: accessor).bridgeJSLowerStackReturn()"]
        case .jsObject:
            return ["\(raw: accessor).bridgeJSLowerStackReturn()"]
        case .swiftHeapObject, .unsafePointer, .closure:
            return ["\(raw: accessor).bridgeJSLowerStackReturn()"]
        case .swiftProtocol(let protocolName):
            let wrapperName = "Any\(protocolName)"
            return ["(\(raw: accessor) as! \(raw: wrapperName)).bridgeJSLowerStackReturn()"]
        case .caseEnum, .rawValueEnum:
            return ["\(raw: accessor).bridgeJSLowerStackReturn()"]
        case .associatedValueEnum, .swiftStruct:
            return ["\(raw: accessor).bridgeJSLowerReturn()"]
        case .optional(let wrappedType):
            return lowerOptionalStatements(wrappedType: wrappedType, accessor: accessor, varPrefix: varPrefix)
        case .void, .namespaceEnum:
            return []
        case .array(let elementType):
            return lowerArrayStatements(elementType: elementType, accessor: accessor, varPrefix: varPrefix)
        }
    }

    private func lowerArrayStatements(
        elementType: BridgeType,
        accessor: String,
        varPrefix: String
    ) -> [CodeBlockItemSyntax] {
        switch elementType {
        case .int, .uint, .float, .double, .string, .bool,
            .jsObject, .swiftStruct, .caseEnum, .swiftHeapObject,
            .unsafePointer, .rawValueEnum, .associatedValueEnum:
            return ["\(raw: accessor).bridgeJSLowerReturn()"]
        case .swiftProtocol(let protocolName):
            return ["\(raw: accessor).map { $0 as! Any\(raw: protocolName) }.bridgeJSLowerReturn()"]
        case .optional, .array, .closure:
            return lowerArrayStatementsInline(
                elementType: elementType,
                accessor: accessor,
                varPrefix: varPrefix
            )
        case .void, .namespaceEnum:
            fatalError("Invalid array element type: \(elementType)")
        }
    }

    private func lowerArrayStatementsInline(
        elementType: BridgeType,
        accessor: String,
        varPrefix: String
    ) -> [CodeBlockItemSyntax] {
        var statements: [CodeBlockItemSyntax] = []
        let elementVarName = "__bjs_elem_\(varPrefix)"
        statements.append("for \(raw: elementVarName) in \(raw: accessor) {")

        let elementStatements = lowerStatements(
            for: elementType,
            accessor: elementVarName,
            varPrefix: "\(varPrefix)_elem"
        )
        for stmt in elementStatements {
            statements.append(stmt)
        }

        statements.append("}")
        statements.append("_swift_js_push_i32(Int32(\(raw: accessor).count))")
        return statements
    }

    private func lowerOptionalStatements(
        wrappedType: BridgeType,
        accessor: String,
        varPrefix: String
    ) -> [CodeBlockItemSyntax] {
        var statements: [CodeBlockItemSyntax] = []
        statements.append("let __bjs_isSome_\(raw: varPrefix) = \(raw: accessor) != nil")
        statements.append("if let __bjs_unwrapped_\(raw: varPrefix) = \(raw: accessor) {")

        let innerStatements = lowerUnwrappedOptionalStatements(
            wrappedType: wrappedType,
            unwrappedVar: "__bjs_unwrapped_\(varPrefix)",
            varPrefix: varPrefix
        )
        for stmt in innerStatements {
            statements.append(stmt)
        }

        statements.append("}")
        statements.append("_swift_js_push_i32(__bjs_isSome_\(raw: varPrefix) ? 1 : 0)")
        return statements
    }

    private func lowerUnwrappedOptionalStatements(
        wrappedType: BridgeType,
        unwrappedVar: String,
        varPrefix: String
    ) -> [CodeBlockItemSyntax] {
        switch wrappedType {
        case .string, .int, .uint, .bool, .float, .double:
            return ["\(raw: unwrappedVar).bridgeJSLowerStackReturn()"]
        case .caseEnum, .rawValueEnum:
            // Enums conform to _BridgedSwiftStackType
            return ["\(raw: unwrappedVar).bridgeJSLowerStackReturn()"]
        case .swiftStruct:
            return ["\(raw: unwrappedVar).bridgeJSLowerReturn()"]
        case .swiftHeapObject:
            return ["\(raw: unwrappedVar).bridgeJSLowerStackReturn()"]
        case .associatedValueEnum:
            // Push payloads via bridgeJSLowerParameter(), then push the returned case ID
            return ["_swift_js_push_i32(\(raw: unwrappedVar).bridgeJSLowerParameter())"]
        case .jsObject:
            return ["\(raw: unwrappedVar).bridgeJSLowerStackReturn()"]
        case .array(let elementType):
            return lowerArrayStatements(elementType: elementType, accessor: unwrappedVar, varPrefix: varPrefix)
        default:
            return ["preconditionFailure(\"BridgeJS: unsupported optional wrapped type\")"]
        }
    }
}

// MARK: - EnumCodegen

struct EnumCodegen {
    private let stackCodegen = StackCodegen()

    func renderEnumHelpers(_ enumDef: ExportedEnum) -> DeclSyntax? {
        switch enumDef.enumType {
        case .simple:
            return renderCaseEnumHelpers(enumDef)
        case .rawValue:
            return renderRawValueEnumHelpers(enumDef)
        case .associatedValue:
            return renderAssociatedValueEnumHelpers(enumDef)
        case .namespace:
            return nil
        }
    }

    private func renderCaseEnumHelpers(_ enumDef: ExportedEnum) -> DeclSyntax {
        let typeName = enumDef.swiftCallName
        var initCases: [String] = []
        var valueCases: [String] = []
        for (index, enumCase) in enumDef.cases.enumerated() {
            initCases.append("case \(index): self = .\(enumCase.name)")
            valueCases.append("case .\(enumCase.name): return \(index)")
        }
        let initSwitch = (["switch bridgeJSRawValue {"] + initCases + ["default: return nil", "}"]).joined(
            separator: "\n"
        )
        let valueSwitch = (["switch self {"] + valueCases + ["}"]).joined(separator: "\n")

        return """
            extension \(raw: typeName): _BridgedSwiftCaseEnum {
                @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
                    return bridgeJSRawValue
                }
                @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Int32) -> \(raw: typeName) {
                    return bridgeJSLiftParameter(value)
                }
                @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> \(raw: typeName) {
                    return \(raw: typeName)(bridgeJSRawValue: value)!
                }
                @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
                    return bridgeJSLowerParameter()
                }

                private init?(bridgeJSRawValue: Int32) {
                    \(raw: initSwitch)
                }

                private var bridgeJSRawValue: Int32 {
                    \(raw: valueSwitch)
                }
            }
            """
    }

    private func renderRawValueEnumHelpers(_ enumDef: ExportedEnum) -> DeclSyntax {
        let typeName = enumDef.swiftCallName
        guard enumDef.rawType != nil else {
            return """
                extension \(raw: typeName): _BridgedSwiftEnumNoPayload {}
                """
        }
        // When rawType is present, conform to _BridgedSwiftRawValueEnum which provides
        // default implementations for _BridgedSwiftStackType methods via protocol extension.
        return """
            extension \(raw: typeName): _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {}
            """
    }

    private func renderAssociatedValueEnumHelpers(_ enumDef: ExportedEnum) -> DeclSyntax {
        let typeName = enumDef.swiftCallName
        return """
            extension \(raw: typeName): _BridgedSwiftAssociatedValueEnum {
                private static func _bridgeJSLiftFromCaseId(_ caseId: Int32) -> \(raw: typeName) {
                    switch caseId {
                    \(raw: generateStackLiftSwitchCases(enumDef: enumDef).joined(separator: "\n"))
                    default: fatalError("Unknown \(raw: typeName) case ID: \\(caseId)")
                    }
                }

                // MARK: Protocol Export

                @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
                    switch self {
                    \(raw: generateLowerParameterSwitchCases(enumDef: enumDef).joined(separator: "\n"))
                    }
                }

                @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ caseId: Int32) -> \(raw: typeName) {
                    return _bridgeJSLiftFromCaseId(caseId)
                }

                // MARK: ExportSwift

                @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ caseId: Int32) -> \(raw: typeName) {
                    return _bridgeJSLiftFromCaseId(caseId)
                }

                @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
                    switch self {
                    \(raw: generateReturnSwitchCases(enumDef: enumDef).joined(separator: "\n"))
                    }
                }
            }
            """
    }

    private func generateStackLiftSwitchCases(enumDef: ExportedEnum) -> [String] {
        var cases: [String] = []
        for (caseIndex, enumCase) in enumDef.cases.enumerated() {
            if enumCase.associatedValues.isEmpty {
                cases.append("case \(caseIndex): return .\(enumCase.name)")
            } else {
                var lines: [String] = []
                lines.append("case \(caseIndex):")
                let argList = enumCase.associatedValues.map { associatedValue in
                    let labelPrefix: String
                    if let label = associatedValue.label {
                        labelPrefix = "\(label): "
                    } else {
                        labelPrefix = ""
                    }
                    let liftExpr = stackCodegen.liftExpression(for: associatedValue.type)
                    return "\(labelPrefix)\(liftExpr)"
                }
                lines.append("return .\(enumCase.name)(\(argList.joined(separator: ", ")))")
                cases.append(lines.joined(separator: "\n"))
            }
        }
        return cases
    }

    private func generatePayloadPushingCode(
        associatedValues: [AssociatedValue]
    ) -> [String] {
        var bodyLines: [String] = []
        for (index, associatedValue) in associatedValues.enumerated() {
            let paramName = associatedValue.label ?? "param\(index)"
            let statements = stackCodegen.lowerStatements(
                for: associatedValue.type,
                accessor: paramName,
                varPrefix: paramName
            )
            for stmt in statements {
                bodyLines.append(stmt.description)
            }
        }
        return bodyLines
    }

    private func generateLowerParameterSwitchCases(enumDef: ExportedEnum) -> [String] {
        var cases: [String] = []
        for (caseIndex, enumCase) in enumDef.cases.enumerated() {
            if enumCase.associatedValues.isEmpty {
                cases.append("case .\(enumCase.name):")
                cases.append("return Int32(\(caseIndex))")
            } else {
                let payloadCode = generatePayloadPushingCode(associatedValues: enumCase.associatedValues)
                let pattern = enumCase.associatedValues.enumerated()
                    .map { index, associatedValue in "let \(associatedValue.label ?? "param\(index)")" }
                    .joined(separator: ", ")
                cases.append("case .\(enumCase.name)(\(pattern)):")
                cases.append(contentsOf: payloadCode)
                cases.append("return Int32(\(caseIndex))")
            }
        }
        return cases
    }

    private func generateReturnSwitchCases(enumDef: ExportedEnum) -> [String] {
        var cases: [String] = []
        for (caseIndex, enumCase) in enumDef.cases.enumerated() {
            if enumCase.associatedValues.isEmpty {
                cases.append("case .\(enumCase.name):")
                cases.append("_swift_js_push_tag(Int32(\(caseIndex)))")
            } else {
                let pattern = enumCase.associatedValues.enumerated()
                    .map { index, associatedValue in "let \(associatedValue.label ?? "param\(index)")" }
                    .joined(separator: ", ")
                cases.append("case .\(enumCase.name)(\(pattern)):")
                cases.append("_swift_js_push_tag(Int32(\(caseIndex)))")
                let payloadCode = generatePayloadPushingCode(associatedValues: enumCase.associatedValues)
                cases.append(contentsOf: payloadCode)
            }
        }
        return cases
    }
}

// MARK: - StructCodegen

struct StructCodegen {
    private let stackCodegen = StackCodegen()

    func renderStructHelpers(_ structDef: ExportedStruct) -> [DeclSyntax] {
        let typeName = structDef.swiftCallName
        let liftCode = generateStructLiftCode(structDef: structDef)
        let lowerCode = generateStructLowerCode(structDef: structDef)
        let accessControl = structDef.explicitAccessControl.map { "\($0) " } ?? ""

        let lowerExternName = "swift_js_struct_lower_\(structDef.name)"
        let liftExternName = "swift_js_struct_lift_\(structDef.name)"
        let lowerFunctionName = "_bjs_struct_lower_\(structDef.name)"
        let liftFunctionName = "_bjs_struct_lift_\(structDef.name)"

        let bridgedStructExtension: DeclSyntax = """
            extension \(raw: typeName): _BridgedSwiftStruct {
                @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter() -> \(raw: typeName) {
                    \(raw: liftCode.joined(separator: "\n"))
                }

                @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() {
                    \(raw: lowerCode.joined(separator: "\n"))
                }

                \(raw: accessControl)init(unsafelyCopying jsObject: JSObject) {
                    let __bjs_cleanupId = \(raw: lowerFunctionName)(jsObject.bridgeJSLowerParameter())
                    defer { _swift_js_struct_cleanup(__bjs_cleanupId) }
                    self = Self.bridgeJSLiftParameter()
                }

                \(raw: accessControl)func toJSObject() -> JSObject {
                    let __bjs_self = self
                    __bjs_self.bridgeJSLowerReturn()
                    return JSObject(id: UInt32(bitPattern: \(raw: liftFunctionName)()))
                }
            }
            """

        let lowerExternDecl = Self.renderStructExtern(
            externName: lowerExternName,
            functionName: lowerFunctionName,
            signature: SwiftSignatureBuilder.buildABIFunctionSignature(
                abiParameters: [("objectId", .i32)],
                returnType: .i32
            )
        )
        let liftExternDecl = Self.renderStructExtern(
            externName: liftExternName,
            functionName: liftFunctionName,
            signature: SwiftSignatureBuilder.buildABIFunctionSignature(
                abiParameters: [],
                returnType: .i32
            )
        )

        return [bridgedStructExtension, lowerExternDecl, liftExternDecl]
    }

    private static func renderStructExtern(
        externName: String,
        functionName: String,
        signature: FunctionSignatureSyntax
    ) -> DeclSyntax {
        let externFuncDecl = SwiftCodePattern.buildExternFunctionDecl(
            moduleName: "bjs",
            abiName: externName,
            functionName: functionName,
            signature: signature
        )

        let stubFuncDecl = FunctionDeclSyntax(
            modifiers: DeclModifierListSyntax {
                DeclModifierSyntax(name: .keyword(.fileprivate))
            },
            funcKeyword: .keyword(.func),
            name: .identifier(functionName),
            signature: signature,
            body: CodeBlockSyntax {
                "fatalError(\"Only available on WebAssembly\")"
            }
        )

        return DeclSyntax(
            SwiftCodePattern.buildWasmConditionalCompilationDecls(
                wasmDecl: DeclSyntax(externFuncDecl),
                elseDecl: DeclSyntax(stubFuncDecl)
            )
        )
    }

    private func generateStructLiftCode(structDef: ExportedStruct) -> [String] {
        var lines: [String] = []
        let instanceProps = structDef.properties.filter { !$0.isStatic }

        for property in instanceProps.reversed() {
            let fieldName = property.name
            let liftExpr = stackCodegen.liftExpression(for: property.type)
            lines.append("let \(fieldName) = \(liftExpr)")
        }

        let initArgs = instanceProps.map { "\($0.name): \($0.name)" }.joined(separator: ", ")
        lines.append("return \(structDef.swiftCallName)(\(initArgs))")

        return lines
    }

    private func generateStructLowerCode(structDef: ExportedStruct) -> [String] {
        var lines: [String] = []
        let instanceProps = structDef.properties.filter { !$0.isStatic }

        for property in instanceProps {
            let accessor = "self.\(property.name)"
            let statements = stackCodegen.lowerStatements(
                for: property.type,
                accessor: accessor,
                varPrefix: property.name
            )
            for stmt in statements {
                lines.append(stmt.description)
            }
        }

        return lines
    }
}

// MARK: - ProtocolCodegen

struct ProtocolCodegen {
    func renderProtocolWrapper(_ proto: ExportedProtocol, moduleName: String) throws -> [DeclSyntax] {
        let wrapperName = "Any\(proto.name)"
        let protocolName = proto.name

        var methodDecls: [DeclSyntax] = []
        var externDecls: [DeclSyntax] = []

        for method in proto.methods {
            let builder = ImportTS.CallJSEmission(
                moduleName: moduleName,
                abiName: "_extern_\(method.name)",
                context: .exportSwift
            )
            try builder.lowerParameter(param: Parameter(label: nil, name: "jsObject", type: .jsObject(nil)))
            for param in method.parameters {
                try builder.lowerParameter(param: param)
            }
            try builder.call(returnType: method.returnType)
            try builder.liftReturnValue(returnType: method.returnType)

            // Build function signature using SwiftSignatureBuilder
            let signature = SwiftSignatureBuilder.buildFunctionSignature(
                parameters: method.parameters,
                returnType: method.returnType,
                effects: nil
            )

            // Build extern declaration using helper function
            let externSignature = SwiftSignatureBuilder.buildABIFunctionSignature(
                abiParameters: builder.abiParameterSignatures,
                returnType: builder.abiReturnType
            )
            let externFuncDecl = SwiftCodePattern.buildExternFunctionDecl(
                moduleName: moduleName,
                abiName: method.abiName,
                functionName: "_extern_\(method.name)",
                signature: externSignature
            )
            externDecls.append(DeclSyntax(externFuncDecl))
            let methodImplementation = DeclSyntax(
                FunctionDeclSyntax(
                    name: .identifier(method.name),
                    signature: signature,
                    body: builder.getBody()
                )
            )

            methodDecls.append(methodImplementation)
        }

        var propertyDecls: [DeclSyntax] = []

        for property in proto.properties {
            let (propertyImpl, propertyExternDecls) = try renderProtocolProperty(
                property: property,
                protocolName: protocolName,
                moduleName: moduleName
            )
            propertyDecls.append(propertyImpl)
            externDecls.append(contentsOf: propertyExternDecls)
        }

        let structDecl = StructDeclSyntax(
            name: .identifier(wrapperName),
            inheritanceClause: InheritanceClauseSyntax(
                inheritedTypesBuilder: {
                    InheritedTypeSyntax(type: IdentifierTypeSyntax(name: .identifier(protocolName)))
                    InheritedTypeSyntax(type: IdentifierTypeSyntax(name: .identifier("_BridgedSwiftProtocolWrapper")))
                }
            ),
            memberBlockBuilder: {
                DeclSyntax(
                    """
                    let jsObject: JSObject
                    """
                ).with(\.trailingTrivia, .newlines(2))

                for decl in methodDecls + propertyDecls {
                    decl.with(\.trailingTrivia, .newlines(2))
                }

                DeclSyntax(
                    """
                    static func bridgeJSLiftParameter(_ value: Int32) -> Self {
                        return \(raw: wrapperName)(jsObject: JSObject(id: UInt32(bitPattern: value)))
                    }
                    """
                )
            }
        )
        return [DeclSyntax(structDecl)] + externDecls
    }

    private func renderProtocolProperty(
        property: ExportedProtocolProperty,
        protocolName: String,
        moduleName: String
    ) throws -> (propertyDecl: DeclSyntax, externDecls: [DeclSyntax]) {
        let getterAbiName = ABINameGenerator.generateABIName(
            baseName: property.name,
            operation: "get",
            className: protocolName
        )
        let setterAbiName = ABINameGenerator.generateABIName(
            baseName: property.name,
            operation: "set",
            className: protocolName
        )

        let getterBuilder = ImportTS.CallJSEmission(
            moduleName: moduleName,
            abiName: getterAbiName,
            context: .exportSwift
        )
        try getterBuilder.lowerParameter(param: Parameter(label: nil, name: "jsObject", type: .jsObject(nil)))
        try getterBuilder.call(returnType: property.type)
        try getterBuilder.liftReturnValue(returnType: property.type)

        // Build getter extern declaration using helper function
        let getterExternSignature = SwiftSignatureBuilder.buildABIFunctionSignature(
            abiParameters: getterBuilder.abiParameterSignatures,
            returnType: getterBuilder.abiReturnType
        )
        let getterExternDecl = SwiftCodePattern.buildExternFunctionDecl(
            moduleName: moduleName,
            abiName: getterAbiName,
            functionName: getterAbiName,
            signature: getterExternSignature
        )

        if property.isReadonly {
            let propertyDecl = VariableDeclSyntax(
                bindingSpecifier: .keyword(.var),
                bindings: PatternBindingListSyntax {
                    PatternBindingSyntax(
                        pattern: IdentifierPatternSyntax(identifier: .identifier(property.name)),
                        typeAnnotation: TypeAnnotationSyntax(
                            type: IdentifierTypeSyntax(name: .identifier(property.type.swiftType))
                        ),
                        accessorBlock: AccessorBlockSyntax(
                            accessors: .accessors(
                                AccessorDeclListSyntax {
                                    AccessorDeclSyntax(
                                        accessorSpecifier: .keyword(.get),
                                        body: getterBuilder.getBody()
                                    )
                                }
                            )
                        )
                    )
                }
            )
            return (DeclSyntax(propertyDecl), [DeclSyntax(getterExternDecl)])
        } else {
            let setterBuilder = ImportTS.CallJSEmission(
                moduleName: moduleName,
                abiName: setterAbiName,
                context: .exportSwift
            )
            try setterBuilder.lowerParameter(param: Parameter(label: nil, name: "jsObject", type: .jsObject(nil)))
            try setterBuilder.lowerParameter(param: Parameter(label: nil, name: "newValue", type: property.type))
            try setterBuilder.call(returnType: .void)

            // Build setter extern declaration using helper function
            let setterExternSignature = SwiftSignatureBuilder.buildABIFunctionSignature(
                abiParameters: setterBuilder.abiParameterSignatures,
                returnType: setterBuilder.abiReturnType
            )
            let setterExternDecl = SwiftCodePattern.buildExternFunctionDecl(
                moduleName: moduleName,
                abiName: setterAbiName,
                functionName: setterAbiName,
                signature: setterExternSignature
            )

            let propertyDecl = VariableDeclSyntax(
                bindingSpecifier: .keyword(.var),
                bindings: PatternBindingListSyntax {
                    PatternBindingSyntax(
                        pattern: IdentifierPatternSyntax(identifier: .identifier(property.name)),
                        typeAnnotation: TypeAnnotationSyntax(
                            type: IdentifierTypeSyntax(name: .identifier(property.type.swiftType))
                        ),
                        accessorBlock: AccessorBlockSyntax(
                            accessors: .accessors(
                                AccessorDeclListSyntax {
                                    AccessorDeclSyntax(
                                        accessorSpecifier: .keyword(.get),
                                        body: getterBuilder.getBody()
                                    )
                                    AccessorDeclSyntax(
                                        accessorSpecifier: .keyword(.set),
                                        body: setterBuilder.getBody()
                                    )
                                }
                            )
                        )
                    )
                }
            )
            return (DeclSyntax(propertyDecl), [DeclSyntax(getterExternDecl), DeclSyntax(setterExternDecl)])
        }
    }
}

extension WasmCoreType {
    var swiftType: String {
        switch self {
        case .i32: return "Int32"
        case .i64: return "Int64"
        case .f32: return "Float32"
        case .f64: return "Float64"
        case .pointer: return "UnsafeMutableRawPointer"
        }
    }
}

extension UnsafePointerType {
    var swiftType: String {
        switch kind {
        case .unsafePointer:
            return "UnsafePointer<\(pointee ?? "Never")>"
        case .unsafeMutablePointer:
            return "UnsafeMutablePointer<\(pointee ?? "Never")>"
        case .unsafeRawPointer:
            return "UnsafeRawPointer"
        case .unsafeMutableRawPointer:
            return "UnsafeMutableRawPointer"
        case .opaquePointer:
            return "OpaquePointer"
        }
    }
}

extension BridgeType {
    var swiftType: String {
        switch self {
        case .bool: return "Bool"
        case .int: return "Int"
        case .uint: return "UInt"
        case .float: return "Float"
        case .double: return "Double"
        case .string: return "String"
        case .jsObject(nil): return "JSObject"
        case .jsObject(let name?): return name
        case .swiftHeapObject(let name): return name
        case .unsafePointer(let ptr): return ptr.swiftType
        case .swiftProtocol(let name): return "Any\(name)"
        case .void: return "Void"
        case .optional(let wrappedType): return "Optional<\(wrappedType.swiftType)>"
        case .array(let elementType): return "[\(elementType.swiftType)]"
        case .caseEnum(let name): return name
        case .rawValueEnum(let name, _): return name
        case .associatedValueEnum(let name): return name
        case .swiftStruct(let name): return name
        case .namespaceEnum(let name): return name
        case .closure(let signature):
            let paramTypes = signature.parameters.map { $0.swiftType }.joined(separator: ", ")
            let effectsStr = (signature.isAsync ? " async" : "") + (signature.isThrows ? " throws" : "")
            return "(\(paramTypes))\(effectsStr) -> \(signature.returnType.swiftType)"
        }
    }

    struct LiftingIntrinsicInfo: Sendable {
        let parameters: [(name: String, type: WasmCoreType)]

        static let bool = LiftingIntrinsicInfo(parameters: [("value", .i32)])
        static let int = LiftingIntrinsicInfo(parameters: [("value", .i32)])
        static let float = LiftingIntrinsicInfo(parameters: [("value", .f32)])
        static let double = LiftingIntrinsicInfo(parameters: [("value", .f64)])
        static let string = LiftingIntrinsicInfo(parameters: [("bytes", .i32), ("length", .i32)])
        static let jsObject = LiftingIntrinsicInfo(parameters: [("value", .i32)])
        static let swiftHeapObject = LiftingIntrinsicInfo(parameters: [("value", .pointer)])
        static let unsafePointer = LiftingIntrinsicInfo(parameters: [("pointer", .pointer)])
        static let void = LiftingIntrinsicInfo(parameters: [])
        static let caseEnum = LiftingIntrinsicInfo(parameters: [("value", .i32)])
        static let associatedValueEnum = LiftingIntrinsicInfo(parameters: [
            ("caseId", .i32)
        ])
    }

    func liftParameterInfo() throws -> LiftingIntrinsicInfo {
        switch self {
        case .bool: return .bool
        case .int, .uint: return .int
        case .float: return .float
        case .double: return .double
        case .string: return .string
        case .jsObject: return .jsObject
        case .swiftHeapObject: return .swiftHeapObject
        case .unsafePointer: return .unsafePointer
        case .swiftProtocol: return .jsObject
        case .void: return .void
        case .optional(let wrappedType):
            var optionalParams: [(name: String, type: WasmCoreType)] = [("isSome", .i32)]
            optionalParams.append(contentsOf: try wrappedType.liftParameterInfo().parameters)
            return LiftingIntrinsicInfo(parameters: optionalParams)
        case .caseEnum: return .caseEnum
        case .rawValueEnum(_, let rawType):
            return rawType.liftingIntrinsicInfo
        case .associatedValueEnum:
            return .associatedValueEnum
        case .swiftStruct:
            return LiftingIntrinsicInfo(parameters: [])
        case .namespaceEnum:
            throw BridgeJSCoreError("Namespace enums are not supported to pass as parameters")
        case .closure:
            return LiftingIntrinsicInfo(parameters: [("callbackId", .i32)])
        case .array:
            return LiftingIntrinsicInfo(parameters: [])
        }
    }

    struct LoweringIntrinsicInfo: Sendable {
        let returnType: WasmCoreType?

        static let bool = LoweringIntrinsicInfo(returnType: .i32)
        static let int = LoweringIntrinsicInfo(returnType: .i32)
        static let float = LoweringIntrinsicInfo(returnType: .f32)
        static let double = LoweringIntrinsicInfo(returnType: .f64)
        static let string = LoweringIntrinsicInfo(returnType: nil)
        static let jsObject = LoweringIntrinsicInfo(returnType: .i32)
        static let swiftHeapObject = LoweringIntrinsicInfo(returnType: .pointer)
        static let unsafePointer = LoweringIntrinsicInfo(returnType: .pointer)
        static let void = LoweringIntrinsicInfo(returnType: nil)
        static let caseEnum = LoweringIntrinsicInfo(returnType: .i32)
        static let rawValueEnum = LoweringIntrinsicInfo(returnType: .i32)
        static let associatedValueEnum = LoweringIntrinsicInfo(returnType: nil)
        static let swiftStruct = LoweringIntrinsicInfo(returnType: nil)
        static let optional = LoweringIntrinsicInfo(returnType: nil)
        static let array = LoweringIntrinsicInfo(returnType: nil)
    }

    func loweringReturnInfo() throws -> LoweringIntrinsicInfo {
        switch self {
        case .bool: return .bool
        case .int, .uint: return .int
        case .float: return .float
        case .double: return .double
        case .string: return .string
        case .jsObject: return .jsObject
        case .swiftHeapObject: return .swiftHeapObject
        case .unsafePointer: return .unsafePointer
        case .swiftProtocol: return .jsObject
        case .void: return .void
        case .optional: return .optional
        case .caseEnum: return .caseEnum
        case .rawValueEnum(_, let rawType):
            return rawType.loweringIntrinsicInfo
        case .associatedValueEnum:
            return .associatedValueEnum
        case .swiftStruct:
            return .swiftStruct
        case .namespaceEnum:
            throw BridgeJSCoreError("Namespace enums are not supported to pass as parameters")
        case .closure:
            return .swiftHeapObject
        case .array:
            return .array
        }
    }
}

extension SwiftEnumRawType {
    var liftingIntrinsicInfo: BridgeType.LiftingIntrinsicInfo {
        switch self {
        case .bool: return .bool
        case .int, .int32, .int64, .uint, .uint32, .uint64: return .int
        case .float: return .float
        case .double: return .double
        case .string: return .string
        }
    }

    var loweringIntrinsicInfo: BridgeType.LoweringIntrinsicInfo {
        switch self {
        case .bool: return .bool
        case .int, .int32, .int64, .uint, .uint32, .uint64: return .int
        case .float: return .float
        case .double: return .double
        case .string: return .string
        }
    }
}

extension DeclModifierSyntax {
    var isAccessControl: Bool {
        switch self.name.tokenKind {
        case .keyword(.private),
            .keyword(.fileprivate),
            .keyword(.internal),
            .keyword(.package),
            .keyword(.public),
            .keyword(.open):
            return true
        default:
            return false
        }
    }

    var isAtLeastInternal: Bool {
        switch self.name.tokenKind {
        case .keyword(.private): false
        case .keyword(.fileprivate): false
        case .keyword(.internal): true
        case .keyword(.package): true
        case .keyword(.public): true
        case .keyword(.open): true
        default: false
        }
    }

    var isAtLeastPackage: Bool {
        switch self.name.tokenKind {
        case .keyword(.private): false
        case .keyword(.fileprivate): false
        case .keyword(.internal): true
        case .keyword(.package): true
        case .keyword(.public): true
        case .keyword(.open): true
        default: false
        }
    }
}

extension WithModifiersSyntax {
    var explicitAccessControl: DeclModifierSyntax? {
        return self.modifiers.first { modifier in
            modifier.isAccessControl
        }
    }
}
