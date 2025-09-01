import class Foundation.JSONDecoder
import struct Foundation.Data
#if canImport(BridgeJSSkeleton)
import BridgeJSSkeleton
#endif
#if canImport(BridgeJSUtilities)
import BridgeJSUtilities
#endif

struct BridgeJSLink {
    /// The exported skeletons
    var exportedSkeletons: [ExportedSkeleton] = []
    var importedSkeletons: [ImportedModuleSkeleton] = []
    let sharedMemory: Bool

    init(
        exportedSkeletons: [ExportedSkeleton] = [],
        importedSkeletons: [ImportedModuleSkeleton] = [],
        sharedMemory: Bool
    ) {
        self.exportedSkeletons = exportedSkeletons
        self.importedSkeletons = importedSkeletons
        self.sharedMemory = sharedMemory
    }

    mutating func addExportedSkeletonFile(data: Data) throws {
        let skeleton = try JSONDecoder().decode(ExportedSkeleton.self, from: data)
        exportedSkeletons.append(skeleton)
    }

    mutating func addImportedSkeletonFile(data: Data) throws {
        let skeletons = try JSONDecoder().decode(ImportedModuleSkeleton.self, from: data)
        importedSkeletons.append(skeletons)
    }

    let swiftHeapObjectClassDts = """
        /// Represents a Swift heap object like a class instance or an actor instance.
        export interface SwiftHeapObject {
            /// Release the heap object.
            ///
            /// Note: Calling this method will release the heap object and it will no longer be accessible.
            release(): void;
        }
        """

    let swiftHeapObjectClassJs = """
        /// Represents a Swift heap object like a class instance or an actor instance.
        class SwiftHeapObject {
            static __wrap(pointer, deinit, prototype) {
                const obj = Object.create(prototype);
                obj.pointer = pointer;
                obj.hasReleased = false;
                obj.deinit = deinit;
                obj.registry = new FinalizationRegistry((pointer) => {
                    deinit(pointer);
                });
                obj.registry.register(this, obj.pointer);
                return obj;
            }

            release() {
                this.registry.unregister(this);
                this.deinit(this.pointer);
            }
        }
        """

    let sharedEnumHelpersJs = """
        """

    func link() throws -> (outputJs: String, outputDts: String) {
        var exportsLines: [String] = []
        var classLines: [String] = []
        var dtsExportLines: [String] = []
        var dtsClassLines: [String] = []
        var namespacedFunctions: [ExportedFunction] = []
        var namespacedClasses: [ExportedClass] = []
        var namespacedEnums: [ExportedEnum] = []
        var topLevelEnumLines: [String] = []
        var topLevelDtsEnumLines: [String] = []

        if exportedSkeletons.contains(where: { $0.classes.count > 0 }) {
            classLines.append(
                contentsOf: swiftHeapObjectClassJs.split(separator: "\n", omittingEmptySubsequences: false).map {
                    String($0)
                }
            )
            dtsClassLines.append(
                contentsOf: swiftHeapObjectClassDts.split(separator: "\n", omittingEmptySubsequences: false).map {
                    String($0)
                }
            )
        }

        for skeleton in exportedSkeletons {
            for klass in skeleton.classes {
                let (jsType, dtsType, dtsExportEntry) = try renderExportedClass(klass)
                classLines.append(contentsOf: jsType)
                exportsLines.append("\(klass.name),")
                dtsExportLines.append(contentsOf: dtsExportEntry)
                dtsClassLines.append(contentsOf: dtsType)

                if klass.namespace != nil {
                    namespacedClasses.append(klass)
                }
            }

            if !skeleton.enums.isEmpty {
                for enumDefinition in skeleton.enums {
                    let (jsEnum, dtsEnum) = try renderExportedEnum(enumDefinition)

                    switch enumDefinition.enumType {
                    case .namespace:
                        break
                    case .simple, .rawValue:
                        var exportedJsEnum = jsEnum
                        if !exportedJsEnum.isEmpty && exportedJsEnum[0].hasPrefix("const ") {
                            exportedJsEnum[0] = "export " + exportedJsEnum[0]
                        }
                        topLevelEnumLines.append(contentsOf: exportedJsEnum)
                        topLevelDtsEnumLines.append(contentsOf: dtsEnum)

                        if enumDefinition.namespace != nil {
                            namespacedEnums.append(enumDefinition)
                        }
                    case .associatedValue:
                        var exportedJsEnum = jsEnum
                        if !exportedJsEnum.isEmpty && exportedJsEnum[0].hasPrefix("const ") {
                            exportedJsEnum[0] = "export " + exportedJsEnum[0]
                        }
                        topLevelEnumLines.append(contentsOf: exportedJsEnum)
                        topLevelDtsEnumLines.append(contentsOf: dtsEnum)
                        if enumDefinition.namespace != nil {
                            namespacedEnums.append(enumDefinition)
                        }
                    }
                }
            }

            for function in skeleton.functions {
                var (js, dts) = try renderExportedFunction(function: function)

                if function.namespace != nil {
                    namespacedFunctions.append(function)
                }

                js[0] = "\(function.name): " + js[0]
                js[js.count - 1] += ","
                exportsLines.append(contentsOf: js)
                dtsExportLines.append(contentsOf: dts)
            }
        }

        var importObjectBuilders: [ImportObjectBuilder] = []
        for skeletonSet in importedSkeletons {
            let importObjectBuilder = ImportObjectBuilder(moduleName: skeletonSet.moduleName)
            for fileSkeleton in skeletonSet.children {
                for function in fileSkeleton.functions {
                    try renderImportedFunction(importObjectBuilder: importObjectBuilder, function: function)
                }
                for type in fileSkeleton.types {
                    try renderImportedType(importObjectBuilder: importObjectBuilder, type: type)
                }
            }
            importObjectBuilders.append(importObjectBuilder)
        }

        let hasNamespacedItems = !namespacedFunctions.isEmpty || !namespacedClasses.isEmpty

        let namespaceBuilder = NamespaceBuilder()
        let namespaceDeclarationsLines = namespaceBuilder.namespaceDeclarations(
            exportedSkeletons: exportedSkeletons,
            renderTSSignatureCallback: { parameters, returnType, effects in
                self.renderTSSignature(parameters: parameters, returnType: returnType, effects: effects)
            }
        )

        let exportsSection: String
        if hasNamespacedItems {
            let namespaceSetupCode = namespaceBuilder.renderGlobalNamespace(
                namespacedFunctions: namespacedFunctions,
                namespacedClasses: namespacedClasses
            )
            .map { $0.indent(count: 12) }.joined(separator: "\n")

            exportsSection = """
                \(classLines.map { $0.indent(count: 12) }.joined(separator: "\n"))
                \("const exports = {".indent(count: 12))
                \(exportsLines.map { $0.indent(count: 16) }.joined(separator: "\n"))
                \("};".indent(count: 12))

                \(namespaceSetupCode)

                \("return exports;".indent(count: 12))
                        },
                """
        } else {
            exportsSection = """
                \(classLines.map { $0.indent(count: 12) }.joined(separator: "\n"))
                \("return {".indent(count: 12))
                \(exportsLines.map { $0.indent(count: 16) }.joined(separator: "\n"))
                \("};".indent(count: 12))
                        },
                """
        }

        let hasAssociatedValueEnums = exportedSkeletons.contains { skeleton in
            skeleton.enums.contains { $0.enumType == .associatedValue }
        }
        let sharedEnumHelpersSection = hasAssociatedValueEnums ? sharedEnumHelpersJs : ""
        let topLevelEnumsSection = topLevelEnumLines.isEmpty ? "" : topLevelEnumLines.joined(separator: "\n") + "\n\n"
        let topLevelNamespaceCode = namespaceBuilder.renderTopLevelEnumNamespaceAssignments(
            namespacedEnums: namespacedEnums
        )
        let namespaceAssignmentsSection =
            topLevelNamespaceCode.isEmpty ? "" : topLevelNamespaceCode.joined(separator: "\n") + "\n\n"

        let enumHelpers = renderEnumHelperAssignments()
        let enumHelpersSection =
            enumHelpers.isEmpty ? "" : "\n\n" + enumHelpers.map { $0.indent(count: 12) }.joined(separator: "\n")
        let enumHelpersDeclaration = hasAssociatedValueEnums ? "const enumHelpers = {};\n" : "\n"

        let outputJs = """
            // NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
            // DO NOT EDIT.
            //
            // To update this file, just rebuild your project or run
            // `swift package bridge-js`.

            \(sharedEnumHelpersSection)\(topLevelEnumsSection)\(namespaceAssignmentsSection)export async function createInstantiator(options, \(JSGlueVariableScope.reservedSwift)) {
                let \(JSGlueVariableScope.reservedInstance);
                let \(JSGlueVariableScope.reservedMemory);
                let \(JSGlueVariableScope.reservedSetException);
                const \(JSGlueVariableScope.reservedTextDecoder) = new TextDecoder("utf-8");
                const \(JSGlueVariableScope.reservedTextEncoder) = new TextEncoder("utf-8");
                let \(JSGlueVariableScope.reservedStorageToReturnString);
                let \(JSGlueVariableScope.reservedStorageToReturnBytes);
                let \(JSGlueVariableScope.reservedStorageToReturnException);
                let \(JSGlueVariableScope.reservedTmpRetTag);
                let \(JSGlueVariableScope.reservedTmpRetStrings) = [];
                let \(JSGlueVariableScope.reservedTmpRetInts) = [];
                let \(JSGlueVariableScope.reservedTmpRetF32s) = [];
                let \(JSGlueVariableScope.reservedTmpRetF64s) = [];
                let \(JSGlueVariableScope.reservedTmpParamInts) = [];
                let \(JSGlueVariableScope.reservedTmpParamF32s) = [];
                let \(JSGlueVariableScope.reservedTmpParamF64s) = [];
                \(enumHelpersDeclaration)
                return {
                    /**
                     * @param {WebAssembly.Imports} importObject
                     */
                    addImports: (importObject, importsContext) => {
                        const bjs = {};
                        importObject["bjs"] = bjs;
                        const imports = options.getImports(importsContext);
                        bjs["swift_js_return_string"] = function(ptr, len) {
                            const bytes = new Uint8Array(\(JSGlueVariableScope.reservedMemory).buffer, ptr, len)\(sharedMemory ? ".slice()" : "");
                            \(JSGlueVariableScope.reservedStorageToReturnString) = \(JSGlueVariableScope.reservedTextDecoder).decode(bytes);
                        }
                        bjs["swift_js_init_memory"] = function(sourceId, bytesPtr) {
                            const source = \(JSGlueVariableScope.reservedSwift).\(JSGlueVariableScope.reservedMemory).getObject(sourceId);
                            const bytes = new Uint8Array(\(JSGlueVariableScope.reservedMemory).buffer, bytesPtr);
                            bytes.set(source);
                        }
                        bjs["swift_js_make_js_string"] = function(ptr, len) {
                            const bytes = new Uint8Array(\(JSGlueVariableScope.reservedMemory).buffer, ptr, len)\(sharedMemory ? ".slice()" : "");
                            return \(JSGlueVariableScope.reservedSwift).\(JSGlueVariableScope.reservedMemory).retain(\(JSGlueVariableScope.reservedTextDecoder).decode(bytes));
                        }
                        bjs["swift_js_init_memory_with_result"] = function(ptr, len) {
                            const target = new Uint8Array(\(JSGlueVariableScope.reservedMemory).buffer, ptr, len);
                            target.set(\(JSGlueVariableScope.reservedStorageToReturnBytes));
                            \(JSGlueVariableScope.reservedStorageToReturnBytes) = undefined;
                        }
                        bjs["swift_js_throw"] = function(id) {
                            \(JSGlueVariableScope.reservedStorageToReturnException) = \(JSGlueVariableScope.reservedSwift).\(JSGlueVariableScope.reservedMemory).retainByRef(id);
                        }
                        bjs["swift_js_retain"] = function(id) {
                            return \(JSGlueVariableScope.reservedSwift).\(JSGlueVariableScope.reservedMemory).retainByRef(id);
                        }
                        bjs["swift_js_release"] = function(id) {
                            \(JSGlueVariableScope.reservedSwift).memory.release(id);
                        }
                        bjs["swift_js_push_tag"] = function(tag) {
                            \(JSGlueVariableScope.reservedTmpRetTag) = tag;
                        }
                        bjs["swift_js_push_int"] = function(v) {
                            \(JSGlueVariableScope.reservedTmpRetInts).push(v | 0);
                        }
                        bjs["swift_js_push_f32"] = function(v) {
                            \(JSGlueVariableScope.reservedTmpRetF32s).push(Math.fround(v));
                        }
                        bjs["swift_js_push_f64"] = function(v) {
                            \(JSGlueVariableScope.reservedTmpRetF64s).push(v);
                        }
                        bjs["swift_js_push_string"] = function(ptr, len) {
                            const bytes = new Uint8Array(\(JSGlueVariableScope.reservedMemory).buffer, ptr, len)\(sharedMemory ? ".slice()" : "");
                            const value = \(JSGlueVariableScope.reservedTextDecoder).decode(bytes);
                            \(JSGlueVariableScope.reservedTmpRetStrings).push(value);
                        }
                        bjs["swift_js_pop_param_int32"] = function() {
                            return \(JSGlueVariableScope.reservedTmpParamInts).pop();
                        }
                        bjs["swift_js_pop_param_f32"] = function() {
                            return \(JSGlueVariableScope.reservedTmpParamF32s).pop();
                        }
                        bjs["swift_js_pop_param_f64"] = function() {
                            return \(JSGlueVariableScope.reservedTmpParamF64s).pop();
                        }
            \(renderSwiftClassWrappers().map { $0.indent(count: 12) }.joined(separator: "\n"))
            \(importObjectBuilders.flatMap { $0.importedLines }.map { $0.indent(count: 12) }.joined(separator: "\n"))
                    },
                    setInstance: (i) => {
                        \(JSGlueVariableScope.reservedInstance) = i;
                        \(JSGlueVariableScope.reservedMemory) = \(JSGlueVariableScope.reservedInstance).exports.memory;
                        \(enumHelpersSection)
                        \(JSGlueVariableScope.reservedSetException) = (error) => {
                            \(JSGlueVariableScope.reservedInstance).exports._swift_js_exception.value = \(JSGlueVariableScope.reservedSwift).memory.retain(error)
                        }
                    },
                    /** @param {WebAssembly.Instance} instance */
                    createExports: (instance) => {
                        const js = \(JSGlueVariableScope.reservedSwift).memory.heap;
            \(exportsSection)
                }
            }
            """

        var dtsLines: [String] = []
        dtsLines.append(contentsOf: namespaceDeclarationsLines)
        dtsLines.append(contentsOf: dtsClassLines)
        dtsLines.append(contentsOf: generateImportedTypeDefinitions())
        dtsLines.append("export type Exports = {")
        dtsLines.append(contentsOf: dtsExportLines.map { $0.indent(count: 4) })
        dtsLines.append("}")
        dtsLines.append("export type Imports = {")
        dtsLines.append(contentsOf: importObjectBuilders.flatMap { $0.dtsImportLines }.map { $0.indent(count: 4) })
        dtsLines.append("}")
        let topLevelDtsEnumsSection =
            topLevelDtsEnumLines.isEmpty ? "" : topLevelDtsEnumLines.joined(separator: "\n") + "\n"

        let outputDts = """
            // NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
            // DO NOT EDIT.
            //
            // To update this file, just rebuild your project or run
            // `swift package bridge-js`.

            \(topLevelDtsEnumsSection)\(dtsLines.joined(separator: "\n"))
            export function createInstantiator(options: {
                imports: Imports;
            }, swift: any): Promise<{
                addImports: (importObject: WebAssembly.Imports) => void;
                setInstance: (instance: WebAssembly.Instance) => void;
                createExports: (instance: WebAssembly.Instance) => Exports;
            }>;
            """
        return (outputJs, outputDts)
    }

    private func renderEnumHelperAssignments() -> [String] {
        let printer = CodeFragmentPrinter()

        for skeleton in exportedSkeletons {
            for enumDef in skeleton.enums where enumDef.enumType == .associatedValue {
                let base = enumDef.name
                printer.write(
                    "const \(base)Helpers = __bjs_create\(base)Helpers()(\(JSGlueVariableScope.reservedTmpParamInts), \(JSGlueVariableScope.reservedTmpParamF32s), \(JSGlueVariableScope.reservedTmpParamF64s), \(JSGlueVariableScope.reservedTextEncoder), \(JSGlueVariableScope.reservedSwift));"
                )
                printer.write("enumHelpers.\(base) = \(base)Helpers;")
                printer.nextLine()
            }
        }

        return printer.lines
    }

    private func renderSwiftClassWrappers() -> [String] {
        var wrapperLines: [String] = []
        var modulesByName: [String: [ExportedClass]] = [:]

        // Group classes by their module name
        for skeleton in exportedSkeletons {
            if skeleton.classes.isEmpty { continue }

            if modulesByName[skeleton.moduleName] == nil {
                modulesByName[skeleton.moduleName] = []
            }
            modulesByName[skeleton.moduleName]?.append(contentsOf: skeleton.classes)
        }

        // Generate wrapper functions for each module
        for (moduleName, classes) in modulesByName {
            wrapperLines.append("// Wrapper functions for module: \(moduleName)")
            wrapperLines.append("if (!importObject[\"\(moduleName)\"]) {")
            wrapperLines.append("    importObject[\"\(moduleName)\"] = {};")
            wrapperLines.append("}")

            for klass in classes {
                let wrapperFunctionName = "bjs_\(klass.name)_wrap"
                wrapperLines.append("importObject[\"\(moduleName)\"][\"\(wrapperFunctionName)\"] = function(pointer) {")
                wrapperLines.append("    const obj = \(klass.name).__construct(pointer);")
                wrapperLines.append("    return \(JSGlueVariableScope.reservedSwift).memory.retain(obj);")
                wrapperLines.append("};")
            }
        }

        return wrapperLines
    }

    private func generateImportedTypeDefinitions() -> [String] {
        let printer = CodeFragmentPrinter()

        for skeletonSet in importedSkeletons {
            for fileSkeleton in skeletonSet.children {
                for type in fileSkeleton.types {
                    printer.write("export interface \(type.name) {")
                    printer.indent()

                    // Add methods
                    for method in type.methods {
                        let methodSignature =
                            "\(method.name)\(renderTSSignature(parameters: method.parameters, returnType: method.returnType, effects: Effects(isAsync: false, isThrows: false)));"
                        printer.write(methodSignature)
                    }

                    // Add properties
                    for property in type.properties {
                        let propertySignature =
                            property.isReadonly
                            ? "readonly \(property.name): \(property.type.tsType);"
                            : "\(property.name): \(property.type.tsType);"
                        printer.write(propertySignature)
                    }

                    printer.unindent()
                    printer.write("}")
                }
            }
        }

        return printer.lines
    }

    class ExportedThunkBuilder {
        var body: CodeFragmentPrinter
        var cleanupCode: CodeFragmentPrinter
        var parameterForwardings: [String] = []
        let effects: Effects
        let scope: JSGlueVariableScope

        init(effects: Effects) {
            self.effects = effects
            self.scope = JSGlueVariableScope()
            self.body = CodeFragmentPrinter()
            self.cleanupCode = CodeFragmentPrinter()
        }

        func lowerParameter(param: Parameter) throws {
            let loweringFragment = try IntrinsicJSFragment.lowerParameter(type: param.type)
            assert(
                loweringFragment.parameters.count == 1,
                "Lowering fragment should have exactly one parameter to lower"
            )
            let loweredValues = loweringFragment.printCode([param.name], scope, body, cleanupCode)
            parameterForwardings.append(contentsOf: loweredValues)
        }

        func lowerSelf() {
            parameterForwardings.append("this.pointer")
        }

        func call(abiName: String, returnType: BridgeType) throws -> String? {
            if effects.isAsync {
                return try _call(abiName: abiName, returnType: .jsObject(nil))
            } else {
                return try _call(abiName: abiName, returnType: returnType)
            }
        }

        private func _call(abiName: String, returnType: BridgeType) throws -> String? {
            let call = "instance.exports.\(abiName)(\(parameterForwardings.joined(separator: ", ")))"
            let liftingFragment = try IntrinsicJSFragment.liftReturn(type: returnType)
            assert(
                liftingFragment.parameters.count <= 1,
                "Lifting fragment should have at most one parameter to lift"
            )
            let fragmentArguments: [String]
            if liftingFragment.parameters.isEmpty {
                body.write("\(call);")
                fragmentArguments = []
            } else {
                let returnVariable = scope.variable("ret")
                body.write("const \(returnVariable) = \(call);")
                fragmentArguments = [returnVariable]
            }
            let liftedValues = liftingFragment.printCode(fragmentArguments, scope, body, cleanupCode)
            assert(liftedValues.count <= 1, "Lifting fragment should produce at most one value")
            return liftedValues.first
        }

        func callConstructor(abiName: String) -> String {
            let call =
                "\(JSGlueVariableScope.reservedInstance).exports.\(abiName)(\(parameterForwardings.joined(separator: ", ")))"
            body.write("const ret = \(call);")
            return "ret"
        }

        func checkExceptionLines() -> [String] {
            guard effects.isThrows else {
                return []
            }
            let exceptionVariable = JSGlueVariableScope.reservedStorageToReturnException
            return [
                "if (\(exceptionVariable)) {",
                // TODO: Implement "take" operation
                "    const error = \(JSGlueVariableScope.reservedSwift).memory.getObject(\(exceptionVariable));",
                "    \(JSGlueVariableScope.reservedSwift).memory.release(\(exceptionVariable));",
                "    \(exceptionVariable) = undefined;",
                "    throw error;",
                "}",
            ]
        }

        func renderFunction(
            name: String,
            parameters: [Parameter],
            returnExpr: String?,
            declarationPrefixKeyword: String?
        ) -> [String] {
            var funcLines: [String] = []
            funcLines.append(
                "\(declarationPrefixKeyword.map { "\($0) "} ?? "")\(name)(\(parameters.map { $0.name }.joined(separator: ", "))) {"
            )
            funcLines.append(contentsOf: body.lines.map { $0.indent(count: 4) })
            funcLines.append(contentsOf: cleanupCode.lines.map { $0.indent(count: 4) })
            funcLines.append(contentsOf: checkExceptionLines().map { $0.indent(count: 4) })
            if let returnExpr = returnExpr {
                funcLines.append("return \(returnExpr);".indent(count: 4))
            }
            funcLines.append("}")
            return funcLines
        }
    }

    private func renderTSSignature(parameters: [Parameter], returnType: BridgeType, effects: Effects) -> String {
        let returnTypeWithEffect: String
        if effects.isAsync {
            returnTypeWithEffect = "Promise<\(returnType.tsType)>"
        } else {
            returnTypeWithEffect = returnType.tsType
        }
        return
            "(\(parameters.map { "\($0.name): \($0.type.tsType)" }.joined(separator: ", "))): \(returnTypeWithEffect)"
    }

    func renderExportedEnum(_ enumDefinition: ExportedEnum) throws -> (js: [String], dts: [String]) {
        var jsLines: [String] = []
        var dtsLines: [String] = []
        let scope = JSGlueVariableScope()
        let cleanup = CodeFragmentPrinter()
        let printer = CodeFragmentPrinter()

        switch enumDefinition.enumType {
        case .simple:
            let fragment = IntrinsicJSFragment.simpleEnumHelper(enumDefinition: enumDefinition)
            _ = fragment.printCode([enumDefinition.name], scope, printer, cleanup)

            jsLines.append(contentsOf: printer.lines)
        case .rawValue:
            guard enumDefinition.rawType != nil else {
                throw BridgeJSLinkError(message: "Raw value enum \(enumDefinition.name) is missing rawType")
            }

            let fragment = IntrinsicJSFragment.rawValueEnumHelper(enumDefinition: enumDefinition)
            _ = fragment.printCode([enumDefinition.name], scope, printer, cleanup)

            jsLines.append(contentsOf: printer.lines)
        case .associatedValue:
            let fragment = IntrinsicJSFragment.associatedValueEnumHelper(enumDefinition: enumDefinition)
            _ = fragment.printCode([enumDefinition.name], scope, printer, cleanup)

            jsLines.append(contentsOf: printer.lines)
        case .namespace:
            break
        }

        if enumDefinition.namespace == nil {
            dtsLines.append(contentsOf: generateDeclarations(enumDefinition: enumDefinition))
        }

        return (jsLines, dtsLines)
    }

    private func generateDeclarations(enumDefinition: ExportedEnum) -> [String] {
        let printer = CodeFragmentPrinter()

        switch enumDefinition.emitStyle {
        case .tsEnum:
            switch enumDefinition.enumType {
            case .simple, .rawValue:
                printer.write("export enum \(enumDefinition.name) {")
                printer.indent()
                for (index, enumCase) in enumDefinition.cases.enumerated() {
                    let caseName = enumCase.name.capitalizedFirstLetter
                    let value: String

                    switch enumDefinition.enumType {
                    case .simple:
                        value = "\(index)"
                    case .rawValue:
                        let rawValue = enumCase.rawValue ?? enumCase.name
                        value = SwiftEnumRawType.formatValue(rawValue, rawType: enumDefinition.rawType ?? "")
                    case .associatedValue, .namespace:
                        continue
                    }

                    printer.write("\(caseName) = \(value),")
                }
                printer.unindent()
                printer.write("}")
                printer.nextLine()
            case .associatedValue, .namespace:
                break
            }

        case .const:
            switch enumDefinition.enumType {
            case .simple:
                printer.write("export const \(enumDefinition.name): {")
                printer.indent()
                for (index, enumCase) in enumDefinition.cases.enumerated() {
                    let caseName = enumCase.name.capitalizedFirstLetter
                    printer.write("readonly \(caseName): \(index);")
                }
                printer.unindent()
                printer.write("};")
                printer.write(
                    "export type \(enumDefinition.name) = typeof \(enumDefinition.name)[keyof typeof \(enumDefinition.name)];"
                )
                printer.nextLine()
            case .rawValue:
                printer.write("export const \(enumDefinition.name): {")
                printer.indent()
                for enumCase in enumDefinition.cases {
                    let caseName = enumCase.name.capitalizedFirstLetter
                    let rawValue = enumCase.rawValue ?? enumCase.name
                    let formattedValue = SwiftEnumRawType.formatValue(rawValue, rawType: enumDefinition.rawType ?? "")
                    printer.write("readonly \(caseName): \(formattedValue);")
                }
                printer.unindent()
                printer.write("};")
                printer.write(
                    "export type \(enumDefinition.name) = typeof \(enumDefinition.name)[keyof typeof \(enumDefinition.name)];"
                )
                printer.nextLine()
            case .associatedValue:
                printer.write("export const \(enumDefinition.name): {")
                printer.indent()
                printer.write("readonly Tag: {")
                printer.indent()
                for (index, enumCase) in enumDefinition.cases.enumerated() {
                    let caseName = enumCase.name.capitalizedFirstLetter
                    printer.write("readonly \(caseName): \(index);")
                }
                printer.unindent()
                printer.write("};")
                printer.unindent()
                printer.write("};")
                printer.nextLine()

                var unionParts: [String] = []
                for enumCase in enumDefinition.cases {
                    if enumCase.associatedValues.isEmpty {
                        unionParts.append(
                            "{ tag: typeof \(enumDefinition.name).Tag.\(enumCase.name.capitalizedFirstLetter) }"
                        )
                    } else {
                        var fields: [String] = [
                            "tag: typeof \(enumDefinition.name).Tag.\(enumCase.name.capitalizedFirstLetter)"
                        ]
                        for (associatedValueIndex, associatedValue) in enumCase.associatedValues.enumerated() {
                            let prop = associatedValue.label ?? "param\(associatedValueIndex)"
                            fields.append("\(prop): \(associatedValue.type.tsType)")
                        }
                        unionParts.append("{ \(fields.joined(separator: "; ")) }")
                    }
                }

                printer.write("export type \(enumDefinition.name) =")
                printer.write("  " + unionParts.joined(separator: " | "))
                printer.nextLine()
            case .namespace:
                break
            }
        }
        return printer.lines
    }
}

extension BridgeJSLink {

    func renderExportedFunction(function: ExportedFunction) throws -> (js: [String], dts: [String]) {
        let thunkBuilder = ExportedThunkBuilder(effects: function.effects)
        for param in function.parameters {
            try thunkBuilder.lowerParameter(param: param)
        }
        let returnExpr = try thunkBuilder.call(abiName: function.abiName, returnType: function.returnType)
        let funcLines = thunkBuilder.renderFunction(
            name: function.abiName,
            parameters: function.parameters,
            returnExpr: returnExpr,
            declarationPrefixKeyword: "function"
        )
        var dtsLines: [String] = []
        dtsLines.append(
            "\(function.name)\(renderTSSignature(parameters: function.parameters, returnType: function.returnType, effects: function.effects));"
        )

        return (funcLines, dtsLines)
    }

    func renderExportedClass(
        _ klass: ExportedClass
    ) throws -> (js: [String], dtsType: [String], dtsExportEntry: [String]) {
        var jsLines: [String] = []
        var dtsTypeLines: [String] = []
        var dtsExportEntryLines: [String] = []

        dtsTypeLines.append("export interface \(klass.name) extends SwiftHeapObject {")
        dtsExportEntryLines.append("\(klass.name): {")
        jsLines.append("class \(klass.name) extends SwiftHeapObject {")

        // Always add __construct and constructor methods for all classes
        var constructorLines: [String] = []
        constructorLines.append("static __construct(ptr) {")
        constructorLines.append(
            "return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_\(klass.name)_deinit, \(klass.name).prototype);"
                .indent(count: 4)
        )
        constructorLines.append("}")
        constructorLines.append("")
        jsLines.append(contentsOf: constructorLines.map { $0.indent(count: 4) })

        if let constructor: ExportedConstructor = klass.constructor {
            let thunkBuilder = ExportedThunkBuilder(effects: constructor.effects)
            for param in constructor.parameters {
                try thunkBuilder.lowerParameter(param: param)
            }
            var funcLines: [String] = []
            funcLines.append("")
            funcLines.append("constructor(\(constructor.parameters.map { $0.name }.joined(separator: ", "))) {")
            let returnExpr = thunkBuilder.callConstructor(abiName: constructor.abiName)
            funcLines.append(contentsOf: thunkBuilder.body.lines.map { $0.indent(count: 4) })
            funcLines.append(contentsOf: thunkBuilder.cleanupCode.lines.map { $0.indent(count: 4) })
            funcLines.append(contentsOf: thunkBuilder.checkExceptionLines().map { $0.indent(count: 4) })
            funcLines.append("return \(klass.name).__construct(\(returnExpr));".indent(count: 4))
            funcLines.append("}")
            jsLines.append(contentsOf: funcLines.map { $0.indent(count: 4) })

            dtsExportEntryLines.append(
                "new\(renderTSSignature(parameters: constructor.parameters, returnType: .swiftHeapObject(klass.name), effects: constructor.effects));"
                    .indent(count: 4)
            )
        }

        for method in klass.methods {
            let thunkBuilder = ExportedThunkBuilder(effects: method.effects)
            thunkBuilder.lowerSelf()
            for param in method.parameters {
                try thunkBuilder.lowerParameter(param: param)
            }
            let returnExpr = try thunkBuilder.call(abiName: method.abiName, returnType: method.returnType)
            jsLines.append(
                contentsOf: thunkBuilder.renderFunction(
                    name: method.name,
                    parameters: method.parameters,
                    returnExpr: returnExpr,
                    declarationPrefixKeyword: nil
                ).map { $0.indent(count: 4) }
            )
            dtsTypeLines.append(
                "\(method.name)\(renderTSSignature(parameters: method.parameters, returnType: method.returnType, effects: method.effects));"
                    .indent(count: 4)
            )
        }

        // Generate property getters and setters
        for property in klass.properties {
            // Generate getter
            let getterThunkBuilder = ExportedThunkBuilder(effects: Effects(isAsync: false, isThrows: false))
            getterThunkBuilder.lowerSelf()
            let getterReturnExpr = try getterThunkBuilder.call(
                abiName: property.getterAbiName(className: klass.name),
                returnType: property.type
            )
            jsLines.append(
                contentsOf: getterThunkBuilder.renderFunction(
                    name: property.name,
                    parameters: [],
                    returnExpr: getterReturnExpr,
                    declarationPrefixKeyword: "get"
                ).map { $0.indent(count: 4) }
            )

            // Generate setter if not readonly
            if !property.isReadonly {
                let setterThunkBuilder = ExportedThunkBuilder(effects: Effects(isAsync: false, isThrows: false))
                setterThunkBuilder.lowerSelf()
                try setterThunkBuilder.lowerParameter(
                    param: Parameter(label: "value", name: "value", type: property.type)
                )
                _ = try setterThunkBuilder.call(
                    abiName: property.setterAbiName(className: klass.name),
                    returnType: .void
                )
                jsLines.append(
                    contentsOf: setterThunkBuilder.renderFunction(
                        name: property.name,
                        parameters: [.init(label: nil, name: "value", type: property.type)],
                        returnExpr: nil,
                        declarationPrefixKeyword: "set"
                    ).map { $0.indent(count: 4) }
                )
            }

            // Add TypeScript property definition
            let readonly = property.isReadonly ? "readonly " : ""
            dtsTypeLines.append(
                "\(readonly)\(property.name): \(property.type.tsType);"
                    .indent(count: 4)
            )
        }

        jsLines.append("}")

        dtsTypeLines.append("}")
        dtsExportEntryLines.append("}")

        return (jsLines, dtsTypeLines, dtsExportEntryLines)
    }

    func renderGlobalNamespace(
        namespacedFunctions: [ExportedFunction],
        namespacedClasses: [ExportedClass],
        namespacedEnums: [ExportedEnum]
    ) -> [String] {
        var lines: [String] = []
        var uniqueNamespaces: [String] = []
        var seen = Set<String>()

        let functionNamespacePaths: Set<[String]> = Set(
            namespacedFunctions
                .compactMap { $0.namespace }
        )
        let classNamespacePaths: Set<[String]> = Set(
            namespacedClasses
                .compactMap { $0.namespace }
        )
        let enumNamespacePaths: Set<[String]> = Set(
            namespacedEnums
                .compactMap { $0.namespace }
        )

        let allNamespacePaths =
            functionNamespacePaths
            .union(classNamespacePaths)
            .union(enumNamespacePaths)

        allNamespacePaths.forEach { namespacePath in
            namespacePath.makeIterator().enumerated().forEach { (index, _) in
                let path = namespacePath[0...index].joined(separator: ".")
                if seen.insert(path).inserted {
                    uniqueNamespaces.append(path)
                }
            }
        }

        uniqueNamespaces.sorted().forEach { namespace in
            lines.append("if (typeof globalThis.\(namespace) === 'undefined') {")
            lines.append("globalThis.\(namespace) = {};".indent(count: 4))
            lines.append("}")
        }

        namespacedClasses.forEach { klass in
            let namespacePath: String = klass.namespace?.joined(separator: ".") ?? ""
            lines.append("globalThis.\(namespacePath).\(klass.name) = exports.\(klass.name);")
        }

        namespacedEnums.forEach { enumDefinition in
            if enumDefinition.enumType == .associatedValue {
                let namespacePath: String = enumDefinition.namespace?.joined(separator: ".") ?? ""
                lines.append("globalThis.\(namespacePath).\(enumDefinition.name) = exports.\(enumDefinition.name);")
            }
        }

        namespacedFunctions.forEach { function in
            let namespacePath: String = function.namespace?.joined(separator: ".") ?? ""
            lines.append("globalThis.\(namespacePath).\(function.name) = exports.\(function.name);")
        }

        return lines
    }

    class ImportedThunkBuilder {
        let body: CodeFragmentPrinter
        let scope: JSGlueVariableScope
        let cleanupCode: CodeFragmentPrinter
        var parameterNames: [String] = []
        var parameterForwardings: [String] = []

        init() {
            self.body = CodeFragmentPrinter()
            self.scope = JSGlueVariableScope()
            self.cleanupCode = CodeFragmentPrinter()
        }

        func liftSelf() {
            parameterNames.append("self")
        }

        func liftParameter(param: Parameter) throws {
            let liftingFragment = try IntrinsicJSFragment.liftParameter(type: param.type)
            assert(
                liftingFragment.parameters.count >= 1,
                "Lifting fragment should have at least one parameter to lift"
            )
            let valuesToLift: [String]
            if liftingFragment.parameters.count == 1 {
                parameterNames.append(param.name)
                valuesToLift = [scope.variable(param.name)]
            } else {
                valuesToLift = liftingFragment.parameters.map { scope.variable(param.name + $0.capitalizedFirstLetter) }
            }
            let liftedValues = liftingFragment.printCode(valuesToLift, scope, body, cleanupCode)
            assert(liftedValues.count == 1, "Lifting fragment should produce exactly one value")
            parameterForwardings.append(contentsOf: liftedValues)
        }

        func renderFunction(
            name: String,
            returnExpr: String?,
            returnType: BridgeType
        ) -> [String] {
            var funcLines: [String] = []
            funcLines.append(
                "function \(name)(\(parameterNames.joined(separator: ", "))) {"
            )
            funcLines.append("try {".indent(count: 4))
            funcLines.append(contentsOf: body.lines.map { $0.indent(count: 8) })
            if let returnExpr = returnExpr {
                funcLines.append("return \(returnExpr);".indent(count: 8))
            }
            funcLines.append("} catch (error) {".indent(count: 4))
            funcLines.append("setException(error);".indent(count: 8))
            if let abiReturnType = returnType.abiReturnType {
                funcLines.append("return \(abiReturnType.placeholderValue)".indent(count: 8))
            }
            funcLines.append("}".indent(count: 4))
            funcLines.append("}")
            return funcLines
        }

        func call(name: String, returnType: BridgeType) throws -> String? {
            return try self.call(calleeExpr: "imports.\(name)", returnType: returnType)
        }

        private func call(calleeExpr: String, returnType: BridgeType) throws -> String? {
            let callExpr = "\(calleeExpr)(\(parameterForwardings.joined(separator: ", ")))"
            return try self.call(callExpr: callExpr, returnType: returnType)
        }

        private func call(callExpr: String, returnType: BridgeType) throws -> String? {
            let loweringFragment = try IntrinsicJSFragment.lowerReturn(type: returnType)
            let returnExpr: String?
            if loweringFragment.parameters.count == 0 {
                body.write("\(callExpr);")
                returnExpr = nil
            } else {
                let resultVariable = scope.variable("ret")
                body.write("let \(resultVariable) = \(callExpr);")
                returnExpr = resultVariable
            }
            return try lowerReturnValue(
                returnType: returnType,
                returnExpr: returnExpr,
                loweringFragment: loweringFragment
            )
        }

        func callConstructor(name: String) throws -> String? {
            let call = "new imports.\(name)(\(parameterForwardings.joined(separator: ", ")))"
            let type: BridgeType = .jsObject(name)
            let loweringFragment = try IntrinsicJSFragment.lowerReturn(type: type)
            return try lowerReturnValue(returnType: type, returnExpr: call, loweringFragment: loweringFragment)
        }

        func callMethod(name: String, returnType: BridgeType) throws -> String? {
            return try call(
                calleeExpr: "\(JSGlueVariableScope.reservedSwift).memory.getObject(self).\(name)",
                returnType: returnType
            )
        }

        func callPropertyGetter(name: String, returnType: BridgeType) throws -> String? {
            return try call(
                callExpr: "\(JSGlueVariableScope.reservedSwift).memory.getObject(self).\(name)",
                returnType: returnType
            )
        }

        func callPropertySetter(name: String, returnType: BridgeType) {
            let call =
                "\(JSGlueVariableScope.reservedSwift).memory.getObject(self).\(name) = \(parameterForwardings.joined(separator: ", "))"
            body.write("\(call);")
        }

        private func lowerReturnValue(
            returnType: BridgeType,
            returnExpr: String?,
            loweringFragment: IntrinsicJSFragment
        ) throws -> String? {
            assert(loweringFragment.parameters.count <= 1, "Lowering fragment should have at most one parameter")
            let loweredValues = loweringFragment.printCode(returnExpr.map { [$0] } ?? [], scope, body, cleanupCode)
            assert(loweredValues.count <= 1, "Lowering fragment should produce at most one value")
            return loweredValues.first
        }
    }

    class ImportObjectBuilder {
        var moduleName: String
        var importedLines: [String] = []
        var dtsImportLines: [String] = []

        init(moduleName: String) {
            self.moduleName = moduleName
            importedLines.append(
                "const \(moduleName) = importObject[\"\(moduleName)\"] = importObject[\"\(moduleName)\"] || {};"
            )
        }

        func assignToImportObject(name: String, function: [String]) {
            var js = function
            js[0] = "\(moduleName)[\"\(name)\"] = " + js[0]
            importedLines.append(contentsOf: js)
        }

        func appendDts(_ lines: [String]) {
            dtsImportLines.append(contentsOf: lines)
        }
    }

    struct NamespaceBuilder {

        /// Generates JavaScript code for setting up global namespace structure
        ///
        /// This function creates the necessary JavaScript code to properly expose namespaced
        /// functions, classes, and enums on the global object (globalThis). It ensures that
        /// nested namespace paths are created correctly and that all exported items are
        /// accessible through their full namespace paths.
        ///
        /// For example, if you have @JS("Utils.Math") func add() it will generate code that
        /// makes globalThis.Utils.Math.add accessible.
        ///
        /// - Parameters:
        ///   - namespacedFunctions: Functions annotated with @JS("namespace.path")
        ///   - namespacedClasses: Classes annotated with @JS("namespace.path")
        ///   - namespacedEnums: Enums annotated with @JS("namespace.path")
        /// - Returns: Array of JavaScript code lines that set up the global namespace structure
        func renderGlobalNamespace(
            namespacedFunctions: [ExportedFunction],
            namespacedClasses: [ExportedClass]
        ) -> [String] {
            let printer = CodeFragmentPrinter()
            var uniqueNamespaces: [String] = []
            var seen = Set<String>()

            let functionNamespacePaths: Set<[String]> = Set(
                namespacedFunctions
                    .compactMap { $0.namespace }
            )
            let classNamespacePaths: Set<[String]> = Set(
                namespacedClasses
                    .compactMap { $0.namespace }
            )

            let allNamespacePaths =
                functionNamespacePaths
                .union(classNamespacePaths)

            allNamespacePaths.forEach { namespacePath in
                namespacePath.makeIterator().enumerated().forEach { (index, _) in
                    let path = namespacePath[0...index].joined(separator: ".")
                    if seen.insert(path).inserted {
                        uniqueNamespaces.append(path)
                    }
                }
            }

            uniqueNamespaces.sorted().forEach { namespace in
                printer.write("if (typeof globalThis.\(namespace) === 'undefined') {")
                printer.indent()
                printer.write("globalThis.\(namespace) = {};")
                printer.unindent()
                printer.write("}")
            }

            namespacedClasses.forEach { klass in
                let namespacePath: String = klass.namespace?.joined(separator: ".") ?? ""
                printer.write("globalThis.\(namespacePath).\(klass.name) = exports.\(klass.name);")
            }

            namespacedFunctions.forEach { function in
                let namespacePath: String = function.namespace?.joined(separator: ".") ?? ""
                printer.write("globalThis.\(namespacePath).\(function.name) = exports.\(function.name);")
            }

            return printer.lines
        }

        func renderTopLevelEnumNamespaceAssignments(namespacedEnums: [ExportedEnum]) -> [String] {
            guard !namespacedEnums.isEmpty else { return [] }

            let printer = CodeFragmentPrinter()
            var uniqueNamespaces: [String] = []
            var seen = Set<String>()

            for enumDef in namespacedEnums {
                guard let namespacePath = enumDef.namespace else { continue }
                namespacePath.enumerated().forEach { (index, _) in
                    let path = namespacePath[0...index].joined(separator: ".")
                    if !seen.contains(path) {
                        seen.insert(path)
                        uniqueNamespaces.append(path)
                    }
                }
            }

            for namespace in uniqueNamespaces {
                printer.write("if (typeof globalThis.\(namespace) === 'undefined') {")
                printer.indent()
                printer.write("globalThis.\(namespace) = {};")
                printer.unindent()
                printer.write("}")
            }

            if !uniqueNamespaces.isEmpty {
                printer.nextLine()
            }

            for enumDef in namespacedEnums {
                let namespacePath = enumDef.namespace?.joined(separator: ".") ?? ""
                printer.write("globalThis.\(namespacePath).\(enumDef.name) = \(enumDef.name);")
            }

            return printer.lines
        }

        private struct NamespaceContent {
            var functions: [ExportedFunction] = []
            var classes: [ExportedClass] = []
            var enums: [ExportedEnum] = []
        }

        private final class NamespaceNode {
            let name: String
            var children: [String: NamespaceNode] = [:]
            var content: NamespaceContent = NamespaceContent()

            init(name: String) {
                self.name = name
            }

            func addChild(_ childName: String) -> NamespaceNode {
                if let existing = children[childName] {
                    return existing
                }
                let newChild = NamespaceNode(name: childName)
                children[childName] = newChild
                return newChild
            }
        }

        /// Generates TypeScript declarations for all namespaces
        ///
        /// This function enables properly grouping all Swift code within given namespaces
        /// regardless of location in Swift input files. It uses a tree-based structure to
        /// properly create unique namespace declarations that avoid namespace duplication in TS and generate
        /// predictable declarations in sorted order.
        ///
        /// The function collects all namespaced items (functions, classes, enums) from the
        /// exported skeletons and builds a hierarchical namespace tree. It then traverses
        /// this tree to generate TypeScript namespace declarations that mirror the Swift
        /// namespace structure.
        /// - Parameters:
        ///   - exportedSkeletons: Exported Swift structures to generate namespaces for
        ///   - renderTSSignatureCallback: closure to generate TS signature that aligns with rest of codebase
        /// - Returns: Array of TypeScript declaration lines defining the global namespace structure
        func namespaceDeclarations(
            exportedSkeletons: [ExportedSkeleton],
            renderTSSignatureCallback: @escaping ([Parameter], BridgeType, Effects) -> String
        ) -> [String] {
            let printer = CodeFragmentPrinter()

            let rootNode = NamespaceNode(name: "")

            for skeleton in exportedSkeletons {
                for function in skeleton.functions {
                    if let namespace = function.namespace {
                        var currentNode = rootNode
                        for part in namespace {
                            currentNode = currentNode.addChild(part)
                        }
                        currentNode.content.functions.append(function)
                    }
                }

                for klass in skeleton.classes {
                    if let classNamespace = klass.namespace {
                        var currentNode = rootNode
                        for part in classNamespace {
                            currentNode = currentNode.addChild(part)
                        }
                        currentNode.content.classes.append(klass)
                    }
                }

                for enumDefinition in skeleton.enums {
                    if let enumNamespace = enumDefinition.namespace, enumDefinition.enumType != .namespace {
                        var currentNode = rootNode
                        for part in enumNamespace {
                            currentNode = currentNode.addChild(part)
                        }
                        currentNode.content.enums.append(enumDefinition)
                    }
                }
            }

            guard !rootNode.children.isEmpty else {
                return printer.lines
            }

            printer.write("export {};")
            printer.nextLine()
            printer.write("declare global {")
            printer.indent()

            func generateNamespaceDeclarations(node: NamespaceNode, depth: Int) {
                let sortedChildren = node.children.sorted { $0.key < $1.key }

                for (childName, childNode) in sortedChildren {
                    printer.write("namespace \(childName) {")
                    printer.indent()

                    let sortedClasses = childNode.content.classes.sorted { $0.name < $1.name }
                    for klass in sortedClasses {
                        printer.write("class \(klass.name) {")
                        printer.indent()

                        if let constructor = klass.constructor {
                            let constructorSignature =
                                "constructor(\(constructor.parameters.map { "\($0.name): \($0.type.tsType)" }.joined(separator: ", ")));"
                            printer.write(constructorSignature)
                        }

                        let sortedMethods = klass.methods.sorted { $0.name < $1.name }
                        for method in sortedMethods {
                            let methodSignature =
                                "\(method.name)\(renderTSSignatureCallback(method.parameters, method.returnType, method.effects));"
                            printer.write(methodSignature)
                        }

                        printer.unindent()
                        printer.write("}")
                    }

                    let sortedEnums = childNode.content.enums.sorted { $0.name < $1.name }
                    for enumDefinition in sortedEnums {
                        let style: EnumEmitStyle = enumDefinition.emitStyle
                        switch enumDefinition.enumType {
                        case .simple:
                            switch style {
                            case .tsEnum:
                                printer.write("enum \(enumDefinition.name) {")
                                printer.indent()
                                for (index, enumCase) in enumDefinition.cases.enumerated() {
                                    let caseName = enumCase.name.capitalizedFirstLetter
                                    printer.write("\(caseName) = \(index),")
                                }
                                printer.unindent()
                                printer.write("}")
                            case .const:
                                printer.write("const \(enumDefinition.name): {")
                                printer.indent()
                                for (index, enumCase) in enumDefinition.cases.enumerated() {
                                    let caseName = enumCase.name.capitalizedFirstLetter
                                    printer.write("readonly \(caseName): \(index);")
                                }
                                printer.unindent()
                                printer.write("};")
                                printer.write(
                                    "type \(enumDefinition.name) = typeof \(enumDefinition.name)[keyof typeof \(enumDefinition.name)];"
                                )
                            }
                        case .rawValue:
                            guard let rawType = enumDefinition.rawType else { continue }
                            switch style {
                            case .tsEnum:
                                printer.write("enum \(enumDefinition.name) {")
                                printer.indent()
                                for enumCase in enumDefinition.cases {
                                    let caseName = enumCase.name.capitalizedFirstLetter
                                    let rawValue = enumCase.rawValue ?? enumCase.name
                                    let formattedValue: String
                                    switch rawType {
                                    case "String": formattedValue = "\"\(rawValue)\""
                                    case "Bool": formattedValue = rawValue.lowercased() == "true" ? "true" : "false"
                                    case "Float", "Double": formattedValue = rawValue
                                    default: formattedValue = rawValue
                                    }
                                    printer.write("\(caseName) = \(formattedValue),")
                                }
                                printer.unindent()
                                printer.write("}")
                            case .const:
                                printer.write("const \(enumDefinition.name): {")
                                printer.indent()
                                for enumCase in enumDefinition.cases {
                                    let caseName = enumCase.name.capitalizedFirstLetter
                                    let rawValue = enumCase.rawValue ?? enumCase.name
                                    let formattedValue: String
                                    switch rawType {
                                    case "String": formattedValue = "\"\(rawValue)\""
                                    case "Bool": formattedValue = rawValue.lowercased() == "true" ? "true" : "false"
                                    case "Float", "Double": formattedValue = rawValue
                                    default: formattedValue = rawValue
                                    }
                                    printer.write("readonly \(caseName): \(formattedValue);")
                                }
                                printer.unindent()
                                printer.write("};")
                                printer.write(
                                    "type \(enumDefinition.name) = typeof \(enumDefinition.name)[keyof typeof \(enumDefinition.name)];"
                                )
                            }
                        case .associatedValue:
                            printer.write("const \(enumDefinition.name): {")
                            printer.indent()
                            printer.write("readonly Tag: {")
                            printer.indent()
                            for (caseIndex, enumCase) in enumDefinition.cases.enumerated() {
                                let caseName = enumCase.name.capitalizedFirstLetter
                                printer.write("readonly \(caseName): \(caseIndex);")
                            }
                            printer.unindent()
                            printer.write("};")
                            printer.unindent()
                            printer.write("};")

                            var unionParts: [String] = []
                            for enumCase in enumDefinition.cases {
                                if enumCase.associatedValues.isEmpty {
                                    unionParts.append(
                                        "{ tag: typeof \(enumDefinition.name).Tag.\(enumCase.name.capitalizedFirstLetter) }"
                                    )
                                } else {
                                    var fields: [String] = [
                                        "tag: typeof \(enumDefinition.name).Tag.\(enumCase.name.capitalizedFirstLetter)"
                                    ]
                                    for (associatedValueIndex, associatedValue) in enumCase.associatedValues
                                        .enumerated()
                                    {
                                        let prop = associatedValue.label ?? "param\(associatedValueIndex)"
                                        fields.append("\(prop): \(associatedValue.type.tsType)")
                                    }
                                    unionParts.append("{ \(fields.joined(separator: "; ")) }")
                                }
                            }
                            printer.write("type \(enumDefinition.name) =")
                            printer.write("  " + unionParts.joined(separator: " | "))
                        case .namespace:
                            continue
                        }
                    }

                    let sortedFunctions = childNode.content.functions.sorted { $0.name < $1.name }
                    for function in sortedFunctions {
                        let signature =
                            "\(function.name)\(renderTSSignatureCallback(function.parameters, function.returnType, function.effects));"
                        printer.write(signature)
                    }

                    generateNamespaceDeclarations(node: childNode, depth: depth + 1)

                    printer.unindent()
                    printer.write("}")
                }
            }

            generateNamespaceDeclarations(node: rootNode, depth: 1)

            printer.unindent()
            printer.write("}")
            printer.nextLine()

            return printer.lines
        }
    }

    func renderImportedFunction(
        importObjectBuilder: ImportObjectBuilder,
        function: ImportedFunctionSkeleton
    ) throws {
        let thunkBuilder = ImportedThunkBuilder()
        for param in function.parameters {
            try thunkBuilder.liftParameter(param: param)
        }
        let returnExpr = try thunkBuilder.call(name: function.name, returnType: function.returnType)
        let funcLines = thunkBuilder.renderFunction(
            name: function.abiName(context: nil),
            returnExpr: returnExpr,
            returnType: function.returnType
        )
        let effects = Effects(isAsync: false, isThrows: false)
        importObjectBuilder.appendDts(
            [
                "\(function.name)\(renderTSSignature(parameters: function.parameters, returnType: function.returnType, effects: effects));"
            ]
        )
        importObjectBuilder.assignToImportObject(name: function.abiName(context: nil), function: funcLines)
    }

    func renderImportedType(
        importObjectBuilder: ImportObjectBuilder,
        type: ImportedTypeSkeleton
    ) throws {
        if let constructor = type.constructor {
            try renderImportedConstructor(
                importObjectBuilder: importObjectBuilder,
                type: type,
                constructor: constructor
            )
        }
        for property in type.properties {
            let getterAbiName = property.getterAbiName(context: type)
            let (js, dts) = try renderImportedProperty(
                property: property,
                abiName: getterAbiName,
                emitCall: { thunkBuilder in
                    return try thunkBuilder.callPropertyGetter(name: property.name, returnType: property.type)
                }
            )
            importObjectBuilder.assignToImportObject(name: getterAbiName, function: js)
            importObjectBuilder.appendDts(dts)

            if !property.isReadonly {
                let setterAbiName = property.setterAbiName(context: type)
                let (js, dts) = try renderImportedProperty(
                    property: property,
                    abiName: setterAbiName,
                    emitCall: { thunkBuilder in
                        try thunkBuilder.liftParameter(
                            param: Parameter(label: nil, name: "newValue", type: property.type)
                        )
                        thunkBuilder.callPropertySetter(name: property.name, returnType: property.type)
                        return nil
                    }
                )
                importObjectBuilder.assignToImportObject(name: setterAbiName, function: js)
                importObjectBuilder.appendDts(dts)
            }
        }
        for method in type.methods {
            let (js, dts) = try renderImportedMethod(context: type, method: method)
            importObjectBuilder.assignToImportObject(name: method.abiName(context: type), function: js)
            importObjectBuilder.appendDts(dts)
        }
    }

    func renderImportedConstructor(
        importObjectBuilder: ImportObjectBuilder,
        type: ImportedTypeSkeleton,
        constructor: ImportedConstructorSkeleton
    ) throws {
        let thunkBuilder = ImportedThunkBuilder()
        for param in constructor.parameters {
            try thunkBuilder.liftParameter(param: param)
        }
        let returnType = BridgeType.jsObject(type.name)
        let returnExpr = try thunkBuilder.callConstructor(name: type.name)
        let abiName = constructor.abiName(context: type)
        let funcLines = thunkBuilder.renderFunction(
            name: abiName,
            returnExpr: returnExpr,
            returnType: returnType
        )
        importObjectBuilder.assignToImportObject(name: abiName, function: funcLines)
        importObjectBuilder.appendDts([
            "\(type.name): {",
            "new\(renderTSSignature(parameters: constructor.parameters, returnType: returnType, effects: Effects(isAsync: false, isThrows: false)));"
                .indent(count: 4),
            "}",
        ])
    }

    func renderImportedProperty(
        property: ImportedPropertySkeleton,
        abiName: String,
        emitCall: (ImportedThunkBuilder) throws -> String?
    ) throws -> (js: [String], dts: [String]) {
        let thunkBuilder = ImportedThunkBuilder()
        thunkBuilder.liftSelf()
        let returnExpr = try emitCall(thunkBuilder)
        let funcLines = thunkBuilder.renderFunction(
            name: abiName,
            returnExpr: returnExpr,
            returnType: property.type
        )
        return (funcLines, [])
    }

    func renderImportedMethod(
        context: ImportedTypeSkeleton,
        method: ImportedFunctionSkeleton
    ) throws -> (js: [String], dts: [String]) {
        let thunkBuilder = ImportedThunkBuilder()
        thunkBuilder.liftSelf()
        for param in method.parameters {
            try thunkBuilder.liftParameter(param: param)
        }
        let returnExpr = try thunkBuilder.callMethod(name: method.name, returnType: method.returnType)
        let funcLines = thunkBuilder.renderFunction(
            name: method.abiName(context: context),
            returnExpr: returnExpr,
            returnType: method.returnType
        )
        return (funcLines, [])
    }
}

struct BridgeJSLinkError: Error {
    let message: String
}

extension String {
    func indent(count: Int) -> String {
        return String(repeating: " ", count: count) + self
    }
}

extension BridgeType {
    var tsType: String {
        switch self {
        case .void:
            return "void"
        case .string:
            return "string"
        case .int:
            return "number"
        case .float:
            return "number"
        case .double:
            return "number"
        case .bool:
            return "boolean"
        case .jsObject(let name):
            return name ?? "any"
        case .swiftHeapObject(let name):
            return name
        case .caseEnum(let name):
            return name
        case .rawValueEnum(let name, _):
            return name
        case .associatedValueEnum(let name):
            return name
        case .namespaceEnum(let name):
            return name
        }
    }
}

extension WasmCoreType {
    fileprivate var placeholderValue: String {
        switch self {
        case .i32, .i64, .f32, .f64, .pointer: return "0"
        }
    }
}
