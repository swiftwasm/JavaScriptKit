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

    private struct LinkData {
        var exportsLines: [String] = []
        var classLines: [String] = []
        var dtsExportLines: [String] = []
        var dtsClassLines: [String] = []
        var namespacedFunctions: [ExportedFunction] = []
        var namespacedClasses: [ExportedClass] = []
        var namespacedEnums: [ExportedEnum] = []
        var topLevelEnumLines: [String] = []
        var topLevelDtsEnumLines: [String] = []
        var importObjectBuilders: [ImportObjectBuilder] = []
        var enumStaticAssignments: [String] = []
    }

    private func collectLinkData() throws -> LinkData {
        var data = LinkData()

        // Swift heap object class definitions
        if exportedSkeletons.contains(where: { $0.classes.count > 0 }) {
            data.classLines.append(
                contentsOf: swiftHeapObjectClassJs.split(separator: "\n", omittingEmptySubsequences: false).map {
                    String($0)
                }
            )
            data.dtsClassLines.append(
                contentsOf: swiftHeapObjectClassDts.split(separator: "\n", omittingEmptySubsequences: false).map {
                    String($0)
                }
            )
        }

        // Process exported skeletons
        for skeleton in exportedSkeletons {
            // Process classes
            for klass in skeleton.classes {
                let (jsType, dtsType, dtsExportEntry) = try renderExportedClass(klass)
                data.classLines.append(contentsOf: jsType)
                data.exportsLines.append("\(klass.name),")
                data.dtsExportLines.append(contentsOf: dtsExportEntry)
                data.dtsClassLines.append(contentsOf: dtsType)

                if klass.namespace != nil {
                    data.namespacedClasses.append(klass)
                }
            }

            // Process enums
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
                        data.topLevelEnumLines.append(contentsOf: exportedJsEnum)
                        data.topLevelDtsEnumLines.append(contentsOf: dtsEnum)

                        if enumDefinition.namespace != nil {
                            data.namespacedEnums.append(enumDefinition)
                        }
                    case .associatedValue:
                        var exportedJsEnum = jsEnum
                        if !exportedJsEnum.isEmpty && exportedJsEnum[0].hasPrefix("const ") {
                            exportedJsEnum[0] = "export " + exportedJsEnum[0]
                        }
                        data.topLevelEnumLines.append(contentsOf: exportedJsEnum)
                        data.topLevelDtsEnumLines.append(contentsOf: dtsEnum)
                        if enumDefinition.namespace != nil {
                            data.namespacedEnums.append(enumDefinition)
                        }
                    }
                }
            }

            // Process functions
            for function in skeleton.functions {
                if function.effects.isStatic,
                    case .enumName(_) = function.staticContext
                {
                    continue
                }

                var (js, dts) = try renderExportedFunction(function: function)

                if function.effects.isStatic,
                    case .namespaceEnum = function.staticContext
                {
                    data.namespacedFunctions.append(function)
                } else if function.namespace != nil {
                    data.namespacedFunctions.append(function)
                }

                js[0] = "\(function.name): " + js[0]
                js[js.count - 1] += ","
                data.exportsLines.append(contentsOf: js)
                data.dtsExportLines.append(contentsOf: dts)
            }

            for enumDefinition in skeleton.enums where enumDefinition.enumType == .namespace {
                for function in enumDefinition.staticMethods {
                    // Create namespace function with full namespace path (parent namespace + enum name)
                    var functionWithNamespace = function
                    let fullNamespace = (enumDefinition.namespace ?? []) + [enumDefinition.name]
                    functionWithNamespace.namespace = fullNamespace
                    data.namespacedFunctions.append(functionWithNamespace)

                    var (js, dts) = try renderExportedFunction(function: functionWithNamespace)
                    js[0] = "\(functionWithNamespace.name): " + js[0]
                    js[js.count - 1] += ","
                    data.exportsLines.append(contentsOf: js)
                    data.dtsExportLines.append(contentsOf: dts)
                }

                for property in enumDefinition.staticProperties {
                    let fullNamespace = (enumDefinition.namespace ?? []) + [enumDefinition.name]
                    let namespacePath = fullNamespace.joined(separator: ".")
                    let (propJs, _) = try renderNamespaceStaticProperty(
                        property: property,
                        namespacePath: namespacePath
                    )
                    data.enumStaticAssignments.append(contentsOf: propJs)
                }
            }

            for enumDefinition in skeleton.enums where enumDefinition.enumType != .namespace {
                for function in enumDefinition.staticMethods {
                    let assignmentJs = try renderEnumStaticFunctionAssignment(
                        function: function,
                        enumName: enumDefinition.name
                    )
                    data.enumStaticAssignments.append(contentsOf: assignmentJs)
                }
                for property in enumDefinition.staticProperties {
                    let (propJs, _) = try renderEnumStaticProperty(property: property, enumName: enumDefinition.name)
                    data.enumStaticAssignments.append(contentsOf: propJs)
                }
            }

        }

        // Process imported skeletons
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
            data.importObjectBuilders.append(importObjectBuilder)
        }

        return data
    }

    private func generateVariableDeclarations() -> [String] {
        let hasAssociatedValueEnums = exportedSkeletons.contains { skeleton in
            skeleton.enums.contains { $0.enumType == .associatedValue }
        }

        var declarations = [
            "let \(JSGlueVariableScope.reservedInstance);",
            "let \(JSGlueVariableScope.reservedMemory);",
            "let \(JSGlueVariableScope.reservedSetException);",
            "const \(JSGlueVariableScope.reservedTextDecoder) = new TextDecoder(\"utf-8\");",
            "const \(JSGlueVariableScope.reservedTextEncoder) = new TextEncoder(\"utf-8\");",
            "let \(JSGlueVariableScope.reservedStorageToReturnString);",
            "let \(JSGlueVariableScope.reservedStorageToReturnBytes);",
            "let \(JSGlueVariableScope.reservedStorageToReturnException);",
            "let \(JSGlueVariableScope.reservedStorageToReturnOptionalBool);",
            "let \(JSGlueVariableScope.reservedStorageToReturnOptionalInt);",
            "let \(JSGlueVariableScope.reservedStorageToReturnOptionalFloat);",
            "let \(JSGlueVariableScope.reservedStorageToReturnOptionalDouble);",
            "let \(JSGlueVariableScope.reservedStorageToReturnOptionalHeapObject);",
            "let \(JSGlueVariableScope.reservedTmpRetTag);",
            "let \(JSGlueVariableScope.reservedTmpRetStrings) = [];",
            "let \(JSGlueVariableScope.reservedTmpRetInts) = [];",
            "let \(JSGlueVariableScope.reservedTmpRetF32s) = [];",
            "let \(JSGlueVariableScope.reservedTmpRetF64s) = [];",
            "let \(JSGlueVariableScope.reservedTmpParamInts) = [];",
            "let \(JSGlueVariableScope.reservedTmpParamF32s) = [];",
            "let \(JSGlueVariableScope.reservedTmpParamF64s) = [];",
        ]

        if hasAssociatedValueEnums {
            declarations.append("const enumHelpers = {};")
        }

        return declarations
    }

    private func generateAddImports() -> CodeFragmentPrinter {
        let printer = CodeFragmentPrinter()
        printer.write("return {")
        printer.indent {
            printer.write(lines: [
                "/**",
                " * @param {WebAssembly.Imports} importObject",
                " */",
                "addImports: (importObject, importsContext) => {",
            ])

            printer.indent {
                printer.write(lines: [
                    "const bjs = {};",
                    "importObject[\"bjs\"] = bjs;",
                    "const imports = options.getImports(importsContext);",
                ])
                printer.write("bjs[\"swift_js_return_string\"] = function(ptr, len) {")
                printer.indent {
                    printer.write(
                        "const bytes = new Uint8Array(\(JSGlueVariableScope.reservedMemory).buffer, ptr, len)\(sharedMemory ? ".slice()" : "");"
                    )
                    printer.write(
                        "\(JSGlueVariableScope.reservedStorageToReturnString) = \(JSGlueVariableScope.reservedTextDecoder).decode(bytes);"
                    )
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_init_memory\"] = function(sourceId, bytesPtr) {")
                printer.indent {
                    printer.write(
                        "const source = \(JSGlueVariableScope.reservedSwift).\(JSGlueVariableScope.reservedMemory).getObject(sourceId);"
                    )
                    printer.write(
                        "const bytes = new Uint8Array(\(JSGlueVariableScope.reservedMemory).buffer, bytesPtr);"
                    )
                    printer.write("bytes.set(source);")
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_make_js_string\"] = function(ptr, len) {")
                printer.indent {
                    printer.write(
                        "const bytes = new Uint8Array(\(JSGlueVariableScope.reservedMemory).buffer, ptr, len)\(sharedMemory ? ".slice()" : "");"
                    )
                    printer.write(
                        "return \(JSGlueVariableScope.reservedSwift).\(JSGlueVariableScope.reservedMemory).retain(\(JSGlueVariableScope.reservedTextDecoder).decode(bytes));"
                    )
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_init_memory_with_result\"] = function(ptr, len) {")
                printer.indent {
                    printer.write(
                        "const target = new Uint8Array(\(JSGlueVariableScope.reservedMemory).buffer, ptr, len);"
                    )
                    printer.write("target.set(\(JSGlueVariableScope.reservedStorageToReturnBytes));")
                    printer.write("\(JSGlueVariableScope.reservedStorageToReturnBytes) = undefined;")
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_throw\"] = function(id) {")
                printer.indent {
                    printer.write(
                        "\(JSGlueVariableScope.reservedStorageToReturnException) = \(JSGlueVariableScope.reservedSwift).\(JSGlueVariableScope.reservedMemory).retainByRef(id);"
                    )
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_retain\"] = function(id) {")
                printer.indent {
                    printer.write(
                        "return \(JSGlueVariableScope.reservedSwift).\(JSGlueVariableScope.reservedMemory).retainByRef(id);"
                    )
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_release\"] = function(id) {")
                printer.indent {
                    printer.write("\(JSGlueVariableScope.reservedSwift).memory.release(id);")
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_push_tag\"] = function(tag) {")
                printer.indent {
                    printer.write("\(JSGlueVariableScope.reservedTmpRetTag) = tag;")
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_push_int\"] = function(v) {")
                printer.indent {
                    printer.write("\(JSGlueVariableScope.reservedTmpRetInts).push(v | 0);")
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_push_f32\"] = function(v) {")
                printer.indent {
                    printer.write("\(JSGlueVariableScope.reservedTmpRetF32s).push(Math.fround(v));")
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_push_f64\"] = function(v) {")
                printer.indent {
                    printer.write("\(JSGlueVariableScope.reservedTmpRetF64s).push(v);")
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_push_string\"] = function(ptr, len) {")
                printer.indent {
                    printer.write(
                        "const bytes = new Uint8Array(\(JSGlueVariableScope.reservedMemory).buffer, ptr, len)\(sharedMemory ? ".slice()" : "");"
                    )
                    printer.write("const value = \(JSGlueVariableScope.reservedTextDecoder).decode(bytes);")
                    printer.write("\(JSGlueVariableScope.reservedTmpRetStrings).push(value);")
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_pop_param_int32\"] = function() {")
                printer.indent {
                    printer.write("return \(JSGlueVariableScope.reservedTmpParamInts).pop();")
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_pop_param_f32\"] = function() {")
                printer.indent {
                    printer.write("return \(JSGlueVariableScope.reservedTmpParamF32s).pop();")
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_pop_param_f64\"] = function() {")
                printer.indent {
                    printer.write("return \(JSGlueVariableScope.reservedTmpParamF64s).pop();")
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_return_optional_bool\"] = function(isSome, value) {")
                printer.indent {
                    printer.write("if (isSome === 0) {")
                    printer.indent {
                        printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalBool) = null;")
                    }
                    printer.write("} else {")
                    printer.indent {
                        printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalBool) = value !== 0;")
                    }
                    printer.write("}")
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_return_optional_int\"] = function(isSome, value) {")
                printer.indent {
                    printer.write("if (isSome === 0) {")
                    printer.indent {
                        printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalInt) = null;")
                    }
                    printer.write("} else {")
                    printer.indent {
                        printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalInt) = value | 0;")
                    }
                    printer.write("}")
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_return_optional_float\"] = function(isSome, value) {")
                printer.indent {
                    printer.write("if (isSome === 0) {")
                    printer.indent {
                        printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalFloat) = null;")
                    }
                    printer.write("} else {")
                    printer.indent {
                        printer.write(
                            "\(JSGlueVariableScope.reservedStorageToReturnOptionalFloat) = Math.fround(value);"
                        )
                    }
                    printer.write("}")
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_return_optional_double\"] = function(isSome, value) {")
                printer.indent {
                    printer.write("if (isSome === 0) {")
                    printer.indent {
                        printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalDouble) = null;")
                    }
                    printer.write("} else {")
                    printer.indent {
                        printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalDouble) = value;")
                    }
                    printer.write("}")
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_return_optional_string\"] = function(isSome, ptr, len) {")
                printer.indent {
                    printer.write("if (isSome === 0) {")
                    printer.indent {
                        printer.write("\(JSGlueVariableScope.reservedStorageToReturnString) = null;")
                    }
                    printer.write("} else {")
                    printer.indent {
                        printer.write(lines: [
                            "const bytes = new Uint8Array(\(JSGlueVariableScope.reservedMemory).buffer, ptr, len);",
                            "\(JSGlueVariableScope.reservedStorageToReturnString) = \(JSGlueVariableScope.reservedTextDecoder).decode(bytes);",
                        ])
                    }
                    printer.write("}")
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_return_optional_object\"] = function(isSome, objectId) {")
                printer.indent {
                    printer.write("if (isSome === 0) {")
                    printer.indent {
                        printer.write("\(JSGlueVariableScope.reservedStorageToReturnString) = null;")
                    }
                    printer.write("} else {")
                    printer.indent {
                        printer.write(
                            "\(JSGlueVariableScope.reservedStorageToReturnString) = \(JSGlueVariableScope.reservedSwift).memory.getObject(objectId);"
                        )
                    }
                    printer.write("}")
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_return_optional_heap_object\"] = function(isSome, pointer) {")
                printer.indent {
                    printer.write("if (isSome === 0) {")
                    printer.indent {
                        printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalHeapObject) = null;")
                    }
                    printer.write("} else {")
                    printer.indent {
                        printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalHeapObject) = pointer;")
                    }
                    printer.write("}")
                }
                printer.write("}")
            }
        }
        return printer
    }

    private func generateTypeScript(data: LinkData) -> String {
        let header = """
            // NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
            // DO NOT EDIT.
            //
            // To update this file, just rebuild your project or run
            // `swift package bridge-js`.
            """
        let printer = CodeFragmentPrinter(header: header)
        printer.nextLine()
        printer.write(lines: data.topLevelDtsEnumLines)

        // Type definitions section (namespace declarations, class definitions, imported types)
        let namespaceBuilder = NamespaceBuilder()
        let namespaceDeclarationsLines = namespaceBuilder.namespaceDeclarations(
            exportedSkeletons: exportedSkeletons,
            renderTSSignatureCallback: { parameters, returnType, effects in
                self.renderTSSignature(parameters: parameters, returnType: returnType, effects: effects)
            }
        )
        printer.write(lines: namespaceDeclarationsLines)

        printer.write(lines: data.dtsClassLines)

        // Imported type definitions
        printer.write(lines: generateImportedTypeDefinitions())

        // Exports type
        printer.write("export type Exports = {")
        printer.indent {
            printer.write(lines: data.dtsExportLines)
        }
        printer.write("}")

        // Imports type
        printer.write("export type Imports = {")
        printer.indent {
            printer.write(lines: data.importObjectBuilders.flatMap { $0.dtsImportLines })
        }
        printer.write("}")

        // Function signature section
        printer.write("export function createInstantiator(options: {")
        printer.indent {
            printer.write("imports: Imports;")
        }
        printer.write("}, swift: any): Promise<{")
        printer.indent {
            printer.write(lines: [
                "addImports: (importObject: WebAssembly.Imports) => void;",
                "setInstance: (instance: WebAssembly.Instance) => void;",
                "createExports: (instance: WebAssembly.Instance) => Exports;",
            ])
        }
        printer.write("}>;")

        return printer.lines.joined(separator: "\n")
    }

    /// Generates JavaScript output using CodeFragmentPrinter for better maintainability
    private func generateJavaScript(data: LinkData) -> String {
        let header = """
            // NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
            // DO NOT EDIT.
            //
            // To update this file, just rebuild your project or run
            // `swift package bridge-js`.
            """
        let printer = CodeFragmentPrinter(header: header)
        printer.nextLine()

        // Top-level enums section
        printer.write(lines: data.topLevelEnumLines)

        // Namespace assignments section
        let topLevelNamespaceCode = generateNamespaceInitializationCode(
            namespacePaths: Set(data.namespacedEnums.compactMap { $0.namespace })
        )
        printer.write(lines: topLevelNamespaceCode)

        // Add enum assignments to global namespace
        for enumDef in data.namespacedEnums {
            if enumDef.enumType != .namespace {
                let namespacePath = enumDef.namespace?.joined(separator: ".") ?? ""
                printer.write("globalThis.\(namespacePath).\(enumDef.name) = \(enumDef.name);")
            }
        }

        // Main function declaration
        printer.write("export async function createInstantiator(options, \(JSGlueVariableScope.reservedSwift)) {")

        printer.indent {
            printer.write(lines: generateVariableDeclarations())
            printer.nextLine()
            printer.write(contentsOf: generateAddImports())
        }
        printer.indent()

        printer.indent {
            printer.indent {
                // Swift class wrappers
                let swiftClassWrappers = renderSwiftClassWrappers()
                printer.write(lines: swiftClassWrappers)

                // Import object builders
                for importBuilder in data.importObjectBuilders {
                    printer.write(lines: importBuilder.importedLines)
                }
            }
            printer.write("},")
        }

        // setInstance method
        printer.indent {
            printer.write("setInstance: (i) => {")
            printer.indent {
                printer.write(lines: [
                    "\(JSGlueVariableScope.reservedInstance) = i;",
                    "\(JSGlueVariableScope.reservedMemory) = \(JSGlueVariableScope.reservedInstance).exports.memory;",
                ])
                printer.nextLine()
                // Enum helpers section
                printer.write(contentsOf: enumHelperAssignments())
                // Error handling
                printer.write("\(JSGlueVariableScope.reservedSetException) = (error) => {")
                printer.indent {
                    printer.write(
                        "\(JSGlueVariableScope.reservedInstance).exports._swift_js_exception.value = \(JSGlueVariableScope.reservedSwift).memory.retain(error)"
                    )
                }
                printer.write("}")
            }
            printer.write("},")
        }

        // createExports method
        printer.indent {
            printer.write(lines: [
                "/** @param {WebAssembly.Instance} instance */",
                "createExports: (instance) => {",
            ])
            printer.indent {
                printer.write("const js = \(JSGlueVariableScope.reservedSwift).memory.heap;")

                // Exports / return section
                let hasNamespacedItems = !data.namespacedFunctions.isEmpty || !data.namespacedClasses.isEmpty
                let hasNamespacedEnums = !data.namespacedEnums.isEmpty
                let hasAnyNamespacedItems = hasNamespacedItems || hasNamespacedEnums

                printer.write(lines: data.classLines)

                // Initialize all namespaces before property assignments
                if hasAnyNamespacedItems {
                    let allNamespacePaths = collectAllNamespacePaths(data: data)
                    let namespaceInitializationCode = generateNamespaceInitializationCode(
                        namespacePaths: allNamespacePaths
                    )
                    printer.write(lines: namespaceInitializationCode)
                }

                let propertyAssignments = generateNamespacePropertyAssignments(
                    data: data,
                    hasAnyNamespacedItems: hasAnyNamespacedItems
                )
                printer.write(lines: propertyAssignments)
            }
            printer.write("},")
        }
        printer.write("}")
        printer.unindent()
        printer.write("}")

        return printer.lines.joined(separator: "\n")
    }

    func link() throws -> (outputJs: String, outputDts: String) {
        let data = try collectLinkData()
        let outputJs = generateJavaScript(data: data)
        let outputDts = generateTypeScript(data: data)
        return (outputJs, outputDts)
    }

    private func enumHelperAssignments() -> CodeFragmentPrinter {
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

        return printer
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

    /// Collects all unique namespace paths from functions, classes, enums, and static properties
    private func collectAllNamespacePaths(data: LinkData) -> Set<[String]> {
        let functionNamespacePaths: Set<[String]> = Set(
            data.namespacedFunctions.compactMap { $0.namespace }
        )
        let classNamespacePaths: Set<[String]> = Set(
            data.namespacedClasses.compactMap { $0.namespace }
        )
        let allRegularNamespacePaths = functionNamespacePaths.union(classNamespacePaths)

        let enumNamespacePaths: Set<[String]> = Set(
            data.namespacedEnums.compactMap { $0.namespace }
        )
        var staticPropertyNamespacePaths: Set<[String]> = Set()
        for skeleton in exportedSkeletons {
            for enumDefinition in skeleton.enums {
                for property in enumDefinition.staticProperties {
                    if let namespace = property.namespace, !namespace.isEmpty {
                        staticPropertyNamespacePaths.insert(namespace)
                    }
                }
            }
        }

        return allRegularNamespacePaths.union(enumNamespacePaths).union(staticPropertyNamespacePaths)
    }

    /// Generates JavaScript code lines for initializing namespace objects on globalThis
    private func generateNamespaceInitializationCode(namespacePaths: Set<[String]>) -> [String] {
        let printer = CodeFragmentPrinter()
        var allUniqueNamespaces: [String] = []
        var seen = Set<String>()

        namespacePaths.forEach { namespacePath in
            namespacePath.enumerated().forEach { (index, _) in
                let path = namespacePath[0...index].joined(separator: ".")
                if seen.insert(path).inserted {
                    allUniqueNamespaces.append(path)
                }
            }
        }

        allUniqueNamespaces.sorted().forEach { namespace in
            printer.write("if (typeof globalThis.\(namespace) === 'undefined') {")
            printer.indent {
                printer.write("globalThis.\(namespace) = {};")
            }
            printer.write("}")
        }

        return printer.lines
    }

    /// Generates JavaScript code for assigning namespaced items to globalThis
    private func generateNamespacePropertyAssignments(data: LinkData, hasAnyNamespacedItems: Bool) -> [String] {
        let printer = CodeFragmentPrinter()

        printer.write(lines: data.enumStaticAssignments)

        if hasAnyNamespacedItems {
            printer.write("const exports = {")
            printer.indent()
            printer.write(lines: data.exportsLines.map { "\($0)" })
            printer.unindent()
            printer.write("};")

            data.namespacedClasses.forEach { klass in
                let namespacePath: String = klass.namespace?.joined(separator: ".") ?? ""
                printer.write("globalThis.\(namespacePath).\(klass.name) = exports.\(klass.name);")
            }

            data.namespacedFunctions.forEach { function in
                let namespacePath: String = function.namespace?.joined(separator: ".") ?? ""
                printer.write("globalThis.\(namespacePath).\(function.name) = exports.\(function.name);")
            }

            printer.write("return exports;")
        } else {
            printer.write("return {")
            printer.indent()
            printer.write(lines: data.exportsLines.map { "\($0)" })
            printer.unindent()
            printer.write("};")
        }

        return printer.lines
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
            let printer = CodeFragmentPrinter()

            printer.write(
                "\(declarationPrefixKeyword.map { "\($0) "} ?? "")\(name)(\(parameters.map { $0.name }.joined(separator: ", "))) {"
            )
            printer.indent {
                printer.write(contentsOf: body)
                printer.write(contentsOf: cleanupCode)
                printer.write(lines: checkExceptionLines())
                if let returnExpr = returnExpr {
                    printer.write("return \(returnExpr);")
                }
            }
            printer.write("}")

            return printer.lines
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

        let enumStaticFunctions = enumDefinition.staticMethods

        switch enumDefinition.emitStyle {
        case .tsEnum:
            switch enumDefinition.enumType {
            case .simple, .rawValue:
                printer.write("export enum \(enumDefinition.name) {")
                printer.indent {
                    for (index, enumCase) in enumDefinition.cases.enumerated() {
                        let caseName = enumCase.name.capitalizedFirstLetter
                        let value = getEnumCaseValue(
                            enumCase: enumCase,
                            enumType: enumDefinition.enumType,
                            rawType: enumDefinition.rawType,
                            index: index
                        )
                        printer.write("\(caseName) = \(value),")
                    }
                }
                printer.write("}")
                printer.nextLine()
            case .associatedValue, .namespace:
                break
            }

        case .const:
            printer.write("export const \(enumDefinition.name): {")
            switch enumDefinition.enumType {
            case .simple, .rawValue:
                printer.indent {
                    for (index, enumCase) in enumDefinition.cases.enumerated() {
                        let caseName = enumCase.name.capitalizedFirstLetter
                        let value = getEnumCaseValue(
                            enumCase: enumCase,
                            enumType: enumDefinition.enumType,
                            rawType: enumDefinition.rawType,
                            index: index
                        )
                        printer.write("readonly \(caseName): \(value);")
                    }

                    for function in enumStaticFunctions {
                        let signature = renderTSSignature(
                            parameters: function.parameters,
                            returnType: function.returnType,
                            effects: function.effects
                        )
                        printer.write("\(function.name)\(signature);")
                    }
                    for property in enumDefinition.staticProperties {
                        let readonly = property.isReadonly ? "readonly " : ""
                        printer.write("\(readonly)\(property.name): \(property.type.tsType);")
                    }
                }
                printer.write("};")
                printer.write(
                    "export type \(enumDefinition.name) = typeof \(enumDefinition.name)[keyof typeof \(enumDefinition.name)];"
                )
                printer.nextLine()
            case .associatedValue:
                printer.indent {
                    printer.write("readonly Tag: {")
                    printer.indent {
                        for (index, enumCase) in enumDefinition.cases.enumerated() {
                            let caseName = enumCase.name.capitalizedFirstLetter
                            printer.write("readonly \(caseName): \(index);")
                        }
                    }
                    printer.write("};")

                    for function in enumStaticFunctions {
                        let signature = renderTSSignature(
                            parameters: function.parameters,
                            returnType: function.returnType,
                            effects: function.effects
                        )
                        printer.write("\(function.name)\(signature);")
                    }
                    for property in enumDefinition.staticProperties {
                        let readonly = property.isReadonly ? "readonly " : ""
                        printer.write("\(readonly)\(property.name): \(property.type.tsType);")
                    }
                }
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

    private func getEnumCaseValue(enumCase: EnumCase, enumType: EnumType, rawType: String?, index: Int) -> String {
        switch enumType {
        case .simple:
            return "\(index)"
        case .rawValue:
            let rawValue = enumCase.rawValue ?? enumCase.name
            return SwiftEnumRawType.formatValue(rawValue, rawType: rawType ?? "")
        case .associatedValue, .namespace:
            return ""
        }
    }
}

extension BridgeJSLink {

    func renderExportedFunction(function: ExportedFunction) throws -> (js: [String], dts: [String]) {
        if function.effects.isStatic, let staticContext = function.staticContext {
            return try renderStaticFunction(function: function, staticContext: staticContext)
        }

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

    private func renderStaticFunction(
        function: ExportedFunction,
        staticContext: StaticContext
    ) throws -> (js: [String], dts: [String]) {
        switch staticContext {
        case .className(let className):
            return try renderClassStaticFunction(function: function, className: className)
        case .enumName(let enumName):
            return try renderEnumStaticFunction(function: function, enumName: enumName)
        case .namespaceEnum:
            if let namespace = function.namespace, !namespace.isEmpty {
                return try renderNamespaceFunction(function: function, namespace: namespace.joined(separator: "."))
            } else {
                return try renderExportedFunction(function: function)
            }
        }
    }

    private func renderClassStaticFunction(
        function: ExportedFunction,
        className: String
    ) throws -> (js: [String], dts: [String]) {
        let thunkBuilder = ExportedThunkBuilder(effects: function.effects)
        for param in function.parameters {
            try thunkBuilder.lowerParameter(param: param)
        }
        let returnExpr = try thunkBuilder.call(abiName: function.abiName, returnType: function.returnType)

        let funcLines = thunkBuilder.renderFunction(
            name: function.name,
            parameters: function.parameters,
            returnExpr: returnExpr,
            declarationPrefixKeyword: "static"
        )

        let dtsLines = [
            "static \(function.name)\(renderTSSignature(parameters: function.parameters, returnType: function.returnType, effects: function.effects));"
        ]

        return (funcLines, dtsLines)
    }

    private func renderEnumStaticFunction(
        function: ExportedFunction,
        enumName: String
    ) throws -> (js: [String], dts: [String]) {
        let thunkBuilder = ExportedThunkBuilder(effects: function.effects)
        for param in function.parameters {
            try thunkBuilder.lowerParameter(param: param)
        }
        let returnExpr = try thunkBuilder.call(abiName: function.abiName, returnType: function.returnType)

        let printer = CodeFragmentPrinter()
        printer.write("\(function.name)(\(function.parameters.map { $0.name }.joined(separator: ", "))) {")
        printer.indent {
            printer.write(contentsOf: thunkBuilder.body)
            printer.write(contentsOf: thunkBuilder.cleanupCode)
            printer.write(lines: thunkBuilder.checkExceptionLines())
            if let returnExpr = returnExpr {
                printer.write("return \(returnExpr);")
            }
        }
        printer.write("},")

        let dtsLines = [
            "\(function.name)\(renderTSSignature(parameters: function.parameters, returnType: function.returnType, effects: function.effects));"
        ]

        return (printer.lines, dtsLines)
    }

    private func renderNamespaceFunction(
        function: ExportedFunction,
        namespace: String
    ) throws -> (js: [String], dts: [String]) {
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

        let dtsLines: [String] = []

        return (funcLines, dtsLines)
    }

    private func renderEnumStaticFunctionAssignment(
        function: ExportedFunction,
        enumName: String
    ) throws -> [String] {
        let thunkBuilder = ExportedThunkBuilder(effects: function.effects)
        for param in function.parameters {
            try thunkBuilder.lowerParameter(param: param)
        }
        let returnExpr = try thunkBuilder.call(abiName: function.abiName, returnType: function.returnType)

        let printer = CodeFragmentPrinter()
        printer.write(
            "\(enumName).\(function.name) = function(\(function.parameters.map { $0.name }.joined(separator: ", "))) {"
        )
        printer.indent {
            printer.write(contentsOf: thunkBuilder.body)
            printer.write(contentsOf: thunkBuilder.cleanupCode)
            printer.write(lines: thunkBuilder.checkExceptionLines())
            if let returnExpr = returnExpr {
                printer.write("return \(returnExpr);")
            }
        }
        printer.write("};")

        return printer.lines
    }

    /// Renders an enum static property as getter/setter assignments on the enum object
    private func renderEnumStaticProperty(
        property: ExportedProperty,
        enumName: String
    ) throws -> (js: [String], dts: [String]) {
        var jsLines: [String] = []

        // Generate getter assignment
        let getterThunkBuilder = ExportedThunkBuilder(effects: Effects(isAsync: false, isThrows: false))
        let getterReturnExpr = try getterThunkBuilder.call(
            abiName: property.getterAbiName(),
            returnType: property.type
        )

        let getterLines = getterThunkBuilder.renderFunction(
            name: property.name,
            parameters: [],
            returnExpr: getterReturnExpr,
            declarationPrefixKeyword: nil
        )

        // Build Object.defineProperty call
        var definePropertyLines: [String] = []
        definePropertyLines.append("Object.defineProperty(\(enumName), '\(property.name)', { get: function() {")

        // Add getter body (skip function declaration and closing brace)
        if getterLines.count > 2 {
            let bodyLines = Array(getterLines[1..<getterLines.count - 1])  // Skip first and last lines
            definePropertyLines.append(contentsOf: bodyLines)
        }

        if !property.isReadonly {
            // Generate setter
            let setterThunkBuilder = ExportedThunkBuilder(effects: Effects(isAsync: false, isThrows: false))
            try setterThunkBuilder.lowerParameter(
                param: Parameter(label: "value", name: "value", type: property.type)
            )
            _ = try setterThunkBuilder.call(
                abiName: property.setterAbiName(),
                returnType: .void
            )

            let setterLines = setterThunkBuilder.renderFunction(
                name: property.name,
                parameters: [.init(label: nil, name: "value", type: property.type)],
                returnExpr: nil,
                declarationPrefixKeyword: nil
            )

            // Add setter with proper comma separation
            definePropertyLines.append("}, set: function(value) {")
            if setterLines.count > 2 {
                let bodyLines = Array(setterLines[1..<setterLines.count - 1])  // Skip first and last lines
                definePropertyLines.append(contentsOf: bodyLines)
            }
            definePropertyLines.append("} });")
        } else {
            // Readonly property - just close the getter
            definePropertyLines.append("} });")
        }

        jsLines.append(contentsOf: definePropertyLines)

        // TypeScript definitions are handled by generateDeclarations
        let dtsLines: [String] = []

        return (jsLines, dtsLines)
    }

    /// Renders a namespace static property as getter/setter assignments on the namespace object
    private func renderNamespaceStaticProperty(
        property: ExportedProperty,
        namespacePath: String
    ) throws -> (js: [String], dts: [String]) {
        var jsLines: [String] = []

        // Generate getter assignment
        let getterThunkBuilder = ExportedThunkBuilder(effects: Effects(isAsync: false, isThrows: false))
        let getterReturnExpr = try getterThunkBuilder.call(
            abiName: property.getterAbiName(),
            returnType: property.type
        )

        let getterLines = getterThunkBuilder.renderFunction(
            name: property.name,
            parameters: [],
            returnExpr: getterReturnExpr,
            declarationPrefixKeyword: nil
        )

        // Build Object.defineProperty call for namespace
        var definePropertyLines: [String] = []
        definePropertyLines.append(
            "Object.defineProperty(globalThis.\(namespacePath), '\(property.name)', { get: function() {"
        )

        // Add getter body (skip function declaration and closing brace)
        if getterLines.count > 2 {
            let bodyLines = Array(getterLines[1..<getterLines.count - 1])  // Skip first and last lines
            definePropertyLines.append(contentsOf: bodyLines)
        }

        if !property.isReadonly {
            // Generate setter
            let setterThunkBuilder = ExportedThunkBuilder(effects: Effects(isAsync: false, isThrows: false))
            try setterThunkBuilder.lowerParameter(
                param: Parameter(label: "value", name: "value", type: property.type)
            )
            _ = try setterThunkBuilder.call(
                abiName: property.setterAbiName(),
                returnType: .void
            )

            let setterLines = setterThunkBuilder.renderFunction(
                name: property.name,
                parameters: [.init(label: nil, name: "value", type: property.type)],
                returnExpr: nil,
                declarationPrefixKeyword: nil
            )

            // Add setter with proper comma separation
            definePropertyLines.append("}, set: function(value) {")
            // Add setter body (skip function declaration and closing brace)
            if setterLines.count > 2 {
                let bodyLines = Array(setterLines[1..<setterLines.count - 1])  // Skip first and last lines
                definePropertyLines.append(contentsOf: bodyLines)
            }
            definePropertyLines.append("} });")
        } else {
            // Readonly property - just close the getter
            definePropertyLines.append("} });")
        }

        jsLines.append(contentsOf: definePropertyLines)

        // TypeScript definitions are handled by namespace declarations
        let dtsLines: [String] = []

        return (jsLines, dtsLines)
    }

    func renderExportedClass(
        _ klass: ExportedClass
    ) throws -> (js: [String], dtsType: [String], dtsExportEntry: [String]) {
        let jsPrinter = CodeFragmentPrinter()
        let dtsTypePrinter = CodeFragmentPrinter()
        let dtsExportEntryPrinter = CodeFragmentPrinter()

        dtsTypePrinter.write("export interface \(klass.name) extends SwiftHeapObject {")
        dtsExportEntryPrinter.write("\(klass.name): {")
        jsPrinter.write("class \(klass.name) extends SwiftHeapObject {")

        // Always add __construct and constructor methods for all classes
        jsPrinter.indent {
            jsPrinter.write("static __construct(ptr) {")
            jsPrinter.indent {
                jsPrinter.write(
                    "return SwiftHeapObject.__wrap(ptr, instance.exports.bjs_\(klass.name)_deinit, \(klass.name).prototype);"
                )
            }
            jsPrinter.write("}")
            jsPrinter.nextLine()
        }

        if let constructor: ExportedConstructor = klass.constructor {
            let thunkBuilder = ExportedThunkBuilder(effects: constructor.effects)
            for param in constructor.parameters {
                try thunkBuilder.lowerParameter(param: param)
            }

            jsPrinter.indent {
                jsPrinter.write("constructor(\(constructor.parameters.map { $0.name }.joined(separator: ", "))) {")
                let returnExpr = thunkBuilder.callConstructor(abiName: constructor.abiName)
                jsPrinter.indent {
                    jsPrinter.write(contentsOf: thunkBuilder.body)
                    jsPrinter.write(contentsOf: thunkBuilder.cleanupCode)
                    jsPrinter.write(lines: thunkBuilder.checkExceptionLines())
                    jsPrinter.write("return \(klass.name).__construct(\(returnExpr));")
                }
                jsPrinter.write("}")
            }

            dtsExportEntryPrinter.indent {
                dtsExportEntryPrinter.write(
                    "new\(renderTSSignature(parameters: constructor.parameters, returnType: .swiftHeapObject(klass.name), effects: constructor.effects));"
                )
            }
        }

        for method in klass.methods {
            if method.effects.isStatic {
                let thunkBuilder = ExportedThunkBuilder(effects: method.effects)
                for param in method.parameters {
                    try thunkBuilder.lowerParameter(param: param)
                }
                let returnExpr = try thunkBuilder.call(abiName: method.abiName, returnType: method.returnType)

                jsPrinter.indent {
                    jsPrinter.write(
                        lines: thunkBuilder.renderFunction(
                            name: method.name,
                            parameters: method.parameters,
                            returnExpr: returnExpr,
                            declarationPrefixKeyword: "static"
                        )
                    )
                }

                dtsExportEntryPrinter.indent {
                    dtsExportEntryPrinter.write(
                        "\(method.name)\(renderTSSignature(parameters: method.parameters, returnType: method.returnType, effects: method.effects));"
                    )
                }
            } else {
                let thunkBuilder = ExportedThunkBuilder(effects: method.effects)
                thunkBuilder.lowerSelf()
                for param in method.parameters {
                    try thunkBuilder.lowerParameter(param: param)
                }
                let returnExpr = try thunkBuilder.call(abiName: method.abiName, returnType: method.returnType)

                jsPrinter.indent {
                    jsPrinter.write(
                        lines: thunkBuilder.renderFunction(
                            name: method.name,
                            parameters: method.parameters,
                            returnExpr: returnExpr,
                            declarationPrefixKeyword: nil
                        )
                    )
                }

                dtsTypePrinter.indent {
                    dtsTypePrinter.write(
                        "\(method.name)\(renderTSSignature(parameters: method.parameters, returnType: method.returnType, effects: method.effects));"
                    )
                }
            }
        }

        // Generate property getters and setters
        for property in klass.properties {
            if property.isStatic {
                // Generate static property getter
                let getterThunkBuilder = ExportedThunkBuilder(effects: Effects(isAsync: false, isThrows: false))
                let getterReturnExpr = try getterThunkBuilder.call(
                    abiName: property.getterAbiName(),
                    returnType: property.type
                )

                jsPrinter.indent {
                    jsPrinter.write(
                        lines: getterThunkBuilder.renderFunction(
                            name: property.name,
                            parameters: [],
                            returnExpr: getterReturnExpr,
                            declarationPrefixKeyword: "static get"
                        )
                    )
                }

                // Generate static property setter if not readonly
                if !property.isReadonly {
                    let setterThunkBuilder = ExportedThunkBuilder(effects: Effects(isAsync: false, isThrows: false))
                    try setterThunkBuilder.lowerParameter(
                        param: Parameter(label: "value", name: "value", type: property.type)
                    )
                    _ = try setterThunkBuilder.call(
                        abiName: property.setterAbiName(),
                        returnType: .void
                    )

                    jsPrinter.indent {
                        jsPrinter.write(
                            lines: setterThunkBuilder.renderFunction(
                                name: property.name,
                                parameters: [.init(label: nil, name: "value", type: property.type)],
                                returnExpr: nil,
                                declarationPrefixKeyword: "static set"
                            )
                        )
                    }
                }

                // Add static property to TypeScript exports definition (not instance interface)
                let readonly = property.isReadonly ? "readonly " : ""
                dtsExportEntryPrinter.indent {
                    dtsExportEntryPrinter.write("\(readonly)\(property.name): \(property.type.tsType);")
                }
            } else {
                // Generate instance property getter
                let getterThunkBuilder = ExportedThunkBuilder(effects: Effects(isAsync: false, isThrows: false))
                getterThunkBuilder.lowerSelf()
                let getterReturnExpr = try getterThunkBuilder.call(
                    abiName: property.getterAbiName(className: klass.name),
                    returnType: property.type
                )

                jsPrinter.indent {
                    jsPrinter.write(
                        lines: getterThunkBuilder.renderFunction(
                            name: property.name,
                            parameters: [],
                            returnExpr: getterReturnExpr,
                            declarationPrefixKeyword: "get"
                        )
                    )
                }

                // Generate instance property setter if not readonly
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

                    jsPrinter.indent {
                        jsPrinter.write(
                            lines: setterThunkBuilder.renderFunction(
                                name: property.name,
                                parameters: [.init(label: nil, name: "value", type: property.type)],
                                returnExpr: nil,
                                declarationPrefixKeyword: "set"
                            )
                        )
                    }
                }

                // Add instance property to TypeScript interface definition
                let readonly = property.isReadonly ? "readonly " : ""
                dtsTypePrinter.indent {
                    dtsTypePrinter.write("\(readonly)\(property.name): \(property.type.tsType);")
                }
            }
        }

        jsPrinter.write("}")
        dtsTypePrinter.write("}")
        dtsExportEntryPrinter.write("}")

        return (jsPrinter.lines, dtsTypePrinter.lines, dtsExportEntryPrinter.lines)
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
            let printer = CodeFragmentPrinter()

            printer.write("function \(name)(\(parameterNames.joined(separator: ", "))) {")
            printer.indent {
                printer.write("try {")
                printer.indent {
                    printer.write(contentsOf: body)
                    if let returnExpr = returnExpr {
                        printer.write("return \(returnExpr);")
                    }
                }
                printer.write("} catch (error) {")
                printer.indent {
                    printer.write("setException(error);")
                    if let abiReturnType = returnType.abiReturnType {
                        printer.write("return \(abiReturnType.placeholderValue)")
                    }
                }
                printer.write("}")
            }
            printer.write("}")

            return printer.lines
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
        private let importedPrinter: CodeFragmentPrinter = CodeFragmentPrinter()
        private let dtsImportPrinter: CodeFragmentPrinter = CodeFragmentPrinter()
        var importedLines: [String] {
            importedPrinter.lines
        }

        var dtsImportLines: [String] {
            dtsImportPrinter.lines
        }

        init(moduleName: String) {
            self.moduleName = moduleName
            importedPrinter.write(
                "const \(moduleName) = importObject[\"\(moduleName)\"] = importObject[\"\(moduleName)\"] || {};"
            )
        }

        func assignToImportObject(name: String, function: [String]) {
            var js = function
            js[0] = "\(moduleName)[\"\(name)\"] = " + js[0]
            importedPrinter.write(lines: js)
        }

        func appendDts(_ lines: [String]) {
            dtsImportPrinter.write(lines: lines)
        }
    }

    struct NamespaceBuilder {
        private struct NamespaceContent {
            var functions: [ExportedFunction] = []
            var classes: [ExportedClass] = []
            var enums: [ExportedEnum] = []
            var staticProperties: [ExportedProperty] = []
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
                    if function.effects.isStatic,
                        case .namespaceEnum = function.staticContext
                    {
                        // Use the function's namespace property instead of enumName
                        if let namespace = function.namespace {
                            var currentNode = rootNode
                            for part in namespace {
                                currentNode = currentNode.addChild(part)
                            }
                            currentNode.content.functions.append(function)
                        }
                    } else if let namespace = function.namespace {
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

                    if enumDefinition.enumType == .namespace {
                        for function in enumDefinition.staticMethods {
                            var currentNode = rootNode
                            // Build full namespace path: parent namespace + enum name
                            let fullNamespace = (enumDefinition.namespace ?? []) + [enumDefinition.name]
                            for part in fullNamespace {
                                currentNode = currentNode.addChild(part)
                            }
                            currentNode.content.functions.append(function)
                        }

                        // Add static properties to namespace content for TypeScript declarations
                        for property in enumDefinition.staticProperties {
                            var currentNode = rootNode
                            let fullNamespace = (enumDefinition.namespace ?? []) + [enumDefinition.name]
                            for part in fullNamespace {
                                currentNode = currentNode.addChild(part)
                            }
                            if !currentNode.content.staticProperties.contains(where: { $0.name == property.name }) {
                                currentNode.content.staticProperties.append(property)
                            }
                        }
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
                        printer.indent {
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
                        }
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
                                printer.indent {
                                    for (index, enumCase) in enumDefinition.cases.enumerated() {
                                        let caseName = enumCase.name.capitalizedFirstLetter
                                        printer.write("\(caseName) = \(index),")
                                    }
                                }
                                printer.write("}")
                            case .const:
                                printer.write("const \(enumDefinition.name): {")
                                printer.indent {
                                    for (index, enumCase) in enumDefinition.cases.enumerated() {
                                        let caseName = enumCase.name.capitalizedFirstLetter
                                        printer.write("readonly \(caseName): \(index);")
                                    }
                                }
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
                                printer.indent {
                                    for enumCase in enumDefinition.cases {
                                        let caseName = enumCase.name.capitalizedFirstLetter
                                        let rawValue = enumCase.rawValue ?? enumCase.name
                                        let formattedValue = SwiftEnumRawType.formatValue(rawValue, rawType: rawType)
                                        printer.write("\(caseName) = \(formattedValue),")
                                    }
                                }
                                printer.write("}")
                            case .const:
                                printer.write("const \(enumDefinition.name): {")
                                printer.indent {
                                    for enumCase in enumDefinition.cases {
                                        let caseName = enumCase.name.capitalizedFirstLetter
                                        let rawValue = enumCase.rawValue ?? enumCase.name
                                        let formattedValue = SwiftEnumRawType.formatValue(rawValue, rawType: rawType)
                                        printer.write("readonly \(caseName): \(formattedValue);")
                                    }
                                }
                                printer.write("};")
                                printer.write(
                                    "type \(enumDefinition.name) = typeof \(enumDefinition.name)[keyof typeof \(enumDefinition.name)];"
                                )
                            }
                        case .associatedValue:
                            printer.write("const \(enumDefinition.name): {")
                            printer.indent {
                                printer.write("readonly Tag: {")
                                printer.indent {
                                    for (caseIndex, enumCase) in enumDefinition.cases.enumerated() {
                                        let caseName = enumCase.name.capitalizedFirstLetter
                                        printer.write("readonly \(caseName): \(caseIndex);")
                                    }
                                }
                                printer.write("};")
                            }
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
                    let sortedProperties = childNode.content.staticProperties.sorted { $0.name < $1.name }
                    for property in sortedProperties {
                        let readonly = property.isReadonly ? "var " : "let "
                        printer.write("\(readonly)\(property.name): \(property.type.tsType);")
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

        let dtsPrinter = CodeFragmentPrinter()
        dtsPrinter.write("\(type.name): {")
        dtsPrinter.indent {
            dtsPrinter.write(
                "new\(renderTSSignature(parameters: constructor.parameters, returnType: returnType, effects: Effects(isAsync: false, isThrows: false)));"
            )
        }
        dtsPrinter.write("}")

        importObjectBuilder.appendDts(dtsPrinter.lines)
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
        case .optional(let wrappedType):
            return "\(wrappedType.tsType) | null"
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
