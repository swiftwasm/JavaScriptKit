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
    private var moduleName: String {
        skeleton.moduleName
    }

    public init(progress: ProgressReporting, moduleName: String) {
        self.progress = progress
        self.skeleton = ImportedModuleSkeleton(moduleName: moduleName, children: [])
    }

    /// Adds a skeleton to the importer's state
    public mutating func addSkeleton(_ skeleton: ImportedFileSkeleton) {
        self.skeleton.children.append(skeleton)
    }

    /// Finalizes the import process and generates Swift code
    public func finalize() throws -> String? {
        var decls: [DeclSyntax] = []
        for skeleton in self.skeleton.children {
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
        let allDecls: [DeclSyntax] = [Self.prelude] + decls
        return allDecls.map { $0.formatted(using: format).description }.joined(separator: "\n\n")
    }

    class ImportedThunkBuilder {
        let abiName: String
        let moduleName: String

        var body: [CodeBlockItemSyntax] = []
        var abiParameterForwardings: [LabeledExprSyntax] = []
        var abiParameterSignatures: [(name: String, type: WasmCoreType)] = []
        var abiReturnType: WasmCoreType?

        init(moduleName: String, abiName: String) {
            self.moduleName = moduleName
            self.abiName = abiName
        }

        func lowerParameter(param: Parameter) throws {
            let loweringInfo = try param.type.loweringParameterInfo()
            assert(
                loweringInfo.loweredParameters.count == 1,
                "For now, we require a single parameter to be lowered to a single Wasm core type"
            )
            let (_, type) = loweringInfo.loweredParameters[0]
            abiParameterForwardings.append(
                LabeledExprSyntax(
                    label: param.label,
                    expression: ExprSyntax("\(raw: param.name).bridgeJSLowerParameter()")
                )
            )
            abiParameterSignatures.append((param.name, type))
        }

        func call(returnType: BridgeType) {
            let call: ExprSyntax =
                "\(raw: abiName)(\(raw: abiParameterForwardings.map { $0.description }.joined(separator: ", ")))"
            if returnType == .void {
                body.append("\(raw: call)")
            } else {
                body.append("let ret = \(raw: call)")
            }
            body.append("if let error = _swift_js_take_exception() { throw error }")
        }

        func liftReturnValue(returnType: BridgeType) throws {
            let liftingInfo = try returnType.liftingReturnInfo()
            abiReturnType = liftingInfo.valueToLift
            if returnType == .void {
                return
            }
            body.append("return \(raw: returnType.swiftType).bridgeJSLiftReturn(ret)")
        }

        func assignThis(returnType: BridgeType) {
            guard case .jsObject = returnType else {
                preconditionFailure("assignThis can only be called with a jsObject return type")
            }
            abiReturnType = .i32
            body.append("self.jsObject = JSObject(id: UInt32(bitPattern: ret))")
        }

        func renderImportDecl() -> DeclSyntax {
            let baseDecl = FunctionDeclSyntax(
                modifiers: DeclModifierListSyntax(itemsBuilder: {
                    DeclModifierSyntax(name: .keyword(.fileprivate)).with(\.trailingTrivia, .space)
                }),
                funcKeyword: .keyword(.func).with(\.trailingTrivia, .space),
                name: .identifier(abiName),
                signature: FunctionSignatureSyntax(
                    parameterClause: FunctionParameterClauseSyntax(parametersBuilder: {
                        for param in abiParameterSignatures {
                            FunctionParameterSyntax(
                                firstName: .wildcardToken().with(\.trailingTrivia, .space),
                                secondName: .identifier(param.name),
                                type: IdentifierTypeSyntax(name: .identifier(param.type.swiftType))
                            )
                        }
                    }),
                    returnClause: ReturnClauseSyntax(
                        arrow: .arrowToken(),
                        type: IdentifierTypeSyntax(name: .identifier(abiReturnType.map { $0.swiftType } ?? "Void"))
                    )
                )
            )
            var externDecl = baseDecl
            externDecl.attributes = AttributeListSyntax(itemsBuilder: {
                "@_extern(wasm, module: \"\(raw: moduleName)\", name: \"\(raw: abiName)\")"
            }).with(\.trailingTrivia, .newline)
            var stubDecl = baseDecl
            stubDecl.body = CodeBlockSyntax {
                """
                fatalError("Only available on WebAssembly")
                """
            }
            return """
                #if arch(wasm32)
                \(externDecl)
                #else
                \(stubDecl)
                #endif
                """
        }

        func renderThunkDecl(name: String, parameters: [Parameter], returnType: BridgeType) -> DeclSyntax {
            let isAsync: Bool
            if case .jsPromise = returnType {
                print(returnType)
                isAsync = true
            } else {
                isAsync = false
            }
            return DeclSyntax(
                FunctionDeclSyntax(
                    name: .identifier(name.backtickIfNeeded()),
                    signature: FunctionSignatureSyntax(
                        parameterClause: FunctionParameterClauseSyntax(parametersBuilder: {
                            for param in parameters {
                                FunctionParameterSyntax(
                                    firstName: .wildcardToken(),
                                    secondName: .identifier(param.name),
                                    colon: .colonToken(),
                                    type: IdentifierTypeSyntax(name: .identifier(param.type.swiftType))
                                )
                            }
                        }),
                        effectSpecifiers: ImportTS.buildFunctionEffect(throws: true, async: isAsync),
                        returnClause: ReturnClauseSyntax(
                            arrow: .arrowToken(),
                            type: IdentifierTypeSyntax(name: .identifier(returnType.swiftType))
                        )
                    ),
                    body: CodeBlockSyntax {
                        body
                    }
                )
            )
        }

        func renderConstructorDecl(parameters: [Parameter]) -> DeclSyntax {
            return DeclSyntax(
                InitializerDeclSyntax(
                    signature: FunctionSignatureSyntax(
                        parameterClause: FunctionParameterClauseSyntax(
                            parametersBuilder: {
                                for param in parameters {
                                    FunctionParameterSyntax(
                                        firstName: .wildcardToken(),
                                        secondName: .identifier(param.name),
                                        type: IdentifierTypeSyntax(name: .identifier(param.type.swiftType))
                                    )
                                }
                            }
                        ),
                        effectSpecifiers: ImportTS.buildFunctionEffect(throws: true, async: false)
                    ),
                    bodyBuilder: {
                        body
                    }
                )
            )
        }
    }

    static let prelude: DeclSyntax = """
        // NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
        // DO NOT EDIT.
        //
        // To update this file, just rebuild your project or run
        // `swift package bridge-js`.

        @_spi(BridgeJS) import JavaScriptKit
        """

    func renderSwiftThunk(
        _ function: ImportedFunctionSkeleton,
        topLevelDecls: inout [DeclSyntax]
    ) throws -> [DeclSyntax] {
        let builder = ImportedThunkBuilder(moduleName: moduleName, abiName: function.abiName(context: nil))
        for param in function.parameters {
            try builder.lowerParameter(param: param)
        }
        builder.call(returnType: function.returnType)
        try builder.liftReturnValue(returnType: function.returnType)
        topLevelDecls.append(builder.renderImportDecl())
        return [
            builder.renderThunkDecl(
                name: function.name,
                parameters: function.parameters,
                returnType: function.returnType
            )
            .with(\.leadingTrivia, Self.renderDocumentation(documentation: function.documentation))
        ]
    }

    func renderSwiftType(_ type: ImportedTypeSkeleton, topLevelDecls: inout [DeclSyntax]) throws -> [DeclSyntax] {
        let name = type.name

        func renderMethod(method: ImportedFunctionSkeleton) throws -> [DeclSyntax] {
            let builder = ImportedThunkBuilder(moduleName: moduleName, abiName: method.abiName(context: type))
            try builder.lowerParameter(param: Parameter(label: nil, name: "self", type: .jsObject(name)))
            for param in method.parameters {
                try builder.lowerParameter(param: param)
            }
            builder.call(returnType: method.returnType)
            try builder.liftReturnValue(returnType: method.returnType)
            topLevelDecls.append(builder.renderImportDecl())
            return [
                builder.renderThunkDecl(
                    name: method.name,
                    parameters: method.parameters,
                    returnType: method.returnType
                )
                .with(\.leadingTrivia, Self.renderDocumentation(documentation: method.documentation))
            ]
        }

        func renderConstructorDecl(constructor: ImportedConstructorSkeleton) throws -> [DeclSyntax] {
            let builder = ImportedThunkBuilder(moduleName: moduleName, abiName: constructor.abiName(context: type))
            for param in constructor.parameters {
                try builder.lowerParameter(param: param)
            }
            builder.call(returnType: .jsObject(name))
            builder.assignThis(returnType: .jsObject(name))
            topLevelDecls.append(builder.renderImportDecl())
            return [
                builder.renderConstructorDecl(parameters: constructor.parameters)
            ]
        }

        func renderGetterDecl(property: ImportedPropertySkeleton) throws -> AccessorDeclSyntax {
            let builder = ImportedThunkBuilder(
                moduleName: moduleName,
                abiName: property.getterAbiName(context: type)
            )
            try builder.lowerParameter(param: Parameter(label: nil, name: "self", type: .jsObject(name)))
            builder.call(returnType: property.type)
            try builder.liftReturnValue(returnType: property.type)
            topLevelDecls.append(builder.renderImportDecl())
            return AccessorDeclSyntax(
                accessorSpecifier: .keyword(.get),
                effectSpecifiers: Self.buildAccessorEffect(throws: true, async: false),
                body: CodeBlockSyntax {
                    builder.body
                }
            )
        }

        func renderSetterDecl(property: ImportedPropertySkeleton) throws -> DeclSyntax {
            let builder = ImportedThunkBuilder(
                moduleName: moduleName,
                abiName: property.setterAbiName(context: type)
            )
            let newValue = Parameter(label: nil, name: "newValue", type: property.type)
            try builder.lowerParameter(param: Parameter(label: nil, name: "self", type: .jsObject(name)))
            try builder.lowerParameter(param: newValue)
            builder.call(returnType: .void)
            topLevelDecls.append(builder.renderImportDecl())
            return builder.renderThunkDecl(
                name: "set\(property.name.capitalizedFirstLetter)",
                parameters: [newValue],
                returnType: .void
            )
        }

        func renderPropertyDecl(property: ImportedPropertySkeleton) throws -> [DeclSyntax] {
            let accessorDecls: [AccessorDeclSyntax] = [try renderGetterDecl(property: property)]
            var decls: [DeclSyntax] = [
                DeclSyntax(
                    VariableDeclSyntax(
                        leadingTrivia: Self.renderDocumentation(documentation: property.documentation),
                        bindingSpecifier: .keyword(.var),
                        bindingsBuilder: {
                            PatternBindingListSyntax {
                                PatternBindingSyntax(
                                    pattern: IdentifierPatternSyntax(
                                        identifier: .identifier(property.name.backtickIfNeeded())
                                    ),
                                    typeAnnotation: TypeAnnotationSyntax(
                                        type: IdentifierTypeSyntax(name: .identifier(property.type.swiftType))
                                    ),
                                    accessorBlock: AccessorBlockSyntax(
                                        accessors: .accessors(
                                            AccessorDeclListSyntax(accessorDecls)
                                        )
                                    )
                                )
                            }
                        }
                    )
                )
            ]
            if !property.isReadonly {
                decls.append(try renderSetterDecl(property: property))
            }
            return decls
        }
        let classDecl = try StructDeclSyntax(
            leadingTrivia: Self.renderDocumentation(documentation: type.documentation),
            name: .identifier(name),
            inheritanceClause: InheritanceClauseSyntax(
                inheritedTypesBuilder: {
                    InheritedTypeSyntax(type: TypeSyntax("_JSBridgedClass"))
                }
            ),
            memberBlockBuilder: {
                DeclSyntax(
                    """
                    let jsObject: JSObject
                    """
                ).with(\.trailingTrivia, .newlines(2))

                DeclSyntax(
                    """
                    init(unsafelyWrapping jsObject: JSObject) {
                        self.jsObject = jsObject
                    }
                    """
                ).with(\.trailingTrivia, .newlines(2))

                if let constructor = type.constructor {
                    try renderConstructorDecl(constructor: constructor).map { $0.with(\.trailingTrivia, .newlines(2)) }
                }

                for property in type.properties {
                    try renderPropertyDecl(property: property).map { $0.with(\.trailingTrivia, .newlines(2)) }
                }

                for method in type.methods {
                    try renderMethod(method: method).map { $0.with(\.trailingTrivia, .newlines(2)) }
                }
            }
        )

        return [DeclSyntax(classDecl)]
    }

    static func renderDocumentation(documentation: String?) -> Trivia {
        guard let documentation = documentation else {
            return Trivia()
        }
        let lines = documentation.split { $0.isNewline }
        return Trivia(pieces: lines.flatMap { [TriviaPiece.docLineComment("/// \($0)"), .newlines(1)] })
    }

    static func buildFunctionEffect(throws: Bool, async: Bool) -> FunctionEffectSpecifiersSyntax {
        return FunctionEffectSpecifiersSyntax(
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
        case .int: return .int
        case .float: return .float
        case .double: return .double
        case .string: return .string
        case .jsObject, .jsPromise: return .jsObject
        case .void: return .void
        case .closure:
            throw BridgeJSCoreError("Closure types are not yet supported in TypeScript imports")
        case .swiftHeapObject(let className):
            switch context {
            case .importTS:
                throw BridgeJSCoreError(
                    """
                    swiftHeapObject '\(className)' is not supported in TypeScript imports.
                    Swift classes can only be used in @JS protocols where Swift owns the instance.
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
                throw BridgeJSCoreError("Enum types are not yet supported in TypeScript imports")
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
                throw BridgeJSCoreError("Swift structs are not yet supported in TypeScript imports")
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
        case .int: return .int
        case .float: return .float
        case .double: return .double
        case .string: return .string
        case .jsObject, .jsPromise: return .jsObject
        case .void: return .void
        case .closure:
            throw BridgeJSCoreError("Closure types are not yet supported in TypeScript imports")
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
                throw BridgeJSCoreError("Enum types are not yet supported in TypeScript imports")
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
                throw BridgeJSCoreError("Swift structs are not yet supported in TypeScript imports")
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
        }
    }
}

extension String {
    func backtickIfNeeded() -> String {
        return self.isValidSwiftIdentifier(for: .variableName) ? self : "`\(self)`"
    }
}
