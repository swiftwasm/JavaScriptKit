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
            for getter in skeleton.globalGetters {
                let getterDecls = try renderSwiftGlobalGetter(getter, topLevelDecls: &decls)
                decls.append(contentsOf: getterDecls)
            }
            for function in skeleton.functions {
                let thunkDecls = try renderSwiftThunk(function, topLevelDecls: &decls)
                decls.append(contentsOf: thunkDecls)
            }
            for type in skeleton.types {
                let typeDecls = try renderSwiftType(type, topLevelDecls: &decls)
                decls.append(contentsOf: typeDecls)
            }
        }
        if decls.isEmpty {
            // No declarations to import
            return nil
        }

        let format = BasicFormat()
        return decls.map { $0.formatted(using: format).description }.joined(separator: "\n\n")
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

        var body: [CodeBlockItemSyntax] = []
        var abiParameterForwardings: [LabeledExprSyntax] = []
        var abiParameterSignatures: [(name: String, type: WasmCoreType)] = []
        var abiReturnType: WasmCoreType?
        // Track destructured variable names for multiple lowered parameters
        var destructuredVarNames: [String] = []

        init(moduleName: String, abiName: String, context: BridgeContext = .importTS) {
            self.moduleName = moduleName
            self.abiName = abiName
            self.context = context
        }

        func lowerParameter(param: Parameter) throws {
            let loweringInfo = try param.type.loweringParameterInfo(context: context)

            // Generate destructured variable names for all lowered parameters
            let destructuredNames = loweringInfo.loweredParameters.map {
                "\(param.name)\($0.name.capitalizedFirstLetter)"
            }

            let initializerExpr: ExprSyntax
            switch param.type {
            case .closure(let signature):
                initializerExpr = ExprSyntax(
                    "_BJS_Closure_\(raw: signature.mangleName).bridgeJSLower(\(raw: param.name))"
                )
            default:
                initializerExpr = ExprSyntax("\(raw: param.name).bridgeJSLowerParameter()")
            }

            // Always add destructuring statement to body (unified for single and multiple)
            let pattern: PatternSyntax
            if destructuredNames.count == 1 {
                pattern = PatternSyntax(IdentifierPatternSyntax(identifier: .identifier(destructuredNames[0])))
            } else {
                pattern = PatternSyntax(
                    TuplePatternSyntax {
                        for name in destructuredNames {
                            TuplePatternElementSyntax(
                                pattern: IdentifierPatternSyntax(identifier: .identifier(name))
                            )
                        }
                    }
                )
            }

            body.append(
                CodeBlockItemSyntax(
                    item: .decl(
                        DeclSyntax(
                            VariableDeclSyntax(
                                bindingSpecifier: .keyword(.let),
                                bindings: PatternBindingListSyntax {
                                    PatternBindingSyntax(
                                        pattern: pattern,
                                        initializer: InitializerClauseSyntax(
                                            value: initializerExpr
                                        )
                                    )
                                }
                            )
                        )
                    )
                )
            )
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
                let callExpr = ExprSyntax("\(raw: destructuredNames[index])")
                abiParameterForwardings.append(
                    LabeledExprSyntax(expression: callExpr)
                )
            }
        }

        func call(returnType: BridgeType) throws {
            // Build function call expression
            let callExpr = FunctionCallExprSyntax(
                calledExpression: ExprSyntax("\(raw: abiName)"),
                leftParen: .leftParenToken(),
                arguments: LabeledExprListSyntax {
                    for forwarding in abiParameterForwardings {
                        forwarding
                    }
                },
                rightParen: .rightParenToken()
            )

            if returnType == .void {
                body.append(CodeBlockItemSyntax(item: .stmt(StmtSyntax(ExpressionStmtSyntax(expression: callExpr)))))
            } else if returnType.usesSideChannelForOptionalReturn() {
                // Side channel returns don't need "let ret ="
                body.append(CodeBlockItemSyntax(item: .stmt(StmtSyntax(ExpressionStmtSyntax(expression: callExpr)))))
            } else {
                body.append("let ret = \(raw: callExpr)")
            }

            // Add exception check for ImportTS context
            if context == .importTS {
                body.append("if let error = _swift_js_take_exception() { throw error }")
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
                body.append(
                    CodeBlockItemSyntax(
                        item: .stmt(
                            StmtSyntax(
                                ReturnStmtSyntax(
                                    expression: ExprSyntax(
                                        "\(raw: returnType.swiftType).bridgeJSLiftReturnFromSideChannel()"
                                    )
                                )
                            )
                        )
                    )
                )
            } else {
                abiReturnType = liftingInfo.valueToLift
                let liftExpr: ExprSyntax
                switch returnType {
                case .closure(let signature):
                    liftExpr = ExprSyntax("_BJS_Closure_\(raw: signature.mangleName).bridgeJSLift(ret)")
                default:
                    if liftingInfo.valueToLift != nil {
                        liftExpr = "\(raw: returnType.swiftType).bridgeJSLiftReturn(ret)"
                    } else {
                        liftExpr = "\(raw: returnType.swiftType).bridgeJSLiftReturn()"
                    }
                }
                body.append(
                    CodeBlockItemSyntax(
                        item: .stmt(
                            StmtSyntax(
                                ReturnStmtSyntax(expression: liftExpr)
                            )
                        )
                    )
                )
            }
        }

        func getBody() -> CodeBlockSyntax {
            return CodeBlockSyntax(statements: CodeBlockItemListSyntax(body))
        }

        func assignThis(returnType: BridgeType) {
            guard case .jsObject = returnType else {
                preconditionFailure("assignThis can only be called with a jsObject return type")
            }
            abiReturnType = .i32
            body.append("self.jsObject = JSObject(id: UInt32(bitPattern: ret))")
        }

        func renderImportDecl() -> DeclSyntax {
            let signature = SwiftSignatureBuilder.buildABIFunctionSignature(
                abiParameters: abiParameterSignatures,
                returnType: abiReturnType
            )

            // Build extern function declaration (no body)
            let externFuncDecl = FunctionDeclSyntax(
                attributes: SwiftCodePattern.buildExternAttribute(moduleName: moduleName, abiName: abiName),
                modifiers: DeclModifierListSyntax {
                    DeclModifierSyntax(name: .keyword(.fileprivate)).with(\.trailingTrivia, .space)
                },
                funcKeyword: .keyword(.func).with(\.trailingTrivia, .space),
                name: .identifier(abiName),
                signature: signature
            )

            // Build stub function declaration (with fatalError body)
            let stubFuncDecl = FunctionDeclSyntax(
                modifiers: DeclModifierListSyntax {
                    DeclModifierSyntax(name: .keyword(.fileprivate)).with(\.trailingTrivia, .space)
                },
                funcKeyword: .keyword(.func).with(\.trailingTrivia, .space),
                name: .identifier(abiName),
                signature: signature,
                body: CodeBlockSyntax {
                    "fatalError(\"Only available on WebAssembly\")"
                }
            )

            // Use conditional compilation helper
            return DeclSyntax(
                SwiftCodePattern.buildWasmConditionalCompilationDecls(
                    wasmDecl: DeclSyntax(externFuncDecl),
                    elseDecl: DeclSyntax(stubFuncDecl)
                )
            )
        }

        func renderThunkDecl(name: String, parameters: [Parameter], returnType: BridgeType) -> DeclSyntax {
            let effects = Effects(isAsync: false, isThrows: true)
            let signature = SwiftSignatureBuilder.buildFunctionSignature(
                parameters: parameters,
                returnType: returnType,
                effects: effects,
                useWildcardLabels: true
            )
            return DeclSyntax(
                FunctionDeclSyntax(
                    name: .identifier(name.backtickIfNeeded()),
                    signature: signature,
                    body: CodeBlockSyntax {
                        body
                    }
                )
            )
        }

        func renderConstructorDecl(parameters: [Parameter]) -> DeclSyntax {
            let effects = Effects(isAsync: false, isThrows: true)
            // Constructors don't have return types, so build signature without return clause
            let signature = FunctionSignatureSyntax(
                parameterClause: SwiftSignatureBuilder.buildParameterClause(
                    parameters: parameters,
                    useWildcardLabels: true
                ),
                effectSpecifiers: SwiftSignatureBuilder.buildEffectSpecifiers(effects: effects)
            )
            return DeclSyntax(
                InitializerDeclSyntax(
                    signature: signature,
                    bodyBuilder: {
                        body
                    }
                )
            )
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
    ) -> FunctionSignatureSyntax {
        return FunctionSignatureSyntax(
            parameterClause: buildParameterClause(parameters: parameters, useWildcardLabels: useWildcardLabels),
            effectSpecifiers: effects.flatMap { buildEffectSpecifiers(effects: $0) },
            returnClause: buildReturnClause(returnType: returnType)
        )
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
    ) -> FunctionSignatureSyntax {
        return FunctionSignatureSyntax(
            parameterClause: buildABIParameterClause(abiParameters: abiParameters),
            effectSpecifiers: effects.flatMap { buildEffectSpecifiers(effects: $0) },
            returnClause: buildABIReturnClause(returnType: returnType)
        )
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
    ) -> FunctionParameterClauseSyntax {
        return FunctionParameterClauseSyntax(parametersBuilder: {
            for param in parameters {
                let paramTypeSyntax = buildParameterTypeSyntax(from: param.type)
                if useWildcardLabels {
                    // Always use wildcard labels: "_ name: Type"
                    FunctionParameterSyntax(
                        firstName: .wildcardToken(),
                        secondName: .identifier(param.name),
                        colon: .colonToken(),
                        type: paramTypeSyntax
                    )
                } else {
                    let label = param.label ?? param.name
                    if label == param.name {
                        // External label same as parameter name: "count: Int"
                        FunctionParameterSyntax(
                            firstName: .identifier(label),
                            secondName: nil,
                            colon: .colonToken(),
                            type: paramTypeSyntax
                        )
                    } else if param.label == nil {
                        // No label specified: use wildcard "_ name: Type"
                        FunctionParameterSyntax(
                            firstName: .wildcardToken(),
                            secondName: .identifier(param.name),
                            colon: .colonToken(),
                            type: paramTypeSyntax
                        )
                    } else {
                        // External label differs: "label count: Int"
                        FunctionParameterSyntax(
                            firstName: .identifier(label),
                            secondName: .identifier(param.name),
                            colon: .colonToken(),
                            type: paramTypeSyntax
                        )
                    }
                }
            }
        })
    }

    /// Builds a parameter clause for ABI/extern functions
    ///
    /// All parameters use wildcard labels: "_ name: Type"
    static func buildABIParameterClause(
        abiParameters: [(name: String, type: WasmCoreType)]
    ) -> FunctionParameterClauseSyntax {
        return FunctionParameterClauseSyntax(parametersBuilder: {
            for param in abiParameters {
                FunctionParameterSyntax(
                    firstName: .wildcardToken().with(\.trailingTrivia, .space),
                    secondName: .identifier(param.name),
                    type: IdentifierTypeSyntax(name: .identifier(param.type.swiftType))
                )
            }
        })
    }

    /// Builds a return clause from a BridgeType
    ///
    /// Always returns a ReturnClauseSyntax, including for Void types
    /// (to match original behavior that explicitly includes "-> Void")
    static func buildReturnClause(returnType: BridgeType) -> ReturnClauseSyntax? {
        return ReturnClauseSyntax(
            arrow: .arrowToken(),
            type: buildTypeSyntax(from: returnType)
        )
    }

    /// Builds a return clause for ABI/extern functions
    ///
    /// Returns nil for Void (when returnType is nil), otherwise returns a ReturnClauseSyntax
    static func buildABIReturnClause(returnType: WasmCoreType?) -> ReturnClauseSyntax? {
        guard let returnType = returnType else {
            return ReturnClauseSyntax(
                arrow: .arrowToken(),
                type: IdentifierTypeSyntax(name: .identifier("Void"))
            )
        }
        return ReturnClauseSyntax(
            arrow: .arrowToken(),
            type: IdentifierTypeSyntax(name: .identifier(returnType.swiftType))
        )
    }

    /// Builds effect specifiers (async/throws) from an Effects struct
    ///
    /// Uses JSException as the thrown error type for throws clauses
    static func buildEffectSpecifiers(effects: Effects) -> FunctionEffectSpecifiersSyntax? {
        guard effects.isAsync || effects.isThrows else {
            return nil
        }
        return FunctionEffectSpecifiersSyntax(
            asyncSpecifier: effects.isAsync ? .keyword(.async) : nil,
            throwsClause: effects.isThrows
                ? ThrowsClauseSyntax(
                    throwsSpecifier: .keyword(.throws),
                    leftParen: .leftParenToken(),
                    type: IdentifierTypeSyntax(name: .identifier("JSException")),
                    rightParen: .rightParenToken()
                ) : nil
        )
    }

    /// Builds a TypeSyntax node from a BridgeType
    ///
    /// Converts BridgeType to its Swift type representation as a TypeSyntax node
    static func buildTypeSyntax(from type: BridgeType) -> TypeSyntax {
        let identifierType = IdentifierTypeSyntax(name: .identifier(type.swiftType))
        return TypeSyntax(identifierType)
    }

    /// Builds a parameter type syntax from a BridgeType.
    ///
    /// Swift closure parameters must be `@escaping` because they are boxed and can be invoked from JavaScript.
    static func buildParameterTypeSyntax(from type: BridgeType) -> TypeSyntax {
        switch type {
        case .closure:
            return TypeSyntax("@escaping \(raw: type.swiftType)")
        default:
            return buildTypeSyntax(from: type)
        }
    }
}

enum SwiftCodePattern {
    /// Builds a conditional compilation block with #if arch(wasm32) and #else fatalError
    static func buildWasmConditionalCompilation(
        wasmBody: CodeBlockItemListSyntax
    ) -> IfConfigDeclSyntax {
        return IfConfigDeclSyntax(
            clauses: IfConfigClauseListSyntax {
                IfConfigClauseSyntax(
                    poundKeyword: .poundIfToken(),
                    condition: ExprSyntax("arch(wasm32)"),
                    elements: .statements(wasmBody)
                )
                IfConfigClauseSyntax(
                    poundKeyword: .poundElseToken(),
                    elements: .statements(
                        CodeBlockItemListSyntax {
                            "fatalError(\"Only available on WebAssembly\")"
                        }
                    )
                )
            }
        )
    }

    /// Builds a conditional compilation block with #if arch(wasm32) and #else for declarations
    static func buildWasmConditionalCompilationDecls(
        wasmDecl: DeclSyntax,
        elseDecl: DeclSyntax
    ) -> IfConfigDeclSyntax {
        return IfConfigDeclSyntax(
            clauses: IfConfigClauseListSyntax {
                IfConfigClauseSyntax(
                    poundKeyword: .poundIfToken(),
                    condition: ExprSyntax("arch(wasm32)"),
                    elements: .statements(
                        CodeBlockItemListSyntax {
                            CodeBlockItemSyntax(item: .decl(wasmDecl))
                        }
                    )
                )
                IfConfigClauseSyntax(
                    poundKeyword: .poundElseToken(),
                    elements: .statements(
                        CodeBlockItemListSyntax {
                            CodeBlockItemSyntax(item: .decl(elseDecl))
                        }
                    )
                )
            }
        )
    }

    /// Builds the @_extern attribute for WebAssembly extern function declarations
    /// Builds an @_extern function declaration (no body, just the declaration)
    static func buildExternFunctionDecl(
        moduleName: String,
        abiName: String,
        functionName: String,
        signature: FunctionSignatureSyntax
    ) -> FunctionDeclSyntax {
        return FunctionDeclSyntax(
            attributes: buildExternAttribute(moduleName: moduleName, abiName: abiName),
            modifiers: DeclModifierListSyntax {
                DeclModifierSyntax(name: .keyword(.fileprivate))
            },
            funcKeyword: .keyword(.func),
            name: .identifier(functionName),
            signature: signature
        )
    }

    /// Builds the standard @_expose and @_cdecl attributes for WebAssembly-exposed functions
    static func buildExposeAttributes(abiName: String) -> AttributeListSyntax {
        return AttributeListSyntax {
            #if canImport(SwiftSyntax602)
            let exposeAttrArgs = AttributeSyntax.Arguments.argumentList(
                LabeledExprListSyntax {
                    LabeledExprSyntax(label: nil, expression: DeclReferenceExprSyntax(baseName: "wasm"))
                        .with(\.trailingComma, .commaToken())
                    LabeledExprSyntax(label: nil, expression: StringLiteralExprSyntax(content: abiName))
                }
            )
            let cdeclAttrArgs = AttributeSyntax.Arguments.argumentList(
                [
                    LabeledExprSyntax(label: nil, expression: StringLiteralExprSyntax(content: abiName))
                ]
            )
            #else
            let exposeAttrArgs = AttributeSyntax.Arguments.exposeAttributeArguments(
                ExposeAttributeArgumentsSyntax(
                    language: .identifier("wasm"),
                    comma: .commaToken(),
                    cxxName: StringLiteralExprSyntax(content: abiName)
                )
            )
            let cdeclAttrArgs = AttributeSyntax.Arguments.string(StringLiteralExprSyntax(content: abiName))
            #endif
            AttributeSyntax(
                attributeName: IdentifierTypeSyntax(name: .identifier("_expose")),
                leftParen: .leftParenToken(),
                arguments: exposeAttrArgs,
                rightParen: .rightParenToken()
            )
            .with(\.trailingTrivia, .newline)

            AttributeSyntax(
                attributeName: IdentifierTypeSyntax(name: .identifier("_cdecl")),
                leftParen: .leftParenToken(),
                arguments: cdeclAttrArgs,
                rightParen: .rightParenToken()
            )
            .with(\.trailingTrivia, .newline)
        }
    }

    /// Builds a function declaration with @_expose/@_cdecl attributes and conditional compilation
    static func buildExposedFunctionDecl(
        abiName: String,
        signature: FunctionSignatureSyntax,
        body: CodeBlockItemListSyntax
    ) -> FunctionDeclSyntax {
        let funcBody = CodeBlockSyntax {
            buildWasmConditionalCompilation(wasmBody: body)
        }

        return FunctionDeclSyntax(
            attributes: buildExposeAttributes(abiName: abiName),
            modifiers: DeclModifierListSyntax {
                DeclModifierSyntax(name: .keyword(.public))
            },
            funcKeyword: .keyword(.func),
            name: .identifier("_\(abiName)"),
            signature: signature,
            body: funcBody
        )
    }

    /// Builds the @_extern attribute for WebAssembly extern function declarations
    static func buildExternAttribute(moduleName: String, abiName: String) -> AttributeListSyntax {
        return AttributeListSyntax {
            AttributeSyntax(
                attributeName: IdentifierTypeSyntax(name: .identifier("_extern")),
                leftParen: .leftParenToken(),
                arguments: .argumentList(
                    LabeledExprListSyntax {
                        LabeledExprSyntax(
                            expression: ExprSyntax("wasm")
                        )
                        LabeledExprSyntax(
                            label: .identifier("module"),
                            colon: .colonToken(),
                            expression: StringLiteralExprSyntax(content: moduleName)
                        )
                        LabeledExprSyntax(
                            label: .identifier("name"),
                            colon: .colonToken(),
                            expression: StringLiteralExprSyntax(content: abiName)
                        )
                    }
                ),
                rightParen: .rightParenToken()
            )
            .with(\.trailingTrivia, .newline)
        }
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
        case .void: return .void
        case .closure:
            // Swift closure is boxed and passed to JS as a pointer.
            return LoweringParameterInfo(loweredParameters: [("pointer", .pointer)])
        case .unsafePointer:
            return LoweringParameterInfo(loweredParameters: [("pointer", .pointer)])
        case .swiftHeapObject(let className):
            switch context {
            case .importTS:
                throw BridgeJSCoreError(
                    """
                    swiftHeapObject '\(className)' is not supported in TypeScript imports.
                    Pass Swift instances through exported @JS classes or structs instead.
                    """
                )
            case .exportSwift:
                return LoweringParameterInfo(loweredParameters: [("pointer", .pointer)])
            }
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
            switch context {
            case .importTS:
                return LoweringParameterInfo(loweredParameters: [("value", rawType.wasmCoreType ?? .i32)])
            case .exportSwift:
                // For protocol export we return .i32 for String raw value type instead of nil
                return LoweringParameterInfo(loweredParameters: [("value", rawType.wasmCoreType ?? .i32)])
            }
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
        case .optional(let wrappedType):
            switch context {
            case .importTS:
                throw BridgeJSCoreError("Optional types are not yet supported in TypeScript imports")
            case .exportSwift:
                let wrappedInfo = try wrappedType.loweringParameterInfo(context: context)
                var params = [("isSome", WasmCoreType.i32)]
                params.append(contentsOf: wrappedInfo.loweredParameters)
                return LoweringParameterInfo(loweredParameters: params)
            }
        case .array:
            switch context {
            case .importTS:
                throw BridgeJSCoreError("Array types are not yet supported in TypeScript imports")
            case .exportSwift:
                return LoweringParameterInfo(loweredParameters: [])
            }
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
        case .void: return .void
        case .closure:
            // JS returns a callback ID for closures, which Swift lifts to a typed closure.
            return LiftingReturnInfo(valueToLift: .i32)
        case .unsafePointer:
            return LiftingReturnInfo(valueToLift: .pointer)
        case .swiftHeapObject(let className):
            switch context {
            case .importTS:
                throw BridgeJSCoreError(
                    """
                    swiftHeapObject '\(className)' cannot be returned from imported TypeScript functions.
                    JavaScript cannot create Swift heap objects.
                    """
                )
            case .exportSwift:
                return LiftingReturnInfo(valueToLift: .pointer)
            }
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
            switch context {
            case .importTS:
                return LiftingReturnInfo(valueToLift: rawType.wasmCoreType ?? .i32)
            case .exportSwift:
                // For protocol export we return .i32 for String raw value type instead of nil
                return LiftingReturnInfo(valueToLift: rawType.wasmCoreType ?? .i32)
            }
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
        case .optional(let wrappedType):
            switch context {
            case .importTS:
                throw BridgeJSCoreError("Optional types are not yet supported in TypeScript imports")
            case .exportSwift:
                let wrappedInfo = try wrappedType.liftingReturnInfo(context: context)
                return LiftingReturnInfo(valueToLift: wrappedInfo.valueToLift)
            }
        case .array:
            switch context {
            case .importTS:
                throw BridgeJSCoreError("Array types are not yet supported in TypeScript imports")
            case .exportSwift:
                return LiftingReturnInfo(valueToLift: nil)
            }
        }
    }
}

extension String {
    func backtickIfNeeded() -> String {
        return self.isValidSwiftIdentifier(for: .variableName) ? self : "`\(self)`"
    }
}
