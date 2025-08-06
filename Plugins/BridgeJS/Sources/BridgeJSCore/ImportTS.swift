import SwiftBasicFormat
import SwiftSyntax
import SwiftSyntaxBuilder
#if canImport(BridgeJSSkeleton)
import BridgeJSSkeleton
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
            switch param.type {
            case .bool:
                abiParameterForwardings.append(
                    LabeledExprSyntax(
                        label: param.label,
                        expression: ExprSyntax("Int32(\(raw: param.name) ? 1 : 0)")
                    )
                )
                abiParameterSignatures.append((param.name, .i32))
            case .int:
                abiParameterForwardings.append(
                    LabeledExprSyntax(
                        label: param.label,
                        expression: ExprSyntax("\(raw: param.name)")
                    )
                )
                abiParameterSignatures.append((param.name, .i32))
            case .float:
                abiParameterForwardings.append(
                    LabeledExprSyntax(
                        label: param.label,
                        expression: ExprSyntax("\(raw: param.name)")
                    )
                )
                abiParameterSignatures.append((param.name, .f32))
            case .double:
                abiParameterForwardings.append(
                    LabeledExprSyntax(
                        label: param.label,
                        expression: ExprSyntax("\(raw: param.name)")
                    )
                )
                abiParameterSignatures.append((param.name, .f64))
            case .string:
                let stringIdName = "\(param.name)Id"
                body.append(
                    """
                    var \(raw: param.name) = \(raw: param.name)

                    """
                )
                body.append(
                    """
                    let \(raw: stringIdName) = \(raw: param.name).withUTF8 { b in
                        _swift_js_make_js_string(b.baseAddress.unsafelyUnwrapped, Int32(b.count))
                    }
                    """
                )
                abiParameterForwardings.append(
                    LabeledExprSyntax(
                        label: param.label,
                        expression: ExprSyntax("\(raw: stringIdName)")
                    )
                )
                abiParameterSignatures.append((param.name, .i32))
            case .caseEnum, .rawValueEnum, .associatedValueEnum, .namespaceEnum:
                throw BridgeJSCoreError("Enum types are not yet supported in TypeScript imports")
            case .jsObject(_?):
                abiParameterSignatures.append((param.name, .i32))
                abiParameterForwardings.append(
                    LabeledExprSyntax(
                        label: param.label,
                        expression: ExprSyntax("Int32(bitPattern: \(raw: param.name).this.id)")
                    )
                )
            case .jsObject(nil):
                abiParameterForwardings.append(
                    LabeledExprSyntax(
                        label: param.label,
                        expression: ExprSyntax("Int32(bitPattern: \(raw: param.name).id)")
                    )
                )
                abiParameterSignatures.append((param.name, .i32))
            case .swiftHeapObject(_):
                throw BridgeJSCoreError("swiftHeapObject is not supported in imported signatures")
            case .void:
                break
            }
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
            switch returnType {
            case .bool:
                abiReturnType = .i32
                body.append("return ret == 1")
            case .int:
                abiReturnType = .i32
                body.append("return \(raw: returnType.swiftType)(ret)")
            case .float:
                abiReturnType = .f32
                body.append("return \(raw: returnType.swiftType)(ret)")
            case .double:
                abiReturnType = .f64
                body.append("return \(raw: returnType.swiftType)(ret)")
            case .string:
                abiReturnType = .i32
                body.append(
                    """
                    return String(unsafeUninitializedCapacity: Int(ret)) { b in
                        _swift_js_init_memory_with_result(b.baseAddress.unsafelyUnwrapped, Int32(ret))
                        return Int(ret)
                    }
                    """
                )
            case .caseEnum, .rawValueEnum, .associatedValueEnum, .namespaceEnum:
                throw BridgeJSCoreError("Enum types are not yet supported in TypeScript imports")
            case .jsObject(let name):
                abiReturnType = .i32
                if let name = name {
                    body.append("return \(raw: name)(takingThis: ret)")
                } else {
                    body.append("return JSObject(id: UInt32(bitPattern: ret))")
                }
            case .swiftHeapObject(_):
                throw BridgeJSCoreError("swiftHeapObject is not supported in imported signatures")
            case .void:
                break
            }
        }

        func assignThis(returnType: BridgeType) {
            guard case .jsObject = returnType else {
                preconditionFailure("assignThis can only be called with a jsObject return type")
            }
            abiReturnType = .i32
            body.append("self.this = JSObject(id: UInt32(bitPattern: ret))")
        }

        func renderImportDecl() -> DeclSyntax {
            let baseDecl = FunctionDeclSyntax(
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
            return DeclSyntax(
                FunctionDeclSyntax(
                    name: .identifier(name),
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
                        effectSpecifiers: ImportTS.buildFunctionEffect(throws: true, async: false),
                        returnClause: ReturnClauseSyntax(
                            arrow: .arrowToken(),
                            type: IdentifierTypeSyntax(name: .identifier(returnType.swiftType))
                        )
                    ),
                    body: CodeBlockSyntax {
                        self.renderImportDecl()
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
                        self.renderImportDecl()
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
            return AccessorDeclSyntax(
                accessorSpecifier: .keyword(.get),
                effectSpecifiers: Self.buildAccessorEffect(throws: true, async: false),
                body: CodeBlockSyntax {
                    builder.renderImportDecl()
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
            return builder.renderThunkDecl(
                name: "set\(property.name.capitalizedFirstLetter())",
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
                                    pattern: IdentifierPatternSyntax(identifier: .identifier(property.name)),
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
            memberBlockBuilder: {
                DeclSyntax(
                    """
                    let this: JSObject
                    """
                ).with(\.trailingTrivia, .newlines(2))

                DeclSyntax(
                    """
                    init(this: JSObject) {
                        self.this = this
                    }
                    """
                ).with(\.trailingTrivia, .newlines(2))

                DeclSyntax(
                    """
                    init(takingThis this: Int32) {
                        self.this = JSObject(id: UInt32(bitPattern: this))
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

extension String {
    func capitalizedFirstLetter() -> String {
        guard !isEmpty else { return self }
        return prefix(1).uppercased() + dropFirst()
    }
}
