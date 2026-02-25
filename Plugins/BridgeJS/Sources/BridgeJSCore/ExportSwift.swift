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

        try withSpan("Render Protocols") { [self] in
            let protocolCodegen = ProtocolCodegen()
            for proto in skeleton.protocols {
                decls.append(contentsOf: try protocolCodegen.renderProtocolWrapper(proto, moduleName: moduleName))
            }
        }

        try withSpan("Render Enums") { [self] in
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
        }

        try withSpan("Render Structs") { [self] in
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
        }
        return withSpan("Format Export Glue") {
            return decls.map { $0.description }.joined(separator: "\n\n")
        }
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
            case .closure(let signature, _):
                typeNameForIntrinsic = param.type.swiftType
                liftingExpr = ExprSyntax("_BJS_Closure_\(raw: signature.mangleName).bridgeJSLift(\(raw: param.name))")
            case .swiftStruct(let structName):
                typeNameForIntrinsic = structName
                liftingExpr = ExprSyntax("\(raw: structName).bridgeJSLiftParameter()")
            case .array:
                typeNameForIntrinsic = param.type.swiftType
                liftingExpr = StackCodegen().liftExpression(for: param.type)
            case .nullable(let wrappedType, let kind):
                let optionalSwiftType: String
                if case .null = kind {
                    optionalSwiftType = "Optional"
                } else {
                    optionalSwiftType = "JSUndefinedOr"
                }
                typeNameForIntrinsic = "\(optionalSwiftType)<\(wrappedType.swiftType)>"
                liftingExpr = ExprSyntax(
                    "\(raw: typeNameForIntrinsic).bridgeJSLiftParameter(\(raw: argumentsToLift.joined(separator: ", ")))"
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

        private func protocolCastSuffix(for returnType: BridgeType) -> (prefix: String, suffix: String) {
            switch returnType {
            case .swiftProtocol:
                return ("", " as! \(returnType.swiftType)")
            case .nullable(let wrappedType, _):
                if case .swiftProtocol = wrappedType {
                    return ("(", ").flatMap { $0 as? \(wrappedType.swiftType) }")
                }
                return ("", "")
            default:
                return ("", "")
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
                let (prefix, suffix) = protocolCastSuffix(for: returnType)
                return CodeBlockItemSyntax(
                    item: .init(DeclSyntax("let ret = \(raw: prefix)\(raw: callExpr)\(raw: suffix)"))
                )
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
                let (prefix, suffix) = protocolCastSuffix(for: returnType)
                append("let ret = \(raw: prefix)\(raw: name)\(raw: suffix)")
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
                param.type.isStackUsingParameter ? index : nil
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
                let (prefix, suffix) = protocolCastSuffix(for: returnType)
                append("let ret = \(raw: prefix)\(raw: selfExpr).\(raw: propertyName)\(raw: suffix)")
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
            case .closure(_, useJSTypedClosure: false):
                append("return JSTypedClosure(ret).bridgeJSLowerReturn()")
            case .array, .nullable(.array, _):
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
                signature: signature
            ) { printer in
                printer.write(multilineString: body.description)
            }

            return DeclSyntax(funcDecl)
        }

        private func returnPlaceholderStmt() -> String {
            return abiReturnType?.swiftReturnPlaceholderStmt ?? "return"
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
            let callName = "\(staticContextBaseName(staticContext)).\(function.name)"
            builder.call(name: callName, returnType: function.returnType)
        } else {
            builder.call(name: function.name, returnType: function.returnType)
        }

        try builder.lowerReturnValue(returnType: function.returnType)
        return builder.render(abiName: function.abiName)
    }

    private func staticContextBaseName(_ staticContext: StaticContext) -> String {
        switch staticContext {
        case .className(let baseName), .enumName(let baseName), .structName(let baseName),
            .namespaceEnum(let baseName):
            return baseName
        }
    }

    private func renderSingleExportedConstructor(
        constructor: ExportedConstructor,
        callName: String,
        returnType: BridgeType
    ) throws -> DeclSyntax {
        let builder = ExportedThunkBuilder(effects: constructor.effects)
        for param in constructor.parameters {
            try builder.liftParameter(param: param)
        }
        builder.call(name: callName, returnType: returnType)
        try builder.lowerReturnValue(returnType: returnType)
        return builder.render(abiName: constructor.abiName)
    }

    private func renderSingleExportedMethod(
        method: ExportedFunction,
        ownerTypeName: String,
        instanceSelfType: BridgeType
    ) throws -> DeclSyntax {
        let builder = ExportedThunkBuilder(effects: method.effects)
        if !method.effects.isStatic {
            try builder.liftParameter(param: Parameter(label: nil, name: "_self", type: instanceSelfType))
        }
        for param in method.parameters {
            try builder.liftParameter(param: param)
        }

        if method.effects.isStatic {
            builder.call(name: "\(ownerTypeName).\(method.name)", returnType: method.returnType)
        } else {
            builder.callMethod(methodName: method.name, returnType: method.returnType)
        }
        try builder.lowerReturnValue(returnType: method.returnType)
        return builder.render(abiName: method.abiName)
    }

    func renderSingleExportedStruct(struct structDef: ExportedStruct) throws -> [DeclSyntax] {
        var decls: [DeclSyntax] = []

        if let constructor = structDef.constructor {
            decls.append(
                try renderSingleExportedConstructor(
                    constructor: constructor,
                    callName: structDef.swiftCallName,
                    returnType: .swiftStruct(structDef.swiftCallName)
                )
            )
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
            decls.append(
                try renderSingleExportedMethod(
                    method: method,
                    ownerTypeName: structDef.swiftCallName,
                    instanceSelfType: .swiftStruct(structDef.swiftCallName)
                )
            )
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
            decls.append(
                try renderSingleExportedConstructor(
                    constructor: constructor,
                    callName: klass.swiftCallName,
                    returnType: .swiftHeapObject(klass.name)
                )
            )
        }
        for method in klass.methods {
            decls.append(
                try renderSingleExportedMethod(
                    method: method,
                    ownerTypeName: klass.swiftCallName,
                    instanceSelfType: .swiftHeapObject(klass.swiftCallName)
                )
            )
        }

        // Generate property getters and setters
        for property in klass.properties {
            let context: PropertyRenderingContext =
                property.isStatic ? .classStatic(klass: klass) : .classInstance(klass: klass)
            decls.append(contentsOf: try renderSingleExportedProperty(property: property, context: context))
        }

        do {
            let funcDecl = SwiftCodePattern.buildExposedFunctionDecl(
                abiName: "bjs_\(klass.name)_deinit",
                signature: SwiftSignatureBuilder.buildABIFunctionSignature(
                    abiParameters: [("pointer", .pointer)],
                    returnType: nil
                )
            ) { printer in
                printer.write("Unmanaged<\(klass.swiftCallName)>.fromOpaque(pointer).release()")
            }
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
        let externDeclPrinter = CodeFragmentPrinter()
        SwiftCodePattern.buildExternFunctionDecl(
            printer: externDeclPrinter,
            moduleName: moduleName,
            abiName: externFunctionName,
            functionName: wrapFunctionName,
            abiParameters: [("pointer", .pointer)],
            returnType: .i32
        )
        let externDecl: DeclSyntax = "\(raw: externDeclPrinter.lines.joined(separator: "\n"))"
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
            .jsObject(nil), .jsValue, .swiftStruct, .swiftHeapObject, .unsafePointer,
            .swiftProtocol, .caseEnum, .associatedValueEnum, .rawValueEnum, .array, .dictionary:
            return "\(raw: type.swiftType).bridgeJSStackPop()"
        case .jsObject(let className?):
            return "\(raw: className)(unsafelyWrapping: JSObject.bridgeJSStackPop())"
        case .nullable(let wrappedType, let kind):
            return liftNullableExpression(wrappedType: wrappedType, kind: kind)
        case .closure:
            return "JSObject.bridgeJSStackPop()"
        case .void, .namespaceEnum:
            return "()"
        }
    }

    private func liftNullableExpression(wrappedType: BridgeType, kind: JSOptionalKind) -> ExprSyntax {
        let typeName = kind == .null ? "Optional" : "JSUndefinedOr"
        switch wrappedType {
        case .string, .int, .uint, .bool, .float, .double, .jsObject(nil), .jsValue,
            .swiftStruct, .swiftHeapObject, .caseEnum, .associatedValueEnum, .rawValueEnum,
            .array, .dictionary:
            return "\(raw: typeName)<\(raw: wrappedType.swiftType)>.bridgeJSStackPop()"
        case .jsObject(let className?):
            return "\(raw: typeName)<JSObject>.bridgeJSStackPop().map { \(raw: className)(unsafelyWrapping: $0) }"
        case .nullable, .void, .namespaceEnum, .closure, .unsafePointer, .swiftProtocol:
            fatalError("Invalid nullable wrapped type: \(wrappedType)")
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
        case .string, .int, .uint, .bool, .float, .double, .jsValue,
            .jsObject(nil), .swiftHeapObject, .unsafePointer, .closure,
            .caseEnum, .rawValueEnum, .associatedValueEnum, .swiftStruct, .nullable:
            return ["\(raw: accessor).bridgeJSStackPush()"]
        case .jsObject(_?):
            return ["\(raw: accessor).jsObject.bridgeJSStackPush()"]
        case .swiftProtocol:
            return ["(\(raw: accessor) as! \(raw: type.swiftType)).bridgeJSStackPush()"]
        case .void, .namespaceEnum:
            return []
        case .array(let elementType):
            return lowerArrayStatements(elementType: elementType, accessor: accessor, varPrefix: varPrefix)
        case .dictionary(let valueType):
            return lowerDictionaryStatements(valueType: valueType, accessor: accessor, varPrefix: varPrefix)
        }
    }

    private func lowerArrayStatements(
        elementType: BridgeType,
        accessor: String,
        varPrefix: String
    ) -> [CodeBlockItemSyntax] {
        switch elementType {
        case .swiftProtocol:
            return ["\(raw: accessor).map { $0 as! \(raw: elementType.swiftType) }.bridgeJSStackPush()"]
        case .void, .namespaceEnum:
            fatalError("Invalid array element type: \(elementType)")
        default:
            return ["\(raw: accessor).bridgeJSStackPush()"]
        }
    }

    private func lowerDictionaryStatements(
        valueType: BridgeType,
        accessor: String,
        varPrefix: String
    ) -> [CodeBlockItemSyntax] {
        switch valueType {
        case .jsObject(let className?) where className != "JSObject":
            return ["\(raw: accessor).mapValues { $0.jsObject }.bridgeJSStackPush()"]
        case .swiftProtocol:
            return ["\(raw: accessor).mapValues { $0 as! \(raw: valueType.swiftType) }.bridgeJSStackPush()"]
        case .nullable, .closure:
            return lowerDictionaryStatementsInline(
                valueType: valueType,
                accessor: accessor,
                varPrefix: varPrefix
            )
        case .void, .namespaceEnum:
            fatalError("Invalid dictionary value type: \(valueType)")
        default:
            return ["\(raw: accessor).bridgeJSStackPush()"]
        }
    }

    private func lowerDictionaryStatementsInline(
        valueType: BridgeType,
        accessor: String,
        varPrefix: String
    ) -> [CodeBlockItemSyntax] {
        var statements: [CodeBlockItemSyntax] = []
        let pairVarName = "__bjs_kv_\(varPrefix)"
        statements.append("for \(raw: pairVarName) in \(raw: accessor) {")
        statements.append("let __bjs_key_\(raw: varPrefix) = \(raw: pairVarName).key")
        statements.append("let __bjs_value_\(raw: varPrefix) = \(raw: pairVarName).value")

        let keyStatements = lowerStatements(
            for: .string,
            accessor: "__bjs_key_\(varPrefix)",
            varPrefix: "\(varPrefix)_key"
        )
        for stmt in keyStatements {
            statements.append(stmt)
        }

        let valueStatements = lowerStatements(
            for: valueType,
            accessor: "__bjs_value_\(varPrefix)",
            varPrefix: "\(varPrefix)_value"
        )
        for stmt in valueStatements {
            statements.append(stmt)
        }

        statements.append("}")
        statements.append("_swift_js_push_i32(Int32(\(raw: accessor).count))")
        return statements
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
        let printer = CodeFragmentPrinter()
        printer.write("extension \(enumDef.swiftCallName): _BridgedSwiftCaseEnum {")
        printer.indent {
            printer.write(
                multilineString: """
                    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerParameter() -> Int32 {
                        return bridgeJSRawValue
                    }
                    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftReturn(_ value: Int32) -> \(enumDef.swiftCallName) {
                        return bridgeJSLiftParameter(value)
                    }
                    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> \(enumDef.swiftCallName) {
                        return \(enumDef.swiftCallName)(bridgeJSRawValue: value)!
                    }
                    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
                        return bridgeJSLowerParameter()
                    }

                    """
            )
            printer.nextLine()

            printer.write("private init?(bridgeJSRawValue: Int32) {")
            printer.indent {
                printer.write("switch bridgeJSRawValue {")
                for (index, enumCase) in enumDef.cases.enumerated() {
                    printer.write("case \(index):")
                    printer.indent {
                        printer.write("self = .\(enumCase.name)")
                    }
                }
                printer.write("default:")
                printer.indent {
                    printer.write("return nil")
                }
                printer.write("}")
            }
            printer.write("}")
            printer.nextLine()

            printer.write("private var bridgeJSRawValue: Int32 {")
            printer.indent {
                printer.write("switch self {")
                for (index, enumCase) in enumDef.cases.enumerated() {
                    printer.write("case .\(enumCase.name):")
                    printer.indent {
                        printer.write("return \(index)")
                    }
                }
                printer.write("}")
            }
            printer.write("}")
        }
        printer.write("}")
        return "\(raw: printer.lines.joined(separator: "\n"))"
    }

    private func renderRawValueEnumHelpers(_ enumDef: ExportedEnum) -> DeclSyntax {
        let typeName = enumDef.swiftCallName
        guard enumDef.rawType != nil else {
            return """
                extension \(raw: typeName): _BridgedSwiftEnumNoPayload {
                }
                """
        }
        // When rawType is present, conform to _BridgedSwiftRawValueEnum which provides
        // default implementations for _BridgedSwiftStackType methods via protocol extension.
        return """
            extension \(raw: typeName): _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {
            }
            """
    }

    private func renderAssociatedValueEnumHelpers(_ enumDef: ExportedEnum) -> DeclSyntax {
        let typeName = enumDef.swiftCallName
        let printer = CodeFragmentPrinter()
        printer.write("extension \(typeName): _BridgedSwiftAssociatedValueEnum {")
        printer.indent {
            printer.write(
                "@_spi(BridgeJS) @_transparent public static func bridgeJSStackPopPayload(_ caseId: Int32) -> \(typeName) {"
            )
            printer.indent {
                printer.write("switch caseId {")
                generateStackLiftSwitchCases(printer: printer, enumDef: enumDef)
                printer.write("default:")
                printer.indent {
                    printer.write("fatalError(\"Unknown \(typeName) case ID: \\(caseId)\")")
                }
                printer.write("}")
            }
            printer.write("}")
            printer.nextLine()

            printer.write("@_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPushPayload() -> Int32 {")
            printer.indent {
                printer.write("switch self {")
                generateReturnSwitchCases(printer: printer, enumDef: enumDef)
                printer.write("}")
            }
            printer.write("}")
        }
        printer.write("}")
        return "\(raw: printer.lines.joined(separator: "\n"))"
    }

    private func generateStackLiftSwitchCases(printer: CodeFragmentPrinter, enumDef: ExportedEnum) {
        for (caseIndex, enumCase) in enumDef.cases.enumerated() {
            if enumCase.associatedValues.isEmpty {
                printer.write("case \(caseIndex):")
                printer.indent {
                    printer.write("return .\(enumCase.name)")
                }
            } else {
                printer.write("case \(caseIndex):")
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
                printer.indent {
                    printer.write("return .\(enumCase.name)(\(argList.joined(separator: ", ")))")
                }
            }
        }
    }

    private func generatePayloadPushingCode(
        printer: CodeFragmentPrinter,
        associatedValues: [AssociatedValue]
    ) {
        for (index, associatedValue) in associatedValues.enumerated() {
            let paramName = associatedValue.label ?? "param\(index)"
            let statements = stackCodegen.lowerStatements(
                for: associatedValue.type,
                accessor: paramName,
                varPrefix: paramName
            )
            printer.write(multilineString: CodeBlockItemListSyntax(statements).description)
        }
    }

    private func generateReturnSwitchCases(printer: CodeFragmentPrinter, enumDef: ExportedEnum) {
        for (caseIndex, enumCase) in enumDef.cases.enumerated() {
            if enumCase.associatedValues.isEmpty {
                printer.write("case .\(enumCase.name):")
                printer.indent {
                    printer.write("return Int32(\(caseIndex))")
                }
            } else {
                let pattern = enumCase.associatedValues.enumerated()
                    .map { index, associatedValue in "let \(associatedValue.label ?? "param\(index)")" }
                    .joined(separator: ", ")
                printer.write("case .\(enumCase.name)(\(pattern)):")
                printer.indent {
                    generatePayloadPushingCode(printer: printer, associatedValues: enumCase.associatedValues)
                    // Push tag AFTER payloads so it's popped first (LIFO) by the JS lift function.
                    // This ensures nested enum tags don't overwrite the outer tag.
                    printer.write("return Int32(\(caseIndex))")
                }
            }
        }
    }
}

// MARK: - StructCodegen

struct StructCodegen {
    private let stackCodegen = StackCodegen()

    func renderStructHelpers(_ structDef: ExportedStruct) -> [DeclSyntax] {
        let typeName = structDef.swiftCallName

        let lowerExternName = "swift_js_struct_lower_\(structDef.name)"
        let liftExternName = "swift_js_struct_lift_\(structDef.name)"
        let lowerFunctionName = "_bjs_struct_lower_\(structDef.name)"
        let liftFunctionName = "_bjs_struct_lift_\(structDef.name)"

        let printer = CodeFragmentPrinter()
        printer.write("extension \(typeName): _BridgedSwiftStruct {")
        printer.indent {
            printer.write("@_spi(BridgeJS) @_transparent public static func bridgeJSStackPop() -> \(typeName) {")
            printer.indent {
                printer.write(lines: generateStructLiftCode(structDef: structDef))
            }
            printer.write("}")
            printer.nextLine()

            printer.write("@_spi(BridgeJS) @_transparent public consuming func bridgeJSStackPush() {")
            printer.indent {
                printer.write(lines: generateStructLowerCode(structDef: structDef))
            }
            printer.write("}")
            printer.nextLine()

            let accessControl = structDef.explicitAccessControl.map { "\($0) " } ?? ""
            printer.write(
                multilineString: """
                    \(accessControl)init(unsafelyCopying jsObject: JSObject) {
                        \(lowerFunctionName)(jsObject.bridgeJSLowerParameter())
                        self = Self.bridgeJSStackPop()
                    }
                    """
            )
            printer.nextLine()

            printer.write(
                multilineString: """
                    \(accessControl)func toJSObject() -> JSObject {
                        let __bjs_self = self
                        __bjs_self.bridgeJSStackPush()
                        return JSObject(id: UInt32(bitPattern: \(liftFunctionName)()))
                    }
                    """
            )
        }
        printer.write("}")

        let bridgedStructExtension: DeclSyntax = "\(raw: printer.lines.joined(separator: "\n"))"

        let lowerExternDeclPrinter = CodeFragmentPrinter()
        SwiftCodePattern.buildExternFunctionDecl(
            printer: lowerExternDeclPrinter,
            moduleName: "bjs",
            abiName: lowerExternName,
            functionName: lowerFunctionName,
            abiParameters: [("objectId", .i32)],
            returnType: nil
        )
        let liftExternDeclPrinter = CodeFragmentPrinter()
        SwiftCodePattern.buildExternFunctionDecl(
            printer: liftExternDeclPrinter,
            moduleName: "bjs",
            abiName: liftExternName,
            functionName: liftFunctionName,
            abiParameters: [],
            returnType: .i32
        )

        return [
            bridgedStructExtension, "\(raw: lowerExternDeclPrinter.lines.joined(separator: "\n"))",
            "\(raw: liftExternDeclPrinter.lines.joined(separator: "\n"))",
        ]
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
        let printer = CodeFragmentPrinter()
        let instanceProps = structDef.properties.filter { !$0.isStatic }

        for property in instanceProps {
            let accessor = "self.\(property.name)"
            let statements = stackCodegen.lowerStatements(
                for: property.type,
                accessor: accessor,
                varPrefix: property.name
            )
            printer.write(multilineString: CodeBlockItemListSyntax(statements).description)
        }

        return printer.lines
    }
}

// MARK: - ProtocolCodegen

struct ProtocolCodegen {
    func renderProtocolWrapper(_ proto: ExportedProtocol, moduleName: String) throws -> [DeclSyntax] {
        let wrapperName = "Any\(proto.name)"
        let protocolName = proto.name

        var methodDecls: [CodeFragmentPrinter] = []
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
            let externDeclPrinter = CodeFragmentPrinter()
            SwiftCodePattern.buildExternFunctionDecl(
                printer: externDeclPrinter,
                moduleName: moduleName,
                abiName: method.abiName,
                functionName: "_extern_\(method.name)",
                abiParameters: builder.abiParameterSignatures,
                returnType: builder.abiReturnType
            )
            externDecls.append(DeclSyntax("\(raw: externDeclPrinter.lines.joined(separator: "\n"))"))
            let methodImplPrinter = CodeFragmentPrinter()
            methodImplPrinter.write("func \(method.name)\(signature) {")
            methodImplPrinter.indent {
                methodImplPrinter.write(lines: builder.body.lines)
            }
            methodImplPrinter.write("}")
            methodDecls.append(methodImplPrinter)
        }

        var propertyDecls: [CodeFragmentPrinter] = []

        for property in proto.properties {
            let propertyDeclPrinter = CodeFragmentPrinter()
            let propertyExternDecls = try renderProtocolProperty(
                printer: propertyDeclPrinter,
                property: property,
                protocolName: protocolName,
                moduleName: moduleName
            )
            propertyDecls.append(propertyDeclPrinter)
            externDecls.append(contentsOf: propertyExternDecls)
        }

        let structDeclPrinter = CodeFragmentPrinter()
        structDeclPrinter.write("struct \(wrapperName): \(protocolName), _BridgedSwiftProtocolWrapper {")
        structDeclPrinter.indent {
            structDeclPrinter.write("let jsObject: JSObject")
            structDeclPrinter.nextLine()

            for methodDecl in methodDecls {
                structDeclPrinter.write(lines: methodDecl.lines)
                structDeclPrinter.nextLine()
            }

            for decl in propertyDecls {
                structDeclPrinter.write(lines: decl.lines)
                structDeclPrinter.nextLine()
            }
            structDeclPrinter.write(
                multilineString: """
                    static func bridgeJSLiftParameter(_ value: Int32) -> Self {
                        return \(wrapperName)(jsObject: JSObject(id: UInt32(bitPattern: value)))
                    }
                    """
            )
        }
        structDeclPrinter.write("}")

        return ["\(raw: structDeclPrinter.lines.joined(separator: "\n"))"] + externDecls
    }

    private func renderProtocolProperty(
        printer: CodeFragmentPrinter,
        property: ExportedProtocolProperty,
        protocolName: String,
        moduleName: String
    ) throws -> [DeclSyntax] {
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
        let getterExternDeclPrinter = CodeFragmentPrinter()
        SwiftCodePattern.buildExternFunctionDecl(
            printer: getterExternDeclPrinter,
            moduleName: moduleName,
            abiName: getterAbiName,
            functionName: getterAbiName,
            abiParameters: getterBuilder.abiParameterSignatures,
            returnType: getterBuilder.abiReturnType
        )
        let getterExternDecl = DeclSyntax("\(raw: getterExternDeclPrinter.lines.joined(separator: "\n"))")
        var externDecls: [DeclSyntax] = [getterExternDecl]

        printer.write("var \(property.name): \(property.type.swiftType) {")
        try printer.indent {
            printer.write("get {")
            printer.indent {
                printer.write(lines: getterBuilder.body.lines)
            }
            printer.write("}")

            if property.isReadonly { return }

            let setterBuilder = ImportTS.CallJSEmission(
                moduleName: moduleName,
                abiName: setterAbiName,
                context: .exportSwift
            )
            try setterBuilder.lowerParameter(param: Parameter(label: nil, name: "jsObject", type: .jsObject(nil)))
            try setterBuilder.lowerParameter(param: Parameter(label: nil, name: "newValue", type: property.type))
            try setterBuilder.call(returnType: .void)

            // Build setter extern declaration using helper function
            let setterExternDeclPrinter = CodeFragmentPrinter()
            SwiftCodePattern.buildExternFunctionDecl(
                printer: setterExternDeclPrinter,
                moduleName: moduleName,
                abiName: setterAbiName,
                functionName: setterAbiName,
                abiParameters: setterBuilder.abiParameterSignatures,
                returnType: setterBuilder.abiReturnType
            )
            let setterExternDecl = DeclSyntax("\(raw: setterExternDeclPrinter.lines.joined(separator: "\n"))")
            externDecls.append(setterExternDecl)

            printer.write("set {")
            printer.indent {
                printer.write(lines: setterBuilder.body.lines)
            }
            printer.write("}")
        }
        printer.write("}")

        return externDecls
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
        case .jsValue: return "JSValue"
        case .jsObject(nil): return "JSObject"
        case .jsObject(let name?): return name
        case .swiftHeapObject(let name): return name
        case .unsafePointer(let ptr): return ptr.swiftType
        case .swiftProtocol(let name): return "Any\(name)"
        case .void: return "Void"
        case .nullable(let wrappedType, let kind):
            return kind == .null ? "Optional<\(wrappedType.swiftType)>" : "JSUndefinedOr<\(wrappedType.swiftType)>"
        case .array(let elementType): return "[\(elementType.swiftType)]"
        case .dictionary(let valueType): return "[String: \(valueType.swiftType)]"
        case .caseEnum(let name): return name
        case .rawValueEnum(let name, _): return name
        case .associatedValueEnum(let name): return name
        case .swiftStruct(let name): return name
        case .namespaceEnum(let name): return name
        case .closure(let signature, let useJSTypedClosure):
            let paramTypes = signature.parameters.map { $0.swiftType }.joined(separator: ", ")
            let effectsStr = (signature.isAsync ? " async" : "") + (signature.isThrows ? " throws" : "")
            let closureType = "(\(paramTypes))\(effectsStr) -> \(signature.returnType.swiftType)"
            return useJSTypedClosure ? "JSTypedClosure<\(closureType)>" : closureType
        }
    }

    var isClosureType: Bool {
        if case .closure = self { return true }
        return false
    }

    var isStackUsingParameter: Bool {
        switch self {
        case .swiftStruct, .array, .dictionary, .associatedValueEnum:
            return true
        case .nullable(let wrapped, _):
            return wrapped.isStackUsingParameter
        default:
            return false
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
        static let jsValue = LiftingIntrinsicInfo(parameters: [("kind", .i32), ("payload1", .i32), ("payload2", .f64)])
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
        case .jsValue: return .jsValue
        case .swiftHeapObject: return .swiftHeapObject
        case .unsafePointer: return .unsafePointer
        case .swiftProtocol: return .jsObject
        case .void: return .void
        case .nullable(let wrappedType, _):
            let wrappedInfo = try wrappedType.liftParameterInfo()
            if wrappedInfo.parameters.isEmpty {
                return LiftingIntrinsicInfo(parameters: [])
            }
            var optionalParams: [(name: String, type: WasmCoreType)] = [("isSome", .i32)]
            optionalParams.append(contentsOf: wrappedInfo.parameters)
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
        case .array, .dictionary:
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
        static let jsValue = LoweringIntrinsicInfo(returnType: nil)
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
        case .jsValue: return .jsValue
        case .swiftHeapObject: return .swiftHeapObject
        case .unsafePointer: return .unsafePointer
        case .swiftProtocol: return .jsObject
        case .void: return .void
        case .nullable: return .optional
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
            return .jsObject
        case .array, .dictionary:
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
