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

    private var exportedFunctions: [ExportedFunction] = []
    private var exportedClasses: [ExportedClass] = []
    private var exportedEnums: [ExportedEnum] = []
    private var exportedProtocols: [ExportedProtocol] = []
    private var exportedProtocolNameByKey: [String: String] = [:]
    private var typeDeclResolver: TypeDeclResolver = TypeDeclResolver()
    private let enumCodegen: EnumCodegen = EnumCodegen()

    public init(progress: ProgressReporting, moduleName: String) {
        self.progress = progress
        self.moduleName = moduleName
    }

    /// Processes a Swift source file to find declarations marked with @JS
    ///
    /// - Parameters:
    ///   - sourceFile: The parsed Swift source file to process
    ///   - inputFilePath: The file path for error reporting
    public func addSourceFile(_ sourceFile: SourceFileSyntax, _ inputFilePath: String) throws {
        progress.print("Processing \(inputFilePath)")
        typeDeclResolver.addSourceFile(sourceFile)

        let errors = try parseSingleFile(sourceFile)
        if errors.count > 0 {
            throw BridgeJSCoreError(
                errors.map { $0.formattedDescription(fileName: inputFilePath) }
                    .joined(separator: "\n")
            )
        }
    }

    /// Finalizes the export process and generates the bridge code
    ///
    /// - Returns: A tuple containing the generated Swift code and a skeleton
    /// describing the exported APIs
    public func finalize() throws -> (outputSwift: String, outputSkeleton: ExportedSkeleton)? {
        guard let outputSwift = try renderSwiftGlue() else {
            return nil
        }
        return (
            outputSwift: outputSwift,
            outputSkeleton: ExportedSkeleton(
                moduleName: moduleName,
                functions: exportedFunctions,
                classes: exportedClasses,
                enums: exportedEnums,
                protocols: exportedProtocols
            )
        )
    }

    fileprivate final class APICollector: SyntaxAnyVisitor {
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
        var errors: [DiagnosticError] = []

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
        let parent: ExportSwift

        init(parent: ExportSwift) {
            self.parent = parent
            super.init(viewMode: .sourceAccurate)
        }

        private func diagnose(node: some SyntaxProtocol, message: String, hint: String? = nil) {
            errors.append(DiagnosticError(node: node, message: message, hint: hint))
        }

        private func diagnoseUnsupportedType(node: some SyntaxProtocol, type: String) {
            diagnose(
                node: node,
                message: "Unsupported type: \(type)",
                hint: "Only primitive types and types defined in the same module are allowed"
            )
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
            if expression.is(ArrayExprSyntax.self) { return false }
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

            let className = calledExpr.baseName.text
            let expectedClassName: String?
            switch type {
            case .swiftHeapObject(let name):
                expectedClassName = name.split(separator: ".").last.map(String.init)
            case .optional(.swiftHeapObject(let name)):
                expectedClassName = name.split(separator: ".").last.map(String.init)
            default:
                diagnose(
                    node: funcCall,
                    message: "Constructor calls are only supported for class types",
                    hint: "Parameter type should be a Swift class"
                )
                return nil
            }

            guard let expectedClassName = expectedClassName, className == expectedClassName else {
                diagnose(
                    node: funcCall,
                    message: "Constructor class name '\(className)' doesn't match parameter type",
                    hint: "Ensure the constructor matches the parameter type"
                )
                return nil
            }

            if funcCall.arguments.isEmpty {
                return .object(className)
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

            return .objectWithArguments(className, constructorArgs)
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

        /// Shared parameter parsing logic used by functions, initializers, and protocol methods
        private func parseParameters(
            from parameterClause: FunctionParameterClauseSyntax,
            allowDefaults: Bool = true
        ) -> [Parameter] {
            var parameters: [Parameter] = []

            for param in parameterClause.parameters {
                let resolvedType = self.parent.lookupType(for: param.type)

                if let type = resolvedType, case .optional(let wrappedType) = type, wrappedType.isOptional {
                    diagnoseNestedOptional(node: param.type, type: param.type.trimmedDescription)
                    continue
                }

                guard let type = resolvedType else {
                    diagnoseUnsupportedType(node: param.type, type: param.type.trimmedDescription)
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
            }
        }

        private func visitFunction(
            node: FunctionDeclSyntax,
            isStatic: Bool,
            className: String? = nil,
            classKey: String? = nil,
            enumName: String? = nil
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
                let resolvedType = self.parent.lookupType(for: returnClause.type)

                if let type = resolvedType, case .optional(let wrappedType) = type, wrappedType.isOptional {
                    diagnoseNestedOptional(node: returnClause.type, type: returnClause.type.trimmedDescription)
                    return nil
                }

                guard let type = resolvedType else {
                    diagnoseUnsupportedType(node: returnClause.type, type: returnClause.type.trimmedDescription)
                    return nil
                }
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
                staticContext = isNamespaceEnum ? .namespaceEnum : .enumName(enumName)
            case .protocolBody(_, _):
                return nil
            }

            let classNameForABI: String?
            if case .classBody(let className, _) = state {
                classNameForABI = className
            } else {
                classNameForABI = nil
            }
            abiName = ABINameGenerator.generateABIName(
                baseName: name,
                namespace: finalNamespace,
                staticContext: isStatic ? staticContext : nil,
                operation: nil,
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
            guard case .classBody(let className, _) = state else {
                if case .enumBody(_, _) = state {
                    diagnose(node: node, message: "Initializers are not supported inside enums")
                } else {
                    diagnose(node: node, message: "@JS init must be inside a @JS class")
                }
                return .skipChildren
            }

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
            if case .classBody(_, let classKey) = state {
                exportedClassByName[classKey]?.constructor = constructor
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
            let classKey: String

            switch state {
            case .classBody(let className, let key):
                classKey = key
                staticContext = isStatic ? .className(className) : nil
            case .enumBody(let enumName, let enumKey):
                if !isStatic {
                    diagnose(node: node, message: "Only static properties are supported in enums")
                    return .skipChildren
                }
                classKey = enumKey

                let isNamespaceEnum = exportedEnumByName[enumKey]?.cases.isEmpty ?? true
                staticContext = isStatic ? (isNamespaceEnum ? .namespaceEnum : .enumName(enumName)) : nil

            case .topLevel:
                diagnose(node: node, message: "@JS var must be inside a @JS class or enum")
                return .skipChildren
            case .protocolBody(let protocolName, let protocolKey):
                return visitProtocolProperty(node: node, protocolName: protocolName, protocolKey: protocolKey)
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

                guard let propertyType = self.parent.lookupType(for: typeAnnotation.type) else {
                    diagnoseUnsupportedType(node: typeAnnotation.type, type: typeAnnotation.type.trimmedDescription)
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

                if case .enumBody(_, let enumKey) = state {
                    if var currentEnum = exportedEnumByName[enumKey] {
                        currentEnum.staticProperties.append(exportedProperty)
                        exportedEnumByName[enumKey] = currentEnum
                    }
                } else {
                    exportedClassByName[classKey]?.properties.append(exportedProperty)
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
            let swiftCallName = ExportSwift.computeSwiftCallName(for: node, itemName: name)
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
                return Constants.supportedRawTypes.contains(typeName)
            }?.type.trimmedDescription

            let namespaceResult = resolveNamespace(from: jsAttribute, for: node, declarationType: "enum")
            guard namespaceResult.isValid else {
                return .skipChildren
            }
            let emitStyle = extractEnumStyle(from: jsAttribute) ?? .const
            let swiftCallName = ExportSwift.computeSwiftCallName(for: node, itemName: name)
            let explicitAccessControl = computeExplicitAtLeastInternalAccessControl(
                for: node,
                message: "Enum visibility must be at least internal"
            )

            // Create enum directly in dictionary
            let exportedEnum = ExportedEnum(
                name: name,
                swiftCallName: swiftCallName,
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
                // Check for Bool raw type limitation
                if exportedEnum.rawType == .bool {
                    diagnose(
                        node: jsAttribute,
                        message: "TypeScript enum style is not supported for Bool raw-value enums",
                        hint: "Use enumStyle: .const or change the raw type to String or a numeric type"
                    )
                }

                // Check for static functions limitation
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

            parent.exportedProtocolNameByKey[protocolUniqueKey] = name

            return .skipChildren
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
                let resolvedType = self.parent.lookupType(for: returnClause.type)

                if let type = resolvedType, case .optional(let wrappedType) = type, wrappedType.isOptional {
                    diagnoseNestedOptional(node: returnClause.type, type: returnClause.type.trimmedDescription)
                    return nil
                }

                guard let type = resolvedType else {
                    diagnoseUnsupportedType(node: returnClause.type, type: returnClause.type.trimmedDescription)
                    return nil
                }
                returnType = type
            } else {
                returnType = .void
            }

            let abiName = ABINameGenerator.generateABIName(
                baseName: name,
                namespace: namespace,
                staticContext: nil,
                operation: nil,
                className: protocolName
            )

            guard let effects = collectEffects(signature: node.signature) else {
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

                guard let propertyType = self.parent.lookupType(for: typeAnnotation.type) else {
                    diagnoseUnsupportedType(node: typeAnnotation.type, type: typeAnnotation.type.trimmedDescription)
                    continue
                }

                if case .optional = propertyType {
                    diagnose(
                        node: typeAnnotation.type,
                        message: "Optional properties are not yet supported in protocols"
                    )
                    continue
                }

                guard let accessorBlock = binding.accessorBlock else {
                    diagnose(
                        node: binding,
                        message: "Protocol property must specify { get } or { get set }",
                        hint: "Add { get } for readonly or { get set } for readwrite property"
                    )
                    continue
                }

                let isReadonly = hasOnlyGetter(accessorBlock)

                let exportedProperty = ExportedProtocolProperty(
                    name: propertyName,
                    type: propertyType,
                    isReadonly: isReadonly
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
                        guard let bridgeType = parent.lookupType(for: param.type) else {
                            diagnose(
                                node: param.type,
                                message: "Unsupported associated value type: \(param.type.trimmedDescription)",
                                hint: "Only primitive types and types defined in the same module are allowed"
                            )
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

    func parseSingleFile(_ sourceFile: SourceFileSyntax) throws -> [DiagnosticError] {
        let collector = APICollector(parent: self)
        collector.walk(sourceFile)
        exportedFunctions.append(contentsOf: collector.exportedFunctions)
        exportedClasses.append(
            contentsOf: collector.exportedClassNames.map {
                collector.exportedClassByName[$0]!
            }
        )
        exportedEnums.append(
            contentsOf: collector.exportedEnumNames.map {
                collector.exportedEnumByName[$0]!
            }
        )
        exportedProtocols.append(
            contentsOf: collector.exportedProtocolNames.map {
                collector.exportedProtocolByName[$0]!
            }
        )

        return collector.errors
    }

    /// Computes the full Swift call name by walking up the AST hierarchy to find all parent enums
    /// This generates the qualified name needed for Swift code generation (e.g., "Networking.API.HTTPServer")
    private static func computeSwiftCallName(for node: some SyntaxProtocol, itemName: String) -> String {
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

    func lookupType(for type: TypeSyntax) -> BridgeType? {
        // T?
        if let optionalType = type.as(OptionalTypeSyntax.self) {
            let wrappedType = optionalType.wrappedType
            if let baseType = lookupType(for: wrappedType) {
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
            if let baseType = lookupType(for: argType) {
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
            if let wrappedType = lookupType(for: argType) {
                return .optional(wrappedType)
            }
        }
        if let aliasDecl = typeDeclResolver.resolveTypeAlias(type) {
            if let resolvedType = lookupType(for: aliasDecl.initializer.value) {
                return resolvedType
            }
        }

        let typeName = type.trimmedDescription
        if let primitiveType = BridgeType(swiftType: typeName) {
            return primitiveType
        }

        let protocolKey = typeName
        if let protocolName = exportedProtocolNameByKey[protocolKey] {
            return .swiftProtocol(protocolName)
        }

        guard let typeDecl = typeDeclResolver.resolve(type) else {
            return nil
        }

        if typeDecl.is(ProtocolDeclSyntax.self) {
            let swiftCallName = ExportSwift.computeSwiftCallName(for: typeDecl, itemName: typeDecl.name.text)
            return .swiftProtocol(swiftCallName)
        }

        if let enumDecl = typeDecl.as(EnumDeclSyntax.self) {
            let swiftCallName = ExportSwift.computeSwiftCallName(for: enumDecl, itemName: enumDecl.name.text)
            let rawTypeString = enumDecl.inheritanceClause?.inheritedTypes.first { inheritedType in
                let typeName = inheritedType.type.trimmedDescription
                return Constants.supportedRawTypes.contains(typeName)
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

        guard typeDecl.is(ClassDeclSyntax.self) || typeDecl.is(ActorDeclSyntax.self) else {
            return nil
        }
        let swiftCallName = ExportSwift.computeSwiftCallName(for: typeDecl, itemName: typeDecl.name.text)
        return .swiftHeapObject(swiftCallName)
    }

    static let prelude: DeclSyntax = """
        // NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
        // DO NOT EDIT.
        //
        // To update this file, just rebuild your project or run
        // `swift package bridge-js`.

        @_spi(BridgeJS) import JavaScriptKit
        """

    func renderSwiftGlue() throws -> String? {
        var decls: [DeclSyntax] = []
        guard
            exportedFunctions.count > 0 || exportedClasses.count > 0 || exportedEnums.count > 0
                || exportedProtocols.count > 0
        else {
            return nil
        }
        decls.append(Self.prelude)

        for proto in exportedProtocols {
            decls.append(try renderProtocolWrapper(protocol: proto))
        }

        for enumDef in exportedEnums {
            switch enumDef.enumType {
            case .simple:
                decls.append(enumCodegen.renderCaseEnumHelpers(enumDef))
            case .rawValue:
                decls.append("extension \(raw: enumDef.swiftCallName): _BridgedSwiftEnumNoPayload {}")
            case .associatedValue:
                decls.append(enumCodegen.renderAssociatedValueEnumHelpers(enumDef))
            case .namespace:
                ()
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

        for function in exportedFunctions {
            decls.append(try renderSingleExportedFunction(function: function))
        }
        for klass in exportedClasses {
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
            switch param.type {
            case .optional(let wrappedType):
                typeNameForIntrinsic = "Optional<\(wrappedType.swiftType)>"
            default:
                typeNameForIntrinsic = param.type.swiftType
            }

            liftedParameterExprs.append(
                ExprSyntax(
                    "\(raw: typeNameForIntrinsic).bridgeJSLiftParameter(\(raw: argumentsToLift.joined(separator: ", ")))"
                )
            )
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

        func callMethod(klassName: String, methodName: String, returnType: BridgeType) {
            let (_, selfExpr) = removeFirstLiftedParameter()
            let item = renderCallStatement(
                callee: "\(raw: selfExpr).\(raw: methodName)",
                returnType: returnType
            )
            append(item)
        }

        func callPropertyGetter(klassName: String, propertyName: String, returnType: BridgeType) {
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

        func callPropertySetter(klassName: String, propertyName: String) {
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

            append("return ret.bridgeJSLowerReturn()")
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
            return """
                @_expose(wasm, "\(raw: abiName)")
                @_cdecl("\(raw: abiName)")
                public func _\(raw: abiName)(\(raw: parameterSignature())) -> \(raw: returnSignature()) {
                    #if arch(wasm32)
                \(body)
                    #else
                    fatalError("Only available on WebAssembly")
                    #endif
                }
                """
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

        func parameterSignature() -> String {
            var nameAndType: [(name: String, abiType: String)] = []
            for (name, type) in abiParameterSignatures {
                nameAndType.append((name, type.swiftType))
            }
            return nameAndType.map { "\($0.name): \($0.abiType)" }.joined(separator: ", ")
        }

        func returnSignature() -> String {
            return abiReturnType?.swiftType ?? "Void"
        }
    }

    private struct EnumCodegen {
        func renderCaseEnumHelpers(_ enumDef: ExportedEnum) -> DeclSyntax {
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
                        return \(raw: typeName)(bridgeJSRawValue: value)!
                    }
                    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ value: Int32) -> \(raw: typeName) {
                        return \(raw: typeName)(bridgeJSRawValue: value)!
                    }
                    @_spi(BridgeJS) @_transparent public consuming func bridgeJSLowerReturn() -> Int32 {
                        return bridgeJSRawValue
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

        func renderAssociatedValueEnumHelpers(_ enumDef: ExportedEnum) -> DeclSyntax {
            let typeName = enumDef.swiftCallName
            return """
                extension \(raw: typeName): _BridgedSwiftAssociatedValueEnum {
                    @_spi(BridgeJS) @_transparent public static func bridgeJSLiftParameter(_ caseId: Int32) -> \(raw: typeName) {
                        switch caseId {
                        \(raw: generateStackLiftSwitchCases(enumDef: enumDef).joined(separator: "\n"))
                        default: fatalError("Unknown \(raw: typeName) case ID: \\(caseId)")
                        }
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
                        let paramName: String
                        if let label = associatedValue.label {
                            paramName = "\(label): "
                        } else {
                            paramName = ""
                        }
                        switch associatedValue.type {
                        case .string:
                            return
                                "\(paramName)String.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32())"
                        case .int:
                            return "\(paramName)Int.bridgeJSLiftParameter(_swift_js_pop_param_int32())"
                        case .bool:
                            return "\(paramName)Bool.bridgeJSLiftParameter(_swift_js_pop_param_int32())"
                        case .float:
                            return "\(paramName)Float.bridgeJSLiftParameter(_swift_js_pop_param_f32())"
                        case .double:
                            return "\(paramName)Double.bridgeJSLiftParameter(_swift_js_pop_param_f64())"
                        case .optional(let wrappedType):
                            switch wrappedType {
                            case .string:
                                return
                                    "\(paramName)Optional<String>.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32(), _swift_js_pop_param_int32())"
                            case .int:
                                return
                                    "\(paramName)Optional<Int>.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32())"
                            case .bool:
                                return
                                    "\(paramName)Optional<Bool>.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_int32())"
                            case .float:
                                return
                                    "\(paramName)Optional<Float>.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_f32())"
                            case .double:
                                return
                                    "\(paramName)Optional<Double>.bridgeJSLiftParameter(_swift_js_pop_param_int32(), _swift_js_pop_param_f64())"
                            default:
                                return ""
                            }
                        default:
                            return "\(paramName)Int.bridgeJSLiftParameter(_swift_js_pop_param_int32())"
                        }
                    }
                    lines.append("return .\(enumCase.name)(\(argList.joined(separator: ", ")))")
                    cases.append(lines.joined(separator: "\n"))
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
                    var bodyLines: [String] = []
                    bodyLines.append("_swift_js_push_tag(Int32(\(caseIndex)))")
                    for (index, associatedValue) in enumCase.associatedValues.enumerated() {
                        let paramName = associatedValue.label ?? "param\(index)"
                        switch associatedValue.type {
                        case .string:
                            bodyLines.append("var __bjs_\(paramName) = \(paramName)")
                            bodyLines.append("__bjs_\(paramName).withUTF8 { ptr in")
                            bodyLines.append("_swift_js_push_string(ptr.baseAddress, Int32(ptr.count))")
                            bodyLines.append("}")
                        case .int:
                            bodyLines.append("_swift_js_push_int(Int32(\(paramName)))")
                        case .bool:
                            bodyLines.append("_swift_js_push_int(\(paramName) ? 1 : 0)")
                        case .float:
                            bodyLines.append("_swift_js_push_f32(\(paramName))")
                        case .double:
                            bodyLines.append("_swift_js_push_f64(\(paramName))")
                        case .optional(let wrappedType):
                            bodyLines.append("let __bjs_isSome_\(paramName) = \(paramName) != nil")
                            bodyLines.append("if let __bjs_unwrapped_\(paramName) = \(paramName) {")
                            switch wrappedType {
                            case .string:
                                bodyLines.append("var __bjs_str_\(paramName) = __bjs_unwrapped_\(paramName)")
                                bodyLines.append("__bjs_str_\(paramName).withUTF8 { ptr in")
                                bodyLines.append("_swift_js_push_string(ptr.baseAddress, Int32(ptr.count))")
                                bodyLines.append("}")
                            case .int:
                                bodyLines.append("_swift_js_push_int(Int32(__bjs_unwrapped_\(paramName)))")
                            case .bool:
                                bodyLines.append("_swift_js_push_int(__bjs_unwrapped_\(paramName) ? 1 : 0)")
                            case .float:
                                bodyLines.append("_swift_js_push_f32(__bjs_unwrapped_\(paramName))")
                            case .double:
                                bodyLines.append("_swift_js_push_f64(__bjs_unwrapped_\(paramName))")
                            default:
                                bodyLines.append(
                                    "preconditionFailure(\"BridgeJS: unsupported optional wrapped type in generated code\")"
                                )
                            }
                            bodyLines.append("}")
                            bodyLines.append("_swift_js_push_int(__bjs_isSome_\(paramName) ? 1 : 0)")
                        default:
                            bodyLines.append(
                                "preconditionFailure(\"BridgeJS: unsupported associated value type in generated code\")"
                            )
                        }
                    }
                    let pattern = enumCase.associatedValues.enumerated()
                        .map { index, associatedValue in "let \(associatedValue.label ?? "param\(index)")" }
                        .joined(separator: ", ")
                    cases.append("case .\(enumCase.name)(\(pattern)):")
                    cases.append(contentsOf: bodyLines)
                }
            }
            return cases
        }
    }

    /// Context for property rendering that determines call behavior and ABI generation
    private enum PropertyRenderingContext {
        case enumStatic(enumDef: ExportedEnum)
        case classStatic(klass: ExportedClass)
        case classInstance(klass: ExportedClass)
    }

    /// Renders getter and setter Swift thunk code for a property in any context
    /// This unified function eliminates duplication between enum static, class static, and class instance property rendering
    private func renderSingleExportedProperty(
        property: ExportedProperty,
        context: PropertyRenderingContext
    ) throws -> [DeclSyntax] {
        var decls: [DeclSyntax] = []

        let (callName, className, isStatic): (String, String, Bool)
        switch context {
        case .enumStatic(let enumDef):
            callName = property.callName(prefix: enumDef.swiftCallName)
            className = enumDef.name
            isStatic = true
        case .classStatic(let klass):
            callName = property.callName()
            className = klass.name
            isStatic = true

        case .classInstance(let klass):
            callName = property.callName()
            className = klass.name
            isStatic = false
        }

        let getterBuilder = ExportedThunkBuilder(effects: Effects(isAsync: false, isThrows: false, isStatic: isStatic))

        if !isStatic {
            try getterBuilder.liftParameter(
                param: Parameter(label: nil, name: "_self", type: .swiftHeapObject(className))
            )
        }

        if isStatic {
            getterBuilder.callStaticProperty(name: callName, returnType: property.type)
        } else {
            getterBuilder.callPropertyGetter(klassName: className, propertyName: callName, returnType: property.type)
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
                setterBuilder.callPropertySetter(klassName: className, propertyName: callName)
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
            case .className(let baseName), .enumName(let baseName):
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
                    klassName: klass.swiftCallName,
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
            decls.append(
                """
                @_expose(wasm, "bjs_\(raw: klass.name)_deinit")
                @_cdecl("bjs_\(raw: klass.name)_deinit")
                public func _bjs_\(raw: klass.name)_deinit(pointer: UnsafeMutableRawPointer) {
                    Unmanaged<\(raw: klass.swiftCallName)>.fromOpaque(pointer).release()
                }
                """
            )
        }

        // Generate ConvertibleToJSValue extension
        decls.append(renderConvertibleToJSValueExtension(klass: klass))

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
    ///         @_extern(wasm, module: "MyModule", name: "bjs_Greeter_wrap")
    ///         func _bjs_Greeter_wrap(_: UnsafeMutableRawPointer) -> Int32
    ///         return JSObject(id: UInt32(bitPattern: _bjs_Greeter_wrap(Unmanaged.passRetained(self).toOpaque())))
    ///     }
    /// }
    /// ```
    func renderConvertibleToJSValueExtension(klass: ExportedClass) -> DeclSyntax {
        let wrapFunctionName = "_bjs_\(klass.name)_wrap"
        let externFunctionName = "bjs_\(klass.name)_wrap"

        // If the class has an explicit access control, we need to add it to the extension declaration.
        let accessControl = klass.explicitAccessControl.map { "\($0) " } ?? ""
        return """
            extension \(raw: klass.swiftCallName): ConvertibleToJSValue, _BridgedSwiftHeapObject {
                \(raw: accessControl)var jsValue: JSValue {
                    #if arch(wasm32)
                    @_extern(wasm, module: "\(raw: moduleName)", name: "\(raw: externFunctionName)")
                    func \(raw: wrapFunctionName)(_: UnsafeMutableRawPointer) -> Int32
                    #else
                    func \(raw: wrapFunctionName)(_: UnsafeMutableRawPointer) -> Int32 {
                        fatalError("Only available on WebAssembly")
                    }
                    #endif
                    return .object(JSObject(id: UInt32(bitPattern: \(raw: wrapFunctionName)(Unmanaged.passRetained(self).toOpaque()))))
                }
            }
            """
    }

    /// Generates an AnyProtocol wrapper struct for a protocol
    ///
    /// Creates a struct that wraps a JSObject and implements protocol methods
    /// by calling `@_extern(wasm)` functions that forward to JavaScript
    func renderProtocolWrapper(protocol proto: ExportedProtocol) throws -> DeclSyntax {
        let wrapperName = "Any\(proto.name)"
        let protocolName = proto.name

        var methodDecls: [DeclSyntax] = []

        for method in proto.methods {
            var swiftParams: [String] = []
            for param in method.parameters {
                let label = param.label ?? param.name
                if label == param.name {
                    swiftParams.append("\(param.name): \(param.type.swiftType)")
                } else {
                    swiftParams.append("\(label) \(param.name): \(param.type.swiftType)")
                }
            }

            var externParams: [String] = ["this: Int32"]
            for param in method.parameters {
                let loweringInfo = try param.type.loweringParameterInfo()
                assert(
                    loweringInfo.loweredParameters.count == 1,
                    "Protocol parameters must lower to a single WASM type"
                )
                let (_, wasmType) = loweringInfo.loweredParameters[0]
                externParams.append("\(param.name): \(wasmType.swiftType)")
            }

            var callArgs: [String] = ["this: Int32(bitPattern: jsObject.id)"]
            for param in method.parameters {
                callArgs.append("\(param.name): \(param.name).bridgeJSLowerParameter()")
            }

            let returnTypeStr: String
            let externReturnType: String
            let callCode: DeclSyntax

            if method.returnType == .void {
                returnTypeStr = ""
                externReturnType = ""
                callCode = """
                    _extern_\(raw: method.name)(\(raw: callArgs.joined(separator: ", ")))
                    """
            } else {
                returnTypeStr = " -> \(method.returnType.swiftType)"
                let liftingInfo = try method.returnType.liftingReturnInfo()
                if let abiType = liftingInfo.valueToLift {
                    externReturnType = " -> \(abiType.swiftType)"
                } else {
                    externReturnType = ""
                }
                callCode = """
                    let ret = _extern_\(raw: method.name)(\(raw: callArgs.joined(separator: ", ")))
                        return \(raw: method.returnType.swiftType).bridgeJSLiftReturn(ret)
                    """
            }
            let methodImplementation: DeclSyntax = """
                func \(raw: method.name)(\(raw: swiftParams.joined(separator: ", ")))\(raw: returnTypeStr) {
                    @_extern(wasm, module: "\(raw: moduleName)", name: "\(raw: method.abiName)")
                    func _extern_\(raw: method.name)(\(raw: externParams.joined(separator: ", ")))\(raw: externReturnType)
                    \(raw: callCode)
                }
                """

            methodDecls.append(methodImplementation)
        }

        var propertyDecls: [DeclSyntax] = []

        for property in proto.properties {
            let propertyImpl = try renderProtocolProperty(
                property: property,
                protocolName: protocolName,
                moduleName: moduleName
            )
            propertyDecls.append(propertyImpl)
        }

        let allDecls = (methodDecls + propertyDecls).map { $0.description }.joined(separator: "\n\n")

        return """
            struct \(raw: wrapperName): \(raw: protocolName), _BridgedSwiftProtocolWrapper {
                let jsObject: JSObject
                
                \(raw: allDecls)
                
                static func bridgeJSLiftParameter(_ value: Int32) -> Self {
                    return \(raw: wrapperName)(jsObject: JSObject(id: UInt32(bitPattern: value)))
                }
            }
            """
    }
    
    private func renderProtocolProperty(
        property: ExportedProtocolProperty,
        protocolName: String,
        moduleName: String
    ) throws -> DeclSyntax {
        let getterAbiName = ABINameGenerator.generateABIName(
            baseName: property.name,
            namespace: nil,
            staticContext: nil,
            operation: "get",
            className: protocolName
        )
        let setterAbiName = ABINameGenerator.generateABIName(
            baseName: property.name,
            namespace: nil,
            staticContext: nil,
            operation: "set",
            className: protocolName
        )
        
        // Generate getter
        let liftingInfo = try property.type.liftingReturnInfo()
        let getterReturnType: String
        let getterCallCode: String
        
        if let abiType = liftingInfo.valueToLift {
            getterReturnType = " -> \(abiType.swiftType)"
            getterCallCode = """
            let ret = _extern_get(this: Int32(bitPattern: jsObject.id))
                    return \(property.type.swiftType).bridgeJSLiftReturn(ret)
            """
        } else {
            // For String and other types that use tmpRetString
            getterReturnType = ""
            getterCallCode = """
            _extern_get(this: Int32(bitPattern: jsObject.id))
                    return \(property.type.swiftType).bridgeJSLiftReturn()
            """
        }
        
        if property.isReadonly {
            // Readonly property - only getter
            return """
                var \(raw: property.name): \(raw: property.type.swiftType) {
                    get {
                        @_extern(wasm, module: "\(raw: moduleName)", name: "\(raw: getterAbiName)")
                        func _extern_get(this: Int32)\(raw: getterReturnType)
                        \(raw: getterCallCode)
                    }
                }
                """
        } else {
            // Readwrite property - getter and setter
            let loweringInfo = try property.type.loweringParameterInfo()
            assert(
                loweringInfo.loweredParameters.count == 1,
                "Protocol property setters must lower to a single WASM parameter"
            )
            
            let (paramName, wasmType) = loweringInfo.loweredParameters[0]
            let setterParams = "this: Int32, \(paramName): \(wasmType.swiftType)"
            let setterCallArgs = "this: Int32(bitPattern: jsObject.id), \(paramName): newValue.bridgeJSLowerParameter()"
            
            return """
                var \(raw: property.name): \(raw: property.type.swiftType) {
                    get {
                        @_extern(wasm, module: "\(raw: moduleName)", name: "\(raw: getterAbiName)")
                        func _extern_get(this: Int32)\(raw: getterReturnType)
                        \(raw: getterCallCode)
                    }
                    set {
                        @_extern(wasm, module: "\(raw: moduleName)", name: "\(raw: setterAbiName)")
                        func _extern_set(\(raw: setterParams))
                        _extern_set(\(raw: setterCallArgs))
                    }
                }
                """
        }
    }
}

fileprivate enum Constants {
    static let supportedRawTypes = SwiftEnumRawType.allCases.map { $0.rawValue }
}

extension AttributeListSyntax {
    fileprivate func hasJSAttribute() -> Bool {
        firstJSAttribute != nil
    }

    fileprivate var firstJSAttribute: AttributeSyntax? {
        first(where: {
            $0.as(AttributeSyntax.self)?.attributeName.trimmedDescription == "JS"
        })?.as(AttributeSyntax.self)
    }
}

extension BridgeType {
    init?(swiftType: String) {
        switch swiftType {
        case "Int":
            self = .int
        case "Float":
            self = .float
        case "Double":
            self = .double
        case "String":
            self = .string
        case "Bool":
            self = .bool
        case "Void":
            self = .void
        case "JSObject":
            self = .jsObject(nil)
        default:
            return nil
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

extension BridgeType {
    var swiftType: String {
        switch self {
        case .bool: return "Bool"
        case .int: return "Int"
        case .float: return "Float"
        case .double: return "Double"
        case .string: return "String"
        case .jsObject(nil): return "JSObject"
        case .jsObject(let name?): return name
        case .swiftHeapObject(let name): return name
        case .swiftProtocol(let name): return "Any\(name)"
        case .void: return "Void"
        case .optional(let wrappedType): return "Optional<\(wrappedType.swiftType)>"
        case .caseEnum(let name): return name
        case .rawValueEnum(let name, _): return name
        case .associatedValueEnum(let name): return name
        case .namespaceEnum(let name): return name
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
        static let void = LiftingIntrinsicInfo(parameters: [])
        static let caseEnum = LiftingIntrinsicInfo(parameters: [("value", .i32)])
        static let associatedValueEnum = LiftingIntrinsicInfo(parameters: [
            ("caseId", .i32)
        ])
    }

    func liftParameterInfo() throws -> LiftingIntrinsicInfo {
        switch self {
        case .bool: return .bool
        case .int: return .int
        case .float: return .float
        case .double: return .double
        case .string: return .string
        case .jsObject: return .jsObject
        case .swiftHeapObject: return .swiftHeapObject
        case .swiftProtocol: return .jsObject
        case .void: return .void
        case .optional(let wrappedType):
            var optionalParams: [(name: String, type: WasmCoreType)] = [("isSome", .i32)]
            optionalParams.append(contentsOf: try wrappedType.liftParameterInfo().parameters)
            return LiftingIntrinsicInfo(parameters: optionalParams)
        case .caseEnum: return .caseEnum
        case .rawValueEnum(_, let rawType):
            switch rawType {
            case .bool: return .bool
            case .int: return .int
            case .float: return .float
            case .double: return .double
            case .string: return .string
            case .int32: return .int
            case .int64: return .int
            case .uint: return .int
            case .uint32: return .int
            case .uint64: return .int
            }
        case .associatedValueEnum:
            return .associatedValueEnum
        case .namespaceEnum:
            throw BridgeJSCoreError("Namespace enums are not supported to pass as parameters")
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
        static let void = LoweringIntrinsicInfo(returnType: nil)
        static let caseEnum = LoweringIntrinsicInfo(returnType: .i32)
        static let rawValueEnum = LoweringIntrinsicInfo(returnType: .i32)
        static let associatedValueEnum = LoweringIntrinsicInfo(returnType: nil)
        static let optional = LoweringIntrinsicInfo(returnType: nil)
    }

    func loweringReturnInfo() throws -> LoweringIntrinsicInfo {
        switch self {
        case .bool: return .bool
        case .int: return .int
        case .float: return .float
        case .double: return .double
        case .string: return .string
        case .jsObject: return .jsObject
        case .swiftHeapObject: return .swiftHeapObject
        case .swiftProtocol: return .jsObject
        case .void: return .void
        case .optional: return .optional
        case .caseEnum: return .caseEnum
        case .rawValueEnum(_, let rawType):
            switch rawType {
            case .bool: return .bool
            case .int: return .int
            case .float: return .float
            case .double: return .double
            case .string: return .string
            case .int32: return .int
            case .int64: return .int
            case .uint: return .int
            case .uint32: return .int
            case .uint64: return .int
            }
        case .associatedValueEnum:
            return .associatedValueEnum
        case .namespaceEnum:
            throw BridgeJSCoreError("Namespace enums are not supported to pass as parameters")
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
