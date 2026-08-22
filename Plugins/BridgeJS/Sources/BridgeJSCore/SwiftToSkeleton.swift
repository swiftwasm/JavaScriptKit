import SwiftExtract
import SwiftSyntax
import SwiftSyntaxBuilder
#if canImport(BridgeJSUtilities)
import BridgeJSUtilities
#endif
#if canImport(BridgeJSSkeleton)
import BridgeJSSkeleton
#endif

/// Builds BridgeJS skeletons from Swift source files.
///
/// Declaration extraction and name resolution are delegated to swift-java's
/// language-neutral `SwiftExtract` analysis layer (`SwiftAnalyzer`); this type
/// lowers the resulting `AnalysisResult` into BridgeJS's skeleton model,
/// applying all JavaScript-specific semantics (the `BridgeType` universe,
/// `@JS` attribute arguments, namespaces, ESM origins, ABI names, …).
///
/// This is a shared entry point for producing:
/// - exported skeletons from `@JS` declarations
/// - imported skeletons from `@JSFunction/@JSGetter/@JSSetter/@JSClass` macro signatures
public final class SwiftToSkeleton {
    public let progress: ProgressReporting
    public let moduleName: String
    public let exposeToGlobal: Bool
    public let identityMode: String?

    let externalModuleIndex: ExternalModuleIndex

    private var sourceFiles: [(sourceFile: SourceFileSyntax, inputFilePath: String)] = []
    private let javaScriptModuleExists: (String) throws -> Bool

    /// Non-fatal diagnostics collected during `finalize()`. These do not fail the build.
    public private(set) var warnings: [(file: String, diagnostic: DiagnosticError)] = []

    public init(
        progress: ProgressReporting,
        moduleName: String,
        exposeToGlobal: Bool,
        externalModuleIndex: ExternalModuleIndex,
        identityMode: String? = nil,
        javaScriptModuleExists: @escaping (String) throws -> Bool = { _ in false }
    ) {
        self.progress = progress
        self.moduleName = moduleName
        self.exposeToGlobal = exposeToGlobal
        self.identityMode = identityMode
        self.javaScriptModuleExists = javaScriptModuleExists
        self.externalModuleIndex = externalModuleIndex
    }

    public func addSourceFile(_ sourceFile: SourceFileSyntax, inputFilePath: String) {
        sourceFiles.append((sourceFile, inputFilePath))
    }

    // MARK: - Analysis

    /// Swift declaration stubs for the JavaScriptKit types that BridgeJS
    /// declarations may reference. Parsed by SwiftExtract as a synthetic
    /// `JavaScriptKit` module so references resolve without the real sources.
    /// Kinds, generic arity, and typealias targets must match the real
    /// declarations in `Sources/JavaScriptKit` — enforced by
    /// `StubFidelityTests`.
    static let javaScriptKitModuleStubs: [String] = [
        "public class JSObject {}",
        "public struct JSValue {}",
        "public struct JSException: Error {}",
        "public class JSPromise {}",
        "public class JSTypedArray<Traits> {}",
        "public typealias JSInt8Array = JSTypedArray<Int8>",
        "public typealias JSUint8Array = JSTypedArray<UInt8>",
        "public typealias JSInt16Array = JSTypedArray<Int16>",
        "public typealias JSUint16Array = JSTypedArray<UInt16>",
        "public typealias JSInt32Array = JSTypedArray<Int32>",
        "public typealias JSUint32Array = JSTypedArray<UInt32>",
        "public typealias JSFloat32Array = JSTypedArray<Float32>",
        "public typealias JSFloat64Array = JSTypedArray<Float64>",
        "public struct JSTypedClosure<Signature> {}",
        "public enum JSUndefinedOr<Wrapped> {}",
        "public protocol BridgedSwiftGenericBridgeable {}",
        "public protocol _BridgedSwiftEnumNoPayload {}",
    ]

    private struct Configuration: SwiftExtractConfiguration {
        var swiftModule: String?
        var staticBuildConfigurationFile: String? { nil }
        var swiftFilterInclude: [String]? { nil }
        var swiftFilterExclude: [String]? { nil }
        var importedModuleStubs: [String: [String]]? {
            ["JavaScriptKit": SwiftToSkeleton.javaScriptKitModuleStubs]
        }
        var externalTypeDeclarations: [String: [ExternalTypeDeclaration]]?
        var effectiveMinimumInputAccessLevelMode: AccessLevelMode { .internal }
        var logLevel: LogLevel? { .error }
        // Keep declarations whose types don't resolve; bridgeability is judged
        // during lowering, where precise source anchors are available.
        var allowUnresolvedTypeReferences: Bool { true }
    }

    private final class SkeletonDiagnosticsSink: SwiftExtractDiagnosticsSink {
        var errors: [(file: String, diagnostic: DiagnosticError)] = []

        func emit(_ diagnostic: SwiftExtractDiagnostic) {
            // A skipped extension is only an error when it contains
            // declarations the user marked for export.
            if let extensionDecl = diagnostic.node.as(ExtensionDeclSyntax.self) {
                let finder = JSAttributeFinder(viewMode: .sourceAccurate)
                finder.walk(extensionDecl.memberBlock.members)
                guard finder.found else { return }
                errors.append(
                    (
                        file: diagnostic.sourceFilePath,
                        diagnostic: DiagnosticError(
                            node: extensionDecl.extendedType,
                            message: "Unsupported type '\(extensionDecl.extendedType.trimmedDescription)'.",
                            hint: "You can only extend `@JS` annotated types defined in the same module"
                        )
                    )
                )
                return
            }
            errors.append(
                (
                    file: diagnostic.sourceFilePath,
                    diagnostic: DiagnosticError(
                        node: diagnostic.node,
                        message: diagnostic.message
                    )
                )
            )
        }
    }

    static let jsAttributeNames: Set<String> = [
        "JS", "JSFunction", "JSClass", "JSGetter", "JSSetter",
    ]

    /// BridgeJS's opt-in extraction policy: a declaration participates when it
    /// carries a `@JS`-family attribute, is a requirement of an extracted
    /// protocol, or is an instance field of a `@JS` struct.
    private struct Decider: ExtractDecider {
        func shouldExtract(decl: DeclSyntax, in parent: ExtractedNominalType?) -> Bool {
            // Every requirement of an extracted protocol is exported.
            if let parent, parent.swiftNominal.kind == .protocol {
                return true
            }
            if let attributed = decl.asProtocol((any WithAttributesSyntax).self),
                attributed.attributes.hasJSFamilyAttribute()
            {
                return true
            }
            // Instance fields of a `@JS` struct don't need their own `@JS`.
            if let parent, parent.swiftNominal.kind == .struct,
                parent.swiftNominal.syntax.attributes.firstJSAttribute != nil,
                let varDecl = decl.as(VariableDeclSyntax.self),
                !varDecl.modifiers.containsStaticOrClass
            {
                return true
            }
            return false
        }
    }

    // MARK: - Finalize

    public func finalize() throws -> BridgeJSSkeleton {
        let sink = SkeletonDiagnosticsSink()
        let externalDeclarations = Self.externalTypeDeclarations(from: externalModuleIndex)
        let analyzer = SwiftAnalyzer(
            config: Configuration(
                swiftModule: moduleName,
                externalTypeDeclarations: externalDeclarations.isEmpty ? nil : externalDeclarations
            ),
            moduleName: moduleName,
            extractDecider: Decider(),
            diagnosticsSink: sink
        )
        var fileOrder: [String: Int] = [:]
        for (index, (sourceFile, inputFilePath)) in sourceFiles.enumerated() {
            progress.print("Processing \(inputFilePath)")
            fileOrder[inputFilePath] = index
            analyzer.add(filePath: inputFilePath, text: sourceFile.description)
        }
        try analyzer.analyze()
        let analysis = analyzer.result

        let context = LoweringContext(
            moduleName: moduleName,
            analyzer: analyzer,
            externalModuleIndex: externalModuleIndex,
            fileOrder: fileOrder
        )

        // Order types by their position in the input: file order first, then
        // source position of the type declaration. Types declared inside an
        // extension sort after directly-declared ones, matching the previous
        // collector's deferred extension resolution.
        func isDeclaredInExtension(_ type: ExtractedNominalType) -> Bool {
            var ancestor = Syntax(type.swiftNominal.syntax).parent
            while let current = ancestor {
                if current.is(ExtensionDeclSyntax.self) { return true }
                ancestor = current.parent
            }
            return false
        }
        let orderedTypes = analysis.extractedTypes.values.sorted { lhs, rhs in
            let lhsExtension = isDeclaredInExtension(lhs)
            let rhsExtension = isDeclaredInExtension(rhs)
            if lhsExtension != rhsExtension { return !lhsExtension }
            let lhsFile = fileOrder[lhs.sourceFilePath] ?? Int.max
            let rhsFile = fileOrder[rhs.sourceFilePath] ?? Int.max
            if lhsFile != rhsFile { return lhsFile < rhsFile }
            return lhs.swiftNominal.syntax.position < rhs.swiftNominal.syntax.position
        }

        let exportLowering = ExportLowering(context: context)
        var exported = ExportedSkeleton(
            functions: [],
            classes: [],
            enums: [],
            exposeToGlobal: exposeToGlobal,
            identityMode: identityMode
        )
        for function in analysis.extractedGlobalFuncs
        where function.declAttributeList?.firstJSAttribute != nil {
            exportLowering.lowerGlobalFunction(function, into: &exported)
        }
        for variable in analysis.extractedGlobalVariables
        where variable.declAttributeList?.firstJSAttribute != nil {
            exportLowering.diagnoseGlobalExportedVariable(variable)
        }
        for type in orderedTypes {
            exportLowering.lower(type, into: &exported)
        }

        let importLowering = ImportLowering(context: context)
        let importedFiles = importLowering.lower(
            analysis: analysis,
            orderedTypes: orderedTypes,
            filePaths: sourceFiles.map(\.inputFilePath)
        )

        validateSnippetPaths(importLowering: importLowering)

        // Aggregate errors: SwiftExtract-dropped declarations first, then
        // lowering diagnostics, grouped per file in input order.
        var perFileErrors: [String: [DiagnosticError]] = [:]
        func record(_ entries: [(file: String, diagnostic: DiagnosticError)]) {
            for entry in entries {
                if entry.diagnostic.severity == .warning {
                    warnings.append(entry)
                } else {
                    perFileErrors[entry.file, default: []].append(entry.diagnostic)
                }
            }
        }
        record(sink.errors)
        // Imported-declaration "Unsupported type" errors are non-fatal: the
        // declaration is skipped, matching the previous collector behavior.
        record(
            importLowering.errors.filter {
                !($0.diagnostic.severity == .error && $0.diagnostic.message.contains("Unsupported type '"))
            }
        )
        record(exportLowering.errors)

        if !perFileErrors.isEmpty {
            let diagnostics = perFileErrors.sorted { lhs, rhs in
                (fileOrder[lhs.key] ?? Int.max) < (fileOrder[rhs.key] ?? Int.max)
            }.flatMap { file, errors in
                errors.map { (file: file, diagnostic: $0) }
            }
            throw BridgeJSCoreDiagnosticError(diagnostics: diagnostics)
        }

        let importedSkeleton: ImportedModuleSkeleton? = {
            let module = ImportedModuleSkeleton(children: importedFiles)
            if module.children.allSatisfy(\.isEmpty) {
                return nil
            }
            return module
        }()

        let exportedSkeleton: ExportedSkeleton? = exported.isEmpty ? nil : exported
        return BridgeJSSkeleton(
            moduleName: moduleName,
            exported: exportedSkeleton,
            imported: importedSkeleton,
            usedExternalModules: context.usedExternalModules.sorted()
        )
    }

    /// Describe the `@JS` types of dependency modules to SwiftExtract so
    /// references to them resolve during analysis. The `BridgeType` mapping
    /// stays in `ExternalModuleIndex`; these entries only carry shapes.
    static func externalTypeDeclarations(
        from index: ExternalModuleIndex
    ) -> [String: [ExternalTypeDeclaration]] {
        var result: [String: [ExternalTypeDeclaration]] = [:]
        for moduleName in index.moduleNames {
            var declarations: [ExternalTypeDeclaration] = []
            for (dotPath, bridgeType) in index.entries(module: moduleName) {
                let qualifiedName = dotPath.split(separator: ".").map(String.init)
                let kind: ExternalTypeDeclaration.Kind
                switch bridgeType.unaliased {
                case .swiftHeapObject: kind = .class
                case .swiftStruct: kind = .struct
                case .caseEnum, .rawValueEnum, .associatedValueEnum, .namespaceEnum: kind = .enum
                case .swiftProtocol: kind = .protocol
                default: kind = .struct
                }
                declarations.append(ExternalTypeDeclaration(qualifiedName: qualifiedName, kind: kind))
            }
            result[moduleName] = declarations
        }
        return result
    }

    private func validateSnippetPaths(importLowering: ImportLowering) {
        var validatedJavaScriptModulePaths = Set<String>()
        let snippetPaths = Set(importLowering.importOrigins.compactMap(\.snippetPath))
        for path in snippetPaths.sorted() {
            if validatedJavaScriptModulePaths.contains(path) {
                continue
            }
            guard let pathNode = importLowering.importedModulePathNodes[path] else { continue }
            guard path.hasPrefix("/") else {
                importLowering.diagnose(
                    node: pathNode,
                    file: importLowering.importedModulePathFiles[path] ?? "",
                    message: "JavaScript snippet paths must start with '/' to indicate the Swift target root: "
                        + "'\(path)'. For an external module, use 'from: .module(\"\(path)\")' instead."
                )
                continue
            }
            guard !path.split(separator: "/").contains("..") else {
                importLowering.diagnose(
                    node: pathNode,
                    file: importLowering.importedModulePathFiles[path] ?? "",
                    message: "JavaScript snippet paths must not contain '..': '\(path)'."
                )
                continue
            }
            let lowercasedPath = path.lowercased()
            guard lowercasedPath.hasSuffix(".js") || lowercasedPath.hasSuffix(".mjs") else {
                importLowering.diagnose(
                    node: pathNode,
                    file: importLowering.importedModulePathFiles[path] ?? "",
                    message: "JavaScript snippets must use a '.js' or '.mjs' extension: '\(path)'."
                )
                continue
            }
            guard (try? javaScriptModuleExists(path)) == true else {
                importLowering.diagnose(
                    node: pathNode,
                    file: importLowering.importedModulePathFiles[path] ?? "",
                    message: "JavaScript snippet file was not found at '\(path)'."
                )
                continue
            }
            validatedJavaScriptModulePaths.insert(path)
        }
    }

    /// Strips surrounding backticks from an identifier (e.g. "`Foo`" -> "Foo").
    static func normalizeIdentifier(_ name: String) -> String {
        guard name.hasPrefix("`"), name.hasSuffix("`"), name.count >= 2 else {
            return name
        }
        return String(name.dropFirst().dropLast())
    }

    static func isValidJSIdentifier(_ name: String) -> Bool {
        func isIdentifierPart(_ scalar: Unicode.Scalar, isStart: Bool) -> Bool {
            switch scalar {
            case "a"..."z", "A"..."Z", "_", "$":
                return true
            case "0"..."9":
                return !isStart
            default:
                return false
            }
        }
        guard let first = name.unicodeScalars.first, isIdentifierPart(first, isStart: true) else {
            return false
        }
        return name.unicodeScalars.dropFirst().allSatisfy { isIdentifierPart($0, isStart: false) }
    }
}

// MARK: - Lowering context

/// State shared by the export and import lowering passes: the analyzer (for
/// ad-hoc type resolution of attribute arguments), the external module index,
/// and the `SwiftType` → `BridgeType` mapping.
final class LoweringContext {
    let moduleName: String
    let analyzer: SwiftAnalyzer
    let externalModuleIndex: ExternalModuleIndex
    let fileOrder: [String: Int]
    var usedExternalModules = Set<String>()

    init(
        moduleName: String,
        analyzer: SwiftAnalyzer,
        externalModuleIndex: ExternalModuleIndex,
        fileOrder: [String: Int]
    ) {
        self.moduleName = moduleName
        self.analyzer = analyzer
        self.externalModuleIndex = externalModuleIndex
        self.fileOrder = fileOrder
    }

    // MARK: Names

    /// The qualified name used to call into Swift (e.g. "Networking.API.HTTPServer"):
    /// the type name prefixed by its `@JS`-annotated ancestors.
    func swiftCallName(for nominal: SwiftNominalTypeDeclaration) -> String {
        var path = [nominal.name]
        var ancestor = nominal.parent
        while let current = ancestor {
            if current.syntax.attributes.firstJSAttribute != nil {
                path.insert(current.name, at: 0)
            }
            ancestor = current.parent
        }
        return path.joined(separator: ".")
    }

    /// Computes the namespace contributed by enclosing `@JS` namespace enums
    /// (enums without cases). The innermost enclosing namespace enum with an
    /// explicit `namespace:` argument prepends it and stops the walk.
    func namespaceFromEnclosingNamespaceEnums(of nominal: SwiftNominalTypeDeclaration?) -> [String]? {
        var namespace: [String] = []
        var ancestor = nominal
        while let current = ancestor {
            defer { ancestor = current.parent }
            guard current.kind == .enum,
                let jsAttribute = current.syntax.attributes.firstJSAttribute
            else { continue }
            let hasCases = current.syntax.memberBlock.members.contains { member in
                member.decl.is(EnumCaseDeclSyntax.self)
            }
            guard !hasCases else { continue }
            namespace.insert(current.name, at: 0)
            if let explicitNamespace = SwiftToSkeleton.extractNamespace(from: jsAttribute) {
                namespace = explicitNamespace + namespace
                break
            }
        }
        return namespace.isEmpty ? nil : namespace
    }

    /// The path contributed by enclosing `@JS` structs/classes.
    func namespaceFromEnclosingTypes(of nominal: SwiftNominalTypeDeclaration?) -> [String]? {
        var path: [String] = []
        var ancestor = nominal
        while let current = ancestor {
            defer { ancestor = current.parent }
            guard current.kind == .struct || current.kind == .class,
                current.syntax.attributes.firstJSAttribute != nil
            else { continue }
            path.insert(current.name, at: 0)
        }
        return path.isEmpty ? nil : path
    }

    // MARK: SwiftType → BridgeType

    private static let jsTypedArrayNamesByElement: [String: String] = [
        "Int8": "JSInt8Array",
        "UInt8": "JSUint8Array",
        "Int16": "JSInt16Array",
        "UInt16": "JSUint16Array",
        "Int32": "JSInt32Array",
        "UInt32": "JSUint32Array",
        "Float": "JSFloat32Array",
        "Float32": "JSFloat32Array",
        "Double": "JSFloat64Array",
        "Float64": "JSFloat64Array",
    ]

    func bridgeType(
        for type: SwiftType,
        anchor: some SyntaxProtocol,
        errors: inout [DiagnosticError]
    ) -> BridgeType? {
        switch type {
        case .nominal(let nominal):
            return bridgeType(forNominal: nominal, anchor: anchor, errors: &errors)

        case .genericParameter(let parameter):
            return .generic(parameter.name)

        case .function(let functionType):
            return bridgeType(forFunction: functionType, anchor: anchor, errors: &errors)

        case .tuple(let elements) where elements.isEmpty:
            return .void

        case .tuple, .metatype, .existential, .opaque, .composite, .inlineArray:
            return unsupported(type: type, anchor: anchor, errors: &errors)
        }
    }

    private func bridgeType(
        forNominal nominal: SwiftNominalType,
        anchor: some SyntaxProtocol,
        errors: inout [DiagnosticError]
    ) -> BridgeType? {
        let decl = nominal.nominalTypeDecl

        if decl.isUnresolvedTypePlaceholder {
            return unsupported(
                name: unresolvedSpelling(of: decl.name, in: anchor),
                anchor: anchor,
                errors: &errors
            )
        }

        if let known = decl.knownTypeKind {
            return bridgeType(
                forKnown: known,
                genericArguments: nominal.genericArguments,
                anchor: anchor,
                errors: &errors
            )
        }

        if decl.moduleName == "JavaScriptKit" {
            return bridgeType(
                forJavaScriptKit: decl.name,
                genericArguments: nominal.genericArguments,
                anchor: anchor,
                errors: &errors
            )
        }

        if decl.moduleName == moduleName {
            return bridgeType(forLocal: decl, anchor: anchor, errors: &errors)
        }

        return bridgeType(forExternal: decl, anchor: anchor, errors: &errors)
    }

    private func bridgeType(
        forKnown known: SwiftKnownTypeDeclKind,
        genericArguments: [SwiftType],
        anchor: some SyntaxProtocol,
        errors: inout [DiagnosticError]
    ) -> BridgeType? {
        switch known {
        case .bool: return .bool
        case .int: return .integer(.int)
        case .uint: return .integer(.uint)
        case .int8: return .integer(.int8)
        case .uint8: return .integer(.uint8)
        case .int16: return .integer(.int16)
        case .uint16: return .integer(.uint16)
        case .int32: return .integer(.int32)
        case .uint32: return .integer(.uint32)
        case .int64: return .integer(.int64)
        case .uint64: return .integer(.uint64)
        case .float: return .float
        case .double: return .double
        case .string: return .string
        case .void: return .void

        case .optional:
            guard let wrapped = genericArguments.first,
                let wrappedType = bridgeType(for: wrapped, anchor: anchor, errors: &errors)
            else { return nil }
            return .nullable(wrappedType, .null)

        case .array:
            guard let element = genericArguments.first,
                let elementType = bridgeType(for: element, anchor: anchor, errors: &errors)
            else { return nil }
            return .array(elementType)

        case .dictionary:
            guard genericArguments.count == 2 else {
                return unsupportedSpelling(anchor: anchor, errors: &errors)
            }
            guard let keyType = bridgeType(for: genericArguments[0], anchor: anchor, errors: &errors),
                keyType == .string
            else {
                return unsupportedSpelling(anchor: anchor, errors: &errors)
            }
            guard let valueType = bridgeType(for: genericArguments[1], anchor: anchor, errors: &errors) else {
                return nil
            }
            return .dictionary(valueType)

        case .unsafeRawPointer:
            return .unsafePointer(.init(kind: .unsafeRawPointer))
        case .unsafeMutableRawPointer:
            return .unsafePointer(.init(kind: .unsafeMutableRawPointer))
        case .opaquePointer:
            return .unsafePointer(.init(kind: .opaquePointer))
        case .unsafePointer:
            return .unsafePointer(.init(kind: .unsafePointer, pointee: genericArguments.first?.description))
        case .unsafeMutablePointer:
            return .unsafePointer(.init(kind: .unsafeMutablePointer, pointee: genericArguments.first?.description))

        case .unsafeRawBufferPointer, .unsafeMutableRawBufferPointer,
            .unsafeBufferPointer, .unsafeMutableBufferPointer,
            .set,
            .foundationDataProtocol, .essentialsDataProtocol,
            .foundationData, .essentialsData,
            .foundationDate, .essentialsDate,
            .foundationUUID, .essentialsUUID,
            .foundationURL, .essentialsURL:
            return unsupportedSpelling(anchor: anchor, errors: &errors)
        }
    }

    private func bridgeType(
        forJavaScriptKit name: String,
        genericArguments: [SwiftType],
        anchor: some SyntaxProtocol,
        errors: inout [DiagnosticError]
    ) -> BridgeType? {
        switch name {
        case "JSObject":
            return .jsObject(nil)
        case "JSValue":
            return .jsValue
        case "JSPromise":
            return .jsObject(name)
        case "JSUndefinedOr":
            guard let wrapped = genericArguments.first,
                let wrappedType = bridgeType(for: wrapped, anchor: anchor, errors: &errors)
            else { return nil }
            return .nullable(wrappedType, .undefined)
        case "JSTypedArray":
            guard let element = genericArguments.first?.asNominalTypeDeclaration,
                let typedArrayName = Self.jsTypedArrayNamesByElement[element.name]
            else {
                return unsupportedSpelling(anchor: anchor, errors: &errors)
            }
            return .jsObject(typedArrayName)
        case "JSTypedClosure":
            guard let signatureArgument = genericArguments.first,
                case .function = signatureArgument,
                let signatureType = bridgeType(for: signatureArgument, anchor: anchor, errors: &errors),
                case .closure(let signature, false) = signatureType
            else {
                return unsupportedSpelling(anchor: anchor, errors: &errors)
            }
            return .closure(signature, useJSTypedClosure: true)
        default:
            return unsupported(name: name, anchor: anchor, errors: &errors)
        }
    }

    private func bridgeType(
        forFunction functionType: SwiftFunctionType,
        anchor: some SyntaxProtocol,
        errors: inout [DiagnosticError]
    ) -> BridgeType? {
        var parameters: [BridgeType] = []
        for parameter in functionType.parameters {
            guard let parameterType = bridgeType(for: parameter.type, anchor: anchor, errors: &errors) else {
                return nil
            }
            parameters.append(parameterType)
        }
        guard let returnType = bridgeType(for: functionType.resultType, anchor: anchor, errors: &errors) else {
            return nil
        }

        let isAsync = functionType.isAsync
        if isAsync, !returnType.isAsyncResolvable {
            errors.append(
                DiagnosticError(
                    node: anchor,
                    message:
                        "Returning '\(returnType.swiftType)' from an async closure is not yet supported",
                    hint:
                        "Return a type lowerable through the async resolve ABI "
                        + "(String/Int/Bool/Double/Float/raw-value or case-only enum/@JS struct/JSObject/Optional/Array/Dictionary), "
                        + "or make the closure non-async."
                )
            )
            return nil
        }

        var isThrows = false
        if functionType.isThrowing {
            guard let thrownType = functionType.thrownTypedError,
                thrownType.asNominalTypeDeclaration?.name == "JSException"
            else {
                let spelled = functionType.thrownTypedError.map { "\($0)" } ?? "unspecified"
                errors.append(
                    DiagnosticError(
                        node: anchor,
                        message:
                            "Only JSException is supported for thrown type of Swift closures, "
                            + "got \(spelled)",
                        hint: "Annotate the closure as `throws(JSException)`"
                    )
                )
                return nil
            }
            isThrows = true
        }

        return .closure(
            ClosureSignature(
                parameters: parameters,
                returnType: returnType,
                moduleName: moduleName,
                isAsync: isAsync,
                isThrows: isThrows
            ),
            useJSTypedClosure: false
        )
    }

    private func bridgeType(
        forLocal decl: SwiftNominalTypeDeclaration,
        anchor: some SyntaxProtocol,
        errors: inout [DiagnosticError]
    ) -> BridgeType? {
        let callName = swiftCallName(for: decl)
        let attributes = decl.syntax.attributes

        if attributes.hasAttribute(name: "JSClass") {
            return .jsObject(callName)
        }

        switch decl.kind {
        case .protocol:
            return .swiftProtocol(callName)

        case .enum:
            guard let enumDecl = decl.syntax.as(EnumDeclSyntax.self) else {
                return unsupported(name: decl.name, anchor: anchor, errors: &errors)
            }
            if let jsAttribute = attributes.firstJSAttribute,
                let aliasTarget = SwiftToSkeleton.extractAliasTarget(from: jsAttribute)
            {
                return aliasType(target: aliasTarget, swiftCallName: callName, anchor: anchor, errors: &errors)
            }
            let rawTypeString = enumDecl.inheritanceClause?.inheritedTypes.first { inheritedType in
                SwiftEnumRawType.supportedTypeNames.contains(inheritedType.type.trimmedDescription)
            }?.type.trimmedDescription
            if let rawType = SwiftEnumRawType(rawTypeString) {
                return .rawValueEnum(callName, rawType)
            }
            let caseDecls = enumDecl.memberBlock.members.compactMap {
                $0.decl.as(EnumCaseDeclSyntax.self)
            }
            if caseDecls.isEmpty {
                return .namespaceEnum(callName)
            }
            let hasAssociatedValues = caseDecls.contains { caseDecl in
                caseDecl.elements.contains { element in
                    !(element.parameterClause?.parameters.isEmpty ?? true)
                }
            }
            return hasAssociatedValues ? .associatedValueEnum(callName) : .caseEnum(callName)

        case .struct:
            if let jsAttribute = attributes.firstJSAttribute,
                let aliasTarget = SwiftToSkeleton.extractAliasTarget(from: jsAttribute)
            {
                return aliasType(target: aliasTarget, swiftCallName: callName, anchor: anchor, errors: &errors)
            }
            return .swiftStruct(callName)

        case .class, .actor:
            if let jsAttribute = attributes.firstJSAttribute,
                let aliasTarget = SwiftToSkeleton.extractAliasTarget(from: jsAttribute)
            {
                return aliasType(target: aliasTarget, swiftCallName: callName, anchor: anchor, errors: &errors)
            }
            return .swiftHeapObject(callName)
        }
    }

    private func bridgeType(
        forExternal decl: SwiftNominalTypeDeclaration,
        anchor: some SyntaxProtocol,
        errors: inout [DiagnosticError]
    ) -> BridgeType? {
        var path = [decl.name]
        var ancestor = decl.parent
        while let current = ancestor {
            path.insert(current.name, at: 0)
            ancestor = current.parent
        }
        let dotPath = path.joined(separator: ".")

        // Preserve the ambiguity diagnostic for unqualified references to a
        // name exported by several dependency modules. The source spelling
        // decides: a module-qualified reference is unambiguous.
        let spelling = anchorSpelling(anchor)
        let isQualifiedSpelling =
            spelling.hasPrefix("\(decl.moduleName).") || spelling.contains(".\(decl.moduleName).")

        let lookupResult: ExternalModuleIndex.LookupResult?
        if isQualifiedSpelling {
            lookupResult = externalModuleIndex.lookup(dotPath: dotPath, module: decl.moduleName)
        } else {
            lookupResult = externalModuleIndex.lookup(dotPath: dotPath)
        }

        guard let lookupResult else {
            return unsupported(name: decl.name, anchor: anchor, errors: &errors)
        }
        switch lookupResult {
        case .unique(let externalType):
            usedExternalModules.insert(externalType.moduleName)
            return externalType.bridgeType
        case .ambiguous(let candidates):
            let moduleNames = candidates.map(\.moduleName).sorted().joined(separator: ", ")
            errors.append(
                DiagnosticError(
                    node: anchor,
                    message: "ambiguous use of '\(spelling)'",
                    hint:
                        "'\(dotPath)' is exported by multiple dependency modules: \(moduleNames). "
                        + "Qualify with a module name (e.g. '<Module>.\(dotPath)') to disambiguate."
                )
            )
            return nil
        }
    }

    func aliasType(
        target aliasTarget: TypeSyntax,
        swiftCallName: String,
        anchor: some SyntaxProtocol,
        errors: inout [DiagnosticError]
    ) -> BridgeType? {
        func diagnoseChainedAlias() -> BridgeType? {
            errors.append(
                DiagnosticError(
                    node: anchor,
                    message: "`@JS(as:)` target must be a `@JS` type, not another `@JS(as:)` type",
                    hint: "Use the underlying `@JS` type directly"
                )
            )
            return nil
        }
        guard let targetSwiftType = try? analyzer.resolveType(aliasTarget),
            !targetSwiftType.isUnresolvedTypePlaceholder
        else {
            return unsupported(name: aliasTarget.trimmedDescription, anchor: anchor, errors: &errors)
        }
        if let targetDecl = targetSwiftType.asNominalTypeDeclaration,
            let targetJSAttribute = targetDecl.syntax.attributes.firstJSAttribute,
            SwiftToSkeleton.extractAliasTarget(from: targetJSAttribute) != nil
        {
            return diagnoseChainedAlias()
        }
        guard let targetType = bridgeType(for: targetSwiftType, anchor: anchor, errors: &errors) else {
            return nil
        }
        if case .alias = targetType {
            // Alias declared in another module.
            return diagnoseChainedAlias()
        }
        if case .swiftProtocol = targetType {
            errors.append(
                DiagnosticError(
                    node: anchor,
                    message: "`@JS(as:)` cannot target a `@JS protocol`"
                )
            )
            return nil
        }
        return .alias(name: swiftCallName, underlying: targetType)
    }

    // MARK: Diagnostics helpers

    private func anchorSpelling(_ anchor: some SyntaxProtocol) -> String {
        anchor.trimmedDescription
    }

    /// Recovers the source spelling of an unresolved name from the anchoring
    /// type syntax, so `Foundation.URL` is reported as written rather than as
    /// the bare `URL` recorded on the placeholder.
    private func unresolvedSpelling(of name: String, in anchor: some SyntaxProtocol) -> String {
        if let memberType = Syntax(anchor).as(MemberTypeSyntax.self), memberType.name.text == name {
            return memberType.trimmedDescription
        }
        let finder = MemberTypeSpellingFinder(name: name)
        finder.walk(Syntax(anchor))
        return finder.spelling ?? name
    }

    private func unsupported(
        type: SwiftType,
        anchor: some SyntaxProtocol,
        errors: inout [DiagnosticError]
    ) -> BridgeType? {
        unsupported(name: "\(type)", anchor: anchor, errors: &errors)
    }

    private func unsupportedSpelling(
        anchor: some SyntaxProtocol,
        errors: inout [DiagnosticError]
    ) -> BridgeType? {
        unsupported(name: anchorSpelling(anchor), anchor: anchor, errors: &errors)
    }

    func unsupported(
        name: String,
        anchor: some SyntaxProtocol,
        errors: inout [DiagnosticError]
    ) -> BridgeType? {
        errors.append(
            DiagnosticError(
                node: anchor,
                message: "Unsupported type '\(name)'.",
                hint:
                    "Only primitive types, types defined in the same module, and "
                    + "`@JS` types from dependency targets that apply the BridgeJS plugin are allowed"
            )
        )
        return nil
    }
}

private final class MemberTypeSpellingFinder: SyntaxAnyVisitor {
    let name: String
    var spelling: String?

    init(name: String) {
        self.name = name
        super.init(viewMode: .sourceAccurate)
    }

    override func visit(_ node: MemberTypeSyntax) -> SyntaxVisitorContinueKind {
        if spelling == nil, node.name.text == name {
            spelling = node.trimmedDescription
            return .skipChildren
        }
        return .visitChildren
    }
}

final class JSAttributeFinder: SyntaxVisitor {
    private(set) var found = false

    override func visit(_ node: AttributeSyntax) -> SyntaxVisitorContinueKind {
        if node.attributeNameText == "JS" {
            found = true
        }
        return .skipChildren
    }
}

// MARK: - Attribute helpers

extension AttributeSyntax {
    /// The attribute name as text when it is a simple identifier (e.g. "JS", "JSFunction").
    var attributeNameText: String? {
        attributeName.as(IdentifierTypeSyntax.self)?.name.text
    }
}

extension AttributeListSyntax {
    func hasJSAttribute() -> Bool {
        firstJSAttribute != nil
    }

    var firstJSAttribute: AttributeSyntax? {
        firstAttribute(named: "JS")
    }

    func firstAttribute(named name: String) -> AttributeSyntax? {
        first(where: { $0.as(AttributeSyntax.self)?.attributeNameText == name })?.as(AttributeSyntax.self)
    }

    /// Returns true if any attribute has the given name (e.g. "JSClass").
    func hasAttribute(name: String) -> Bool {
        firstAttribute(named: name) != nil
    }

    func hasJSFamilyAttribute() -> Bool {
        contains { element in
            guard let name = element.as(AttributeSyntax.self)?.attributeNameText else { return false }
            return SwiftToSkeleton.jsAttributeNames.contains(name)
        }
    }
}

extension DeclModifierListSyntax {
    var containsStaticOrClass: Bool {
        contains { modifier in
            modifier.name.tokenKind == .keyword(.static) || modifier.name.tokenKind == .keyword(.class)
        }
    }
}

extension ExtractedFunc {
    /// The attribute list of the originating declaration, when it has one.
    var declAttributeList: AttributeListSyntax? {
        swiftDecl.asProtocol((any WithAttributesSyntax).self)?.attributes
    }

    var declModifierList: DeclModifierListSyntax? {
        swiftDecl.asProtocol((any WithModifiersSyntax).self)?.modifiers
    }
}

// MARK: - Shared syntax extraction helpers

extension SwiftToSkeleton {
    static func extractJSNameArgument(from jsAttribute: AttributeSyntax) -> String? {
        guard let arguments = jsAttribute.arguments?.as(LabeledExprListSyntax.self),
            let nameArg = arguments.first,
            nameArg.label == nil,
            let stringLiteral = nameArg.expression.as(StringLiteralExprSyntax.self),
            stringLiteral.segments.count == 1,
            let name = stringLiteral.segments.first?.as(StringSegmentSyntax.self)?.content.text
        else {
            return nil
        }
        return name
    }

    static func extractNamespace(from jsAttribute: AttributeSyntax) -> [String]? {
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

    static func extractEnumStyle(from jsAttribute: AttributeSyntax) -> EnumEmitStyle? {
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

    static func extractIdentityMode(from jsAttribute: AttributeSyntax) -> Bool? {
        guard let arguments = jsAttribute.arguments?.as(LabeledExprListSyntax.self),
            let identityArg = arguments.first(where: { $0.label?.text == "identityMode" })
        else { return nil }
        let text = identityArg.expression.trimmedDescription
        return text == "true"
    }

    static func extractAliasTarget(from jsAttribute: AttributeSyntax) -> TypeSyntax? {
        guard
            let arguments = jsAttribute.arguments?.as(LabeledExprListSyntax.self),
            let asArg = arguments.first(where: { $0.label?.text == "as" }),
            let memberAccess = asArg.expression.as(MemberAccessExprSyntax.self),
            memberAccess.declName.baseName.text == "self",
            let base = memberAccess.base
        else {
            return nil
        }
        return TypeSyntax(stringLiteral: base.trimmedDescription)
    }

    /// Returns the doc comment (`///` or `/** */`) attached to a declaration, with
    /// markers stripped and DocC field lists (`- Parameters:`, `- Returns:`) preserved.
    static func extractDocumentation(from node: some SyntaxProtocol) -> String? {
        var run: [String] = []
        for piece in node.leadingTrivia {
            switch piece {
            case .docLineComment(let text):
                var line = Substring(text)
                if line.hasPrefix("///") { line = line.dropFirst(3) }
                if line.first == " " { line = line.dropFirst() }
                if line.last == "\r" { line = line.dropLast() }
                run.append(String(line))
            case .docBlockComment(let text):
                run.append(contentsOf: stripBlockComment(text))
            case .newlines(let count), .carriageReturns(let count), .carriageReturnLineFeeds(let count):
                if count >= 2 { run.removeAll() }
            case .lineComment, .blockComment:
                run.removeAll()
            default:
                continue
            }
        }
        // Trim boundary blank lines so line (`///`) and block (`/** */`) comments
        // produce a consistent skeleton value.
        while run.first?.trimmingCharacters(in: .whitespaces).isEmpty == true { run.removeFirst() }
        while run.last?.trimmingCharacters(in: .whitespaces).isEmpty == true { run.removeLast() }
        return run.isEmpty ? nil : run.joined(separator: "\n")
    }

    private static func stripBlockComment(_ text: String) -> [String] {
        var body = Substring(text)
        if body.hasPrefix("/**") { body = body.dropFirst(3) }
        if body.hasSuffix("*/") { body = body.dropLast(2) }
        return body.split(separator: "\n", omittingEmptySubsequences: false).map { raw -> String in
            var line = raw[...]
            if line.last == "\r" { line = line.dropLast() }
            while let first = line.first, first == " " || first == "\t" { line = line.dropFirst() }
            if line.first == "*" {
                line = line.dropFirst()
                if line.first == " " { line = line.dropFirst() }
            }
            return String(line)
        }
    }
}

private enum ExportSwiftConstants {
    static let supportedRawTypes = SwiftEnumRawType.supportedTypeNames
}
