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
    private let namespaceBuilder = NamespaceBuilder()

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

    fileprivate struct LinkData {
        var exportsLines: [String] = []
        var classLines: [String] = []
        var dtsExportLines: [String] = []
        var dtsClassLines: [String] = []
        var topLevelTypeLines: [String] = []
        var topLevelDtsTypeLines: [String] = []
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

                if klass.namespace == nil {
                    data.exportsLines.append("\(klass.name),")
                    data.dtsExportLines.append(contentsOf: dtsExportEntry)
                }

                data.dtsClassLines.append(contentsOf: dtsType)
            }

            // Process enums - collect top-level definitions and export entries
            var enumExportEntries: [(js: [String], dts: [String])] = []
            for enumDefinition in skeleton.enums {
                let (jsTopLevel, jsExportEntry, dtsType, dtsExportEntry) = try renderExportedEnum(enumDefinition)

                // Add top-level JS const definition
                if enumDefinition.enumType != .namespace {
                    var exportedJsEnum = jsTopLevel
                    if !exportedJsEnum.isEmpty && exportedJsEnum[0].hasPrefix("const ") {
                        exportedJsEnum[0] = "export " + exportedJsEnum[0]
                    }
                    data.topLevelTypeLines.append(contentsOf: exportedJsEnum)
                    data.topLevelDtsTypeLines.append(contentsOf: dtsType)
                }

                if !jsExportEntry.isEmpty || !dtsExportEntry.isEmpty {
                    enumExportEntries.append((js: jsExportEntry, dts: dtsExportEntry))
                }
            }

            var structExportEntries: [(js: [String], dts: [String])] = []
            for structDefinition in skeleton.structs {
                let (jsStruct, dtsType, dtsExportEntry) = try renderExportedStruct(structDefinition)
                data.topLevelDtsTypeLines.append(contentsOf: dtsType)

                if structDefinition.namespace == nil && (!jsStruct.isEmpty || !dtsExportEntry.isEmpty) {
                    structExportEntries.append((js: jsStruct, dts: dtsExportEntry))
                }
            }

            // Process functions
            for function in skeleton.functions {
                if function.namespace == nil {
                    var (js, dts) = try renderExportedFunction(function: function)
                    js[0] = "\(function.name): " + js[0]
                    js[js.count - 1] += ","
                    data.exportsLines.append(contentsOf: js)
                    data.dtsExportLines.append(contentsOf: dts)
                }
            }

            for entry in enumExportEntries {
                data.exportsLines.append(contentsOf: entry.js)
                data.dtsExportLines.append(contentsOf: entry.dts)
            }

            for entry in structExportEntries {
                data.exportsLines.append(contentsOf: entry.js)
                data.dtsExportLines.append(contentsOf: entry.dts)
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

        for skeleton in exportedSkeletons {
            if !skeleton.protocols.isEmpty {
                let importObjectBuilder: ImportObjectBuilder
                if let existingBuilder = data.importObjectBuilders.first(where: { $0.moduleName == skeleton.moduleName }
                ) {
                    importObjectBuilder = existingBuilder
                } else {
                    importObjectBuilder = ImportObjectBuilder(moduleName: skeleton.moduleName)
                    data.importObjectBuilders.append(importObjectBuilder)
                }

                for proto in skeleton.protocols {
                    for property in proto.properties {
                        try renderProtocolProperty(
                            importObjectBuilder: importObjectBuilder,
                            protocol: proto,
                            property: property
                        )
                    }
                    for method in proto.methods {
                        try renderProtocolMethod(
                            importObjectBuilder: importObjectBuilder,
                            protocol: proto,
                            method: method
                        )
                    }
                }
            }
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
            "let \(JSGlueVariableScope.reservedTmpRetPointers) = [];",
            "let \(JSGlueVariableScope.reservedTmpParamPointers) = [];",
        ]

        let hasStructs = exportedSkeletons.contains { skeleton in
            !skeleton.structs.isEmpty
        }

        if hasAssociatedValueEnums {
            declarations.append("const enumHelpers = {};")
        }

        if hasStructs {
            declarations.append("const structHelpers = {};")
        }

        declarations.append("")
        declarations.append("let _exports = null;")
        declarations.append("let bjs = null;")

        return declarations
    }

    /// Checks if a skeleton contains any closure types
    private func hasClosureTypes(in skeleton: ExportedSkeleton) -> Bool {
        for function in skeleton.functions {
            if containsClosureType(in: function.parameters) || containsClosureType(in: function.returnType) {
                return true
            }
        }
        for klass in skeleton.classes {
            if let constructor = klass.constructor, containsClosureType(in: constructor.parameters) {
                return true
            }
            for method in klass.methods {
                if containsClosureType(in: method.parameters) || containsClosureType(in: method.returnType) {
                    return true
                }
            }
            for property in klass.properties {
                if containsClosureType(in: property.type) {
                    return true
                }
            }
        }
        return false
    }

    private func containsClosureType(in parameters: [Parameter]) -> Bool {
        parameters.contains { containsClosureType(in: $0.type) }
    }

    private func containsClosureType(in type: BridgeType) -> Bool {
        switch type {
        case .closure:
            return true
        case .optional(let wrapped):
            return containsClosureType(in: wrapped)
        default:
            return false
        }
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
                    "bjs = {};",
                    "importObject[\"bjs\"] = bjs;",
                ])
                if self.importedSkeletons.count > 0 {
                    printer.write(lines: [
                        "const imports = options.getImports(importsContext);"
                    ])
                }
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
                printer.write("bjs[\"swift_js_push_pointer\"] = function(pointer) {")
                printer.indent {
                    printer.write("\(JSGlueVariableScope.reservedTmpRetPointers).push(pointer);")
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_pop_param_pointer\"] = function() {")
                printer.indent {
                    printer.write("return \(JSGlueVariableScope.reservedTmpParamPointers).pop();")
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
                printer.write("bjs[\"swift_js_get_optional_int_presence\"] = function() {")
                printer.indent {
                    printer.write("return \(JSGlueVariableScope.reservedStorageToReturnOptionalInt) != null ? 1 : 0;")
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_get_optional_int_value\"] = function() {")
                printer.indent {
                    printer.write("const value = \(JSGlueVariableScope.reservedStorageToReturnOptionalInt);")
                    printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalInt) = undefined;")
                    printer.write("return value;")
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_get_optional_string\"] = function() {")
                printer.indent {
                    printer.write("const str = \(JSGlueVariableScope.reservedStorageToReturnString);")
                    printer.write("\(JSGlueVariableScope.reservedStorageToReturnString) = undefined;")
                    printer.write("if (str == null) {")
                    printer.indent {
                        printer.write("return -1;")
                    }
                    printer.write("} else {")
                    printer.indent {
                        printer.write("const bytes = \(JSGlueVariableScope.reservedTextEncoder).encode(str);")
                        printer.write("\(JSGlueVariableScope.reservedStorageToReturnBytes) = bytes;")
                        printer.write("return bytes.length;")
                    }
                    printer.write("}")
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_get_optional_float_presence\"] = function() {")
                printer.indent {
                    printer.write("return \(JSGlueVariableScope.reservedStorageToReturnOptionalFloat) != null ? 1 : 0;")
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_get_optional_float_value\"] = function() {")
                printer.indent {
                    printer.write("const value = \(JSGlueVariableScope.reservedStorageToReturnOptionalFloat);")
                    printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalFloat) = undefined;")
                    printer.write("return value;")
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_get_optional_double_presence\"] = function() {")
                printer.indent {
                    printer.write(
                        "return \(JSGlueVariableScope.reservedStorageToReturnOptionalDouble) != null ? 1 : 0;"
                    )
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_get_optional_double_value\"] = function() {")
                printer.indent {
                    printer.write("const value = \(JSGlueVariableScope.reservedStorageToReturnOptionalDouble);")
                    printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalDouble) = undefined;")
                    printer.write("return value;")
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_get_optional_heap_object_pointer\"] = function() {")
                printer.indent {
                    printer.write("const pointer = \(JSGlueVariableScope.reservedStorageToReturnOptionalHeapObject);")
                    printer.write("\(JSGlueVariableScope.reservedStorageToReturnOptionalHeapObject) = undefined;")
                    printer.write("return pointer || 0;")
                }
                printer.write("}")

                for skeleton in exportedSkeletons {
                    var closureSignatures: Set<ClosureSignature> = []
                    collectClosureSignatures(from: skeleton, into: &closureSignatures)

                    guard !closureSignatures.isEmpty else { continue }

                    for signature in closureSignatures.sorted(by: { $0.mangleName < $1.mangleName }) {
                        let invokeFuncName = "invoke_js_callback_\(skeleton.moduleName)_\(signature.mangleName)"
                        printer.write(
                            lines: generateInvokeFunction(
                                signature: signature,
                                functionName: invokeFuncName
                            )
                        )

                        let lowerFuncName = "lower_closure_\(skeleton.moduleName)_\(signature.mangleName)"
                        printer.write(
                            lines: generateLowerClosureFunction(
                                signature: signature,
                                functionName: lowerFuncName
                            )
                        )
                    }
                }
            }
        }

        return printer
    }

    private func collectClosureSignatures(from skeleton: ExportedSkeleton, into signatures: inout Set<ClosureSignature>)
    {
        for function in skeleton.functions {
            collectClosureSignatures(from: function.parameters, into: &signatures)
            collectClosureSignatures(from: function.returnType, into: &signatures)
        }
        for klass in skeleton.classes {
            if let constructor = klass.constructor {
                collectClosureSignatures(from: constructor.parameters, into: &signatures)
            }
            for method in klass.methods {
                collectClosureSignatures(from: method.parameters, into: &signatures)
                collectClosureSignatures(from: method.returnType, into: &signatures)
            }
            for property in klass.properties {
                collectClosureSignatures(from: property.type, into: &signatures)
            }
        }
    }

    private func collectClosureSignatures(from parameters: [Parameter], into signatures: inout Set<ClosureSignature>) {
        for param in parameters {
            collectClosureSignatures(from: param.type, into: &signatures)
        }
    }

    private func collectClosureSignatures(from type: BridgeType, into signatures: inout Set<ClosureSignature>) {
        switch type {
        case .closure(let signature):
            signatures.insert(signature)
            for paramType in signature.parameters {
                collectClosureSignatures(from: paramType, into: &signatures)
            }
            collectClosureSignatures(from: signature.returnType, into: &signatures)
        case .optional(let wrapped):
            collectClosureSignatures(from: wrapped, into: &signatures)
        default:
            break
        }
    }

    private func generateInvokeFunction(
        signature: ClosureSignature,
        functionName: String
    ) -> [String] {
        let printer = CodeFragmentPrinter()
        let scope = JSGlueVariableScope()
        let cleanupCode = CodeFragmentPrinter()

        // Build parameter list for invoke function
        var invokeParams: [String] = ["callbackId"]
        for (index, paramType) in signature.parameters.enumerated() {
            if case .optional = paramType {
                invokeParams.append("param\(index)IsSome")
                invokeParams.append("param\(index)Value")
            } else {
                invokeParams.append("param\(index)Id")
            }
        }

        printer.nextLine()
        printer.write("bjs[\"\(functionName)\"] = function(\(invokeParams.joined(separator: ", "))) {")
        printer.indent {
            printer.write("try {")
            printer.indent {
                printer.write("const callback = \(JSGlueVariableScope.reservedSwift).memory.getObject(callbackId);")

                for (index, paramType) in signature.parameters.enumerated() {
                    let fragment = try! IntrinsicJSFragment.closureLiftParameter(type: paramType)
                    let args: [String]
                    if case .optional = paramType {
                        args = ["param\(index)IsSome", "param\(index)Value", "param\(index)"]
                    } else {
                        args = ["param\(index)Id", "param\(index)"]
                    }
                    _ = fragment.printCode(args, scope, printer, cleanupCode)
                }

                let callbackParams = signature.parameters.indices.map { "param\($0)" }.joined(separator: ", ")
                printer.write("const result = callback(\(callbackParams));")

                // Type check if needed (for example, formatName requires string return)
                switch signature.returnType {
                case .string:
                    printer.write("if (typeof result !== \"string\") {")
                    printer.indent {
                        printer.write("throw new TypeError(\"Callback must return a string\");")
                    }
                    printer.write("}")
                default:
                    break
                }

                let returnFragment = try! IntrinsicJSFragment.closureLowerReturn(type: signature.returnType)
                _ = returnFragment.printCode(["result"], scope, printer, cleanupCode)
            }
            printer.write("} catch (error) {")
            printer.indent {
                printer.write("\(JSGlueVariableScope.reservedSetException)?.(error);")
                let errorFragment = IntrinsicJSFragment.closureErrorReturn(type: signature.returnType)
                _ = errorFragment.printCode([], scope, printer, cleanupCode)
            }
            printer.write("}")
        }
        printer.write("};")

        return printer.lines
    }

    /// Generates a lower_closure_* function that wraps a Swift closure for JavaScript
    private func generateLowerClosureFunction(
        signature: ClosureSignature,
        functionName: String
    ) -> [String] {
        let printer = CodeFragmentPrinter()
        let scope = JSGlueVariableScope()
        let cleanupCode = CodeFragmentPrinter()

        printer.nextLine()
        printer.write("bjs[\"\(functionName)\"] = function(closurePtr) {")
        printer.indent {
            printer.write(
                "return function(\(signature.parameters.indices.map { "param\($0)" }.joined(separator: ", "))) {"
            )
            printer.indent {
                printer.write("try {")
                printer.indent {
                    var invokeArgs: [String] = ["closurePtr"]

                    for (index, paramType) in signature.parameters.enumerated() {
                        let paramName = "param\(index)"
                        let fragment = try! IntrinsicJSFragment.lowerParameter(type: paramType)
                        let lowered = fragment.printCode([paramName], scope, printer, cleanupCode)
                        invokeArgs.append(contentsOf: lowered)
                    }

                    // Call the Swift invoke function
                    let invokeCall =
                        "\(JSGlueVariableScope.reservedInstance).exports.invoke_swift_closure_\(signature.moduleName)_\(signature.mangleName)(\(invokeArgs.joined(separator: ", ")))"

                    let returnFragment = try! IntrinsicJSFragment.closureLiftReturn(type: signature.returnType)
                    _ = returnFragment.printCode([invokeCall], scope, printer, cleanupCode)
                }
                printer.write("} catch (error) {")
                printer.indent {
                    printer.write("\(JSGlueVariableScope.reservedSetException)?.(error);")
                    switch signature.returnType {
                    case .void:
                        printer.write("return;")
                    default:
                        printer.write("throw error;")
                    }
                }
                printer.write("}")
            }
            printer.write("};")
        }
        printer.write("};")

        return printer.lines
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

        for skeleton in exportedSkeletons {
            for proto in skeleton.protocols {
                printer.write("export interface \(proto.name) {")
                printer.indent {
                    for method in proto.methods {
                        printer.write(
                            "\(method.name)\(renderTSSignature(parameters: method.parameters, returnType: method.returnType, effects: method.effects));"
                        )
                    }
                    for property in proto.properties {
                        let propertySignature =
                            property.isReadonly
                            ? "readonly \(property.name): \(resolveTypeScriptType(property.type));"
                            : "\(property.name): \(resolveTypeScriptType(property.type));"
                        printer.write(propertySignature)
                    }
                }
                printer.write("}")
                printer.nextLine()
            }
        }

        printer.write(lines: data.topLevelDtsTypeLines)

        // Generate Object types for const-style enums
        for skeleton in exportedSkeletons {
            for enumDefinition in skeleton.enums
            where enumDefinition.enumType != .namespace && enumDefinition.emitStyle != .tsEnum {
                let enumValuesName = enumDefinition.valuesName
                let enumObjectName = enumDefinition.objectTypeName

                // Use fully-qualified path for namespaced enums
                let fullEnumValuesPath: String
                if let namespace = enumDefinition.namespace, !namespace.isEmpty {
                    fullEnumValuesPath = namespace.joined(separator: ".") + "." + enumValuesName
                } else {
                    fullEnumValuesPath = enumValuesName
                }

                if !enumDefinition.staticMethods.isEmpty || !enumDefinition.staticProperties.isEmpty {
                    printer.write("export type \(enumObjectName) = typeof \(fullEnumValuesPath) & {")
                    printer.indent {
                        for function in enumDefinition.staticMethods {
                            printer.write(
                                "\(function.name)\(renderTSSignature(parameters: function.parameters, returnType: function.returnType, effects: function.effects));"
                            )
                        }
                        for property in enumDefinition.staticProperties {
                            let readonly = property.isReadonly ? "readonly " : ""
                            printer.write("\(readonly)\(property.name): \(resolveTypeScriptType(property.type));")
                        }
                    }
                    printer.write("};")
                } else {
                    printer.write("export type \(enumObjectName) = typeof \(fullEnumValuesPath);")
                }
                printer.nextLine()
            }
        }

        // Type definitions section (namespace declarations, class definitions, imported types)
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
            // Add non-namespaced items
            printer.write(lines: data.dtsExportLines)

            // Add hierarchical namespaced items
            let hierarchicalLines = namespaceBuilder.buildHierarchicalExportsType(
                exportedSkeletons: exportedSkeletons,
                renderClassEntry: { klass in
                    let printer = CodeFragmentPrinter()
                    printer.write("\(klass.name): {")
                    printer.indent {
                        if let constructor = klass.constructor {
                            printer.write(
                                "new\(self.renderTSSignature(parameters: constructor.parameters, returnType: .swiftHeapObject(klass.name), effects: constructor.effects));"
                            )
                        }
                    }
                    printer.write("}")
                    return printer.lines
                },
                renderFunctionSignature: { function in
                    "\(function.name)\(self.renderTSSignature(parameters: function.parameters, returnType: function.returnType, effects: function.effects));"
                }
            )
            printer.write(lines: hierarchicalLines)
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
    private func generateJavaScript(data: LinkData) throws -> String {
        let header = """
            // NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
            // DO NOT EDIT.
            //
            // To update this file, just rebuild your project or run
            // `swift package bridge-js`.
            """
        let printer = CodeFragmentPrinter(header: header)
        printer.nextLine()

        printer.write(lines: data.topLevelTypeLines)

        let topLevelNamespaceCode = namespaceBuilder.buildTopLevelNamespaceInitialization(
            exportedSkeletons: exportedSkeletons
        )
        printer.write(lines: topLevelNamespaceCode)

        // Main function declaration
        printer.write("export async function createInstantiator(options, \(JSGlueVariableScope.reservedSwift)) {")

        printer.indent {
            printer.write(lines: generateVariableDeclarations())

            let allStructs = exportedSkeletons.flatMap { $0.structs }
            for structDef in allStructs {
                let structPrinter = CodeFragmentPrinter()
                let structScope = JSGlueVariableScope()
                let structCleanup = CodeFragmentPrinter()
                let fragment = IntrinsicJSFragment.structHelper(structDefinition: structDef, allStructs: allStructs)
                _ = fragment.printCode([structDef.name], structScope, structPrinter, structCleanup)
                printer.write(lines: structPrinter.lines)
            }
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
        try printer.indent {
            printer.write(lines: [
                "/** @param {WebAssembly.Instance} instance */",
                "createExports: (instance) => {",
            ])
            try printer.indent {
                printer.write("const js = \(JSGlueVariableScope.reservedSwift).memory.heap;")

                printer.write(lines: data.classLines)

                // Struct helpers must be initialized AFTER classes are defined (to allow _exports access)
                printer.write(contentsOf: structHelperAssignments())
                let namespaceInitCode = namespaceBuilder.buildNamespaceInitialization(
                    exportedSkeletons: exportedSkeletons
                )
                printer.write(lines: namespaceInitCode)

                let propertyAssignments = try generateNamespacePropertyAssignments(
                    data: data,
                    exportedSkeletons: exportedSkeletons,
                    namespaceBuilder: namespaceBuilder
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
        let outputJs = try generateJavaScript(data: data)
        let outputDts = generateTypeScript(data: data)
        return (outputJs, outputDts)
    }

    private func enumHelperAssignments() -> CodeFragmentPrinter {
        let printer = CodeFragmentPrinter()

        for skeleton in exportedSkeletons {
            for enumDef in skeleton.enums where enumDef.enumType == .associatedValue {
                printer.write(
                    "const \(enumDef.name)Helpers = __bjs_create\(enumDef.valuesName)Helpers()(\(JSGlueVariableScope.reservedTmpParamInts), \(JSGlueVariableScope.reservedTmpParamF32s), \(JSGlueVariableScope.reservedTmpParamF64s), \(JSGlueVariableScope.reservedTextEncoder), \(JSGlueVariableScope.reservedSwift));"
                )
                printer.write("enumHelpers.\(enumDef.name) = \(enumDef.name)Helpers;")
                printer.nextLine()
            }
        }

        return printer
    }

    private func structHelperAssignments() -> CodeFragmentPrinter {
        let printer = CodeFragmentPrinter()

        for skeleton in exportedSkeletons {
            for structDef in skeleton.structs {
                printer.write(
                    "const \(structDef.name)Helpers = __bjs_create\(structDef.name)Helpers()(\(JSGlueVariableScope.reservedTmpParamInts), \(JSGlueVariableScope.reservedTmpParamF32s), \(JSGlueVariableScope.reservedTmpParamF64s), \(JSGlueVariableScope.reservedTmpParamPointers), \(JSGlueVariableScope.reservedTmpRetPointers), \(JSGlueVariableScope.reservedTextEncoder), \(JSGlueVariableScope.reservedSwift), enumHelpers);"
                )
                printer.write("structHelpers.\(structDef.name) = \(structDef.name)Helpers;")
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
        for (moduleName, classes) in modulesByName.sorted(by: { $0.key < $1.key }) {
            wrapperLines.append("// Wrapper functions for module: \(moduleName)")
            wrapperLines.append("if (!importObject[\"\(moduleName)\"]) {")
            wrapperLines.append("    importObject[\"\(moduleName)\"] = {};")
            wrapperLines.append("}")

            for klass in classes.sorted(by: { $0.name < $1.name }) {
                let wrapperFunctionName = "bjs_\(klass.name)_wrap"
                wrapperLines.append("importObject[\"\(moduleName)\"][\"\(wrapperFunctionName)\"] = function(pointer) {")
                wrapperLines.append("    const obj = \(klass.name).__construct(pointer);")
                wrapperLines.append("    return \(JSGlueVariableScope.reservedSwift).memory.retain(obj);")
                wrapperLines.append("};")
            }
        }

        return wrapperLines
    }

    private func generateNamespacePropertyAssignments(
        data: LinkData,
        exportedSkeletons: [ExportedSkeleton],
        namespaceBuilder: NamespaceBuilder
    ) throws -> [String] {
        let printer = CodeFragmentPrinter()

        // Only include enum static assignments for modules with exposeToGlobal
        let hasAnyGlobalExposure = exportedSkeletons.contains { $0.exposeToGlobal }
        if hasAnyGlobalExposure {
            printer.write(lines: data.enumStaticAssignments)
        }

        printer.write("const exports = {")
        try printer.indent {
            printer.write(lines: data.exportsLines.map { "\($0)" })

            let hierarchicalLines = try namespaceBuilder.buildHierarchicalExportsObject(
                exportedSkeletons: exportedSkeletons,
                renderFunctionImpl: { function in
                    let (js, _) = try self.renderExportedFunction(function: function)
                    return js
                }
            )
            printer.write(lines: hierarchicalLines)
        }
        printer.write("};")
        printer.write("_exports = exports;")

        let globalThisLines = namespaceBuilder.buildGlobalThisAssignments(exportedSkeletons: exportedSkeletons)
        printer.write(lines: globalThisLines)

        printer.write("return exports;")

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
                            ? "readonly \(property.name): \(resolveTypeScriptType(property.type));"
                            : "\(property.name): \(resolveTypeScriptType(property.type));"
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

        /// Renders the thunk body (body code, cleanup, exception handling, and optional return) into a printer.
        func renderFunctionBody(into printer: CodeFragmentPrinter, returnExpr: String?) {
            printer.write(contentsOf: body)
            printer.write(contentsOf: cleanupCode)
            printer.write(lines: checkExceptionLines())
            if let returnExpr = returnExpr {
                printer.write("return \(returnExpr);")
            }
        }

        func renderFunction(
            name: String,
            parameters: [Parameter],
            returnExpr: String?,
            declarationPrefixKeyword: String?
        ) -> [String] {
            let printer = CodeFragmentPrinter()

            let parameterList = DefaultValueUtils.formatParameterList(parameters)

            printer.write(
                "\(declarationPrefixKeyword.map { "\($0) "} ?? "")\(name)(\(parameterList)) {"
            )
            printer.indent {
                renderFunctionBody(into: printer, returnExpr: returnExpr)
            }
            printer.write("}")

            return printer.lines
        }
    }

    /// Returns TypeScript type string for a BridgeType, using full paths for enums
    /// If the type is an enum, looks up the ExportedEnum and uses its tsFullPath
    /// Otherwise, uses the default tsType property
    private func resolveTypeScriptType(_ type: BridgeType) -> String {
        return Self.resolveTypeScriptType(type, exportedSkeletons: exportedSkeletons)
    }

    /// Static helper for resolving TypeScript types with full enum paths
    /// Can be used by both BridgeJSLink and NamespaceBuilder
    fileprivate static func resolveTypeScriptType(_ type: BridgeType, exportedSkeletons: [ExportedSkeleton]) -> String {
        switch type {
        case .caseEnum(let name), .rawValueEnum(let name, _),
            .associatedValueEnum(let name), .namespaceEnum(let name):
            // Look up the enum to get its tsFullPath
            for skeleton in exportedSkeletons {
                for enumDef in skeleton.enums {
                    if enumDef.name == name || enumDef.swiftCallName == name {
                        // Use the stored tsFullPath which has the full namespace
                        switch type {
                        case .namespaceEnum:
                            return enumDef.tsFullPath
                        default:
                            return "\(enumDef.tsFullPath)Tag"
                        }
                    }
                }
            }
            return type.tsType
        case .swiftStruct(let name):
            return name.components(separatedBy: ".").last ?? name
        case .optional(let wrapped):
            return "\(resolveTypeScriptType(wrapped, exportedSkeletons: exportedSkeletons)) | null"
        default:
            return type.tsType
        }
    }

    private func renderTSSignature(parameters: [Parameter], returnType: BridgeType, effects: Effects) -> String {
        let returnTypeWithEffect: String
        if effects.isAsync {
            returnTypeWithEffect = "Promise<\(resolveTypeScriptType(returnType))>"
        } else {
            returnTypeWithEffect = resolveTypeScriptType(returnType)
        }
        let parameterSignatures = parameters.map { param in
            let optional = param.hasDefault ? "?" : ""
            return "\(param.name)\(optional): \(resolveTypeScriptType(param.type))"
        }
        return "(\(parameterSignatures.joined(separator: ", "))): \(returnTypeWithEffect)"
    }

    /// Helper method to append JSDoc comments for parameters with default values
    private func appendJSDocIfNeeded(for parameters: [Parameter], to lines: inout [String]) {
        let jsDocLines = DefaultValueUtils.formatJSDoc(for: parameters)
        lines.append(contentsOf: jsDocLines)
    }

    func renderExportedStruct(
        _ structDefinition: ExportedStruct
    ) throws -> (js: [String], dtsType: [String], dtsExportEntry: [String]) {
        let structName = structDefinition.name
        let hasConstructor = structDefinition.constructor != nil
        let staticMethods = structDefinition.methods.filter { $0.effects.isStatic }
        let staticProperties = structDefinition.properties.filter { $0.isStatic }

        let dtsTypePrinter = CodeFragmentPrinter()
        dtsTypePrinter.write("export interface \(structName) {")
        let instanceProps = structDefinition.properties.filter { !$0.isStatic }
        dtsTypePrinter.indent {
            for property in instanceProps {
                let tsType = resolveTypeScriptType(property.type)
                dtsTypePrinter.write("\(property.name): \(tsType);")
            }
            for method in structDefinition.methods where !method.effects.isStatic {
                let jsDocLines = DefaultValueUtils.formatJSDoc(for: method.parameters)
                dtsTypePrinter.write(lines: jsDocLines)
                let signature = renderTSSignature(
                    parameters: method.parameters,
                    returnType: method.returnType,
                    effects: method.effects
                )
                dtsTypePrinter.write("\(method.name)\(signature);")
            }
        }
        dtsTypePrinter.write("}")

        guard hasConstructor || !staticMethods.isEmpty || !staticProperties.isEmpty else {
            return (js: [], dtsType: dtsTypePrinter.lines, dtsExportEntry: [])
        }

        let jsPrinter = CodeFragmentPrinter()
        jsPrinter.write("\(structName): {")
        try jsPrinter.indent {
            // Constructor as 'init' function
            if let constructor = structDefinition.constructor {
                let thunkBuilder = ExportedThunkBuilder(effects: constructor.effects)
                for param in constructor.parameters {
                    try thunkBuilder.lowerParameter(param: param)
                }
                let returnExpr = try thunkBuilder.call(
                    abiName: constructor.abiName,
                    returnType: .swiftStruct(structDefinition.swiftCallName)
                )

                let constructorPrinter = CodeFragmentPrinter()
                let paramList = DefaultValueUtils.formatParameterList(constructor.parameters)
                constructorPrinter.write("init: function(\(paramList)) {")
                constructorPrinter.indent {
                    thunkBuilder.renderFunctionBody(into: constructorPrinter, returnExpr: returnExpr)
                }
                constructorPrinter.write("},")
                jsPrinter.write(lines: constructorPrinter.lines)
            }

            for property in staticProperties {
                let propertyLines = try renderStaticPropertyForExportObject(
                    property: property,
                    className: structName
                )
                jsPrinter.write(lines: propertyLines)
            }

            for method in staticMethods {
                let methodLines = try renderStaticMethodForExportObject(method: method)
                jsPrinter.write(lines: methodLines)
            }
        }
        jsPrinter.write("},")

        let dtsExportEntryPrinter = CodeFragmentPrinter()
        dtsExportEntryPrinter.write("\(structName): {")
        dtsExportEntryPrinter.indent {
            if let constructor = structDefinition.constructor {
                let jsDocLines = DefaultValueUtils.formatJSDoc(for: constructor.parameters)
                dtsExportEntryPrinter.write(lines: jsDocLines)
                dtsExportEntryPrinter.write(
                    "init\(renderTSSignature(parameters: constructor.parameters, returnType: .swiftStruct(structDefinition.swiftCallName), effects: constructor.effects));"
                )
            }
            for property in staticProperties {
                let readonly = property.isReadonly ? "readonly " : ""
                dtsExportEntryPrinter.write("\(readonly)\(property.name): \(resolveTypeScriptType(property.type));")
            }
            for method in staticMethods {
                let jsDocLines = DefaultValueUtils.formatJSDoc(for: method.parameters)
                dtsExportEntryPrinter.write(lines: jsDocLines)
                dtsExportEntryPrinter.write(
                    "\(method.name)\(renderTSSignature(parameters: method.parameters, returnType: method.returnType, effects: method.effects));"
                )
            }
        }
        dtsExportEntryPrinter.write("}")

        return (js: jsPrinter.lines, dtsType: dtsTypePrinter.lines, dtsExportEntry: dtsExportEntryPrinter.lines)
    }

    func renderExportedEnum(
        _ enumDefinition: ExportedEnum
    ) throws -> (jsTopLevel: [String], jsExportEntry: [String], dtsType: [String], dtsExportEntry: [String]) {
        var jsTopLevelLines: [String] = []
        var dtsTypeLines: [String] = []
        let scope = JSGlueVariableScope()
        let cleanup = CodeFragmentPrinter()
        let printer = CodeFragmentPrinter()
        let enumValuesName = enumDefinition.valuesName

        switch enumDefinition.enumType {
        case .simple:
            let fragment = IntrinsicJSFragment.simpleEnumHelper(enumDefinition: enumDefinition)
            _ = fragment.printCode([enumValuesName], scope, printer, cleanup)
            jsTopLevelLines.append(contentsOf: printer.lines)
        case .rawValue:
            guard enumDefinition.rawType != nil else {
                throw BridgeJSLinkError(message: "Raw value enum \(enumDefinition.name) is missing rawType")
            }

            let fragment = IntrinsicJSFragment.rawValueEnumHelper(enumDefinition: enumDefinition)
            _ = fragment.printCode([enumValuesName], scope, printer, cleanup)
            jsTopLevelLines.append(contentsOf: printer.lines)
        case .associatedValue:
            let fragment = IntrinsicJSFragment.associatedValueEnumHelper(enumDefinition: enumDefinition)
            _ = fragment.printCode([enumValuesName], scope, printer, cleanup)
            jsTopLevelLines.append(contentsOf: printer.lines)
        case .namespace:
            break
        }

        if enumDefinition.namespace == nil {
            dtsTypeLines.append(contentsOf: generateDeclarations(enumDefinition: enumDefinition))
        }

        var jsExportEntryLines: [String] = []
        var dtsExportEntryLines: [String] = []

        if enumDefinition.enumType != .namespace
            && enumDefinition.emitStyle != .tsEnum
            && enumDefinition.namespace == nil
        {
            var enumMethodLines: [String] = []
            for function in enumDefinition.staticMethods {
                let methodLines = try renderStaticMethodForExportObject(method: function)
                enumMethodLines.append(contentsOf: methodLines)
            }

            var enumPropertyLines: [String] = []
            for property in enumDefinition.staticProperties {
                let propertyLines = try renderStaticPropertyForExportObject(
                    property: property,
                    className: nil
                )
                enumPropertyLines.append(contentsOf: propertyLines)
            }

            let exportsPrinter = CodeFragmentPrinter()

            if !enumMethodLines.isEmpty || !enumPropertyLines.isEmpty {
                exportsPrinter.write("\(enumDefinition.name): {")
                exportsPrinter.indent {
                    exportsPrinter.write("...\(enumValuesName),")
                    var allLines = enumMethodLines + enumPropertyLines
                    if let lastLineIndex = allLines.indices.last, allLines[lastLineIndex].hasSuffix(",") {
                        allLines[lastLineIndex] = String(allLines[lastLineIndex].dropLast())
                    }
                    exportsPrinter.write(lines: allLines)
                }
                exportsPrinter.write("},")
            } else {
                exportsPrinter.write("\(enumDefinition.name): \(enumValuesName),")
            }

            jsExportEntryLines = exportsPrinter.lines
            dtsExportEntryLines = ["\(enumDefinition.name): \(enumDefinition.objectTypeName)"]
        }

        return (jsTopLevelLines, jsExportEntryLines, dtsTypeLines, dtsExportEntryLines)
    }

    private func generateDeclarations(enumDefinition: ExportedEnum) -> [String] {
        let printer = CodeFragmentPrinter()
        let enumValuesName = enumDefinition.valuesName

        switch enumDefinition.emitStyle {
        case .tsEnum:
            switch enumDefinition.enumType {
            case .simple, .rawValue:
                printer.write("export enum \(enumDefinition.name) {")
                printer.indent {
                    for (index, enumCase) in enumDefinition.cases.enumerated() {
                        let caseName = enumCase.name.capitalizedFirstLetter
                        let value = enumCase.jsValue(
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
            printer.write("export const \(enumValuesName): {")
            switch enumDefinition.enumType {
            case .simple, .rawValue:
                printer.indent {
                    for (index, enumCase) in enumDefinition.cases.enumerated() {
                        let caseName = enumCase.name.capitalizedFirstLetter
                        let value = enumCase.jsValue(
                            rawType: enumDefinition.rawType,
                            index: index
                        )
                        printer.write("readonly \(caseName): \(value);")
                    }

                }
                printer.write("};")
                printer.write(
                    "export type \(enumDefinition.name)Tag = typeof \(enumValuesName)[keyof typeof \(enumValuesName)];"
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

                }
                printer.write("};")
                printer.nextLine()

                var unionParts: [String] = []
                for enumCase in enumDefinition.cases {
                    if enumCase.associatedValues.isEmpty {
                        unionParts.append(
                            "{ tag: typeof \(enumValuesName).Tag.\(enumCase.name.capitalizedFirstLetter) }"
                        )
                    } else {
                        var fields: [String] = [
                            "tag: typeof \(enumValuesName).Tag.\(enumCase.name.capitalizedFirstLetter)"
                        ]
                        for (associatedValueIndex, associatedValue) in enumCase.associatedValues.enumerated() {
                            let prop = associatedValue.label ?? "param\(associatedValueIndex)"
                            fields.append("\(prop): \(associatedValue.type.tsType)")
                        }
                        unionParts.append("{ \(fields.joined(separator: "; ")) }")
                    }
                }

                let unionTypeName =
                    enumDefinition.emitStyle == .tsEnum ? enumDefinition.name : "\(enumDefinition.name)Tag"
                printer.write("export type \(unionTypeName) =")
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

        appendJSDocIfNeeded(for: function.parameters, to: &dtsLines)

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
        case .className(let name), .structName(let name):
            return try renderStaticFunction(function: function, className: name)
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

    private func renderStaticFunction(
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

        var dtsLines: [String] = []

        appendJSDocIfNeeded(for: function.parameters, to: &dtsLines)

        dtsLines.append(
            "static \(function.name)\(renderTSSignature(parameters: function.parameters, returnType: function.returnType, effects: function.effects));"
        )

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
            thunkBuilder.renderFunctionBody(into: printer, returnExpr: returnExpr)
        }
        printer.write("},")

        var dtsLines: [String] = []

        appendJSDocIfNeeded(for: function.parameters, to: &dtsLines)

        dtsLines.append(
            "\(function.name)\(renderTSSignature(parameters: function.parameters, returnType: function.returnType, effects: function.effects));"
        )

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

    /// Renders a static method for use in an export object
    private func renderStaticMethodForExportObject(
        method: ExportedFunction
    ) throws -> [String] {
        let thunkBuilder = ExportedThunkBuilder(effects: method.effects)
        for param in method.parameters {
            try thunkBuilder.lowerParameter(param: param)
        }
        let returnExpr = try thunkBuilder.call(abiName: method.abiName, returnType: method.returnType)

        let methodPrinter = CodeFragmentPrinter()
        methodPrinter.write(
            "\(method.name): function(\(method.parameters.map { $0.name }.joined(separator: ", "))) {"
        )
        methodPrinter.indent {
            thunkBuilder.renderFunctionBody(into: methodPrinter, returnExpr: returnExpr)
        }
        methodPrinter.write("},")
        return methodPrinter.lines
    }

    /// Renders a static property getter/setter for use in an export object
    private func renderStaticPropertyForExportObject(
        property: ExportedProperty,
        className: String?
    ) throws -> [String] {
        let propertyPrinter = CodeFragmentPrinter()

        // Generate getter
        let getterThunkBuilder = ExportedThunkBuilder(effects: Effects(isAsync: false, isThrows: false))
        let getterReturnExpr = try getterThunkBuilder.call(
            abiName: className != nil
                ? property.getterAbiName(className: className!)
                : property.getterAbiName(),
            returnType: property.type
        )

        propertyPrinter.write("get \(property.name)() {")
        propertyPrinter.indent {
            getterThunkBuilder.renderFunctionBody(into: propertyPrinter, returnExpr: getterReturnExpr)
        }
        propertyPrinter.write("},")

        // Generate setter if not readonly
        if !property.isReadonly {
            let setterThunkBuilder = ExportedThunkBuilder(
                effects: Effects(isAsync: false, isThrows: false)
            )
            try setterThunkBuilder.lowerParameter(
                param: Parameter(label: "value", name: "value", type: property.type)
            )
            _ = try setterThunkBuilder.call(
                abiName: className != nil
                    ? property.setterAbiName(className: className!)
                    : property.setterAbiName(),
                returnType: .void
            )

            propertyPrinter.write("set \(property.name)(value) {")
            propertyPrinter.indent {
                setterThunkBuilder.renderFunctionBody(into: propertyPrinter, returnExpr: nil)
            }
            propertyPrinter.write("},")
        }

        return propertyPrinter.lines
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

            let constructorParamList = DefaultValueUtils.formatParameterList(constructor.parameters)

            jsPrinter.indent {
                jsPrinter.write("constructor(\(constructorParamList)) {")
                let returnExpr = thunkBuilder.callConstructor(abiName: constructor.abiName)
                jsPrinter.indent {
                    thunkBuilder.renderFunctionBody(
                        into: jsPrinter,
                        returnExpr: "\(klass.name).__construct(\(returnExpr))"
                    )
                }
                jsPrinter.write("}")
            }

            dtsExportEntryPrinter.indent {
                let jsDocLines = DefaultValueUtils.formatJSDoc(for: constructor.parameters)
                for line in jsDocLines {
                    dtsExportEntryPrinter.write(line)
                }
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
            try renderClassProperty(
                property: property,
                className: klass.name,
                isStatic: property.isStatic,
                jsPrinter: jsPrinter,
                dtsPrinter: property.isStatic ? dtsExportEntryPrinter : dtsTypePrinter
            )
        }

        jsPrinter.write("}")
        dtsTypePrinter.write("}")
        dtsExportEntryPrinter.write("}")

        return (jsPrinter.lines, dtsTypePrinter.lines, dtsExportEntryPrinter.lines)
    }

    private func renderClassProperty(
        property: ExportedProperty,
        className: String,
        isStatic: Bool,
        jsPrinter: CodeFragmentPrinter,
        dtsPrinter: CodeFragmentPrinter
    ) throws {
        let getterThunkBuilder = ExportedThunkBuilder(effects: Effects(isAsync: false, isThrows: false))
        if !isStatic {
            getterThunkBuilder.lowerSelf()
        }

        let getterAbiName = isStatic ? property.getterAbiName() : property.getterAbiName(className: className)
        let getterReturnExpr = try getterThunkBuilder.call(abiName: getterAbiName, returnType: property.type)

        let getterKeyword = isStatic ? "static get" : "get"
        jsPrinter.indent {
            jsPrinter.write(
                lines: getterThunkBuilder.renderFunction(
                    name: property.name,
                    parameters: [],
                    returnExpr: getterReturnExpr,
                    declarationPrefixKeyword: getterKeyword
                )
            )
        }

        // Generate setter if not readonly
        if !property.isReadonly {
            let setterThunkBuilder = ExportedThunkBuilder(effects: Effects(isAsync: false, isThrows: false))
            if !isStatic {
                setterThunkBuilder.lowerSelf()
            }
            try setterThunkBuilder.lowerParameter(
                param: Parameter(label: "value", name: "value", type: property.type)
            )

            let setterAbiName = isStatic ? property.setterAbiName() : property.setterAbiName(className: className)
            _ = try setterThunkBuilder.call(abiName: setterAbiName, returnType: .void)

            let setterKeyword = isStatic ? "static set" : "set"
            jsPrinter.indent {
                jsPrinter.write(
                    lines: setterThunkBuilder.renderFunction(
                        name: property.name,
                        parameters: [.init(label: nil, name: "value", type: property.type)],
                        returnExpr: nil,
                        declarationPrefixKeyword: setterKeyword
                    )
                )
            }
        }

        // Add instance property to TypeScript interface definition
        let readonly = property.isReadonly ? "readonly " : ""
        dtsPrinter.indent {
            dtsPrinter.write("\(readonly)\(property.name): \(property.type.tsType);")
        }
    }

    class ImportedThunkBuilder {
        let body: CodeFragmentPrinter
        let scope: JSGlueVariableScope
        let cleanupCode: CodeFragmentPrinter
        let context: BridgeContext
        var parameterNames: [String] = []
        var parameterForwardings: [String] = []

        init(context: BridgeContext = .importTS) {
            self.body = CodeFragmentPrinter()
            self.scope = JSGlueVariableScope()
            self.cleanupCode = CodeFragmentPrinter()
            self.context = context
        }

        func liftSelf() {
            parameterNames.append("self")
        }

        func liftParameter(param: Parameter) throws {
            let liftingFragment = try IntrinsicJSFragment.liftParameter(type: param.type, context: context)
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
                parameterNames.append(contentsOf: valuesToLift)
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
            let loweringFragment = try IntrinsicJSFragment.lowerReturn(type: returnType, context: context)
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
            let loweringFragment = try IntrinsicJSFragment.lowerReturn(type: type, context: context)
            return try lowerReturnValue(returnType: type, returnExpr: call, loweringFragment: loweringFragment)
        }

        func callMethod(name: String, returnType: BridgeType) throws -> String? {
            return try call(
                calleeExpr: "\(JSGlueVariableScope.reservedSwift).memory.getObject(self).\(name)",
                returnType: returnType
            )
        }

        func callPropertyGetter(name: String, returnType: BridgeType) throws -> String? {
            if context == .exportSwift, returnType.usesSideChannelForOptionalReturn() {
                guard case .optional(let wrappedType) = returnType else {
                    fatalError("usesSideChannelForOptionalReturn returned true for non-optional type")
                }

                let resultVar = scope.variable("ret")
                body.write(
                    "let \(resultVar) = \(JSGlueVariableScope.reservedSwift).memory.getObject(self).\(name);"
                )

                let fragment = try IntrinsicJSFragment.protocolPropertyOptionalToSideChannel(wrappedType: wrappedType)
                _ = fragment.printCode([resultVar], scope, body, cleanupCode)

                return nil  // Side-channel types return nil (no direct return value)
            }

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
        func collectAllNamespacePaths(exportedSkeletons: [ExportedSkeleton]) -> Set<[String]> {
            return Set(
                exportedSkeletons.flatMap { skeleton in
                    let itemNamespaces =
                        (skeleton.functions.compactMap(\.namespace) + skeleton.classes.compactMap(\.namespace)
                            + skeleton.enums.filter { $0.namespace != nil && $0.enumType != .namespace }
                            .compactMap(\.namespace))

                    let namespaceEnumPaths = skeleton.enums
                        .filter { $0.enumType == .namespace }
                        .filter { !$0.staticProperties.isEmpty || !$0.staticMethods.isEmpty }
                        .map { ($0.namespace ?? []) + [$0.name] }

                    return itemNamespaces + namespaceEnumPaths
                }
            )
        }

        func buildNamespaceInitialization(exportedSkeletons: [ExportedSkeleton]) -> [String] {
            let globalSkeletons = exportedSkeletons.filter { $0.exposeToGlobal }
            guard !globalSkeletons.isEmpty else { return [] }
            let allNamespacePaths = collectAllNamespacePaths(exportedSkeletons: globalSkeletons)
            return generateNamespaceInitializationCode(namespacePaths: allNamespacePaths)
        }

        func buildTopLevelNamespaceInitialization(
            exportedSkeletons: [ExportedSkeleton]
        ) -> [String] {
            let globalSkeletons = exportedSkeletons.filter { $0.exposeToGlobal }
            guard !globalSkeletons.isEmpty else { return [] }

            var namespacedEnumPaths: Set<[String]> = []
            for skeleton in globalSkeletons {
                for enumDef in skeleton.enums where enumDef.namespace != nil && enumDef.enumType != .namespace {
                    namespacedEnumPaths.insert(enumDef.namespace!)
                }
            }

            let initCode = generateNamespaceInitializationCode(namespacePaths: namespacedEnumPaths)

            let printer = CodeFragmentPrinter()
            printer.write(lines: initCode)

            for skeleton in globalSkeletons {
                for enumDef in skeleton.enums where enumDef.namespace != nil && enumDef.enumType != .namespace {
                    let namespacePath = enumDef.namespace!.joined(separator: ".")
                    printer.write("globalThis.\(namespacePath).\(enumDef.valuesName) = \(enumDef.valuesName);")
                }
            }

            return printer.lines
        }

        func buildGlobalThisAssignments(exportedSkeletons: [ExportedSkeleton]) -> [String] {
            let printer = CodeFragmentPrinter()

            for skeleton in exportedSkeletons where skeleton.exposeToGlobal {
                for klass in skeleton.classes where klass.namespace != nil {
                    let namespacePath = klass.namespace!.joined(separator: ".")
                    printer.write("globalThis.\(namespacePath).\(klass.name) = exports.\(namespacePath).\(klass.name);")
                }
                for function in skeleton.functions where function.namespace != nil {
                    let namespacePath = function.namespace!.joined(separator: ".")
                    printer.write(
                        "globalThis.\(namespacePath).\(function.name) = exports.\(namespacePath).\(function.name);"
                    )
                }
                for enumDef in skeleton.enums where enumDef.enumType == .namespace {
                    for function in enumDef.staticMethods {
                        let fullNamespace = (enumDef.namespace ?? []) + [enumDef.name]
                        let namespacePath = fullNamespace.joined(separator: ".")
                        printer.write(
                            "globalThis.\(namespacePath).\(function.name) = exports.\(namespacePath).\(function.name);"
                        )
                    }
                    for property in enumDef.staticProperties {
                        let fullNamespace = (enumDef.namespace ?? []) + [enumDef.name]
                        let namespacePath = fullNamespace.joined(separator: ".")
                        let exportsPath = "exports.\(namespacePath)"

                        printer.write("Object.defineProperty(globalThis.\(namespacePath), '\(property.name)', {")
                        printer.indent {
                            printer.write("get: () => \(exportsPath).\(property.name),")
                            if !property.isReadonly {
                                printer.write("set: (value) => { \(exportsPath).\(property.name) = value; }")
                            }
                        }
                        printer.write("});")
                    }
                }
            }

            return printer.lines
        }

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

        private struct NamespaceContent {
            var functions: [ExportedFunction] = []
            var classes: [ExportedClass] = []
            var enums: [ExportedEnum] = []
            var staticProperties: [ExportedProperty] = []
            var functionJsLines: [(name: String, lines: [String])] = []
            var functionDtsLines: [(name: String, lines: [String])] = []
            var classDtsLines: [(name: String, lines: [String])] = []
            var enumDtsLines: [(name: String, line: String)] = []
            var propertyJsLines: [String] = []
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

        private func buildExportsTree(
            rootNode: NamespaceNode,
            exportedSkeletons: [ExportedSkeleton]
        ) {
            for skeleton in exportedSkeletons {
                for function in skeleton.functions where function.namespace != nil {
                    var currentNode = rootNode
                    for part in function.namespace! {
                        currentNode = currentNode.addChild(part)
                    }
                    currentNode.content.functions.append(function)
                }

                for klass in skeleton.classes where klass.namespace != nil {
                    var currentNode = rootNode
                    for part in klass.namespace! {
                        currentNode = currentNode.addChild(part)
                    }
                    currentNode.content.classes.append(klass)
                }

                for enumDef in skeleton.enums where enumDef.namespace != nil && enumDef.enumType != .namespace {
                    var currentNode = rootNode
                    for part in enumDef.namespace! {
                        currentNode = currentNode.addChild(part)
                    }
                    currentNode.content.enums.append(enumDef)
                }

                for enumDef in skeleton.enums where enumDef.enumType == .namespace {
                    for property in enumDef.staticProperties {
                        let fullNamespace = (enumDef.namespace ?? []) + [enumDef.name]
                        var currentNode = rootNode
                        for part in fullNamespace {
                            currentNode = currentNode.addChild(part)
                        }
                        currentNode.content.staticProperties.append(property)
                    }
                    for function in enumDef.staticMethods {
                        let fullNamespace = (enumDef.namespace ?? []) + [enumDef.name]
                        var currentNode = rootNode
                        for part in fullNamespace {
                            currentNode = currentNode.addChild(part)
                        }
                        currentNode.content.functions.append(function)
                    }
                }
            }
        }

        fileprivate func buildHierarchicalExportsType(
            exportedSkeletons: [ExportedSkeleton],
            renderClassEntry: (ExportedClass) -> [String],
            renderFunctionSignature: (ExportedFunction) -> String
        ) -> [String] {
            let printer = CodeFragmentPrinter()
            let rootNode = NamespaceNode(name: "")

            buildExportsTree(rootNode: rootNode, exportedSkeletons: exportedSkeletons)

            for (_, node) in rootNode.children {
                populateTypeScriptExportLines(
                    node: node,
                    renderClassEntry: renderClassEntry,
                    renderFunctionSignature: renderFunctionSignature
                )
            }

            printExportsTypeHierarchy(node: rootNode, printer: printer)

            return printer.lines
        }

        private func populateTypeScriptExportLines(
            node: NamespaceNode,
            renderClassEntry: (ExportedClass) -> [String],
            renderFunctionSignature: (ExportedFunction) -> String
        ) {
            for function in node.content.functions {
                let signature = renderFunctionSignature(function)
                node.content.functionDtsLines.append((function.name, [signature]))
            }

            for klass in node.content.classes {
                let entry = renderClassEntry(klass)
                node.content.classDtsLines.append((klass.name, entry))
            }

            for enumDef in node.content.enums {
                node.content.enumDtsLines.append((enumDef.name, "\(enumDef.name): \(enumDef.objectTypeName)"))
            }

            for (_, childNode) in node.children {
                populateTypeScriptExportLines(
                    node: childNode,
                    renderClassEntry: renderClassEntry,
                    renderFunctionSignature: renderFunctionSignature
                )
            }
        }

        fileprivate func buildHierarchicalExportsObject(
            exportedSkeletons: [ExportedSkeleton],
            renderFunctionImpl: (ExportedFunction) throws -> [String]
        ) throws -> [String] {
            let printer = CodeFragmentPrinter()
            let rootNode = NamespaceNode(name: "")

            buildExportsTree(rootNode: rootNode, exportedSkeletons: exportedSkeletons)

            try populateJavaScriptExportLines(node: rootNode, renderFunctionImpl: renderFunctionImpl)

            try populatePropertyImplementations(node: rootNode)

            printExportsObjectHierarchy(node: rootNode, printer: printer, currentPath: [])

            return printer.lines
        }

        private func populateJavaScriptExportLines(
            node: NamespaceNode,
            renderFunctionImpl: (ExportedFunction) throws -> [String]
        ) throws {
            for function in node.content.functions {
                let impl = try renderFunctionImpl(function)
                node.content.functionJsLines.append((function.name, impl))
            }

            for (_, childNode) in node.children {
                try populateJavaScriptExportLines(node: childNode, renderFunctionImpl: renderFunctionImpl)
            }
        }

        private func populatePropertyImplementations(node: NamespaceNode) throws {
            for property in node.content.staticProperties {
                // Generate getter
                let getterThunkBuilder = ExportedThunkBuilder(effects: Effects(isAsync: false, isThrows: false))
                let getterReturnExpr = try getterThunkBuilder.call(
                    abiName: property.getterAbiName(),
                    returnType: property.type
                )

                let getterPrinter = CodeFragmentPrinter()
                getterPrinter.write("get \(property.name)() {")
                getterPrinter.indent {
                    getterPrinter.write(contentsOf: getterThunkBuilder.body)
                    getterPrinter.write(contentsOf: getterThunkBuilder.cleanupCode)
                    getterPrinter.write(lines: getterThunkBuilder.checkExceptionLines())
                    if let returnExpr = getterReturnExpr {
                        getterPrinter.write("return \(returnExpr);")
                    }
                }
                getterPrinter.write("},")

                var propertyLines = getterPrinter.lines

                // Generate setter if not readonly
                if !property.isReadonly {
                    let setterThunkBuilder = ExportedThunkBuilder(
                        effects: Effects(isAsync: false, isThrows: false)
                    )
                    try setterThunkBuilder.lowerParameter(
                        param: Parameter(label: "value", name: "value", type: property.type)
                    )
                    _ = try setterThunkBuilder.call(
                        abiName: property.setterAbiName(),
                        returnType: .void
                    )

                    let setterPrinter = CodeFragmentPrinter()
                    setterPrinter.write("set \(property.name)(value) {")
                    setterPrinter.indent {
                        setterPrinter.write(contentsOf: setterThunkBuilder.body)
                        setterPrinter.write(contentsOf: setterThunkBuilder.cleanupCode)
                        setterPrinter.write(lines: setterThunkBuilder.checkExceptionLines())
                    }
                    setterPrinter.write("},")

                    propertyLines.append(contentsOf: setterPrinter.lines)
                }

                node.content.propertyJsLines.append(contentsOf: propertyLines)
            }

            // Recursively process child nodes
            for (_, childNode) in node.children {
                try populatePropertyImplementations(node: childNode)
            }
        }

        private func printExportsTypeHierarchy(node: NamespaceNode, printer: CodeFragmentPrinter) {
            for (childName, childNode) in node.children.sorted(by: { $0.key < $1.key }) {
                printer.write("\(childName): {")
                printer.indent {
                    for (_, lines) in childNode.content.classDtsLines.sorted(by: { $0.name < $1.name }) {
                        printer.write(lines: lines)
                    }

                    for (_, line) in childNode.content.enumDtsLines.sorted(by: { $0.name < $1.name }) {
                        printer.write(line)
                    }

                    for property in childNode.content.staticProperties.sorted(by: { $0.name < $1.name }) {
                        let readonly = property.isReadonly ? "readonly " : ""
                        printer.write("\(readonly)\(property.name): \(property.type.tsType);")
                    }

                    for (_, lines) in childNode.content.functionDtsLines.sorted(by: { $0.name < $1.name }) {
                        for line in lines {
                            printer.write(line)
                        }
                    }

                    printExportsTypeHierarchy(node: childNode, printer: printer)
                }
                printer.write("},")
            }
        }

        private func printExportsObjectHierarchy(
            node: NamespaceNode,
            printer: CodeFragmentPrinter,
            currentPath: [String] = []
        ) {
            for (childName, childNode) in node.children.sorted(by: { $0.key < $1.key }) {
                let newPath = currentPath + [childName]
                printer.write("\(childName): {")
                printer.indent {
                    for klass in childNode.content.classes.sorted(by: { $0.name < $1.name }) {
                        printer.write("\(klass.name),")
                    }

                    for enumDef in childNode.content.enums.sorted(by: { $0.name < $1.name }) {
                        printer.write("\(enumDef.name): \(enumDef.valuesName),")
                    }

                    // Print function and property implementations
                    printer.write(lines: childNode.content.propertyJsLines)
                    for (name, lines) in childNode.content.functionJsLines.sorted(by: { $0.name < $1.name }) {
                        var modifiedLines = lines
                        if !modifiedLines.isEmpty {
                            modifiedLines[0] = "\(name): " + modifiedLines[0]
                            modifiedLines[modifiedLines.count - 1] += ","
                        }
                        printer.write(lines: modifiedLines)
                    }

                    printExportsObjectHierarchy(node: childNode, printer: printer, currentPath: newPath)
                }
                printer.write("},")
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

            let globalSkeletons = exportedSkeletons.filter { $0.exposeToGlobal }
            let nonGlobalSkeletons = exportedSkeletons.filter { !$0.exposeToGlobal }

            if !globalSkeletons.isEmpty {
                let globalRootNode = NamespaceNode(name: "")
                buildExportsTree(rootNode: globalRootNode, exportedSkeletons: globalSkeletons)

                if !globalRootNode.children.isEmpty {
                    printer.write("export {};")
                    printer.nextLine()
                    printer.write("declare global {")
                    printer.indent()
                    generateNamespaceDeclarationsForNode(
                        node: globalRootNode,
                        depth: 1,
                        printer: printer,
                        exposeToGlobal: true,
                        renderTSSignatureCallback: renderTSSignatureCallback
                    )
                    printer.unindent()
                    printer.write("}")
                    printer.nextLine()
                }
            }

            if !nonGlobalSkeletons.isEmpty {
                let localRootNode = NamespaceNode(name: "")
                buildExportsTree(rootNode: localRootNode, exportedSkeletons: nonGlobalSkeletons)

                if !localRootNode.children.isEmpty {
                    generateNamespaceDeclarationsForNode(
                        node: localRootNode,
                        depth: 1,
                        printer: printer,
                        exposeToGlobal: false,
                        renderTSSignatureCallback: renderTSSignatureCallback
                    )
                }
            }

            return printer.lines
        }

        private func generateNamespaceDeclarationsForNode(
            node: NamespaceNode,
            depth: Int,
            printer: CodeFragmentPrinter,
            exposeToGlobal: Bool,
            renderTSSignatureCallback: @escaping ([Parameter], BridgeType, Effects) -> String
        ) {
            func hasContent(node: NamespaceNode) -> Bool {
                // Enums are always included
                if !node.content.enums.isEmpty {
                    return true
                }

                // When exposeToGlobal is true, classes, functions, and properties are included
                if exposeToGlobal {
                    if !node.content.classes.isEmpty || !node.content.functions.isEmpty
                        || !node.content.staticProperties.isEmpty
                    {
                        return true
                    }
                }

                // Check if any child has content
                for (_, childNode) in node.children {
                    if hasContent(node: childNode) {
                        return true
                    }
                }

                return false
            }

            func generateNamespaceDeclarations(node: NamespaceNode, depth: Int) {
                let sortedChildren = node.children.sorted { $0.key < $1.key }

                for (childName, childNode) in sortedChildren {
                    // Skip empty namespaces
                    guard hasContent(node: childNode) else {
                        continue
                    }

                    let exportKeyword = exposeToGlobal ? "" : "export "
                    printer.write("\(exportKeyword)namespace \(childName) {")
                    printer.indent()

                    // Only include classes when exposeToGlobal is true
                    if exposeToGlobal {
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
                    }

                    // Generate enum definitions within declare global namespace
                    let sortedEnums = childNode.content.enums.sorted { $0.name < $1.name }
                    for enumDefinition in sortedEnums {
                        let style: EnumEmitStyle = enumDefinition.emitStyle
                        let enumValuesName = enumDefinition.valuesName
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
                                printer.write("const \(enumValuesName): {")
                                printer.indent {
                                    for (index, enumCase) in enumDefinition.cases.enumerated() {
                                        let caseName = enumCase.name.capitalizedFirstLetter
                                        printer.write("readonly \(caseName): \(index);")
                                    }
                                }
                                printer.write("};")
                                printer.write(
                                    "type \(enumDefinition.name)Tag = typeof \(enumValuesName)[keyof typeof \(enumValuesName)];"
                                )
                            }
                        case .rawValue:
                            guard let rawType = enumDefinition.rawType else { continue }
                            switch style {
                            case .tsEnum:
                                printer.write("enum \(enumDefinition.name) {")
                                printer.indent {
                                    for (index, enumCase) in enumDefinition.cases.enumerated() {
                                        let caseName = enumCase.name.capitalizedFirstLetter
                                        let value = enumCase.jsValue(
                                            rawType: rawType,
                                            index: index
                                        )
                                        printer.write("\(caseName) = \(value),")
                                    }
                                }
                                printer.write("}")
                            case .const:
                                printer.write("const \(enumValuesName): {")
                                printer.indent {
                                    for (index, enumCase) in enumDefinition.cases.enumerated() {
                                        let caseName = enumCase.name.capitalizedFirstLetter
                                        let value = enumCase.jsValue(
                                            rawType: rawType,
                                            index: index
                                        )
                                        printer.write("readonly \(caseName): \(value);")
                                    }
                                }
                                printer.write("};")
                                printer.write(
                                    "type \(enumDefinition.name)Tag = typeof \(enumValuesName)[keyof typeof \(enumValuesName)];"
                                )
                            }
                        case .associatedValue:
                            printer.write("const \(enumValuesName): {")
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
                                        "{ tag: typeof \(enumValuesName).Tag.\(enumCase.name.capitalizedFirstLetter) }"
                                    )
                                } else {
                                    var fields: [String] = [
                                        "tag: typeof \(enumValuesName).Tag.\(enumCase.name.capitalizedFirstLetter)"
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
                            let unionTypeName =
                                enumDefinition.emitStyle == .tsEnum ? enumDefinition.name : "\(enumDefinition.name)Tag"
                            printer.write("type \(unionTypeName) =")
                            printer.write("  " + unionParts.joined(separator: " | "))
                        case .namespace:
                            continue
                        }
                    }

                    // Only include functions and properties when exposeToGlobal is true
                    if exposeToGlobal {
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
                    }

                    generateNamespaceDeclarationsForNode(
                        node: childNode,
                        depth: depth + 1,
                        printer: printer,
                        exposeToGlobal: exposeToGlobal,
                        renderTSSignatureCallback: renderTSSignatureCallback
                    )

                    printer.unindent()
                    printer.write("}")
                }
            }

            generateNamespaceDeclarations(node: node, depth: depth)
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

    func renderProtocolProperty(
        importObjectBuilder: ImportObjectBuilder,
        protocol: ExportedProtocol,
        property: ExportedProtocolProperty
    ) throws {
        let getterAbiName = ABINameGenerator.generateABIName(
            baseName: property.name,
            namespace: nil,
            staticContext: nil,
            operation: "get",
            className: `protocol`.name
        )

        let getterThunkBuilder = ImportedThunkBuilder(context: .exportSwift)
        getterThunkBuilder.liftSelf()
        let returnExpr = try getterThunkBuilder.callPropertyGetter(name: property.name, returnType: property.type)
        let getterLines = getterThunkBuilder.renderFunction(
            name: getterAbiName,
            returnExpr: returnExpr,
            returnType: property.type
        )
        importObjectBuilder.assignToImportObject(name: getterAbiName, function: getterLines)

        if !property.isReadonly {
            let setterAbiName = ABINameGenerator.generateABIName(
                baseName: property.name,
                namespace: nil,
                staticContext: nil,
                operation: "set",
                className: `protocol`.name
            )
            let setterThunkBuilder = ImportedThunkBuilder(context: .exportSwift)
            setterThunkBuilder.liftSelf()
            try setterThunkBuilder.liftParameter(
                param: Parameter(label: nil, name: "value", type: property.type)
            )
            setterThunkBuilder.callPropertySetter(name: property.name, returnType: property.type)
            let setterLines = setterThunkBuilder.renderFunction(
                name: setterAbiName,
                returnExpr: nil,
                returnType: .void
            )
            importObjectBuilder.assignToImportObject(name: setterAbiName, function: setterLines)
        }
    }

    func renderProtocolMethod(
        importObjectBuilder: ImportObjectBuilder,
        protocol: ExportedProtocol,
        method: ExportedFunction
    ) throws {
        let thunkBuilder = ImportedThunkBuilder(context: .exportSwift)
        thunkBuilder.liftSelf()
        for param in method.parameters {
            try thunkBuilder.liftParameter(param: param)
        }
        let returnExpr = try thunkBuilder.callMethod(name: method.name, returnType: method.returnType)
        let funcLines = thunkBuilder.renderFunction(
            name: method.abiName,
            returnExpr: returnExpr,
            returnType: method.returnType
        )
        importObjectBuilder.assignToImportObject(name: method.abiName, function: funcLines)
    }
}

/// Utility enum for generating default value representations in JavaScript/TypeScript
enum DefaultValueUtils {
    enum OutputFormat {
        case javascript
        case typescript
    }

    /// Generates default value representation for JavaScript or TypeScript
    static func format(_ defaultValue: DefaultValue, as format: OutputFormat) -> String {
        switch defaultValue {
        case .string(let value):
            let escapedValue =
                format == .javascript
                ? escapeForJavaScript(value)
                : value  // TypeScript doesn't need escape in doc comments
            return "\"\(escapedValue)\""
        case .int(let value):
            return "\(value)"
        case .float(let value):
            return "\(value)"
        case .double(let value):
            return "\(value)"
        case .bool(let value):
            return value ? "true" : "false"
        case .null:
            return "null"
        case .enumCase(let enumName, let caseName):
            let simpleName = enumName.components(separatedBy: ".").last ?? enumName
            let jsEnumName = format == .javascript ? "\(simpleName)\(ExportedEnum.valuesSuffix)" : simpleName
            return "\(jsEnumName).\(caseName.capitalizedFirstLetter)"
        case .object(let className):
            return "new \(className)()"
        case .objectWithArguments(let className, let args):
            let argStrings = args.map { arg in
                Self.format(arg, as: format)
            }
            return "new \(className)(\(argStrings.joined(separator: ", ")))"
        case .structLiteral(_, let fields):
            let fieldStrings = fields.map { field in
                "\(field.name): \(Self.format(field.value, as: format))"
            }
            return "{ \(fieldStrings.joined(separator: ", ")) }"
        }
    }

    private static func escapeForJavaScript(_ string: String) -> String {
        return
            string
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
    }

    /// Generates JSDoc comment lines for parameters with default values
    static func formatJSDoc(for parameters: [Parameter]) -> [String] {
        let paramsWithDefaults = parameters.filter { $0.hasDefault }
        guard !paramsWithDefaults.isEmpty else {
            return []
        }

        var jsDocLines: [String] = ["/**"]
        for param in paramsWithDefaults {
            if let defaultValue = param.defaultValue {
                let defaultDoc = format(defaultValue, as: .typescript)
                jsDocLines.append(" * @param \(param.name) - Optional parameter (default: \(defaultDoc))")
            }
        }
        jsDocLines.append(" */")
        return jsDocLines
    }

    /// Generates a JavaScript parameter list with default values
    static func formatParameterList(_ parameters: [Parameter]) -> String {
        return parameters.map { param in
            if let defaultValue = param.defaultValue {
                let defaultJs = format(defaultValue, as: .javascript)
                return "\(param.name) = \(defaultJs)"
            }
            return param.name
        }.joined(separator: ", ")
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
            return "\(name)Tag"
        case .rawValueEnum(let name, _):
            return "\(name)Tag"
        case .associatedValueEnum(let name):
            return "\(name)Tag"
        case .swiftStruct(let name):
            return "\(name)Tag"
        case .namespaceEnum(let name):
            return name
        case .swiftProtocol(let name):
            return name
        case .closure(let signature):
            let paramTypes = signature.parameters.enumerated().map { index, param in
                "arg\(index): \(param.tsType)"
            }.joined(separator: ", ")
            return "(\(paramTypes)) => \(signature.returnType.tsType)"
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
