import class Foundation.JSONDecoder
import struct Foundation.Data
#if canImport(BridgeJSSkeleton)
import BridgeJSSkeleton
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

    func link() throws -> (outputJs: String, outputDts: String) {
        var exportsLines: [String] = []
        var classLines: [String] = []
        var dtsExportLines: [String] = []
        var dtsClassLines: [String] = []
        var namespacedFunctions: [ExportedFunction] = []
        var namespacedClasses: [ExportedClass] = []
        var namespacedEnums: [ExportedEnum] = []
        var enumConstantLines: [String] = []
        var dtsEnumLines: [String] = []
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
                let (jsType, dtsType, dtsExportEntry) = renderExportedClass(klass)
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
                        enumConstantLines.append(contentsOf: jsEnum)
                        exportsLines.append("\(enumDefinition.name),")
                        if enumDefinition.namespace != nil {
                            namespacedEnums.append(enumDefinition)
                        }
                        dtsEnumLines.append(contentsOf: dtsEnum)
                    }
                }
            }

            for function in skeleton.functions {
                var (js, dts) = renderExportedFunction(function: function)

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

        let hasNamespacedItems = !namespacedFunctions.isEmpty || !namespacedClasses.isEmpty || !namespacedEnums.isEmpty

        let namespaceBuilder = NamespaceBuilder()
        let namespaceDeclarationsLines = namespaceBuilder.namespaceDeclarations(
            exportedSkeletons: exportedSkeletons,
            renderTSSignatureCallback: { parameters, returnType, effects in
                self.renderTSSignature(parameters: parameters, returnType: returnType, effects: effects)
            }
        )

        let exportsSection: String
        if hasNamespacedItems {
            let namespacedEnumsForExports = namespacedEnums.filter { $0.enumType == .associatedValue }
            let namespaceSetupCode = namespaceBuilder.renderGlobalNamespace(
                namespacedFunctions: namespacedFunctions,
                namespacedClasses: namespacedClasses,
                namespacedEnums: namespacedEnumsForExports
            )
            .map { $0.indent(count: 12) }.joined(separator: "\n")

            let enumSection =
                enumConstantLines.isEmpty
                ? "" : enumConstantLines.map { $0.indent(count: 12) }.joined(separator: "\n") + "\n"

            exportsSection = """
                \(classLines.map { $0.indent(count: 12) }.joined(separator: "\n"))
                \(enumSection)\("const exports = {".indent(count: 12))
                \(exportsLines.map { $0.indent(count: 16) }.joined(separator: "\n"))
                \("};".indent(count: 12))

                \(namespaceSetupCode)

                \("return exports;".indent(count: 12))
                        },
                """
        } else {
            let enumSection =
                enumConstantLines.isEmpty
                ? "" : enumConstantLines.map { $0.indent(count: 12) }.joined(separator: "\n") + "\n"

            exportsSection = """
                \(classLines.map { $0.indent(count: 12) }.joined(separator: "\n"))
                \(enumSection)\("return {".indent(count: 12))
                \(exportsLines.map { $0.indent(count: 16) }.joined(separator: "\n"))
                \("};".indent(count: 12))
                        },
                """
        }

        let topLevelEnumsSection = topLevelEnumLines.isEmpty ? "" : topLevelEnumLines.joined(separator: "\n") + "\n\n"

        let topLevelNamespaceCode = namespaceBuilder.renderTopLevelEnumNamespaceAssignments(
            namespacedEnums: namespacedEnums
        )
        let namespaceAssignmentsSection =
            topLevelNamespaceCode.isEmpty ? "" : topLevelNamespaceCode.joined(separator: "\n") + "\n\n"

        let outputJs = """
            // NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
            // DO NOT EDIT.
            //
            // To update this file, just rebuild your project or run
            // `swift package bridge-js`.

            \(topLevelEnumsSection)\(namespaceAssignmentsSection)export async function createInstantiator(options, swift) {
                let instance;
                let memory;
                let setException;
                const textDecoder = new TextDecoder("utf-8");
                const textEncoder = new TextEncoder("utf-8");

                let tmpRetString;
                let tmpRetBytes;
                let tmpRetException;
                return {
                    /**
                     * @param {WebAssembly.Imports} importObject
                     */
                    addImports: (importObject, importsContext) => {
                        const bjs = {};
                        importObject["bjs"] = bjs;
                        const imports = options.getImports(importsContext);
                        bjs["swift_js_return_string"] = function(ptr, len) {
                            const bytes = new Uint8Array(memory.buffer, ptr, len)\(sharedMemory ? ".slice()" : "");
                            tmpRetString = textDecoder.decode(bytes);
                        }
                        bjs["swift_js_init_memory"] = function(sourceId, bytesPtr) {
                            const source = swift.memory.getObject(sourceId);
                            const bytes = new Uint8Array(memory.buffer, bytesPtr);
                            bytes.set(source);
                        }
                        bjs["swift_js_make_js_string"] = function(ptr, len) {
                            const bytes = new Uint8Array(memory.buffer, ptr, len)\(sharedMemory ? ".slice()" : "");
                            return swift.memory.retain(textDecoder.decode(bytes));
                        }
                        bjs["swift_js_init_memory_with_result"] = function(ptr, len) {
                            const target = new Uint8Array(memory.buffer, ptr, len);
                            target.set(tmpRetBytes);
                            tmpRetBytes = undefined;
                        }
                        bjs["swift_js_throw"] = function(id) {
                            tmpRetException = swift.memory.retainByRef(id);
                        }
                        bjs["swift_js_retain"] = function(id) {
                            return swift.memory.retainByRef(id);
                        }
                        bjs["swift_js_release"] = function(id) {
                            swift.memory.release(id);
                        }
            \(renderSwiftClassWrappers().map { $0.indent(count: 12) }.joined(separator: "\n"))
            \(importObjectBuilders.flatMap { $0.importedLines }.map { $0.indent(count: 12) }.joined(separator: "\n"))
                    },
                    setInstance: (i) => {
                        instance = i;
                        memory = instance.exports.memory;
                        setException = (error) => {
                            instance.exports._swift_js_exception.value = swift.memory.retain(error)
                        }
                    },
                    /** @param {WebAssembly.Instance} instance */
                    createExports: (instance) => {
                        const js = swift.memory.heap;
            \(exportsSection)
                }
            }
            """

        var dtsLines: [String] = []
        dtsLines.append(contentsOf: namespaceDeclarationsLines)
        dtsLines.append(contentsOf: dtsClassLines)
        dtsLines.append(contentsOf: dtsEnumLines)
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
                wrapperLines.append("    return swift.memory.retain(obj);")
                wrapperLines.append("};")
            }
        }

        return wrapperLines
    }

    private func generateImportedTypeDefinitions() -> [String] {
        var typeDefinitions: [String] = []

        for skeletonSet in importedSkeletons {
            for fileSkeleton in skeletonSet.children {
                for type in fileSkeleton.types {
                    typeDefinitions.append("export interface \(type.name) {")

                    // Add methods
                    for method in type.methods {
                        let methodSignature =
                            "\(method.name)\(renderTSSignature(parameters: method.parameters, returnType: method.returnType, effects: Effects(isAsync: false, isThrows: false)));"
                        typeDefinitions.append(methodSignature.indent(count: 4))
                    }

                    // Add properties
                    for property in type.properties {
                        let propertySignature =
                            property.isReadonly
                            ? "readonly \(property.name): \(property.type.tsType);"
                            : "\(property.name): \(property.type.tsType);"
                        typeDefinitions.append(propertySignature.indent(count: 4))
                    }

                    typeDefinitions.append("}")
                }
            }
        }

        return typeDefinitions
    }

    class ExportedThunkBuilder {
        var bodyLines: [String] = []
        var cleanupLines: [String] = []
        var parameterForwardings: [String] = []
        let effects: Effects

        init(effects: Effects) {
            self.effects = effects
        }

        func lowerParameter(param: Parameter) {
            switch param.type {
            case .void: return
            case .int, .float, .double, .bool:
                parameterForwardings.append(param.name)
            case .string:
                let bytesLabel = "\(param.name)Bytes"
                let bytesIdLabel = "\(param.name)Id"
                bodyLines.append("const \(bytesLabel) = textEncoder.encode(\(param.name));")
                bodyLines.append("const \(bytesIdLabel) = swift.memory.retain(\(bytesLabel));")
                cleanupLines.append("swift.memory.release(\(bytesIdLabel));")
                parameterForwardings.append(bytesIdLabel)
                parameterForwardings.append("\(bytesLabel).length")
            case .caseEnum(_):
                parameterForwardings.append("\(param.name) | 0")
            case .rawValueEnum(_, let rawType):
                switch rawType {
                case .string:
                    let bytesLabel = "\(param.name)Bytes"
                    let bytesIdLabel = "\(param.name)Id"
                    bodyLines.append("const \(bytesLabel) = textEncoder.encode(\(param.name));")
                    bodyLines.append("const \(bytesIdLabel) = swift.memory.retain(\(bytesLabel));")
                    cleanupLines.append("swift.memory.release(\(bytesIdLabel));")
                    parameterForwardings.append(bytesIdLabel)
                    parameterForwardings.append("\(bytesLabel).length")
                case .bool:
                    parameterForwardings.append("\(param.name) ? 1 : 0")
                default:
                    parameterForwardings.append("\(param.name)")
                }
            case .associatedValueEnum:
                parameterForwardings.append("0")
                parameterForwardings.append("0")
            case .namespaceEnum:
                break
            case .jsObject:
                parameterForwardings.append("swift.memory.retain(\(param.name))")
            case .swiftHeapObject:
                parameterForwardings.append("\(param.name).pointer")
            }
        }

        func lowerSelf() {
            parameterForwardings.append("this.pointer")
        }

        func call(abiName: String, returnType: BridgeType) -> String? {
            if effects.isAsync {
                return _call(abiName: abiName, returnType: .jsObject(nil))
            } else {
                return _call(abiName: abiName, returnType: returnType)
            }
        }

        private func _call(abiName: String, returnType: BridgeType) -> String? {
            let call = "instance.exports.\(abiName)(\(parameterForwardings.joined(separator: ", ")))"
            var returnExpr: String?

            switch returnType {
            case .void:
                bodyLines.append("\(call);")
            case .string:
                bodyLines.append("\(call);")
                bodyLines.append("const ret = tmpRetString;")
                bodyLines.append("tmpRetString = undefined;")
                returnExpr = "ret"
            case .caseEnum(_):
                bodyLines.append("const ret = \(call);")
                returnExpr = "ret"
            case .rawValueEnum(_, let rawType):
                switch rawType {
                case .string:
                    bodyLines.append("\(call);")
                    bodyLines.append("const ret = tmpRetString;")
                    bodyLines.append("tmpRetString = undefined;")
                    returnExpr = "ret"
                case .bool:
                    bodyLines.append("const ret = \(call);")
                    returnExpr = "ret !== 0"
                default:
                    bodyLines.append("const ret = \(call);")
                    returnExpr = "ret"
                }
            case .associatedValueEnum:
                bodyLines.append("\(call);")
                returnExpr = "\"\""
            case .namespaceEnum:
                break
            case .int, .float, .double:
                bodyLines.append("const ret = \(call);")
                returnExpr = "ret"
            case .bool:
                bodyLines.append("const ret = \(call) !== 0;")
                returnExpr = "ret"
            case .jsObject:
                bodyLines.append("const retId = \(call);")
                // TODO: Implement "take" operation
                bodyLines.append("const ret = swift.memory.getObject(retId);")
                bodyLines.append("swift.memory.release(retId);")
                returnExpr = "ret"
            case .swiftHeapObject(let name):
                bodyLines.append("const ret = \(name).__construct(\(call));")
                returnExpr = "ret"
            }
            return returnExpr
        }

        func callConstructor(abiName: String) -> String {
            let call = "instance.exports.\(abiName)(\(parameterForwardings.joined(separator: ", ")))"
            bodyLines.append("const ret = \(call);")
            return "ret"
        }

        func checkExceptionLines() -> [String] {
            guard effects.isThrows else {
                return []
            }
            return [
                "if (tmpRetException) {",
                // TODO: Implement "take" operation
                "    const error = swift.memory.getObject(tmpRetException);",
                "    swift.memory.release(tmpRetException);",
                "    tmpRetException = undefined;",
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
            funcLines.append(contentsOf: bodyLines.map { $0.indent(count: 4) })
            funcLines.append(contentsOf: cleanupLines.map { $0.indent(count: 4) })
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
        let style: EnumEmitStyle = enumDefinition.emitStyle

        switch enumDefinition.enumType {
        case .simple:
            jsLines.append("const \(enumDefinition.name) = {")
            for (index, enumCase) in enumDefinition.cases.enumerated() {
                let caseName = enumCase.name.capitalizedFirstLetter
                jsLines.append("\(caseName): \(index),".indent(count: 4))
            }
            jsLines.append("};")
            jsLines.append("")

            if enumDefinition.namespace == nil {
                switch style {
                case .tsEnum:
                    dtsLines.append("export enum \(enumDefinition.name) {")
                    for (index, enumCase) in enumDefinition.cases.enumerated() {
                        let caseName = enumCase.name.capitalizedFirstLetter
                        dtsLines.append("\(caseName) = \(index),".indent(count: 4))
                    }
                    dtsLines.append("}")
                    dtsLines.append("")
                case .const:
                    dtsLines.append("export const \(enumDefinition.name): {")
                    for (index, enumCase) in enumDefinition.cases.enumerated() {
                        let caseName = enumCase.name.capitalizedFirstLetter
                        dtsLines.append("readonly \(caseName): \(index);".indent(count: 4))
                    }
                    dtsLines.append("};")
                    dtsLines.append(
                        "export type \(enumDefinition.name) = typeof \(enumDefinition.name)[keyof typeof \(enumDefinition.name)];"
                    )
                    dtsLines.append("")
                }
            }
        case .rawValue:
            guard let rawType = enumDefinition.rawType else {
                throw BridgeJSLinkError(message: "Raw value enum \(enumDefinition.name) is missing rawType")
            }

            jsLines.append("const \(enumDefinition.name) = {")
            for enumCase in enumDefinition.cases {
                let caseName = enumCase.name.capitalizedFirstLetter
                let rawValue = enumCase.rawValue ?? enumCase.name
                let formattedValue: String

                if let rawTypeEnum = SwiftEnumRawType.from(rawType) {
                    switch rawTypeEnum {
                    case .string:
                        formattedValue = "\"\(rawValue)\""
                    case .bool:
                        formattedValue = rawValue.lowercased() == "true" ? "true" : "false"
                    case .float, .double:
                        formattedValue = rawValue
                    default:
                        formattedValue = rawValue
                    }
                } else {
                    formattedValue = rawValue
                }

                jsLines.append("\(caseName): \(formattedValue),".indent(count: 4))
            }
            jsLines.append("};")
            jsLines.append("")

            if enumDefinition.namespace == nil {
                switch style {
                case .tsEnum:
                    dtsLines.append("export enum \(enumDefinition.name) {")
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
                        dtsLines.append("\(caseName) = \(formattedValue),".indent(count: 4))
                    }
                    dtsLines.append("}")
                    dtsLines.append("")
                case .const:
                    dtsLines.append("export const \(enumDefinition.name): {")
                    for enumCase in enumDefinition.cases {
                        let caseName = enumCase.name.capitalizedFirstLetter
                        let rawValue = enumCase.rawValue ?? enumCase.name
                        let formattedValue: String

                        switch rawType {
                        case "String":
                            formattedValue = "\"\(rawValue)\""
                        case "Bool":
                            formattedValue = rawValue.lowercased() == "true" ? "true" : "false"
                        case "Float", "Double":
                            formattedValue = rawValue
                        default:
                            formattedValue = rawValue
                        }

                        dtsLines.append("readonly \(caseName): \(formattedValue);".indent(count: 4))
                    }
                    dtsLines.append("};")
                    dtsLines.append(
                        "export type \(enumDefinition.name) = typeof \(enumDefinition.name)[keyof typeof \(enumDefinition.name)];"
                    )
                    dtsLines.append("")
                }
            }

        case .associatedValue:
            jsLines.append("// TODO: Implement \(enumDefinition.enumType) enum: \(enumDefinition.name)")
            dtsLines.append("// TODO: Implement \(enumDefinition.enumType) enum: \(enumDefinition.name)")
        case .namespace:
            break
        }

        return (jsLines, dtsLines)
    }

    func renderExportedFunction(function: ExportedFunction) -> (js: [String], dts: [String]) {
        let thunkBuilder = ExportedThunkBuilder(effects: function.effects)
        for param in function.parameters {
            thunkBuilder.lowerParameter(param: param)
        }
        let returnExpr = thunkBuilder.call(abiName: function.abiName, returnType: function.returnType)
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

    func renderExportedClass(_ klass: ExportedClass) -> (js: [String], dtsType: [String], dtsExportEntry: [String]) {
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
                thunkBuilder.lowerParameter(param: param)
            }
            var funcLines: [String] = []
            funcLines.append("")
            funcLines.append("constructor(\(constructor.parameters.map { $0.name }.joined(separator: ", "))) {")
            let returnExpr = thunkBuilder.callConstructor(abiName: constructor.abiName)
            funcLines.append(contentsOf: thunkBuilder.bodyLines.map { $0.indent(count: 4) })
            funcLines.append(contentsOf: thunkBuilder.cleanupLines.map { $0.indent(count: 4) })
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
                thunkBuilder.lowerParameter(param: param)
            }
            let returnExpr = thunkBuilder.call(abiName: method.abiName, returnType: method.returnType)
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
            let getterReturnExpr = getterThunkBuilder.call(
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
                setterThunkBuilder.lowerParameter(param: Parameter(label: "value", name: "value", type: property.type))
                _ = setterThunkBuilder.call(
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
        var bodyLines: [String] = []
        var parameterNames: [String] = []
        var parameterForwardings: [String] = []

        func liftSelf() {
            parameterNames.append("self")
        }

        func liftParameter(param: Parameter) {
            parameterNames.append(param.name)
            switch param.type {
            case .string:
                let stringObjectName = "\(param.name)Object"
                // TODO: Implement "take" operation
                bodyLines.append("const \(stringObjectName) = swift.memory.getObject(\(param.name));")
                bodyLines.append("swift.memory.release(\(param.name));")
                parameterForwardings.append(stringObjectName)
            case .caseEnum(_):
                parameterForwardings.append(param.name)
            case .rawValueEnum(_, let rawType):
                switch rawType {
                case .string:
                    let stringObjectName = "\(param.name)Object"
                    bodyLines.append("const \(stringObjectName) = swift.memory.getObject(\(param.name));")
                    bodyLines.append("swift.memory.release(\(param.name));")
                    parameterForwardings.append(stringObjectName)
                case .bool:
                    parameterForwardings.append("\(param.name) !== 0")
                default:
                    parameterForwardings.append(param.name)
                }
            case .associatedValueEnum:
                parameterForwardings.append("\"\"")
            case .namespaceEnum:
                break
            case .jsObject:
                parameterForwardings.append("swift.memory.getObject(\(param.name))")
            default:
                parameterForwardings.append(param.name)
            }
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
            funcLines.append(contentsOf: bodyLines.map { $0.indent(count: 8) })
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

        func call(name: String, returnType: BridgeType) {
            let call = "imports.\(name)(\(parameterForwardings.joined(separator: ", ")))"
            if returnType == .void {
                bodyLines.append("\(call);")
            } else {
                bodyLines.append("let ret = \(call);")
            }
        }

        func callConstructor(name: String) {
            let call = "new imports.\(name)(\(parameterForwardings.joined(separator: ", ")))"
            bodyLines.append("let ret = \(call);")
        }

        func callMethod(name: String, returnType: BridgeType) {
            let call = "swift.memory.getObject(self).\(name)(\(parameterForwardings.joined(separator: ", ")))"
            if returnType == .void {
                bodyLines.append("\(call);")
            } else {
                bodyLines.append("let ret = \(call);")
            }
        }

        func callPropertyGetter(name: String, returnType: BridgeType) {
            let call = "swift.memory.getObject(self).\(name)"
            bodyLines.append("let ret = \(call);")
        }

        func callPropertySetter(name: String, returnType: BridgeType) {
            let call = "swift.memory.getObject(self).\(name) = \(parameterForwardings.joined(separator: ", "))"
            bodyLines.append("\(call);")
        }

        func lowerReturnValue(returnType: BridgeType) throws -> String? {
            switch returnType {
            case .void:
                return nil
            case .string:
                bodyLines.append("tmpRetBytes = textEncoder.encode(ret);")
                return "tmpRetBytes.length"
            case .caseEnum(_):
                return "ret"
            case .rawValueEnum(_, let rawType):
                switch rawType {
                case .string:
                    bodyLines.append("tmpRetBytes = textEncoder.encode(ret);")
                    return "tmpRetBytes.length"
                case .bool:
                    return "ret ? 1 : 0"
                default:
                    return "ret"
                }
            case .associatedValueEnum:
                return nil
            case .namespaceEnum:
                return nil
            case .int, .float, .double:
                return "ret"
            case .bool:
                return "ret !== 0"
            case .jsObject:
                return "swift.memory.retain(ret)"
            case .swiftHeapObject:
                throw BridgeJSLinkError(message: "Swift heap object is not supported in imported functions")
            }
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
                let namespacePath: String = enumDefinition.namespace?.joined(separator: ".") ?? ""
                lines.append("globalThis.\(namespacePath).\(enumDefinition.name) = exports.\(enumDefinition.name);")
            }

            namespacedFunctions.forEach { function in
                let namespacePath: String = function.namespace?.joined(separator: ".") ?? ""
                lines.append("globalThis.\(namespacePath).\(function.name) = exports.\(function.name);")
            }

            return lines
        }

        func renderTopLevelEnumNamespaceAssignments(namespacedEnums: [ExportedEnum]) -> [String] {
            let topLevelNamespacedEnums = namespacedEnums.filter { $0.enumType == .simple || $0.enumType == .rawValue }

            guard !topLevelNamespacedEnums.isEmpty else { return [] }

            var lines: [String] = []
            var uniqueNamespaces: [String] = []
            var seen = Set<String>()

            for enumDef in topLevelNamespacedEnums {
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
                lines.append("if (typeof globalThis.\(namespace) === 'undefined') {")
                lines.append("globalThis.\(namespace) = {};".indent(count: 4))
                lines.append("}")
            }

            if !lines.isEmpty {
                lines.append("")
            }

            for enumDef in topLevelNamespacedEnums {
                let namespacePath = enumDef.namespace?.joined(separator: ".") ?? ""
                lines.append("globalThis.\(namespacePath).\(enumDef.name) = \(enumDef.name);")
            }

            return lines
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
            var dtsLines: [String] = []

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
                return dtsLines
            }

            dtsLines.append("export {};")
            dtsLines.append("")
            dtsLines.append("declare global {")

            let identBaseSize = 4

            func generateNamespaceDeclarations(node: NamespaceNode, depth: Int) {
                let sortedChildren = node.children.sorted { $0.key < $1.key }

                for (childName, childNode) in sortedChildren {
                    dtsLines.append("namespace \(childName) {".indent(count: identBaseSize * depth))

                    let contentDepth = depth + 1

                    let sortedClasses = childNode.content.classes.sorted { $0.name < $1.name }
                    for klass in sortedClasses {
                        dtsLines.append("class \(klass.name) {".indent(count: identBaseSize * contentDepth))

                        if let constructor = klass.constructor {
                            let constructorSignature =
                                "constructor(\(constructor.parameters.map { "\($0.name): \($0.type.tsType)" }.joined(separator: ", ")));"
                            dtsLines.append("\(constructorSignature)".indent(count: identBaseSize * (contentDepth + 1)))
                        }

                        let sortedMethods = klass.methods.sorted { $0.name < $1.name }
                        for method in sortedMethods {
                            let methodSignature =
                                "\(method.name)\(renderTSSignatureCallback(method.parameters, method.returnType, method.effects));"
                            dtsLines.append("\(methodSignature)".indent(count: identBaseSize * (contentDepth + 1)))
                        }

                        dtsLines.append("}".indent(count: identBaseSize * contentDepth))
                    }

                    let sortedEnums = childNode.content.enums.sorted { $0.name < $1.name }
                    for enumDefinition in sortedEnums {
                        let style: EnumEmitStyle = enumDefinition.emitStyle
                        switch enumDefinition.enumType {
                        case .simple:
                            switch style {
                            case .tsEnum:
                                dtsLines.append(
                                    "enum \(enumDefinition.name) {".indent(count: identBaseSize * contentDepth)
                                )
                                for (index, enumCase) in enumDefinition.cases.enumerated() {
                                    let caseName = enumCase.name.capitalizedFirstLetter
                                    dtsLines.append(
                                        "\(caseName) = \(index),".indent(count: identBaseSize * (contentDepth + 1))
                                    )
                                }
                                dtsLines.append("}".indent(count: identBaseSize * contentDepth))
                            case .const:
                                dtsLines.append(
                                    "const \(enumDefinition.name): {".indent(count: identBaseSize * contentDepth)
                                )
                                for (index, enumCase) in enumDefinition.cases.enumerated() {
                                    let caseName = enumCase.name.capitalizedFirstLetter
                                    dtsLines.append(
                                        "readonly \(caseName): \(index);".indent(
                                            count: identBaseSize * (contentDepth + 1)
                                        )
                                    )
                                }
                                dtsLines.append("};".indent(count: identBaseSize * contentDepth))
                                dtsLines.append(
                                    "type \(enumDefinition.name) = typeof \(enumDefinition.name)[keyof typeof \(enumDefinition.name)];"
                                        .indent(count: identBaseSize * contentDepth)
                                )
                            }
                        case .rawValue:
                            guard let rawType = enumDefinition.rawType else { continue }
                            switch style {
                            case .tsEnum:
                                dtsLines.append(
                                    "enum \(enumDefinition.name) {".indent(count: identBaseSize * contentDepth)
                                )
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
                                    dtsLines.append(
                                        "\(caseName) = \(formattedValue),".indent(
                                            count: identBaseSize * (contentDepth + 1)
                                        )
                                    )
                                }
                                dtsLines.append("}".indent(count: identBaseSize * contentDepth))
                            case .const:
                                dtsLines.append(
                                    "const \(enumDefinition.name): {".indent(count: identBaseSize * contentDepth)
                                )
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
                                    dtsLines.append(
                                        "readonly \(caseName): \(formattedValue);".indent(
                                            count: identBaseSize * (contentDepth + 1)
                                        )
                                    )
                                }
                                dtsLines.append("};".indent(count: identBaseSize * contentDepth))
                                dtsLines.append(
                                    "type \(enumDefinition.name) = typeof \(enumDefinition.name)[keyof typeof \(enumDefinition.name)];"
                                        .indent(count: identBaseSize * contentDepth)
                                )
                            }
                        case .associatedValue, .namespace:
                            continue
                        }
                    }

                    let sortedFunctions = childNode.content.functions.sorted { $0.name < $1.name }
                    for function in sortedFunctions {
                        let signature =
                            "\(function.name)\(renderTSSignatureCallback(function.parameters, function.returnType, function.effects));"
                        dtsLines.append("\(signature)".indent(count: identBaseSize * contentDepth))
                    }

                    generateNamespaceDeclarations(node: childNode, depth: contentDepth)

                    dtsLines.append("}".indent(count: identBaseSize * depth))
                }
            }

            generateNamespaceDeclarations(node: rootNode, depth: 1)

            dtsLines.append("}")
            dtsLines.append("")

            return dtsLines
        }
    }

    func renderImportedFunction(
        importObjectBuilder: ImportObjectBuilder,
        function: ImportedFunctionSkeleton
    ) throws {
        let thunkBuilder = ImportedThunkBuilder()
        for param in function.parameters {
            thunkBuilder.liftParameter(param: param)
        }
        thunkBuilder.call(name: function.name, returnType: function.returnType)
        let returnExpr = try thunkBuilder.lowerReturnValue(returnType: function.returnType)
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
                    thunkBuilder.callPropertyGetter(name: property.name, returnType: property.type)
                    return try thunkBuilder.lowerReturnValue(returnType: property.type)
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
                        thunkBuilder.liftParameter(
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
            thunkBuilder.liftParameter(param: param)
        }
        let returnType = BridgeType.jsObject(type.name)
        thunkBuilder.callConstructor(name: type.name)
        let returnExpr = try thunkBuilder.lowerReturnValue(returnType: returnType)
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
            thunkBuilder.liftParameter(param: param)
        }
        thunkBuilder.callMethod(name: method.name, returnType: method.returnType)
        let returnExpr = try thunkBuilder.lowerReturnValue(returnType: method.returnType)
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

fileprivate extension String {
    var capitalizedFirstLetter: String {
        guard !isEmpty else { return self }
        return prefix(1).uppercased() + dropFirst()
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
