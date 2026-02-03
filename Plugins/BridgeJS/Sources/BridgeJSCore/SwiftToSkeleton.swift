import SwiftSyntax
import SwiftSyntaxBuilder
#if canImport(BridgeJSUtilities)
import BridgeJSUtilities
#endif
#if canImport(BridgeJSSkeleton)
import BridgeJSSkeleton
#endif

/// Builds BridgeJS skeletons from Swift source files using SwiftSyntax walk for API collection.
///
/// This is a shared entry point for producing:
/// - exported skeletons from `@JS` declarations
/// - imported skeletons from `@JSFunction/@JSGetter/@JSSetter/@JSClass` macro signatures
public final class SwiftToSkeleton {
    public let progress: ProgressReporting
    public let moduleName: String
    public let exposeToGlobal: Bool

    private var sourceFiles: [(sourceFile: SourceFileSyntax, inputFilePath: String)] = []
    let typeDeclResolver: TypeDeclResolver

    public init(progress: ProgressReporting, moduleName: String, exposeToGlobal: Bool) {
        self.progress = progress
        self.moduleName = moduleName
        self.exposeToGlobal = exposeToGlobal
        self.typeDeclResolver = TypeDeclResolver()

        // Index known types provided by JavaScriptKit
        self.typeDeclResolver.addSourceFile(
            """
            @JSClass struct JSPromise {}
            """
        )
    }

    public func addSourceFile(_ sourceFile: SourceFileSyntax, inputFilePath: String) {
        self.typeDeclResolver.addSourceFile(sourceFile)
        sourceFiles.append((sourceFile, inputFilePath))
    }

    public func finalize() throws -> BridgeJSSkeleton {
        var perSourceErrors: [(inputFilePath: String, errors: [DiagnosticError])] = []
        var importedFiles: [ImportedFileSkeleton] = []
        var exported = ExportedSkeleton(functions: [], classes: [], enums: [], exposeToGlobal: exposeToGlobal)

        for (sourceFile, inputFilePath) in sourceFiles {
            progress.print("Processing \(inputFilePath)")

            let exportCollector = ExportSwiftAPICollector(parent: self)
            exportCollector.walk(sourceFile)

            let typeNameCollector = ImportSwiftMacrosJSImportTypeNameCollector(viewMode: .sourceAccurate)
            typeNameCollector.walk(sourceFile)
            let importCollector = ImportSwiftMacrosAPICollector(
                inputFilePath: inputFilePath,
                knownJSClassNames: typeNameCollector.typeNames,
                parent: self
            )
            importCollector.walk(sourceFile)

            let importErrorsFatal = importCollector.errors.filter { !$0.message.contains("Unsupported type '") }
            if !exportCollector.errors.isEmpty || !importErrorsFatal.isEmpty {
                perSourceErrors.append(
                    (inputFilePath: inputFilePath, errors: exportCollector.errors + importErrorsFatal)
                )
            }

            importedFiles.append(
                ImportedFileSkeleton(
                    functions: importCollector.importedFunctions,
                    types: importCollector.importedTypes,
                    globalGetters: importCollector.importedGlobalGetters
                )
            )
            exportCollector.finalize(&exported)
        }

        if !perSourceErrors.isEmpty {
            let allErrors = perSourceErrors.flatMap { inputFilePath, errors in
                errors.map { $0.formattedDescription(fileName: inputFilePath) }
            }
            throw BridgeJSCoreError(allErrors.joined(separator: "\n"))
        }
        let importedSkeleton: ImportedModuleSkeleton? = {
            let module = ImportedModuleSkeleton(children: importedFiles)
            if module.children.allSatisfy({ $0.functions.isEmpty && $0.types.isEmpty && $0.globalGetters.isEmpty }) {
                return nil
            }
            return module
        }()

        return BridgeJSSkeleton(moduleName: moduleName, exported: exported, imported: importedSkeleton)
    }

    func lookupType(for type: TypeSyntax, errors: inout [DiagnosticError]) -> BridgeType? {
        if let attributedType = type.as(AttributedTypeSyntax.self) {
            return lookupType(for: attributedType.baseType, errors: &errors)
        }

        // (T1, T2, ...) -> R
        if let functionType = type.as(FunctionTypeSyntax.self) {
            var parameters: [BridgeType] = []
            for param in functionType.parameters {
                guard let paramType = lookupType(for: param.type, errors: &errors) else {
                    return nil
                }
                parameters.append(paramType)
            }

            guard let returnType = lookupType(for: functionType.returnClause.type, errors: &errors) else {
                return nil
            }

            let isAsync = functionType.effectSpecifiers?.asyncSpecifier != nil
            let isThrows = functionType.effectSpecifiers?.throwsClause != nil

            return .closure(
                ClosureSignature(
                    parameters: parameters,
                    returnType: returnType,
                    moduleName: moduleName,
                    isAsync: isAsync,
                    isThrows: isThrows
                )
            )
        }

        // T?
        if let optionalType = type.as(OptionalTypeSyntax.self) {
            let wrappedType = optionalType.wrappedType
            if let baseType = lookupType(for: wrappedType, errors: &errors) {
                return .optional(baseType)
            }
        }
        // Optional<T>
        if let identifierType = type.as(IdentifierTypeSyntax.self),
            identifierType.name.text == "Optional",
            let genericArgs = identifierType.genericArgumentClause?.arguments,
            genericArgs.count == 1,
            let argType = TypeSyntax(genericArgs.first?.argument)
        {
            if let baseType = lookupType(for: argType, errors: &errors) {
                return .optional(baseType)
            }
        }
        // Swift.Optional<T>
        if let memberType = type.as(MemberTypeSyntax.self),
            let baseType = memberType.baseType.as(IdentifierTypeSyntax.self),
            baseType.name.text == "Swift",
            memberType.name.text == "Optional",
            let genericArgs = memberType.genericArgumentClause?.arguments,
            genericArgs.count == 1,
            let argType = TypeSyntax(genericArgs.first?.argument)
        {
            if let wrappedType = lookupType(for: argType, errors: &errors) {
                return .optional(wrappedType)
            }
        }
        // [T]
        if let arrayType = type.as(ArrayTypeSyntax.self) {
            if let elementType = lookupType(for: arrayType.element, errors: &errors) {
                return .array(elementType)
            }
        }
        // Array<T>
        if let identifierType = type.as(IdentifierTypeSyntax.self),
            identifierType.name.text == "Array",
            let genericArgs = identifierType.genericArgumentClause?.arguments,
            genericArgs.count == 1,
            let argType = TypeSyntax(genericArgs.first?.argument)
        {
            if let elementType = lookupType(for: argType, errors: &errors) {
                return .array(elementType)
            }
        }
        // Swift.Array<T>
        if let memberType = type.as(MemberTypeSyntax.self),
            let baseType = memberType.baseType.as(IdentifierTypeSyntax.self),
            baseType.name.text == "Swift",
            memberType.name.text == "Array",
            let genericArgs = memberType.genericArgumentClause?.arguments,
            genericArgs.count == 1,
            let argType = TypeSyntax(genericArgs.first?.argument)
        {
            if let elementType = lookupType(for: argType, errors: &errors) {
                return .array(elementType)
            }
        }
        if let aliasDecl = typeDeclResolver.resolveTypeAlias(type) {
            if let resolvedType = lookupType(for: aliasDecl.initializer.value, errors: &errors) {
                return resolvedType
            }
        }

        // UnsafePointer family
        if let unsafePointerType = Self.parseUnsafePointerType(type) {
            return .unsafePointer(unsafePointerType)
        }

        let typeName: String
        if let identifier = type.as(IdentifierTypeSyntax.self) {
            typeName = Self.normalizeIdentifier(identifier.name.text)
        } else {
            typeName = type.trimmedDescription
        }
        if let primitiveType = BridgeType(swiftType: typeName) {
            return primitiveType
        }

        guard let typeDecl = typeDeclResolver.resolve(type) else {
            errors.append(
                DiagnosticError(
                    node: type,
                    message: "Unsupported type '\(type.trimmedDescription)'.",
                    hint: "Only primitive types and types defined in the same module are allowed"
                )
            )
            return nil
        }

        if typeDecl.is(ProtocolDeclSyntax.self) {
            let swiftCallName = SwiftToSkeleton.computeSwiftCallName(for: typeDecl, itemName: typeDecl.name.text)
            return .swiftProtocol(swiftCallName)
        }

        if let enumDecl = typeDecl.as(EnumDeclSyntax.self) {
            let swiftCallName = SwiftToSkeleton.computeSwiftCallName(for: enumDecl, itemName: enumDecl.name.text)
            let rawTypeString = enumDecl.inheritanceClause?.inheritedTypes.first { inheritedType in
                let typeName = inheritedType.type.trimmedDescription
                return ExportSwiftConstants.supportedRawTypes.contains(typeName)
            }?.type.trimmedDescription

            if let rawType = SwiftEnumRawType(rawTypeString) {
                return .rawValueEnum(swiftCallName, rawType)
            } else {
                let hasAnyCases = enumDecl.memberBlock.members.contains { member in
                    member.decl.is(EnumCaseDeclSyntax.self)
                }
                if !hasAnyCases {
                    return .namespaceEnum(swiftCallName)
                }
                let hasAssociatedValues =
                    enumDecl.memberBlock.members.contains { member in
                        guard let caseDecl = member.decl.as(EnumCaseDeclSyntax.self) else { return false }
                        return caseDecl.elements.contains { element in
                            if let params = element.parameterClause?.parameters {
                                return !params.isEmpty
                            }
                            return false
                        }
                    }
                if hasAssociatedValues {
                    return .associatedValueEnum(swiftCallName)
                } else {
                    return .caseEnum(swiftCallName)
                }
            }
        }

        if let structDecl = typeDecl.as(StructDeclSyntax.self) {
            let swiftCallName = SwiftToSkeleton.computeSwiftCallName(for: structDecl, itemName: structDecl.name.text)
            if structDecl.attributes.hasAttribute(name: "JSClass") {
                return .jsObject(swiftCallName)
            }
            return .swiftStruct(swiftCallName)
        }

        guard typeDecl.is(ClassDeclSyntax.self) || typeDecl.is(ActorDeclSyntax.self) else {
            return nil
        }
        let swiftCallName = SwiftToSkeleton.computeSwiftCallName(for: typeDecl, itemName: typeDecl.name.text)

        // A type annotated with @JSClass is a JavaScript object wrapper (imported),
        // even if it is declared as a Swift class.
        if let classDecl = typeDecl.as(ClassDeclSyntax.self), classDecl.attributes.hasAttribute(name: "JSClass") {
            return .jsObject(swiftCallName)
        }
        if let actorDecl = typeDecl.as(ActorDeclSyntax.self), actorDecl.attributes.hasAttribute(name: "JSClass") {
            return .jsObject(swiftCallName)
        }

        return .swiftHeapObject(swiftCallName)
    }

    fileprivate static func parseUnsafePointerType(_ type: TypeSyntax) -> UnsafePointerType? {
        func parse(baseName: String, genericArg: TypeSyntax?) -> UnsafePointerType? {
            let pointee = genericArg?.trimmedDescription
            switch baseName {
            case "UnsafePointer":
                return .init(kind: .unsafePointer, pointee: pointee)
            case "UnsafeMutablePointer":
                return .init(kind: .unsafeMutablePointer, pointee: pointee)
            case "UnsafeRawPointer":
                return .init(kind: .unsafeRawPointer)
            case "UnsafeMutableRawPointer":
                return .init(kind: .unsafeMutableRawPointer)
            case "OpaquePointer":
                return .init(kind: .opaquePointer)
            default:
                return nil
            }
        }

        if let identifier = type.as(IdentifierTypeSyntax.self) {
            let baseName = identifier.name.text
            if (baseName == "UnsafePointer" || baseName == "UnsafeMutablePointer"),
                let genericArgs = identifier.genericArgumentClause?.arguments,
                genericArgs.count == 1,
                let argType = TypeSyntax(genericArgs.first?.argument)
            {
                return parse(baseName: baseName, genericArg: argType)
            }
            return parse(baseName: baseName, genericArg: nil)
        }

        if let member = type.as(MemberTypeSyntax.self),
            let base = member.baseType.as(IdentifierTypeSyntax.self),
            base.name.text == "Swift"
        {
            let baseName = member.name.text
            if (baseName == "UnsafePointer" || baseName == "UnsafeMutablePointer"),
                let genericArgs = member.genericArgumentClause?.arguments,
                genericArgs.count == 1,
                let argType = TypeSyntax(genericArgs.first?.argument)
            {
                return parse(baseName: baseName, genericArg: argType)
            }
            return parse(baseName: baseName, genericArg: nil)
        }

        return nil
    }

    /// Computes the full Swift call name by walking up the AST hierarchy to find all parent enums
    /// This generates the qualified name needed for Swift code generation (e.g., "Networking.API.HTTPServer")
    fileprivate static func computeSwiftCallName(for node: some SyntaxProtocol, itemName: String) -> String {
        var swiftPath: [String] = []
        var currentNode: Syntax? = node.parent

        while let parent = currentNode {
            if let enumDecl = parent.as(EnumDeclSyntax.self),
                enumDecl.attributes.hasJSAttribute()
            {
                swiftPath.insert(enumDecl.name.text, at: 0)
            }
            currentNode = parent.parent
        }

        if swiftPath.isEmpty {
            return itemName
        } else {
            return swiftPath.joined(separator: ".") + "." + itemName
        }
    }

    /// Strips surrounding backticks from an identifier (e.g. "`Foo`" -> "Foo").
    static func normalizeIdentifier(_ name: String) -> String {
        guard name.hasPrefix("`"), name.hasSuffix("`"), name.count >= 2 else {
            return name
        }
        return String(name.dropFirst().dropLast())
    }

}

private enum ExportSwiftConstants {
    static let supportedRawTypes = SwiftEnumRawType.allCases.map { $0.rawValue }
}

extension AttributeListSyntax {
    func hasJSAttribute() -> Bool {
        firstJSAttribute != nil
    }

    var firstJSAttribute: AttributeSyntax? {
        first(where: {
            $0.as(AttributeSyntax.self)?.attributeName.trimmedDescription == "JS"
        })?.as(AttributeSyntax.self)
    }

    /// Returns true if any attribute has the given name (e.g. "JSClass").
    func hasAttribute(name: String) -> Bool {
        contains { attribute in
            guard let syntax = attribute.as(AttributeSyntax.self) else { return false }
            return syntax.attributeName.trimmedDescription == name
        }
    }
}

private final class ExportSwiftAPICollector: SyntaxAnyVisitor {
    var exportedFunctions: [ExportedFunction] = []
    /// The names of the exported classes, in the order they were written in the source file
    var exportedClassNames: [String] = []
    var exportedClassByName: [String: ExportedClass] = [:]
    /// The names of the exported enums, in the order they were written in the source file
    var exportedEnumNames: [String] = []
    var exportedEnumByName: [String: ExportedEnum] = [:]
    /// The names of the exported protocols, in the order they were written in the source file
    var exportedProtocolNames: [String] = []
    var exportedProtocolByName: [String: ExportedProtocol] = [:]
    /// The names of the exported structs, in the order they were written in the source file
    var exportedStructNames: [String] = []
    var exportedStructByName: [String: ExportedStruct] = [:]
    var errors: [DiagnosticError] = []

    func finalize(_ result: inout ExportedSkeleton) {
        result.functions.append(contentsOf: exportedFunctions)
        result.classes.append(contentsOf: exportedClassNames.map { exportedClassByName[$0]! })
        result.enums.append(contentsOf: exportedEnumNames.map { exportedEnumByName[$0]! })
        result.structs.append(contentsOf: exportedStructNames.map { exportedStructByName[$0]! })
        result.protocols.append(contentsOf: exportedProtocolNames.map { exportedProtocolByName[$0]! })
    }

    /// Creates a unique key by combining name and namespace
    private func makeKey(name: String, namespace: [String]?) -> String {
        if let namespace = namespace, !namespace.isEmpty {
            return "\(namespace.joined(separator: ".")).\(name)"
        } else {
            return name
        }
    }

    struct NamespaceResolution {
        let namespace: [String]?
        let isValid: Bool
    }

    /// Resolves and validates namespace from both @JS attribute and computed (nested) namespace
    /// Returns the effective namespace and whether validation succeeded
    private func resolveNamespace(
        from jsAttribute: AttributeSyntax,
        for node: some SyntaxProtocol,
        declarationType: String
    ) -> NamespaceResolution {
        let attributeNamespace = extractNamespace(from: jsAttribute)
        let computedNamespace = computeNamespace(for: node)

        if computedNamespace != nil && attributeNamespace != nil {
            diagnose(
                node: jsAttribute,
                message: "Nested \(declarationType)s cannot specify their own namespace",
                hint:
                    "Remove the namespace from @JS attribute - nested \(declarationType)s inherit namespace from parent"
            )
            return NamespaceResolution(namespace: nil, isValid: false)
        }

        return NamespaceResolution(namespace: computedNamespace ?? attributeNamespace, isValid: true)
    }

    enum State {
        case topLevel
        case classBody(name: String, key: String)
        case enumBody(name: String, key: String)
        case protocolBody(name: String, key: String)
        case structBody(name: String, key: String)
    }

    struct StateStack {
        private var states: [State]
        var current: State {
            return states.last!
        }

        init(_ initialState: State) {
            self.states = [initialState]
        }
        mutating func push(state: State) {
            states.append(state)
        }

        mutating func pop() {
            _ = states.removeLast()
        }
    }

    var stateStack: StateStack = StateStack(.topLevel)
    var state: State {
        return stateStack.current
    }
    let parent: SwiftToSkeleton

    init(parent: SwiftToSkeleton) {
        self.parent = parent
        super.init(viewMode: .sourceAccurate)
    }

    private func diagnose(node: some SyntaxProtocol, message: String, hint: String? = nil) {
        errors.append(DiagnosticError(node: node, message: message, hint: hint))
    }

    private func withLookupErrors<T>(_ body: (inout [DiagnosticError]) -> T) -> T {
        var errs = self.errors
        defer { self.errors = errs }
        return body(&errs)
    }

    private func diagnoseNestedOptional(node: some SyntaxProtocol, type: String) {
        diagnose(
            node: node,
            message: "Nested optional types are not supported: \(type)",
            hint: "Use a single optional like String? instead of String?? or Optional<Optional<T>>"
        )
    }

    /// Detects whether given expression is supported as default parameter value
    private func isSupportedDefaultValueExpression(_ initClause: InitializerClauseSyntax) -> Bool {
        let expression = initClause.value

        // Function calls are checked later in extractDefaultValue (as constructors are allowed)
        // Array literals are allowed but checked in extractArrayDefaultValue
        if expression.is(DictionaryExprSyntax.self) { return false }
        if expression.is(BinaryOperatorExprSyntax.self) { return false }
        if expression.is(ClosureExprSyntax.self) { return false }

        // Method call chains (e.g., obj.foo())
        if let memberExpression = expression.as(MemberAccessExprSyntax.self),
            memberExpression.base?.is(FunctionCallExprSyntax.self) == true
        {
            return false
        }

        return true
    }

    /// Extract enum case value from member access expression
    private func extractEnumCaseValue(
        from memberExpr: MemberAccessExprSyntax,
        type: BridgeType
    ) -> DefaultValue? {
        let caseName = memberExpr.declName.baseName.text

        let enumName: String?
        switch type {
        case .caseEnum(let name), .rawValueEnum(let name, _), .associatedValueEnum(let name):
            enumName = name
        case .optional(let wrappedType):
            switch wrappedType {
            case .caseEnum(let name), .rawValueEnum(let name, _), .associatedValueEnum(let name):
                enumName = name
            default:
                return nil
            }
        default:
            return nil
        }

        guard let enumName = enumName else { return nil }

        if memberExpr.base == nil {
            return .enumCase(enumName, caseName)
        }

        if let baseExpr = memberExpr.base?.as(DeclReferenceExprSyntax.self) {
            let baseName = baseExpr.baseName.text
            let lastComponent = enumName.split(separator: ".").last.map(String.init) ?? enumName
            if baseName == enumName || baseName == lastComponent {
                return .enumCase(enumName, caseName)
            }
        }

        return nil
    }

    /// Extracts default value from parameter's default value clause
    private func extractDefaultValue(
        from defaultClause: InitializerClauseSyntax?,
        type: BridgeType
    ) -> DefaultValue? {
        guard let defaultClause = defaultClause else {
            return nil
        }

        if !isSupportedDefaultValueExpression(defaultClause) {
            diagnose(
                node: defaultClause,
                message: "Complex default parameter expressions are not supported",
                hint: "Use simple literal values (e.g., \"text\", 42, true, nil) or simple constants"
            )
            return nil
        }

        let expr = defaultClause.value

        if expr.is(NilLiteralExprSyntax.self) {
            guard case .optional(_) = type else {
                diagnose(
                    node: expr,
                    message: "nil is only valid for optional parameters",
                    hint: "Make the parameter optional by adding ? to the type"
                )
                return nil
            }
            return .null
        }

        if let memberExpr = expr.as(MemberAccessExprSyntax.self),
            let enumValue = extractEnumCaseValue(from: memberExpr, type: type)
        {
            return enumValue
        }

        if let funcCall = expr.as(FunctionCallExprSyntax.self) {
            return extractConstructorDefaultValue(from: funcCall, type: type)
        }

        if let arrayExpr = expr.as(ArrayExprSyntax.self) {
            return extractArrayDefaultValue(from: arrayExpr, type: type)
        }

        if let literalValue = extractLiteralValue(from: expr, type: type) {
            return literalValue
        }

        diagnose(
            node: expr,
            message: "Unsupported default parameter value expression",
            hint: "Use simple literal values like \"text\", 42, true, false, nil, or enum cases like .caseName"
        )
        return nil
    }

    /// Extracts default value from a constructor call expression
    private func extractConstructorDefaultValue(
        from funcCall: FunctionCallExprSyntax,
        type: BridgeType
    ) -> DefaultValue? {
        guard let calledExpr = funcCall.calledExpression.as(DeclReferenceExprSyntax.self) else {
            diagnose(
                node: funcCall,
                message: "Complex constructor expressions are not supported",
                hint: "Use a simple constructor call like ClassName() or ClassName(arg: value)"
            )
            return nil
        }

        let typeName = calledExpr.baseName.text

        let isStructType: Bool
        let expectedTypeName: String?
        switch type {
        case .swiftStruct(let name), .optional(.swiftStruct(let name)):
            isStructType = true
            expectedTypeName = name.split(separator: ".").last.map(String.init)
        case .swiftHeapObject(let name), .optional(.swiftHeapObject(let name)):
            isStructType = false
            expectedTypeName = name.split(separator: ".").last.map(String.init)
        default:
            diagnose(
                node: funcCall,
                message: "Constructor calls are only supported for class and struct types",
                hint: "Parameter type should be a Swift class or struct"
            )
            return nil
        }

        guard let expectedTypeName = expectedTypeName, typeName == expectedTypeName else {
            diagnose(
                node: funcCall,
                message: "Constructor type name '\(typeName)' doesn't match parameter type",
                hint: "Ensure the constructor matches the parameter type"
            )
            return nil
        }

        if isStructType {
            // For structs, extract field name/value pairs
            var fields: [DefaultValueField] = []
            for argument in funcCall.arguments {
                guard let fieldName = argument.label?.text else {
                    diagnose(
                        node: argument,
                        message: "Struct initializer arguments must have labels",
                        hint: "Use labeled arguments like MyStruct(x: 1, y: 2)"
                    )
                    return nil
                }
                guard let fieldValue = extractLiteralValue(from: argument.expression) else {
                    diagnose(
                        node: argument.expression,
                        message: "Struct field value must be a literal",
                        hint: "Use simple literals like \"text\", 42, true, false in struct fields"
                    )
                    return nil
                }
                fields.append(DefaultValueField(name: fieldName, value: fieldValue))
            }
            return .structLiteral(typeName, fields)
        } else {
            if funcCall.arguments.isEmpty {
                return .object(typeName)
            }

            var constructorArgs: [DefaultValue] = []
            for argument in funcCall.arguments {
                guard let argValue = extractLiteralValue(from: argument.expression) else {
                    diagnose(
                        node: argument.expression,
                        message: "Constructor argument must be a literal value",
                        hint: "Use simple literals like \"text\", 42, true, false in constructor arguments"
                    )
                    return nil
                }
                constructorArgs.append(argValue)
            }
            return .objectWithArguments(typeName, constructorArgs)
        }
    }

    /// Extracts a literal value from an expression with optional type checking
    private func extractLiteralValue(from expr: ExprSyntax, type: BridgeType? = nil) -> DefaultValue? {
        if expr.is(NilLiteralExprSyntax.self) {
            return .null
        }

        if let stringLiteral = expr.as(StringLiteralExprSyntax.self),
            let segment = stringLiteral.segments.first?.as(StringSegmentSyntax.self)
        {
            let value = DefaultValue.string(segment.content.text)
            if let type = type, !type.isCompatibleWith(.string) {
                return nil
            }
            return value
        }

        if let boolLiteral = expr.as(BooleanLiteralExprSyntax.self) {
            let value = DefaultValue.bool(boolLiteral.literal.text == "true")
            if let type = type, !type.isCompatibleWith(.bool) {
                return nil
            }
            return value
        }

        var numericExpr = expr
        var isNegative = false
        if let prefixExpr = expr.as(PrefixOperatorExprSyntax.self),
            prefixExpr.operator.text == "-"
        {
            numericExpr = prefixExpr.expression
            isNegative = true
        }

        if let intLiteral = numericExpr.as(IntegerLiteralExprSyntax.self),
            let intValue = Int(intLiteral.literal.text)
        {
            let value = DefaultValue.int(isNegative ? -intValue : intValue)
            if let type = type, !type.isCompatibleWith(.int) {
                return nil
            }
            return value
        }

        if let floatLiteral = numericExpr.as(FloatLiteralExprSyntax.self) {
            if let floatValue = Float(floatLiteral.literal.text) {
                let value = DefaultValue.float(isNegative ? -floatValue : floatValue)
                if type == nil || type?.isCompatibleWith(.float) == true {
                    return value
                }
            }
            if let doubleValue = Double(floatLiteral.literal.text) {
                let value = DefaultValue.double(isNegative ? -doubleValue : doubleValue)
                if type == nil || type?.isCompatibleWith(.double) == true {
                    return value
                }
            }
        }

        return nil
    }

    /// Extracts default value from an array literal expression
    private func extractArrayDefaultValue(
        from arrayExpr: ArrayExprSyntax,
        type: BridgeType
    ) -> DefaultValue? {
        // Verify the type is an array type
        let elementType: BridgeType?
        switch type {
        case .array(let element):
            elementType = element
        case .optional(.array(let element)):
            elementType = element
        default:
            diagnose(
                node: arrayExpr,
                message: "Array literal is only valid for array parameters",
                hint: "Parameter type should be an array like [Int] or [String]"
            )
            return nil
        }

        var elements: [DefaultValue] = []
        for element in arrayExpr.elements {
            guard let elementValue = extractLiteralValue(from: element.expression, type: elementType) else {
                diagnose(
                    node: element.expression,
                    message: "Array element must be a literal value",
                    hint: "Use simple literals like \"text\", 42, true, false in array elements"
                )
                return nil
            }
            elements.append(elementValue)
        }

        return .array(elements)
    }

    /// Shared parameter parsing logic used by functions, initializers, and protocol methods
    private func parseParameters(
        from parameterClause: FunctionParameterClauseSyntax,
        allowDefaults: Bool = true
    ) -> [Parameter] {
        var parameters: [Parameter] = []

        for param in parameterClause.parameters {
            let resolvedType = withLookupErrors { self.parent.lookupType(for: param.type, errors: &$0) }
            guard let type = resolvedType else {
                continue  // Skip unsupported types
            }
            if case .closure(let signature) = type {
                if signature.isAsync {
                    diagnose(
                        node: param.type,
                        message: "Async is not supported for Swift closures yet."
                    )
                    continue
                }
                if signature.isThrows {
                    diagnose(
                        node: param.type,
                        message: "Throws is not supported for Swift closures yet."
                    )
                    continue
                }
            }
            if case .optional(let wrappedType) = type, wrappedType.isOptional {
                diagnoseNestedOptional(node: param.type, type: param.type.trimmedDescription)
                continue
            }
            if case .optional(let wrappedType) = type, wrappedType.isOptional {
                diagnoseNestedOptional(node: param.type, type: param.type.trimmedDescription)
                continue
            }

            let name = param.secondName?.text ?? param.firstName.text
            let label = param.firstName.text

            let defaultValue: DefaultValue?
            if allowDefaults {
                defaultValue = extractDefaultValue(from: param.defaultValue, type: type)
            } else {
                defaultValue = nil
            }

            parameters.append(Parameter(label: label, name: name, type: type, defaultValue: defaultValue))
        }

        return parameters
    }

    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        guard node.attributes.hasJSAttribute() else {
            return .skipChildren
        }

        let isStatic = node.modifiers.contains { modifier in
            modifier.name.tokenKind == .keyword(.static) || modifier.name.tokenKind == .keyword(.class)
        }

        switch state {
        case .topLevel:
            if isStatic {
                diagnose(node: node, message: "Top-level functions cannot be static")
                return .skipChildren
            }
            if let exportedFunction = visitFunction(node: node, isStatic: false) {
                exportedFunctions.append(exportedFunction)
            }
            return .skipChildren
        case .classBody(let className, let classKey):
            if let exportedFunction = visitFunction(
                node: node,
                isStatic: isStatic,
                className: className,
                classKey: classKey
            ) {
                exportedClassByName[classKey]?.methods.append(exportedFunction)
            }
            return .skipChildren
        case .enumBody(let enumName, let enumKey):
            if !isStatic {
                diagnose(node: node, message: "Only static functions are supported in enums")
                return .skipChildren
            }
            if let exportedFunction = visitFunction(node: node, isStatic: isStatic, enumName: enumName) {
                if var currentEnum = exportedEnumByName[enumKey] {
                    currentEnum.staticMethods.append(exportedFunction)
                    exportedEnumByName[enumKey] = currentEnum
                }
            }
            return .skipChildren
        case .protocolBody(_, _):
            // Protocol methods are handled in visitProtocolMethod during protocol parsing
            return .skipChildren
        case .structBody(let structName, let structKey):
            if let exportedFunction = visitFunction(node: node, isStatic: isStatic, structName: structName) {
                if var currentStruct = exportedStructByName[structKey] {
                    currentStruct.methods.append(exportedFunction)
                    exportedStructByName[structKey] = currentStruct
                }
            }
            return .skipChildren
        }
    }

    private func visitFunction(
        node: FunctionDeclSyntax,
        isStatic: Bool,
        className: String? = nil,
        classKey: String? = nil,
        enumName: String? = nil,
        structName: String? = nil
    ) -> ExportedFunction? {
        guard let jsAttribute = node.attributes.firstJSAttribute else {
            return nil
        }

        let name = node.name.text

        let attributeNamespace = extractNamespace(from: jsAttribute)
        let computedNamespace = computeNamespace(for: node)

        let finalNamespace: [String]?

        if let computed = computedNamespace, !computed.isEmpty {
            finalNamespace = computed
        } else {
            finalNamespace = attributeNamespace
        }

        if attributeNamespace != nil, case .classBody = state {
            diagnose(
                node: jsAttribute,
                message: "Namespace is only needed in top-level declaration",
                hint: "Remove the namespace from @JS attribute or move this function to top-level"
            )
        }

        if attributeNamespace != nil, case .enumBody = state {
            diagnose(
                node: jsAttribute,
                message: "Namespace is not supported for enum static functions",
                hint: "Remove the namespace from @JS attribute - enum functions inherit namespace from enum"
            )
        }

        let parameters = parseParameters(from: node.signature.parameterClause, allowDefaults: true)
        let returnType: BridgeType
        if let returnClause = node.signature.returnClause {
            let resolvedType = withLookupErrors { self.parent.lookupType(for: returnClause.type, errors: &$0) }

            if let type = resolvedType, case .optional(let wrappedType) = type, wrappedType.isOptional {
                diagnoseNestedOptional(node: returnClause.type, type: returnClause.type.trimmedDescription)
                return nil
            }

            guard let type = resolvedType else { return nil }
            returnType = type
        } else {
            returnType = .void
        }

        let abiName: String
        let staticContext: StaticContext?

        switch state {
        case .topLevel:
            staticContext = nil
        case .classBody(let className, _):
            if isStatic {
                staticContext = .className(className)
            } else {
                staticContext = nil
            }
        case .enumBody(let enumName, let enumKey):
            if !isStatic {
                diagnose(node: node, message: "Only static functions are supported in enums")
                return nil
            }

            let isNamespaceEnum = exportedEnumByName[enumKey]?.cases.isEmpty ?? true
            let swiftCallName = exportedEnumByName[enumKey]?.swiftCallName ?? enumName
            staticContext = isNamespaceEnum ? .namespaceEnum(swiftCallName) : .enumName(enumName)
        case .protocolBody(_, _):
            return nil
        case .structBody(let structName, _):
            if isStatic {
                staticContext = .structName(structName)
            } else {
                staticContext = nil
            }
        }

        let classNameForABI: String?
        switch state {
        case .classBody(let className, _):
            classNameForABI = className
        case .structBody(let structName, _):
            classNameForABI = structName
        default:
            classNameForABI = nil
        }
        abiName = ABINameGenerator.generateABIName(
            baseName: name,
            namespace: finalNamespace,
            staticContext: isStatic ? staticContext : nil,
            className: classNameForABI
        )

        guard let effects = collectEffects(signature: node.signature, isStatic: isStatic) else {
            return nil
        }

        return ExportedFunction(
            name: name,
            abiName: abiName,
            parameters: parameters,
            returnType: returnType,
            effects: effects,
            namespace: finalNamespace,
            staticContext: staticContext
        )
    }

    private func collectEffects(signature: FunctionSignatureSyntax, isStatic: Bool = false) -> Effects? {
        let isAsync = signature.effectSpecifiers?.asyncSpecifier != nil
        var isThrows = false
        if let throwsClause: ThrowsClauseSyntax = signature.effectSpecifiers?.throwsClause {
            // Limit the thrown type to JSException for now
            guard let thrownType = throwsClause.type else {
                diagnose(
                    node: throwsClause,
                    message: "Thrown type is not specified, only JSException is supported for now"
                )
                return nil
            }
            guard thrownType.trimmedDescription == "JSException" else {
                diagnose(
                    node: throwsClause,
                    message: "Only JSException is supported for thrown type, got \(thrownType.trimmedDescription)"
                )
                return nil
            }
            isThrows = true
        }
        return Effects(isAsync: isAsync, isThrows: isThrows, isStatic: isStatic)
    }

    private func collectEffectsFromAccessor(_ accessor: AccessorDeclSyntax) -> Effects? {
        let isAsync = accessor.effectSpecifiers?.asyncSpecifier != nil
        var isThrows = false
        if let throwsClause = accessor.effectSpecifiers?.throwsClause {
            guard let thrownType = throwsClause.type else {
                diagnose(
                    node: throwsClause,
                    message: "Thrown type is not specified, only JSException is supported for now"
                )
                return nil
            }
            guard thrownType.trimmedDescription == "JSException" else {
                diagnose(
                    node: throwsClause,
                    message: "Only JSException is supported for thrown type, got \(thrownType.trimmedDescription)"
                )
                return nil
            }
            isThrows = true
        }
        return Effects(isAsync: isAsync, isThrows: isThrows, isStatic: false)
    }

    private func extractNamespace(
        from jsAttribute: AttributeSyntax
    ) -> [String]? {
        guard let arguments = jsAttribute.arguments?.as(LabeledExprListSyntax.self) else {
            return nil
        }

        guard let namespaceArg = arguments.first(where: { $0.label?.text == "namespace" }),
            let stringLiteral = namespaceArg.expression.as(StringLiteralExprSyntax.self),
            let namespaceString = stringLiteral.segments.first?.as(StringSegmentSyntax.self)?.content.text
        else {
            return nil
        }

        return namespaceString.split(separator: ".").map(String.init)
    }

    private func extractEnumStyle(
        from jsAttribute: AttributeSyntax
    ) -> EnumEmitStyle? {
        guard let arguments = jsAttribute.arguments?.as(LabeledExprListSyntax.self),
            let styleArg = arguments.first(where: { $0.label?.text == "enumStyle" })
        else {
            return nil
        }
        let text = styleArg.expression.trimmedDescription
        if text.contains("tsEnum") {
            return .tsEnum
        }
        if text.contains("const") {
            return .const
        }
        return nil
    }

    override func visit(_ node: InitializerDeclSyntax) -> SyntaxVisitorContinueKind {
        guard let jsAttribute = node.attributes.firstJSAttribute else { return .skipChildren }

        switch state {
        case .classBody(let className, let classKey):
            if extractNamespace(from: jsAttribute) != nil {
                diagnose(
                    node: jsAttribute,
                    message: "Namespace is not supported for initializer declarations",
                    hint: "Remove the namespace from @JS attribute"
                )
            }

            let parameters = parseParameters(from: node.signature.parameterClause, allowDefaults: true)

            guard let effects = collectEffects(signature: node.signature) else {
                return .skipChildren
            }

            let constructor = ExportedConstructor(
                abiName: "bjs_\(className)_init",
                parameters: parameters,
                effects: effects
            )
            exportedClassByName[classKey]?.constructor = constructor

        case .structBody(let structName, let structKey):
            if extractNamespace(from: jsAttribute) != nil {
                diagnose(
                    node: jsAttribute,
                    message: "Namespace is not supported for initializer declarations",
                    hint: "Remove the namespace from @JS attribute"
                )
            }

            let parameters = parseParameters(from: node.signature.parameterClause, allowDefaults: true)

            guard let effects = collectEffects(signature: node.signature) else {
                return .skipChildren
            }

            let constructor = ExportedConstructor(
                abiName: "bjs_\(structName)_init",
                parameters: parameters,
                effects: effects
            )
            exportedStructByName[structKey]?.constructor = constructor

        case .enumBody(_, _):
            diagnose(node: node, message: "Initializers are not supported inside enums")

        case .topLevel, .protocolBody(_, _):
            diagnose(node: node, message: "@JS init must be inside a @JS class or struct")
        }

        return .skipChildren
    }

    override func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
        guard let jsAttribute = node.attributes.firstJSAttribute else { return .skipChildren }

        let isStatic = node.modifiers.contains { modifier in
            modifier.name.tokenKind == .keyword(.static) || modifier.name.tokenKind == .keyword(.class)
        }

        let attributeNamespace = extractNamespace(from: jsAttribute)
        if attributeNamespace != nil {
            diagnose(
                node: jsAttribute,
                message: "Namespace parameter within @JS attribute is not supported for property declarations",
                hint:
                    "Remove the namespace from @JS attribute. If you need dedicated namespace, consider using a nested enum or class instead."
            )
        }

        let computedNamespace = computeNamespace(for: node)
        let finalNamespace: [String]?

        if let computed = computedNamespace, !computed.isEmpty {
            finalNamespace = computed
        } else {
            finalNamespace = nil
        }

        // Determine static context and validate placement
        let staticContext: StaticContext?

        switch state {
        case .classBody(let className, _):
            staticContext = isStatic ? .className(className) : nil
        case .enumBody(let enumName, let enumKey):
            if !isStatic {
                diagnose(node: node, message: "Only static properties are supported in enums")
                return .skipChildren
            }
            let isNamespaceEnum = exportedEnumByName[enumKey]?.cases.isEmpty ?? true
            // Use swiftCallName for the full Swift call path (handles nested enums correctly)
            let swiftCallName = exportedEnumByName[enumKey]?.swiftCallName ?? enumName
            staticContext =
                isStatic ? (isNamespaceEnum ? .namespaceEnum(swiftCallName) : .enumName(swiftCallName)) : nil
        case .topLevel:
            diagnose(node: node, message: "@JS var must be inside a @JS class or enum")
            return .skipChildren
        case .protocolBody(let protocolName, let protocolKey):
            return visitProtocolProperty(node: node, protocolName: protocolName, protocolKey: protocolKey)
        case .structBody(let structName, _):
            if isStatic {
                staticContext = .structName(structName)
            } else {
                diagnose(node: node, message: "@JS var must be static in structs (instance fields don't need @JS)")
                return .skipChildren
            }
        }

        // Process each binding (variable declaration)
        for binding in node.bindings {
            guard let pattern = binding.pattern.as(IdentifierPatternSyntax.self) else {
                diagnose(node: binding.pattern, message: "Complex patterns not supported for @JS properties")
                continue
            }

            let propertyName = pattern.identifier.text

            guard let typeAnnotation = binding.typeAnnotation else {
                diagnose(node: binding, message: "@JS property must have explicit type annotation")
                continue
            }

            guard let propertyType = withLookupErrors({ self.parent.lookupType(for: typeAnnotation.type, errors: &$0) })
            else {
                continue
            }

            // Check if property is readonly
            let isLet = node.bindingSpecifier.tokenKind == .keyword(.let)
            let isGetterOnly = node.bindings.contains(where: { self.hasOnlyGetter($0.accessorBlock) })

            let isReadonly = isLet || isGetterOnly

            let exportedProperty = ExportedProperty(
                name: propertyName,
                type: propertyType,
                isReadonly: isReadonly,
                isStatic: isStatic,
                namespace: finalNamespace,
                staticContext: staticContext
            )

            if case .enumBody(_, let key) = state {
                if var currentEnum = exportedEnumByName[key] {
                    currentEnum.staticProperties.append(exportedProperty)
                    exportedEnumByName[key] = currentEnum
                }
            } else if case .structBody(_, let key) = state {
                exportedStructByName[key]?.properties.append(exportedProperty)
            } else if case .classBody(_, let key) = state {
                exportedClassByName[key]?.properties.append(exportedProperty)
            }
        }

        return .skipChildren
    }

    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        let name = node.name.text

        guard let jsAttribute = node.attributes.firstJSAttribute else {
            return .skipChildren
        }

        let namespaceResult = resolveNamespace(from: jsAttribute, for: node, declarationType: "class")
        guard namespaceResult.isValid else {
            return .skipChildren
        }
        let swiftCallName = SwiftToSkeleton.computeSwiftCallName(for: node, itemName: name)
        let explicitAccessControl = computeExplicitAtLeastInternalAccessControl(
            for: node,
            message: "Class visibility must be at least internal"
        )
        let exportedClass = ExportedClass(
            name: name,
            swiftCallName: swiftCallName,
            explicitAccessControl: explicitAccessControl,
            constructor: nil,
            methods: [],
            properties: [],
            namespace: namespaceResult.namespace
        )
        let uniqueKey = makeKey(name: name, namespace: namespaceResult.namespace)

        stateStack.push(state: .classBody(name: name, key: uniqueKey))
        exportedClassByName[uniqueKey] = exportedClass
        exportedClassNames.append(uniqueKey)
        return .visitChildren
    }

    override func visitPost(_ node: ClassDeclSyntax) {
        // Make sure we pop the state stack only if we're in a class body state (meaning we successfully pushed)
        if case .classBody(_, _) = stateStack.current {
            stateStack.pop()
        }
    }

    override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
        guard let jsAttribute = node.attributes.firstJSAttribute else {
            return .skipChildren
        }

        let name = node.name.text

        let rawType: String? = node.inheritanceClause?.inheritedTypes.first { inheritedType in
            let typeName = inheritedType.type.trimmedDescription
            return ExportSwiftConstants.supportedRawTypes.contains(typeName)
        }?.type.trimmedDescription

        let namespaceResult = resolveNamespace(from: jsAttribute, for: node, declarationType: "enum")
        guard namespaceResult.isValid else {
            return .skipChildren
        }
        let emitStyle = extractEnumStyle(from: jsAttribute) ?? .const
        let swiftCallName = SwiftToSkeleton.computeSwiftCallName(for: node, itemName: name)
        let explicitAccessControl = computeExplicitAtLeastInternalAccessControl(
            for: node,
            message: "Enum visibility must be at least internal"
        )

        let tsFullPath: String
        if let namespace = namespaceResult.namespace, !namespace.isEmpty {
            tsFullPath = namespace.joined(separator: ".") + "." + name
        } else {
            tsFullPath = name
        }

        // Create enum directly in dictionary
        let exportedEnum = ExportedEnum(
            name: name,
            swiftCallName: swiftCallName,
            tsFullPath: tsFullPath,
            explicitAccessControl: explicitAccessControl,
            cases: [],  // Will be populated in visit(EnumCaseDeclSyntax)
            rawType: SwiftEnumRawType(rawType),
            namespace: namespaceResult.namespace,
            emitStyle: emitStyle,
            staticMethods: [],
            staticProperties: []
        )

        let enumUniqueKey = makeKey(name: name, namespace: namespaceResult.namespace)
        exportedEnumByName[enumUniqueKey] = exportedEnum
        exportedEnumNames.append(enumUniqueKey)

        stateStack.push(state: .enumBody(name: name, key: enumUniqueKey))

        return .visitChildren
    }

    override func visitPost(_ node: EnumDeclSyntax) {
        guard let jsAttribute = node.attributes.firstJSAttribute else {
            // Only pop if we have a valid enum that was processed
            if case .enumBody(_, _) = stateStack.current {
                stateStack.pop()
            }
            return
        }

        guard case .enumBody(_, let enumKey) = stateStack.current else {
            return
        }

        guard let exportedEnum = exportedEnumByName[enumKey] else {
            stateStack.pop()
            return
        }

        let emitStyle = exportedEnum.emitStyle

        if case .tsEnum = emitStyle {
            if exportedEnum.rawType == .bool {
                diagnose(
                    node: jsAttribute,
                    message: "TypeScript enum style is not supported for Bool raw-value enums",
                    hint: "Use enumStyle: .const or change the raw type to String or a numeric type"
                )
            }
            if !exportedEnum.staticMethods.isEmpty {
                diagnose(
                    node: jsAttribute,
                    message: "TypeScript enum style does not support static functions",
                    hint: "Use enumStyle: .const to generate a const object that supports static functions"
                )
            }
        }

        if exportedEnum.cases.contains(where: { !$0.associatedValues.isEmpty }) {
            if case .tsEnum = emitStyle {
                diagnose(
                    node: jsAttribute,
                    message: "TypeScript enum style is not supported for associated value enums",
                    hint: "Use enumStyle: .const in order to map associated-value enums"
                )
            }
            for enumCase in exportedEnum.cases {
                for associatedValue in enumCase.associatedValues {
                    switch associatedValue.type {
                    case .string, .int, .float, .double, .bool:
                        break
                    case .optional(let wrappedType):
                        switch wrappedType {
                        case .string, .int, .float, .double, .bool:
                            break
                        default:
                            diagnose(
                                node: node,
                                message: "Unsupported associated value type: \(associatedValue.type.swiftType)",
                                hint:
                                    "Only primitive types and optional primitives (String?, Int?, Float?, Double?, Bool?) are supported in associated-value enums"
                            )
                        }
                    default:
                        diagnose(
                            node: node,
                            message: "Unsupported associated value type: \(associatedValue.type.swiftType)",
                            hint:
                                "Only primitive types and optional primitives (String?, Int?, Float?, Double?, Bool?) are supported in associated-value enums"
                        )
                    }
                }
            }
        }

        stateStack.pop()
    }

    override func visit(_ node: ProtocolDeclSyntax) -> SyntaxVisitorContinueKind {
        guard let jsAttribute = node.attributes.firstJSAttribute else {
            return .skipChildren
        }

        let name = node.name.text

        let namespaceResult = resolveNamespace(from: jsAttribute, for: node, declarationType: "protocol")
        guard namespaceResult.isValid else {
            return .skipChildren
        }
        _ = computeExplicitAtLeastInternalAccessControl(
            for: node,
            message: "Protocol visibility must be at least internal"
        )

        let protocolUniqueKey = makeKey(name: name, namespace: namespaceResult.namespace)

        exportedProtocolByName[protocolUniqueKey] = ExportedProtocol(
            name: name,
            methods: [],
            properties: [],
            namespace: namespaceResult.namespace
        )

        stateStack.push(state: .protocolBody(name: name, key: protocolUniqueKey))

        var methods: [ExportedFunction] = []
        for member in node.memberBlock.members {
            if let funcDecl = member.decl.as(FunctionDeclSyntax.self) {
                if let exportedFunction = visitProtocolMethod(
                    node: funcDecl,
                    protocolName: name,
                    namespace: namespaceResult.namespace
                ) {
                    methods.append(exportedFunction)
                }
            } else if let varDecl = member.decl.as(VariableDeclSyntax.self) {
                _ = visitProtocolProperty(node: varDecl, protocolName: name, protocolKey: protocolUniqueKey)
            }
        }

        let exportedProtocol = ExportedProtocol(
            name: name,
            methods: methods,
            properties: exportedProtocolByName[protocolUniqueKey]?.properties ?? [],
            namespace: namespaceResult.namespace
        )

        exportedProtocolByName[protocolUniqueKey] = exportedProtocol
        exportedProtocolNames.append(protocolUniqueKey)

        stateStack.pop()

        return .skipChildren
    }

    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        guard let jsAttribute = node.attributes.firstJSAttribute else {
            return .skipChildren
        }

        let name = node.name.text

        let namespaceResult = resolveNamespace(from: jsAttribute, for: node, declarationType: "struct")
        guard namespaceResult.isValid else {
            return .skipChildren
        }
        let swiftCallName = SwiftToSkeleton.computeSwiftCallName(for: node, itemName: name)
        let explicitAccessControl = computeExplicitAtLeastInternalAccessControl(
            for: node,
            message: "Struct visibility must be at least internal"
        )

        var properties: [ExportedProperty] = []

        // Process all variables in struct as readonly (value semantics) and don't require @JS
        for member in node.memberBlock.members {
            if let varDecl = member.decl.as(VariableDeclSyntax.self) {
                let isStatic = varDecl.modifiers.contains { modifier in
                    modifier.name.tokenKind == .keyword(.static) || modifier.name.tokenKind == .keyword(.class)
                }

                // Handled with error in visitVariable
                if varDecl.attributes.hasJSAttribute() {
                    continue
                }
                // Skips static non-@JS properties
                if isStatic {
                    continue
                }

                for binding in varDecl.bindings {
                    guard let pattern = binding.pattern.as(IdentifierPatternSyntax.self) else {
                        continue
                    }

                    let fieldName = pattern.identifier.text

                    guard let typeAnnotation = binding.typeAnnotation else {
                        diagnose(node: binding, message: "Struct field must have explicit type annotation")
                        continue
                    }

                    guard
                        let fieldType = withLookupErrors({
                            self.parent.lookupType(for: typeAnnotation.type, errors: &$0)
                        })
                    else {
                        continue
                    }

                    let property = ExportedProperty(
                        name: fieldName,
                        type: fieldType,
                        isReadonly: true,
                        isStatic: false,
                        namespace: namespaceResult.namespace,
                        staticContext: nil
                    )
                    properties.append(property)
                }
            }
        }

        let structUniqueKey = makeKey(name: name, namespace: namespaceResult.namespace)
        let exportedStruct = ExportedStruct(
            name: name,
            swiftCallName: swiftCallName,
            explicitAccessControl: explicitAccessControl,
            properties: properties,
            methods: [],
            namespace: namespaceResult.namespace
        )

        exportedStructByName[structUniqueKey] = exportedStruct
        exportedStructNames.append(structUniqueKey)

        stateStack.push(state: .structBody(name: name, key: structUniqueKey))

        return .visitChildren
    }

    override func visitPost(_ node: StructDeclSyntax) {
        if case .structBody(_, _) = stateStack.current {
            stateStack.pop()
        }
    }

    private func visitProtocolMethod(
        node: FunctionDeclSyntax,
        protocolName: String,
        namespace: [String]?
    ) -> ExportedFunction? {
        let name = node.name.text

        let parameters = parseParameters(from: node.signature.parameterClause, allowDefaults: false)

        let returnType: BridgeType
        if let returnClause = node.signature.returnClause {
            let resolvedType = withLookupErrors { self.parent.lookupType(for: returnClause.type, errors: &$0) }

            if let type = resolvedType, case .optional(let wrappedType) = type, wrappedType.isOptional {
                diagnoseNestedOptional(node: returnClause.type, type: returnClause.type.trimmedDescription)
                return nil
            }

            guard let type = resolvedType else { return nil }
            returnType = type
        } else {
            returnType = .void
        }

        let abiName = ABINameGenerator.generateABIName(
            baseName: name,
            namespace: namespace,
            className: protocolName
        )

        guard let effects = collectEffects(signature: node.signature) else {
            return nil
        }

        guard effects.isThrows else {
            diagnose(
                node: node,
                message: "@JS protocol methods must be throws.",
                hint: "Declare the method as 'throws(JSException)'."
            )
            return nil
        }

        return ExportedFunction(
            name: name,
            abiName: abiName,
            parameters: parameters,
            returnType: returnType,
            effects: effects,
            namespace: namespace,
            staticContext: nil
        )
    }

    private func visitProtocolProperty(
        node: VariableDeclSyntax,
        protocolName: String,
        protocolKey: String
    ) -> SyntaxVisitorContinueKind {
        for binding in node.bindings {
            guard let pattern = binding.pattern.as(IdentifierPatternSyntax.self) else {
                diagnose(node: binding.pattern, message: "Complex patterns not supported for protocol properties")
                continue
            }

            let propertyName = pattern.identifier.text

            guard let typeAnnotation = binding.typeAnnotation else {
                diagnose(node: binding, message: "Protocol property must have explicit type annotation")
                continue
            }

            guard let propertyType = withLookupErrors({ self.parent.lookupType(for: typeAnnotation.type, errors: &$0) })
            else {
                continue
            }

            guard let accessorBlock = binding.accessorBlock else {
                diagnose(
                    node: binding,
                    message: "Protocol property must specify { get throws(JSException) }",
                    hint: "Add { get throws(JSException) } for the property accessor"
                )
                continue
            }

            // Find the getter accessor
            let getterAccessor: AccessorDeclSyntax?
            switch accessorBlock.accessors {
            case .accessors(let accessors):
                getterAccessor = accessors.first { $0.accessorSpecifier.tokenKind == .keyword(.get) }
            case .getter:
                diagnose(
                    node: accessorBlock,
                    message: "@JS protocol property getter must declare throws(JSException)",
                    hint: "Use { get throws(JSException) } syntax"
                )
                continue
            }

            guard let getter = getterAccessor else {
                diagnose(node: accessorBlock, message: "Protocol property must have a getter")
                continue
            }

            // Check for setter - not allowed with throwing getter
            if case .accessors(let accessors) = accessorBlock.accessors {
                if accessors.contains(where: { $0.accessorSpecifier.tokenKind == .keyword(.set) }) {
                    diagnose(
                        node: accessorBlock,
                        message: "@JS protocol cannot have { get set } properties",
                        hint:
                            "Use readonly property with setter method: var \(propertyName): \(typeAnnotation.type.trimmedDescription) { get throws(JSException) } and func set\(propertyName.capitalized)(_ value: \(typeAnnotation.type.trimmedDescription)) throws(JSException)"
                    )
                    continue
                }
            }

            guard let effects = collectEffectsFromAccessor(getter) else {
                continue
            }

            guard effects.isThrows else {
                diagnose(
                    node: getter,
                    message: "@JS protocol property getter must be throws",
                    hint: "Declare the getter as 'get throws(JSException)'"
                )
                continue
            }

            let exportedProperty = ExportedProtocolProperty(
                name: propertyName,
                type: propertyType,
                isReadonly: true,  // Always readonly since { get set } with throws is not allowed
                effects: effects
            )

            if var currentProtocol = exportedProtocolByName[protocolKey] {
                var properties = currentProtocol.properties
                properties.append(exportedProperty)

                currentProtocol = ExportedProtocol(
                    name: currentProtocol.name,
                    methods: currentProtocol.methods,
                    properties: properties,
                    namespace: currentProtocol.namespace
                )
                exportedProtocolByName[protocolKey] = currentProtocol
            }
        }

        return .skipChildren
    }

    private func hasOnlyGetter(_ accessorBlock: AccessorBlockSyntax?) -> Bool {
        switch accessorBlock?.accessors {
        case .accessors(let accessors):
            // Has accessors - check if it only has a getter (no setter, willSet, or didSet)
            return !accessors.contains(where: { accessor in
                let tokenKind = accessor.accessorSpecifier.tokenKind
                return tokenKind == .keyword(.set) || tokenKind == .keyword(.willSet)
                    || tokenKind == .keyword(.didSet)
            })
        case .getter:
            // Has only a getter block
            return true
        case nil:
            // No accessor block - this is a stored property, not readonly
            return false
        }
    }

    override func visit(_ node: EnumCaseDeclSyntax) -> SyntaxVisitorContinueKind {
        guard case .enumBody(_, let enumKey) = stateStack.current else {
            return .visitChildren
        }

        for element in node.elements {
            let caseName = element.name.text
            let rawValue: String?
            var associatedValues: [AssociatedValue] = []

            if exportedEnumByName[enumKey]?.rawType != nil {
                if let stringLiteral = element.rawValue?.value.as(StringLiteralExprSyntax.self) {
                    rawValue = stringLiteral.segments.first?.as(StringSegmentSyntax.self)?.content.text
                } else if let boolLiteral = element.rawValue?.value.as(BooleanLiteralExprSyntax.self) {
                    rawValue = boolLiteral.literal.text
                } else {
                    var numericExpr = element.rawValue?.value
                    var isNegative = false

                    // Check for prefix operator (for negative numbers)
                    if let prefixExpr = numericExpr?.as(PrefixOperatorExprSyntax.self),
                        prefixExpr.operator.text == "-"
                    {
                        numericExpr = prefixExpr.expression
                        isNegative = true
                    }

                    if let intLiteral = numericExpr?.as(IntegerLiteralExprSyntax.self) {
                        rawValue = isNegative ? "-\(intLiteral.literal.text)" : intLiteral.literal.text
                    } else if let floatLiteral = numericExpr?.as(FloatLiteralExprSyntax.self) {
                        rawValue = isNegative ? "-\(floatLiteral.literal.text)" : floatLiteral.literal.text
                    } else {
                        rawValue = nil
                    }
                }
            } else {
                rawValue = nil
            }
            if let parameterClause = element.parameterClause {
                for param in parameterClause.parameters {
                    guard let bridgeType = withLookupErrors({ parent.lookupType(for: param.type, errors: &$0) }) else {
                        continue
                    }

                    let label = param.firstName?.text
                    associatedValues.append(AssociatedValue(label: label, type: bridgeType))
                }
            }
            let enumCase = EnumCase(
                name: caseName,
                rawValue: rawValue,
                associatedValues: associatedValues
            )
            exportedEnumByName[enumKey]?.cases.append(enumCase)
        }

        return .visitChildren
    }

    /// Computes namespace by walking up the AST hierarchy to find parent namespace enums
    /// If parent enum is a namespace enum (no cases) then it will be used as part of namespace for given node
    ///
    ///
    /// Method allows for explicit namespace for top level enum, it will be used as base namespace and will concat enum name
    private func computeNamespace(for node: some SyntaxProtocol) -> [String]? {
        var namespace: [String] = []
        var currentNode: Syntax? = node.parent

        while let parent = currentNode {
            if let enumDecl = parent.as(EnumDeclSyntax.self),
                enumDecl.attributes.hasJSAttribute()
            {
                let isNamespaceEnum = !enumDecl.memberBlock.members.contains { member in
                    member.decl.is(EnumCaseDeclSyntax.self)
                }
                if isNamespaceEnum {
                    namespace.insert(enumDecl.name.text, at: 0)

                    if let jsAttribute = enumDecl.attributes.firstJSAttribute,
                        let explicitNamespace = extractNamespace(from: jsAttribute)
                    {
                        namespace = explicitNamespace + namespace
                        break
                    }
                }
            }
            currentNode = parent.parent
        }

        return namespace.isEmpty ? nil : namespace
    }

    /// Requires the node to have at least internal access control.
    private func computeExplicitAtLeastInternalAccessControl(
        for node: some WithModifiersSyntax,
        message: String
    ) -> String? {
        guard let accessControl = node.explicitAccessControl else {
            return nil
        }
        guard accessControl.isAtLeastInternal else {
            diagnose(
                node: accessControl,
                message: message,
                hint: "Use `internal`, `package` or `public` access control"
            )
            return nil
        }
        return accessControl.name.text
    }
}

fileprivate extension BridgeType {
    /// Returns true if a value of `expectedType` can be assigned to this type.
    func isCompatibleWith(_ expectedType: BridgeType) -> Bool {
        switch (self, expectedType) {
        case let (lhs, rhs) where lhs == rhs:
            return true
        case (.optional(let wrapped), expectedType):
            return wrapped == expectedType
        default:
            return false
        }
    }
}

import SwiftSyntax
#if canImport(BridgeJSSkeleton)
import BridgeJSSkeleton
#endif
#if canImport(BridgeJSUtilities)
import BridgeJSUtilities
#endif

private final class ImportSwiftMacrosJSImportTypeNameCollector: SyntaxAnyVisitor {
    var typeNames: Set<String> = []

    private func visitTypeDecl(_ attributes: AttributeListSyntax?, _ name: String) -> SyntaxVisitorContinueKind {
        if ImportSwiftMacrosAPICollector.AttributeChecker.hasJSClassAttribute(attributes) {
            typeNames.insert(name)
        }
        return .visitChildren
    }

    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        visitTypeDecl(node.attributes, node.name.text)
    }

    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        visitTypeDecl(node.attributes, node.name.text)
    }
}

private final class ImportSwiftMacrosAPICollector: SyntaxAnyVisitor {
    var importedFunctions: [ImportedFunctionSkeleton] = []
    var importedTypes: [ImportedTypeSkeleton] = []
    var importedGlobalGetters: [ImportedGetterSkeleton] = []
    var errors: [DiagnosticError] = []

    private let inputFilePath: String
    private var jsClassNames: Set<String>
    private let parent: SwiftToSkeleton

    // MARK: - State Management

    enum State {
        case topLevel
        case jsClassBody(name: String)
    }

    private var stateStack: [State] = [.topLevel]
    var state: State {
        return stateStack.last!
    }

    // Current type being collected (when in jsClassBody state)
    private struct CurrentType {
        let name: String
        let jsName: String?
        let from: JSImportFrom?
        var constructor: ImportedConstructorSkeleton?
        var methods: [ImportedFunctionSkeleton]
        var getters: [ImportedGetterSkeleton]
        var setters: [ImportedSetterSkeleton]
    }
    private var currentType: CurrentType?

    // MARK: - Attribute Checking

    /// Helper struct for checking and extracting attributes
    fileprivate struct AttributeChecker {
        static func hasJSFunctionAttribute(_ attributes: AttributeListSyntax?) -> Bool {
            hasAttribute(attributes, name: "JSFunction")
        }

        static func firstJSFunctionAttribute(_ attributes: AttributeListSyntax?) -> AttributeSyntax? {
            attributes?.first { attribute in
                attribute.as(AttributeSyntax.self)?.attributeName.trimmedDescription == "JSFunction"
            }?.as(AttributeSyntax.self)
        }

        static func hasJSGetterAttribute(_ attributes: AttributeListSyntax?) -> Bool {
            hasAttribute(attributes, name: "JSGetter")
        }

        static func firstJSGetterAttribute(_ attributes: AttributeListSyntax?) -> AttributeSyntax? {
            attributes?.first { attribute in
                attribute.as(AttributeSyntax.self)?.attributeName.trimmedDescription == "JSGetter"
            }?.as(AttributeSyntax.self)
        }

        static func hasJSSetterAttribute(_ attributes: AttributeListSyntax?) -> Bool {
            hasAttribute(attributes, name: "JSSetter")
        }

        static func firstJSSetterAttribute(_ attributes: AttributeListSyntax?) -> AttributeSyntax? {
            attributes?.first { attribute in
                attribute.as(AttributeSyntax.self)?.attributeName.trimmedDescription == "JSSetter"
            }?.as(AttributeSyntax.self)
        }

        static func hasJSClassAttribute(_ attributes: AttributeListSyntax?) -> Bool {
            hasAttribute(attributes, name: "JSClass")
        }

        static func firstJSClassAttribute(_ attributes: AttributeListSyntax?) -> AttributeSyntax? {
            attributes?.first { attribute in
                attribute.as(AttributeSyntax.self)?.attributeName.trimmedDescription == "JSClass"
            }?.as(AttributeSyntax.self)
        }

        static func hasAttribute(_ attributes: AttributeListSyntax?, name: String) -> Bool {
            guard let attributes else { return false }
            return attributes.contains { attribute in
                guard let syntax = attribute.as(AttributeSyntax.self) else { return false }
                return syntax.attributeName.trimmedDescription == name
            }
        }

        /// Extracts the `jsName` argument value from an attribute, if present.
        static func extractJSName(from attribute: AttributeSyntax) -> String? {
            guard let arguments = attribute.arguments?.as(LabeledExprListSyntax.self) else {
                return nil
            }
            for argument in arguments {
                if argument.label?.text == "jsName",
                    let stringLiteral = argument.expression.as(StringLiteralExprSyntax.self),
                    let segment = stringLiteral.segments.first?.as(StringSegmentSyntax.self)
                {
                    return segment.content.text
                }
            }
            return nil
        }

        /// Extracts the `from` argument value from an attribute, if present.
        static func extractJSImportFrom(from attribute: AttributeSyntax) -> JSImportFrom? {
            guard let arguments = attribute.arguments?.as(LabeledExprListSyntax.self) else {
                return nil
            }
            for argument in arguments {
                guard argument.label?.text == "from" else { continue }

                // Accept `.global`, `JSImportFrom.global`, etc.
                let description = argument.expression.trimmedDescription
                let caseName = description.split(separator: ".").last.map(String.init) ?? description
                return JSImportFrom(rawValue: caseName)
            }
            return nil
        }
    }

    // MARK: - Validation Helpers

    /// Common validation result for setter functions
    private struct SetterValidationResult {
        let effects: Effects
        let jsName: String?
        let firstParam: FunctionParameterSyntax
        let valueType: BridgeType
    }

    /// Validates effects (throws required, async not supported)
    private func validateEffects(
        _ effects: FunctionEffectSpecifiersSyntax?,
        node: some SyntaxProtocol,
        attributeName: String
    ) -> Effects? {
        guard let effects = parseEffects(effects) else {
            errors.append(
                DiagnosticError(
                    node: node,
                    message: "@\(attributeName) declarations must be throws.",
                    hint: "Declare the function as 'throws (JSException)'."
                )
            )
            return nil
        }
        if effects.isAsync {
            errors.append(
                DiagnosticError(
                    node: node,
                    message: "@\(attributeName) declarations do not support async yet."
                )
            )
            return nil
        }
        return effects
    }

    /// Validates a setter function and extracts common information
    private func validateSetter(_ node: FunctionDeclSyntax, jsSetter: AttributeSyntax) -> SetterValidationResult? {
        guard let effects = validateEffects(node.signature.effectSpecifiers, node: node, attributeName: "JSSetter")
        else {
            return nil
        }

        let jsName = AttributeChecker.extractJSName(from: jsSetter)
        let parameters = node.signature.parameterClause.parameters

        guard let firstParam = parameters.first else {
            errors.append(
                DiagnosticError(
                    node: node,
                    message: "@JSSetter function must have at least one parameter."
                )
            )
            return nil
        }

        if firstParam.type.is(MissingTypeSyntax.self) {
            errors.append(
                DiagnosticError(
                    node: firstParam,
                    message: "All @JSSetter parameters must have explicit types."
                )
            )
            return nil
        }

        guard let valueType = withLookupErrors({ parent.lookupType(for: firstParam.type, errors: &$0) }) else {
            return nil
        }

        return SetterValidationResult(
            effects: effects,
            jsName: jsName,
            firstParam: firstParam,
            valueType: valueType
        )
    }

    // MARK: - Property Name Resolution

    /// Helper for resolving property names from setter function names.
    private struct PropertyNameResolver {
        /// Resolves property name and function base name from a setter function.
        /// - Returns: (propertyName, functionBaseName) where `propertyName` is derived from the setter name,
        ///   and `functionBaseName` has lowercase first char for ABI generation.
        static func resolve(
            functionName: String,
            normalizeIdentifier: (String) -> String
        ) -> (propertyName: String, functionBaseName: String)? {
            let rawFunctionName =
                functionName.hasPrefix("`") && functionName.hasSuffix("`") && functionName.count > 2
                ? String(functionName.dropFirst().dropLast())
                : functionName

            guard rawFunctionName.hasPrefix("set"), rawFunctionName.count > 3 else {
                return nil
            }

            let derivedPropertyName = String(rawFunctionName.dropFirst(3))
            let normalized = normalizeIdentifier(derivedPropertyName)
            let propertyName = normalized.prefix(1).lowercased() + normalized.dropFirst()
            return (propertyName: propertyName, functionBaseName: propertyName)
        }
    }

    init(inputFilePath: String, knownJSClassNames: Set<String>, parent: SwiftToSkeleton) {
        self.inputFilePath = inputFilePath
        self.jsClassNames = knownJSClassNames
        self.parent = parent
        super.init(viewMode: .sourceAccurate)
    }

    private func withLookupErrors<T>(_ body: (inout [DiagnosticError]) -> T) -> T {
        var errs = self.errors
        defer { self.errors = errs }
        return body(&errs)
    }

    private func enterJSClass(_ typeName: String) {
        stateStack.append(.jsClassBody(name: typeName))
        currentType = CurrentType(
            name: typeName,
            jsName: nil,
            from: nil,
            constructor: nil,
            methods: [],
            getters: [],
            setters: []
        )
    }

    private func enterJSClass(_ typeName: String, jsName: String?, from: JSImportFrom?) {
        stateStack.append(.jsClassBody(name: typeName))
        currentType = CurrentType(
            name: typeName,
            jsName: jsName,
            from: from,
            constructor: nil,
            methods: [],
            getters: [],
            setters: []
        )
    }

    private func exitJSClass() {
        if case .jsClassBody(let typeName) = state, let type = currentType, type.name == typeName {
            importedTypes.append(
                ImportedTypeSkeleton(
                    name: type.name,
                    jsName: type.jsName,
                    from: type.from,
                    constructor: type.constructor,
                    methods: type.methods,
                    getters: type.getters,
                    setters: type.setters,
                    documentation: nil
                )
            )
            currentType = nil
        }
        stateStack.removeLast()
    }

    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        if AttributeChecker.hasJSClassAttribute(node.attributes) {
            let attribute = AttributeChecker.firstJSClassAttribute(node.attributes)
            let jsName = attribute.flatMap(AttributeChecker.extractJSName)
            let from = attribute.flatMap(AttributeChecker.extractJSImportFrom)
            enterJSClass(node.name.text, jsName: jsName, from: from)
        }
        return .visitChildren
    }

    override func visitPost(_ node: StructDeclSyntax) {
        if AttributeChecker.hasJSClassAttribute(node.attributes) {
            exitJSClass()
        }
    }

    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        if AttributeChecker.hasJSClassAttribute(node.attributes) {
            let attribute = AttributeChecker.firstJSClassAttribute(node.attributes)
            let jsName = attribute.flatMap(AttributeChecker.extractJSName)
            let from = attribute.flatMap(AttributeChecker.extractJSImportFrom)
            enterJSClass(node.name.text, jsName: jsName, from: from)
        }
        return .visitChildren
    }

    override func visitPost(_ node: ClassDeclSyntax) {
        if AttributeChecker.hasJSClassAttribute(node.attributes) {
            exitJSClass()
        }
    }

    // MARK: - Visitor Methods

    override func visit(_ node: ExtensionDeclSyntax) -> SyntaxVisitorContinueKind {
        let typeName = node.extendedType.trimmedDescription
        collectStaticMembers(in: node.memberBlock.members, typeName: typeName)
        return .skipChildren
    }

    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        switch state {
        case .topLevel:
            return handleTopLevelFunction(node)

        case .jsClassBody(let typeName):
            guard var type = currentType, type.name == typeName else {
                return .skipChildren
            }
            let isStaticMember = isStatic(node.modifiers)
            let handled = handleClassFunction(node, typeName: typeName, isStaticMember: isStaticMember, type: &type)
            if handled {
                currentType = type
            }
            return .skipChildren
        }
    }

    private func handleTopLevelFunction(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        if let jsFunction = AttributeChecker.firstJSFunctionAttribute(node.attributes),
            let function = parseFunction(jsFunction, node, enclosingTypeName: nil, isStaticMember: true)
        {
            importedFunctions.append(function)
            return .skipChildren
        }
        // Top-level setters are not supported
        if AttributeChecker.hasJSSetterAttribute(node.attributes) {
            errors.append(
                DiagnosticError(
                    node: node,
                    message: "@JSSetter is not supported at top-level. Use it only in @JSClass types."
                )
            )
            return .skipChildren
        }
        return .visitChildren
    }

    private func handleClassFunction(
        _ node: FunctionDeclSyntax,
        typeName: String,
        isStaticMember: Bool,
        type: inout CurrentType
    ) -> Bool {
        if let jsFunction = AttributeChecker.firstJSFunctionAttribute(node.attributes) {
            if isStaticMember {
                parseFunction(jsFunction, node, enclosingTypeName: typeName, isStaticMember: true).map {
                    importedFunctions.append($0)
                }
            } else {
                parseFunction(jsFunction, node, enclosingTypeName: typeName, isStaticMember: false).map {
                    type.methods.append($0)
                }
            }
            return true
        }

        if AttributeChecker.hasJSSetterAttribute(node.attributes) {
            if isStaticMember {
                errors.append(
                    DiagnosticError(
                        node: node,
                        message:
                            "@JSSetter is not supported for static members. Use it only for instance members in @JSClass types."
                    )
                )
            } else if let jsSetter = AttributeChecker.firstJSSetterAttribute(node.attributes),
                let setter = parseSetterSkeleton(jsSetter, node)
            {
                type.setters.append(setter)
            }
            return true
        }

        return false
    }

    override func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
        guard AttributeChecker.hasJSGetterAttribute(node.attributes) else {
            return .visitChildren
        }
        guard let jsGetter = AttributeChecker.firstJSGetterAttribute(node.attributes) else {
            return .skipChildren
        }

        switch state {
        case .topLevel:
            if let getter = parseGetterSkeleton(jsGetter, node) {
                importedGlobalGetters.append(getter)
            }
            return .skipChildren

        case .jsClassBody(let typeName):
            guard var type = currentType, type.name == typeName else {
                return .skipChildren
            }
            if isStatic(node.modifiers) {
                errors.append(
                    DiagnosticError(
                        node: node,
                        message:
                            "@JSGetter is not supported for static members. Use it only for instance members in @JSClass types."
                    )
                )
            } else if let getter = parseGetterSkeleton(jsGetter, node) {
                type.getters.append(getter)
                currentType = type
            }
            return .skipChildren
        }
    }

    override func visit(_ node: InitializerDeclSyntax) -> SyntaxVisitorContinueKind {
        guard AttributeChecker.hasJSFunctionAttribute(node.attributes) else {
            return .visitChildren
        }

        switch state {
        case .topLevel:
            return .visitChildren

        case .jsClassBody(let typeName):
            guard var type = currentType, type.name == typeName else {
                return .skipChildren
            }
            if type.constructor != nil {
                errors.append(
                    DiagnosticError(
                        node: node,
                        message: "Only one @JSFunction initializer is supported in @JSClass types."
                    )
                )
                return .skipChildren
            }
            if let parsed = parseConstructor(node, typeName: typeName) {
                type.constructor = parsed
                currentType = type
            }
            return .skipChildren
        }
    }

    // MARK: - Member Collection

    private func collectStaticMembers(in members: MemberBlockItemListSyntax, typeName: String) {
        for member in members {
            if let function = member.decl.as(FunctionDeclSyntax.self) {
                if let jsFunction = AttributeChecker.firstJSFunctionAttribute(function.attributes),
                    let parsed = parseFunction(jsFunction, function, enclosingTypeName: typeName, isStaticMember: true)
                {
                    importedFunctions.append(parsed)
                } else if AttributeChecker.hasJSSetterAttribute(function.attributes) {
                    errors.append(
                        DiagnosticError(
                            node: function,
                            message:
                                "@JSSetter is not supported for static members. Use it only for instance members in @JSClass types."
                        )
                    )
                }
            } else if let variable = member.decl.as(VariableDeclSyntax.self),
                AttributeChecker.hasJSGetterAttribute(variable.attributes)
            {
                errors.append(
                    DiagnosticError(
                        node: variable,
                        message:
                            "@JSGetter is not supported for static members. Use it only for instance members in @JSClass types."
                    )
                )
            }
        }
    }

    // MARK: - Parsing Methods

    private func parseConstructor(
        _ initializer: InitializerDeclSyntax,
        typeName: String
    ) -> ImportedConstructorSkeleton? {
        guard
            validateEffects(initializer.signature.effectSpecifiers, node: initializer, attributeName: "JSFunction")
                != nil
        else {
            return nil
        }
        return ImportedConstructorSkeleton(
            parameters: parseParameters(from: initializer.signature.parameterClause)
        )
    }

    private func parseFunction(
        _ jsFunction: AttributeSyntax,
        _ node: FunctionDeclSyntax,
        enclosingTypeName: String?,
        isStaticMember: Bool
    ) -> ImportedFunctionSkeleton? {
        guard validateEffects(node.signature.effectSpecifiers, node: node, attributeName: "JSFunction") != nil
        else {
            return nil
        }

        let baseName = SwiftToSkeleton.normalizeIdentifier(node.name.text)
        let jsName = AttributeChecker.extractJSName(from: jsFunction)
        let from = AttributeChecker.extractJSImportFrom(from: jsFunction)
        let name: String
        if isStaticMember, let enclosingTypeName {
            name = "\(enclosingTypeName)_\(baseName)"
        } else {
            name = baseName
        }

        let parameters = parseParameters(from: node.signature.parameterClause)
        let returnType: BridgeType
        if let returnTypeSyntax = node.signature.returnClause?.type {
            guard let resolved = withLookupErrors({ parent.lookupType(for: returnTypeSyntax, errors: &$0) }) else {
                return nil
            }
            returnType = resolved
        } else {
            returnType = .void
        }
        return ImportedFunctionSkeleton(
            name: name,
            jsName: jsName,
            from: from,
            parameters: parameters,
            returnType: returnType,
            documentation: nil
        )
    }

    /// Extracts property info from a VariableDeclSyntax (binding, identifier, type)
    private func extractPropertyInfo(
        _ node: VariableDeclSyntax,
        errorMessage: String = "@JSGetter must declare a single stored property with an explicit type."
    ) -> (identifier: IdentifierPatternSyntax, type: TypeSyntax)? {
        guard let binding = node.bindings.first,
            let identifier = binding.pattern.as(IdentifierPatternSyntax.self),
            let typeAnnotation = binding.typeAnnotation
        else {
            errors.append(DiagnosticError(node: node, message: errorMessage))
            return nil
        }
        return (identifier, typeAnnotation.type)
    }

    private func parseGetterSkeleton(
        _ jsGetter: AttributeSyntax,
        _ node: VariableDeclSyntax
    ) -> ImportedGetterSkeleton? {
        guard let (identifier, type) = extractPropertyInfo(node) else {
            return nil
        }
        guard let propertyType = withLookupErrors({ parent.lookupType(for: type, errors: &$0) }) else {
            return nil
        }
        let propertyName = SwiftToSkeleton.normalizeIdentifier(identifier.identifier.text)
        let jsName = AttributeChecker.extractJSName(from: jsGetter)
        let from = AttributeChecker.extractJSImportFrom(from: jsGetter)
        return ImportedGetterSkeleton(
            name: propertyName,
            jsName: jsName,
            from: from,
            type: propertyType,
            documentation: nil,
            functionName: nil
        )
    }

    /// Parses a setter as part of a type's property system (for instance setters)
    private func parseSetterSkeleton(
        _ jsSetter: AttributeSyntax,
        _ node: FunctionDeclSyntax
    ) -> ImportedSetterSkeleton? {
        guard let validation = validateSetter(node, jsSetter: jsSetter) else {
            return nil
        }

        let functionName = node.name.text
        guard
            let (propertyName, functionBaseName) = PropertyNameResolver.resolve(
                functionName: functionName,
                normalizeIdentifier: SwiftToSkeleton.normalizeIdentifier
            )
        else {
            return nil
        }

        return ImportedSetterSkeleton(
            name: propertyName,
            jsName: validation.jsName,
            type: validation.valueType,
            documentation: nil,
            functionName: "\(functionBaseName)_set"
        )
    }

    // MARK: - Type and Parameter Parsing

    private func parseParameters(from clause: FunctionParameterClauseSyntax) -> [Parameter] {
        clause.parameters.compactMap { param in
            let type = param.type
            if type.is(MissingTypeSyntax.self) {
                errors.append(
                    DiagnosticError(
                        node: param,
                        message: "All @JSFunction parameters must have explicit types."
                    )
                )
                return nil
            }
            guard let bridgeType = withLookupErrors({ parent.lookupType(for: type, errors: &$0) }) else {
                return nil
            }
            let nameToken = param.secondName ?? param.firstName
            let name = SwiftToSkeleton.normalizeIdentifier(nameToken.text)
            let labelToken = param.secondName == nil ? nil : param.firstName
            let label = labelToken?.text == "_" ? nil : labelToken?.text
            return Parameter(label: label, name: name, type: bridgeType)
        }
    }

    // MARK: - Helper Methods

    private func parseEffects(_ effects: FunctionEffectSpecifiersSyntax?) -> Effects? {
        let isThrows = effects?.throwsClause != nil
        let isAsync = effects?.asyncSpecifier != nil
        guard isThrows else {
            return nil
        }
        return Effects(isAsync: isAsync, isThrows: isThrows)
    }

    private func isStatic(_ modifiers: DeclModifierListSyntax?) -> Bool {
        guard let modifiers else { return false }
        return modifiers.contains { modifier in
            modifier.name.tokenKind == .keyword(.static) || modifier.name.tokenKind == .keyword(.class)
        }
    }
}
