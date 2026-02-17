import class Foundation.JSONDecoder
import struct Foundation.Data
#if canImport(BridgeJSSkeleton)
import BridgeJSSkeleton
#endif
#if canImport(BridgeJSUtilities)
import BridgeJSUtilities
#endif

public struct BridgeJSLink {
    var skeletons: [BridgeJSSkeleton] = []
    let sharedMemory: Bool
    private let namespaceBuilder = NamespaceBuilder()
    private let intrinsicRegistry = JSIntrinsicRegistry()

    public init(
        skeletons: [BridgeJSSkeleton] = [],
        sharedMemory: Bool
    ) {
        self.skeletons = skeletons
        self.sharedMemory = sharedMemory
    }

    mutating func addSkeletonFile(data: Data) throws {
        do {
            let unified = try JSONDecoder().decode(BridgeJSSkeleton.self, from: data)
            skeletons.append(unified)
        } catch {
            struct SkeletonDecodingError: Error, CustomStringConvertible {
                let description: String
            }
            throw SkeletonDecodingError(
                description: """
                    Failed to decode skeleton file: \(error)

                    This file appears to be in an old format. Please regenerate skeleton files using:
                      bridge-js generate --module-name <name> --target-dir <dir> --output-skeleton <path> ...
                    """
            )
        }
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
        var needsImportsObject: Bool = false
    }

    private func collectLinkData() throws -> LinkData {
        var data = LinkData()

        // Swift heap object class definitions
        if skeletons.contains(where: { $0.exported?.classes.isEmpty == false }) {
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
        for unified in skeletons {
            guard let skeleton = unified.exported else { continue }
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
        for unified in skeletons {
            guard let imported = unified.imported else { continue }
            let importObjectBuilder = ImportObjectBuilder(moduleName: unified.moduleName)
            for fileSkeleton in imported.children {
                for getter in fileSkeleton.globalGetters {
                    if getter.from == nil {
                        data.needsImportsObject = true
                    }
                    try renderImportedGlobalGetter(importObjectBuilder: importObjectBuilder, getter: getter)
                }
                for function in fileSkeleton.functions {
                    if function.from == nil {
                        data.needsImportsObject = true
                    }
                    try renderImportedFunction(importObjectBuilder: importObjectBuilder, function: function)
                }
                for type in fileSkeleton.types {
                    if type.constructor != nil, type.from == nil {
                        data.needsImportsObject = true
                    }
                    try renderImportedType(importObjectBuilder: importObjectBuilder, type: type)
                }
            }
            data.importObjectBuilders.append(importObjectBuilder)
        }

        for unified in skeletons {
            guard let skeleton = unified.exported else { continue }
            let moduleName = unified.moduleName
            if !skeleton.protocols.isEmpty {
                let importObjectBuilder: ImportObjectBuilder
                if let existingBuilder = data.importObjectBuilders.first(where: { $0.moduleName == moduleName }
                ) {
                    importObjectBuilder = existingBuilder
                } else {
                    importObjectBuilder = ImportObjectBuilder(moduleName: moduleName)
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
        return [
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
            "let \(JSGlueVariableScope.reservedStringStack) = [];",
            "let \(JSGlueVariableScope.reservedI32Stack) = [];",
            "let \(JSGlueVariableScope.reservedF32Stack) = [];",
            "let \(JSGlueVariableScope.reservedF64Stack) = [];",
            "let \(JSGlueVariableScope.reservedPointerStack) = [];",

            "const \(JSGlueVariableScope.reservedEnumHelpers) = {};",
            "const \(JSGlueVariableScope.reservedStructHelpers) = {};",
            "",
            "let _exports = null;",
            "let bjs = null;",
        ]
    }

    private func generateAddImports(needsImportsObject: Bool) throws -> CodeFragmentPrinter {
        let printer = CodeFragmentPrinter()
        let allStructs = skeletons.compactMap { $0.exported?.structs }.flatMap { $0 }
        printer.write("return {")
        try printer.indent {
            printer.write(lines: [
                "/**",
                " * @param {WebAssembly.Imports} importObject",
                " */",
                "addImports: (importObject, importsContext) => {",
            ])

            try printer.indent {
                printer.write(lines: [
                    "bjs = {};",
                    "importObject[\"bjs\"] = bjs;",
                ])
                if needsImportsObject {
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
                        "\(JSGlueVariableScope.reservedSwift).\(JSGlueVariableScope.reservedMemory).release(sourceId);"
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
                printer.write("bjs[\"swift_js_push_i32\"] = function(v) {")
                printer.indent {
                    printer.write("\(JSGlueVariableScope.reservedI32Stack).push(v | 0);")
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_push_f32\"] = function(v) {")
                printer.indent {
                    printer.write("\(JSGlueVariableScope.reservedF32Stack).push(Math.fround(v));")
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_push_f64\"] = function(v) {")
                printer.indent {
                    printer.write("\(JSGlueVariableScope.reservedF64Stack).push(v);")
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_push_string\"] = function(ptr, len) {")
                printer.indent {
                    printer.write(
                        "const bytes = new Uint8Array(\(JSGlueVariableScope.reservedMemory).buffer, ptr, len)\(sharedMemory ? ".slice()" : "");"
                    )
                    printer.write(
                        "\(JSGlueVariableScope.reservedStringStack).push(\(JSGlueVariableScope.reservedTextDecoder).decode(bytes));"
                    )
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_pop_i32\"] = function() {")
                printer.indent {
                    printer.write("return \(JSGlueVariableScope.reservedI32Stack).pop();")
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_pop_f32\"] = function() {")
                printer.indent {
                    printer.write("return \(JSGlueVariableScope.reservedF32Stack).pop();")
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_pop_f64\"] = function() {")
                printer.indent {
                    printer.write("return \(JSGlueVariableScope.reservedF64Stack).pop();")
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_push_pointer\"] = function(pointer) {")
                printer.indent {
                    printer.write("\(JSGlueVariableScope.reservedPointerStack).push(pointer);")
                }
                printer.write("}")
                printer.write("bjs[\"swift_js_pop_pointer\"] = function() {")
                printer.indent {
                    printer.write("return \(JSGlueVariableScope.reservedPointerStack).pop();")
                }
                printer.write("}")
                if !allStructs.isEmpty {
                    for structDef in allStructs {
                        printer.write("bjs[\"swift_js_struct_lower_\(structDef.name)\"] = function(objectId) {")
                        printer.indent {
                            printer.write(
                                "\(JSGlueVariableScope.reservedStructHelpers).\(structDef.name).lower(\(JSGlueVariableScope.reservedSwift).memory.getObject(objectId));"
                            )
                        }
                        printer.write("}")

                        printer.write("bjs[\"swift_js_struct_lift_\(structDef.name)\"] = function() {")
                        printer.indent {
                            printer.write(
                                "const value = \(JSGlueVariableScope.reservedStructHelpers).\(structDef.name).lift();"
                            )
                            printer.write("return \(JSGlueVariableScope.reservedSwift).memory.retain(value);")
                        }
                        printer.write("}")
                    }
                }

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
                // Always provide swift_js_closure_unregister as a no-op by default.
                // The @_extern(wasm) declaration in BridgeJSIntrinsics.swift is unconditional,
                // so the WASM binary always imports this symbol. When closures ARE used,
                // the real implementation below will override this no-op.
                printer.write("bjs[\"swift_js_closure_unregister\"] = function(funcRef) {}")

                for unified in skeletons {
                    let moduleName = unified.moduleName
                    let collector = ClosureSignatureCollectorVisitor()
                    var walker = BridgeTypeWalker(visitor: collector)
                    walker.walk(unified)
                    let closureSignatures = walker.visitor.signatures

                    guard !closureSignatures.isEmpty else { continue }

                    intrinsicRegistry.register(name: "swiftClosureHelpers") { helperPrinter in
                        helperPrinter.write(
                            "const \(JSGlueVariableScope.reservedSwiftClosureRegistry) = (typeof FinalizationRegistry === \"undefined\") ? { register: () => {}, unregister: () => {} } : new FinalizationRegistry((state) => {"
                        )
                        helperPrinter.indent {
                            helperPrinter.write("if (state.unregistered) { return; }")
                            helperPrinter.write(
                                "\(JSGlueVariableScope.reservedInstance)?.exports?.bjs_release_swift_closure(state.pointer);"
                            )
                        }
                        helperPrinter.write("});")
                        helperPrinter.write(
                            "const \(JSGlueVariableScope.reservedMakeSwiftClosure) = (pointer, file, line, func) => {"
                        )
                        helperPrinter.indent {
                            helperPrinter.write(
                                "const state = { pointer, file, line, unregistered: false };"
                            )
                            helperPrinter.write("const real = (...args) => {")
                            helperPrinter.indent {
                                helperPrinter.write("if (state.unregistered) {")
                                helperPrinter.indent {
                                    helperPrinter.write(
                                        "const bytes = new Uint8Array(\(JSGlueVariableScope.reservedMemory).buffer, state.file);"
                                    )
                                    helperPrinter.write("let length = 0;")
                                    helperPrinter.write("while (bytes[length] !== 0) { length += 1; }")
                                    helperPrinter.write(
                                        "const fileID = \(JSGlueVariableScope.reservedTextDecoder).decode(bytes.subarray(0, length));"
                                    )
                                    helperPrinter.write(
                                        "throw new Error(`Attempted to call a released JSTypedClosure created at ${fileID}:${state.line}`);"
                                    )
                                }
                                helperPrinter.write("}")
                                helperPrinter.write("return func(...args);")
                            }
                            helperPrinter.write("};")
                            helperPrinter.write(
                                "real.__unregister = () => {"
                            )
                            helperPrinter.indent {
                                helperPrinter.write(
                                    "if (state.unregistered) { return; }"
                                )
                                helperPrinter.write("state.unregistered = true;")
                                helperPrinter.write(
                                    "\(JSGlueVariableScope.reservedSwiftClosureRegistry).unregister(state);"
                                )
                            }
                            helperPrinter.write("};")
                            helperPrinter.write(
                                "\(JSGlueVariableScope.reservedSwiftClosureRegistry).register(real, state, state);"
                            )
                            helperPrinter.write("return \(JSGlueVariableScope.reservedSwift).memory.retain(real);")
                        }
                        helperPrinter.write("};")
                    }
                    printer.write("bjs[\"swift_js_closure_unregister\"] = function(funcRef) {")
                    printer.indent {
                        printer.write("const func = \(JSGlueVariableScope.reservedSwift).memory.getObject(funcRef);")
                        printer.write("func.__unregister();")
                    }
                    printer.write("}")

                    for signature in closureSignatures.sorted(by: { $0.mangleName < $1.mangleName }) {
                        let invokeFuncName = "invoke_js_callback_\(moduleName)_\(signature.mangleName)"
                        let invokeLines = try generateInvokeFunction(
                            signature: signature,
                            functionName: invokeFuncName
                        )
                        printer.write(lines: invokeLines)

                        let lowerFuncName = "lower_closure_\(moduleName)_\(signature.mangleName)"
                        let makeFuncName = "make_swift_closure_\(moduleName)_\(signature.mangleName)"
                        printer.write("bjs[\"\(makeFuncName)\"] = function(boxPtr, file, line) {")
                        try printer.indent {
                            let lowerLines = try generateLowerClosureFunction(
                                signature: signature,
                                functionName: lowerFuncName
                            )
                            printer.write(lines: lowerLines)
                            printer.write(
                                "return \(JSGlueVariableScope.reservedMakeSwiftClosure)(boxPtr, file, line, \(lowerFuncName));"
                            )
                        }
                        printer.write("}")
                    }
                }
            }
        }

        return printer
    }

    private func generateInvokeFunction(
        signature: ClosureSignature,
        functionName: String
    ) throws -> [String] {
        let thunkBuilder = ImportedThunkBuilder(context: .exportSwift, intrinsicRegistry: intrinsicRegistry)
        thunkBuilder.parameterNames.append("callbackId")
        thunkBuilder.body.write("const callback = \(JSGlueVariableScope.reservedSwift).memory.getObject(callbackId);")

        for (index, paramType) in signature.parameters.enumerated() {
            let paramName = "param\(index)"
            try thunkBuilder.liftParameter(param: Parameter(label: nil, name: paramName, type: paramType))
        }

        let returnExpr = try thunkBuilder.call(calleeExpr: "callback", returnType: signature.returnType)

        var functionLines = thunkBuilder.renderFunction(
            name: nil,
            returnExpr: returnExpr,
            returnType: signature.returnType
        )
        functionLines[0] = "bjs[\"\(functionName)\"] = " + functionLines[0]

        return functionLines
    }

    /// Generates a lower_closure_* function that wraps a Swift closure for JavaScript
    private func generateLowerClosureFunction(
        signature: ClosureSignature,
        functionName: String
    ) throws -> [String] {
        let printer = CodeFragmentPrinter()
        let builder = ExportedThunkBuilder(
            effects: Effects(isAsync: false, isThrows: true),
            hasDirectAccessToSwiftClass: false,
            intrinsicRegistry: intrinsicRegistry
        )
        builder.parameterForwardings.append("boxPtr")

        printer.write(
            "const \(functionName) = function(\(signature.parameters.indices.map { "param\($0)" }.joined(separator: ", "))) {"
        )
        try printer.indent {
            // Lower parameters using shared thunk builder
            for (index, paramType) in signature.parameters.enumerated() {
                let paramName = "param\(index)"
                try builder.lowerParameter(param: Parameter(label: nil, name: paramName, type: paramType))
            }

            let invokeCall =
                "invoke_swift_closure_\(signature.moduleName)_\(signature.mangleName)"
            let returnExpr = try builder.call(abiName: invokeCall, returnType: signature.returnType)
            builder.renderFunctionBody(into: printer, returnExpr: returnExpr)
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

        let exportedSkeletons = skeletons.compactMap(\.exported)

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

        let exportedSkeletons = skeletons.compactMap(\.exported)
        let topLevelNamespaceCode = namespaceBuilder.buildTopLevelNamespaceInitialization(
            exportedSkeletons: exportedSkeletons
        )
        printer.write(lines: topLevelNamespaceCode)

        let propertyAssignments = try generateNamespacePropertyAssignments(
            data: data,
            exportedSkeletons: exportedSkeletons,
            namespaceBuilder: namespaceBuilder
        )

        // Main function declaration
        printer.write("export async function createInstantiator(options, \(JSGlueVariableScope.reservedSwift)) {")

        try printer.indent {
            printer.write(lines: generateVariableDeclarations())

            let bodyPrinter = CodeFragmentPrinter()
            let allStructs = exportedSkeletons.flatMap { $0.structs }
            for structDef in allStructs {
                let structPrinter = CodeFragmentPrinter()
                let structScope = JSGlueVariableScope(intrinsicRegistry: intrinsicRegistry)
                let fragment = IntrinsicJSFragment.structHelper(structDefinition: structDef, allStructs: allStructs)
                _ = try fragment.printCode(
                    [structDef.name],
                    IntrinsicJSFragment.PrintCodeContext(
                        scope: structScope,
                        printer: structPrinter
                    )
                )
                bodyPrinter.write(lines: structPrinter.lines)
            }

            let allAssocEnums = exportedSkeletons.flatMap {
                $0.enums.filter { $0.enumType == .associatedValue }
            }
            for enumDef in allAssocEnums {
                let enumPrinter = CodeFragmentPrinter()
                let enumScope = JSGlueVariableScope(intrinsicRegistry: intrinsicRegistry)
                let fragment = IntrinsicJSFragment.associatedValueEnumHelperFactory(enumDefinition: enumDef)
                _ = try fragment.printCode(
                    [enumDef.valuesName],
                    IntrinsicJSFragment.PrintCodeContext(
                        scope: enumScope,
                        printer: enumPrinter
                    )
                )
                bodyPrinter.write(lines: enumPrinter.lines)
            }
            bodyPrinter.nextLine()
            bodyPrinter.write(contentsOf: try generateAddImports(needsImportsObject: data.needsImportsObject))

            if !intrinsicRegistry.isEmpty {
                printer.write(lines: intrinsicRegistry.emitLines())
                printer.nextLine()
            }

            printer.write(lines: bodyPrinter.lines)
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

                printer.write(lines: data.classLines)

                // Struct and enum helpers must be initialized AFTER classes are defined (to allow _exports access)
                printer.write(contentsOf: structHelperAssignments())
                printer.write(contentsOf: enumHelperAssignments())
                let namespaceInitCode = namespaceBuilder.buildNamespaceInitialization(
                    exportedSkeletons: exportedSkeletons
                )
                printer.write(lines: namespaceInitCode)

                printer.write(lines: propertyAssignments)
            }
            printer.write("},")
        }
        printer.write("}")
        printer.unindent()
        printer.write("}")

        return printer.lines.joined(separator: "\n")
    }

    public func link() throws -> (outputJs: String, outputDts: String) {
        intrinsicRegistry.reset()
        let data = try collectLinkData()
        let outputJs = try generateJavaScript(data: data)
        let outputDts = generateTypeScript(data: data)
        return (outputJs, outputDts)
    }

    private func enumHelperAssignments() -> CodeFragmentPrinter {
        let printer = CodeFragmentPrinter()

        for skeleton in skeletons.compactMap(\.exported) {
            for enumDef in skeleton.enums where enumDef.enumType == .associatedValue {
                printer.write(
                    "const \(enumDef.name)Helpers = __bjs_create\(enumDef.valuesName)Helpers();"
                )
                printer.write("\(JSGlueVariableScope.reservedEnumHelpers).\(enumDef.name) = \(enumDef.name)Helpers;")
                printer.nextLine()
            }
        }

        return printer
    }

    private func structHelperAssignments() -> CodeFragmentPrinter {
        let printer = CodeFragmentPrinter()

        for skeleton in skeletons.compactMap(\.exported) {
            for structDef in skeleton.structs {
                printer.write(
                    "const \(structDef.name)Helpers = __bjs_create\(structDef.name)Helpers();"
                )
                printer.write(
                    "\(JSGlueVariableScope.reservedStructHelpers).\(structDef.name) = \(structDef.name)Helpers;"
                )
                printer.nextLine()
            }
        }

        return printer
    }

    private func renderSwiftClassWrappers() -> [String] {
        var wrapperLines: [String] = []
        var modulesByName: [String: [ExportedClass]] = [:]

        // Group classes by their module name
        for unified in skeletons {
            guard let skeleton = unified.exported else { continue }
            if skeleton.classes.isEmpty { continue }
            let moduleName = unified.moduleName

            if modulesByName[moduleName] == nil {
                modulesByName[moduleName] = []
            }
            modulesByName[moduleName]?.append(contentsOf: skeleton.classes)
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
                intrinsicRegistry: intrinsicRegistry,
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

        for unified in skeletons {
            guard let skeletonSet = unified.imported else { continue }
            for fileSkeleton in skeletonSet.children {
                for type in fileSkeleton.types {
                    printer.write("export interface \(type.name) {")
                    printer.indent()

                    // Add methods
                    for method in type.methods {
                        let methodName = method.jsName ?? method.name
                        let methodSignature =
                            "\(renderTSPropertyName(methodName))\(renderTSSignature(parameters: method.parameters, returnType: method.returnType, effects: Effects(isAsync: false, isThrows: false)));"
                        printer.write(methodSignature)
                    }

                    // Add properties from getters
                    var propertyNames = Set<String>()
                    for getter in type.getters {
                        let propertyName = getter.jsName ?? getter.name
                        propertyNames.insert(propertyName)
                        let hasSetter = type.setters.contains { ($0.jsName ?? $0.name) == propertyName }
                        let propertySignature =
                            hasSetter
                            ? "\(renderTSPropertyName(propertyName)): \(resolveTypeScriptType(getter.type));"
                            : "readonly \(renderTSPropertyName(propertyName)): \(resolveTypeScriptType(getter.type));"
                        printer.write(propertySignature)
                    }
                    // Add setters that don't have corresponding getters
                    for setter in type.setters {
                        let propertyName = setter.jsName ?? setter.name
                        guard !propertyNames.contains(propertyName) else { continue }
                        printer.write("\(renderTSPropertyName(propertyName)): \(resolveTypeScriptType(setter.type));")
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
        var parameterForwardings: [String] = []
        let effects: Effects
        let scope: JSGlueVariableScope
        let context: IntrinsicJSFragment.PrintCodeContext

        init(effects: Effects, hasDirectAccessToSwiftClass: Bool = true, intrinsicRegistry: JSIntrinsicRegistry) {
            self.effects = effects
            self.scope = JSGlueVariableScope(intrinsicRegistry: intrinsicRegistry)
            self.body = CodeFragmentPrinter()
            self.context = IntrinsicJSFragment.PrintCodeContext(
                scope: scope,
                printer: body,
                hasDirectAccessToSwiftClass: hasDirectAccessToSwiftClass
            )
        }

        func lowerParameter(param: Parameter) throws {
            let loweringFragment = try IntrinsicJSFragment.lowerParameter(type: param.type)
            assert(
                loweringFragment.parameters.count == 1,
                "Lowering fragment should have exactly one parameter to lower"
            )
            let loweredValues = try loweringFragment.printCode([param.name], context)
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
            let liftedValues = try liftingFragment.printCode(fragmentArguments, context)
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

        /// Renders the thunk body (body code, exception handling, and optional return) into a printer.
        func renderFunctionBody(into printer: CodeFragmentPrinter, returnExpr: String?) {
            printer.write(contentsOf: body)
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
        return Self.resolveTypeScriptType(type, exportedSkeletons: skeletons.compactMap(\.exported))
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
                            if enumDef.emitStyle == .tsEnum {
                                return enumDef.tsFullPath
                            }
                            return "\(enumDef.tsFullPath)Tag"
                        }
                    }
                }
            }
            return type.tsType
        case .swiftStruct(let name):
            return name.components(separatedBy: ".").last ?? name
        case .nullable(let wrapped, let kind):
            let base = resolveTypeScriptType(wrapped, exportedSkeletons: exportedSkeletons)
            return "\(base) | \(kind.absenceLiteral)"
        case .array(let elementType):
            let elementTypeStr = resolveTypeScriptType(elementType, exportedSkeletons: exportedSkeletons)
            // Parenthesize compound types so `[]` binds correctly in TypeScript
            // e.g. `(string | null)[]` not `string | null[]`, `((x: number) => void)[]` not `(x: number) => void[]`
            if elementTypeStr.contains("|") || elementTypeStr.contains("=>") {
                return "(\(elementTypeStr))[]"
            }
            return "\(elementTypeStr)[]"
        case .dictionary(let valueType):
            let valueTypeStr = resolveTypeScriptType(valueType, exportedSkeletons: exportedSkeletons)
            return "Record<string, \(valueTypeStr)>"
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

    private func renderTSPropertyName(_ name: String) -> String {
        // TypeScript allows quoted property names for keys that aren't valid identifiers.
        if name.range(of: #"^[$A-Z_][0-9A-Z_$]*$"#, options: [.regularExpression, .caseInsensitive]) != nil {
            return name
        }
        return "\"\(Self.escapeForJavaScriptStringLiteral(name))\""
    }

    fileprivate static func escapeForJavaScriptStringLiteral(_ string: String) -> String {
        string
            .replacingOccurrences(of: "\\", with: "\\\\")
            .replacingOccurrences(of: "\"", with: "\\\"")
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
                let thunkBuilder = ExportedThunkBuilder(
                    effects: constructor.effects,
                    intrinsicRegistry: intrinsicRegistry
                )
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
        let scope = JSGlueVariableScope(intrinsicRegistry: intrinsicRegistry)
        let printer = CodeFragmentPrinter()
        let context = IntrinsicJSFragment.PrintCodeContext(
            scope: scope,
            printer: printer
        )
        let enumValuesName = enumDefinition.valuesName

        switch enumDefinition.enumType {
        case .simple, .rawValue:
            let fragment = IntrinsicJSFragment.caseEnumHelper(enumDefinition: enumDefinition)
            _ = try fragment.printCode([enumValuesName], context)
            jsTopLevelLines.append(contentsOf: printer.lines)
        case .associatedValue:
            let fragment = IntrinsicJSFragment.associatedValueEnumValues(enumDefinition: enumDefinition)
            _ = try fragment.printCode([enumValuesName], context)
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
                            fields.append("\(prop): \(resolveTypeScriptType(associatedValue.type))")
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

    func renderExportedFunction(
        function: ExportedFunction
    ) throws -> (js: [String], dts: [String]) {
        if function.effects.isStatic, let staticContext = function.staticContext {
            return try renderStaticFunction(function: function, staticContext: staticContext)
        }

        let thunkBuilder = ExportedThunkBuilder(
            effects: function.effects,
            intrinsicRegistry: intrinsicRegistry
        )
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
                return try renderNamespaceFunction(
                    function: function,
                    namespace: namespace.joined(separator: ".")
                )
            } else {
                return try renderExportedFunction(function: function)
            }
        }
    }

    private func renderStaticFunction(
        function: ExportedFunction,
        className: String
    ) throws -> (js: [String], dts: [String]) {
        let thunkBuilder = ExportedThunkBuilder(
            effects: function.effects,
            intrinsicRegistry: intrinsicRegistry
        )
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
        let thunkBuilder = ExportedThunkBuilder(
            effects: function.effects,
            intrinsicRegistry: intrinsicRegistry
        )
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
        let thunkBuilder = ExportedThunkBuilder(
            effects: function.effects,
            intrinsicRegistry: intrinsicRegistry
        )
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
        let thunkBuilder = ExportedThunkBuilder(
            effects: method.effects,
            intrinsicRegistry: intrinsicRegistry
        )
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
        let getterThunkBuilder = ExportedThunkBuilder(
            effects: Effects(isAsync: false, isThrows: false),
            intrinsicRegistry: intrinsicRegistry
        )
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
                effects: Effects(isAsync: false, isThrows: false),
                intrinsicRegistry: intrinsicRegistry
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
            let thunkBuilder = ExportedThunkBuilder(
                effects: constructor.effects,
                intrinsicRegistry: intrinsicRegistry
            )
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
                let thunkBuilder = ExportedThunkBuilder(
                    effects: method.effects,
                    intrinsicRegistry: intrinsicRegistry
                )
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
                let thunkBuilder = ExportedThunkBuilder(
                    effects: method.effects,
                    intrinsicRegistry: intrinsicRegistry
                )
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
        let getterThunkBuilder = ExportedThunkBuilder(
            effects: Effects(isAsync: false, isThrows: false),
            intrinsicRegistry: intrinsicRegistry
        )
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
            let setterThunkBuilder = ExportedThunkBuilder(
                effects: Effects(isAsync: false, isThrows: false),
                intrinsicRegistry: intrinsicRegistry
            )
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
        let context: BridgeContext
        var parameterNames: [String] = []
        var parameterForwardings: [String] = []
        let printContext: IntrinsicJSFragment.PrintCodeContext

        init(context: BridgeContext = .importTS, intrinsicRegistry: JSIntrinsicRegistry) {
            self.body = CodeFragmentPrinter()
            self.scope = JSGlueVariableScope(intrinsicRegistry: intrinsicRegistry)
            self.context = context
            self.printContext = IntrinsicJSFragment.PrintCodeContext(
                scope: scope,
                printer: body
            )
        }

        func liftSelf() {
            parameterNames.append("self")
        }

        func liftParameter(param: Parameter) throws {
            let liftingFragment = try IntrinsicJSFragment.liftParameter(type: param.type, context: context)
            let valuesToLift: [String]
            if liftingFragment.parameters.count == 0 {
                valuesToLift = []
            } else if liftingFragment.parameters.count == 1 {
                parameterNames.append(param.name)
                valuesToLift = [scope.variable(param.name)]
            } else {
                valuesToLift = liftingFragment.parameters.map { scope.variable(param.name + $0.capitalizedFirstLetter) }
                parameterNames.append(contentsOf: valuesToLift)
            }
            let liftedValues = try liftingFragment.printCode(valuesToLift, printContext)
            assert(liftedValues.count == 1, "Lifting fragment should produce exactly one value")
            parameterForwardings.append(contentsOf: liftedValues)
        }

        func renderFunction(
            name: String?,
            returnExpr: String?,
            returnType: BridgeType
        ) -> [String] {
            let printer = CodeFragmentPrinter()

            printer.write("function\(name.map { " \($0)" } ?? "")(\(parameterNames.joined(separator: ", "))) {")
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
                    if !returnType.isOptional, let abiReturnType = returnType.descriptor.wasmReturnType {
                        printer.write("return \(abiReturnType.placeholderValue)")
                    }
                }
                printer.write("}")
            }
            printer.write("}")

            return printer.lines
        }

        func call(name: String, fromObjectExpr: String, returnType: BridgeType) throws -> String? {
            let calleeExpr = Self.propertyAccessExpr(objectExpr: fromObjectExpr, propertyName: name)
            return try self.call(calleeExpr: calleeExpr, returnType: returnType)
        }

        func call(name: String, returnType: BridgeType) throws -> String? {
            return try call(name: name, fromObjectExpr: "imports", returnType: returnType)
        }

        func call(calleeExpr: String, returnType: BridgeType) throws -> String? {
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

        func callConstructor(jsName: String, swiftTypeName: String, fromObjectExpr: String) throws -> String? {
            let ctorExpr = Self.propertyAccessExpr(objectExpr: fromObjectExpr, propertyName: jsName)
            let call = "new \(ctorExpr)(\(parameterForwardings.joined(separator: ", ")))"
            let type: BridgeType = .jsObject(swiftTypeName)
            let loweringFragment = try IntrinsicJSFragment.lowerReturn(type: type, context: context)
            return try lowerReturnValue(returnType: type, returnExpr: call, loweringFragment: loweringFragment)
        }

        func callConstructor(jsName: String, swiftTypeName: String) throws -> String? {
            return try callConstructor(jsName: jsName, swiftTypeName: swiftTypeName, fromObjectExpr: "imports")
        }

        func callMethod(name: String, returnType: BridgeType) throws -> String? {
            let objectExpr = "\(JSGlueVariableScope.reservedSwift).memory.getObject(self)"
            let calleeExpr = Self.propertyAccessExpr(objectExpr: objectExpr, propertyName: name)
            return try call(
                calleeExpr: calleeExpr,
                returnType: returnType
            )
        }

        func callStaticMethod(on objectExpr: String, name: String, returnType: BridgeType) throws -> String? {
            let calleeExpr = Self.propertyAccessExpr(objectExpr: objectExpr, propertyName: name)
            return try call(
                calleeExpr: calleeExpr,
                returnType: returnType
            )
        }

        func callPropertyGetter(name: String, returnType: BridgeType) throws -> String? {
            let objectExpr = "\(JSGlueVariableScope.reservedSwift).memory.getObject(self)"
            let accessExpr = Self.propertyAccessExpr(objectExpr: objectExpr, propertyName: name)
            if context == .exportSwift, returnType.usesSideChannelForOptionalReturn {
                guard case .nullable(let wrappedType, _) = returnType else {
                    fatalError("usesSideChannelForOptionalReturn returned true for non-optional type")
                }

                let resultVar = scope.variable("ret")
                body.write(
                    "let \(resultVar) = \(accessExpr);"
                )

                let fragment = try IntrinsicJSFragment.protocolPropertyOptionalToSideChannel(wrappedType: wrappedType)
                _ = try fragment.printCode([resultVar], printContext)

                return nil  // Side-channel types return nil (no direct return value)
            }

            return try call(
                callExpr: accessExpr,
                returnType: returnType
            )
        }

        func callPropertySetter(name: String, returnType: BridgeType) {
            let objectExpr = "\(JSGlueVariableScope.reservedSwift).memory.getObject(self)"
            let accessExpr = Self.propertyAccessExpr(objectExpr: objectExpr, propertyName: name)
            let call = "\(accessExpr) = \(parameterForwardings.joined(separator: ", "))"
            body.write("\(call);")
        }

        func getImportProperty(name: String, fromObjectExpr: String, returnType: BridgeType) throws -> String? {
            if returnType == .void {
                throw BridgeJSLinkError(message: "Void is not supported for imported JS properties")
            }

            let loweringFragment = try IntrinsicJSFragment.lowerReturn(type: returnType, context: context)
            let expr = Self.propertyAccessExpr(objectExpr: fromObjectExpr, propertyName: name)

            let returnExpr: String?
            if loweringFragment.parameters.count == 0 {
                body.write("\(expr);")
                returnExpr = nil
            } else {
                let resultVariable = scope.variable("ret")
                body.write("let \(resultVariable) = \(expr);")
                returnExpr = resultVariable
            }

            return try lowerReturnValue(
                returnType: returnType,
                returnExpr: returnExpr,
                loweringFragment: loweringFragment
            )
        }

        func getImportProperty(name: String, returnType: BridgeType) throws -> String? {
            return try getImportProperty(name: name, fromObjectExpr: "imports", returnType: returnType)
        }

        private func lowerReturnValue(
            returnType: BridgeType,
            returnExpr: String?,
            loweringFragment: IntrinsicJSFragment
        ) throws -> String? {
            assert(loweringFragment.parameters.count <= 1, "Lowering fragment should have at most one parameter")
            let loweredValues = try loweringFragment.printCode(
                returnExpr.map { [$0] } ?? [],
                printContext
            )
            assert(loweredValues.count <= 1, "Lowering fragment should produce at most one value")
            return loweredValues.first
        }

        static func propertyAccessExpr(objectExpr: String, propertyName: String) -> String {
            if propertyName.range(of: #"^[$A-Z_][0-9A-Z_$]*$"#, options: [.regularExpression, .caseInsensitive]) != nil
            {
                return "\(objectExpr).\(propertyName)"
            }
            let escapedName = BridgeJSLink.escapeForJavaScriptStringLiteral(propertyName)
            return "\(objectExpr)[\"\(escapedName)\"]"
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
            intrinsicRegistry: JSIntrinsicRegistry,
            renderFunctionImpl: (ExportedFunction) throws -> [String]
        ) throws -> [String] {
            let printer = CodeFragmentPrinter()
            let rootNode = NamespaceNode(name: "")

            buildExportsTree(rootNode: rootNode, exportedSkeletons: exportedSkeletons)

            try populateJavaScriptExportLines(node: rootNode, renderFunctionImpl: renderFunctionImpl)

            try populatePropertyImplementations(
                node: rootNode,
                intrinsicRegistry: intrinsicRegistry
            )

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

        private func populatePropertyImplementations(
            node: NamespaceNode,
            intrinsicRegistry: JSIntrinsicRegistry
        ) throws {
            for property in node.content.staticProperties {
                // Generate getter
                let getterThunkBuilder = ExportedThunkBuilder(
                    effects: Effects(isAsync: false, isThrows: false),
                    intrinsicRegistry: intrinsicRegistry
                )
                let getterReturnExpr = try getterThunkBuilder.call(
                    abiName: property.getterAbiName(),
                    returnType: property.type
                )

                let getterPrinter = CodeFragmentPrinter()
                getterPrinter.write("get \(property.name)() {")
                getterPrinter.indent {
                    getterPrinter.write(contentsOf: getterThunkBuilder.body)
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
                        effects: Effects(isAsync: false, isThrows: false),
                        intrinsicRegistry: intrinsicRegistry
                    )
                    try setterThunkBuilder.lowerParameter(
                        param: Parameter(label: "value", name: "value", type: property.type)
                    )
                    _ = try setterThunkBuilder.call(
                        abiName: property.setterAbiName(),
                        returnType: BridgeType.void
                    )

                    let setterPrinter = CodeFragmentPrinter()
                    setterPrinter.write("set \(property.name)(value) {")
                    setterPrinter.indent {
                        setterPrinter.write(contentsOf: setterThunkBuilder.body)
                        setterPrinter.write(lines: setterThunkBuilder.checkExceptionLines())
                    }
                    setterPrinter.write("},")

                    propertyLines.append(contentsOf: setterPrinter.lines)
                }

                node.content.propertyJsLines.append(contentsOf: propertyLines)
            }

            // Recursively process child nodes
            for (_, childNode) in node.children {
                try populatePropertyImplementations(
                    node: childNode,
                    intrinsicRegistry: intrinsicRegistry
                )
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
                        exportedSkeletons: exportedSkeletons,
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
                        exportedSkeletons: exportedSkeletons,
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
            exportedSkeletons: [ExportedSkeleton],
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
                                        fields.append(
                                            "\(prop): \(BridgeJSLink.resolveTypeScriptType(associatedValue.type, exportedSkeletons: exportedSkeletons))"
                                        )
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
                                "function \(function.name)\(renderTSSignatureCallback(function.parameters, function.returnType, function.effects));"
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
                        exportedSkeletons: exportedSkeletons,
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
        let thunkBuilder = ImportedThunkBuilder(intrinsicRegistry: intrinsicRegistry)
        for param in function.parameters {
            try thunkBuilder.liftParameter(param: param)
        }
        let jsName = function.jsName ?? function.name
        let importRootExpr = function.from == .global ? "globalThis" : "imports"
        let returnExpr = try thunkBuilder.call(
            name: jsName,
            fromObjectExpr: importRootExpr,
            returnType: function.returnType
        )
        let funcLines = thunkBuilder.renderFunction(
            name: function.abiName(context: nil),
            returnExpr: returnExpr,
            returnType: function.returnType
        )
        let effects = Effects(isAsync: false, isThrows: false)
        if function.from == nil {
            importObjectBuilder.appendDts(
                [
                    "\(renderTSPropertyName(jsName))\(renderTSSignature(parameters: function.parameters, returnType: function.returnType, effects: effects));"
                ]
            )
        }
        importObjectBuilder.assignToImportObject(name: function.abiName(context: nil), function: funcLines)
    }

    func renderImportedGlobalGetter(
        importObjectBuilder: ImportObjectBuilder,
        getter: ImportedGetterSkeleton
    ) throws {
        let thunkBuilder = ImportedThunkBuilder(intrinsicRegistry: intrinsicRegistry)
        let jsName = getter.jsName ?? getter.name
        let importRootExpr = getter.from == .global ? "globalThis" : "imports"
        let returnExpr = try thunkBuilder.getImportProperty(
            name: jsName,
            fromObjectExpr: importRootExpr,
            returnType: getter.type
        )
        let abiName = getter.abiName(context: nil)
        let funcLines = thunkBuilder.renderFunction(
            name: abiName,
            returnExpr: returnExpr,
            returnType: getter.type
        )
        if getter.from == nil {
            importObjectBuilder.appendDts(["readonly \(renderTSPropertyName(jsName)): \(getter.type.tsType);"])
        }
        importObjectBuilder.assignToImportObject(name: abiName, function: funcLines)
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
        for getter in type.getters {
            let getterAbiName = getter.abiName(context: type)
            let (js, dts) = try renderImportedGetter(
                getter: getter,
                abiName: getterAbiName,
                emitCall: { thunkBuilder in
                    return try thunkBuilder.callPropertyGetter(
                        name: getter.jsName ?? getter.name,
                        returnType: getter.type
                    )
                }
            )
            importObjectBuilder.assignToImportObject(name: getterAbiName, function: js)
            importObjectBuilder.appendDts(dts)
        }

        for setter in type.setters {
            let setterAbiName = setter.abiName(context: type)
            let (js, dts) = try renderImportedSetter(
                setter: setter,
                abiName: setterAbiName,
                emitCall: { thunkBuilder in
                    try thunkBuilder.liftParameter(
                        param: Parameter(label: nil, name: "newValue", type: setter.type)
                    )
                    thunkBuilder.callPropertySetter(name: setter.jsName ?? setter.name, returnType: setter.type)
                    return nil
                }
            )
            importObjectBuilder.assignToImportObject(name: setterAbiName, function: js)
            importObjectBuilder.appendDts(dts)
        }
        for method in type.staticMethods {
            let abiName = method.abiName(context: type, operation: "static")
            let (js, dts) = try renderImportedStaticMethod(context: type, method: method)
            importObjectBuilder.assignToImportObject(name: abiName, function: js)
            importObjectBuilder.appendDts(dts)
        }
        if type.from == nil, type.constructor != nil || !type.staticMethods.isEmpty {
            let dtsPrinter = CodeFragmentPrinter()
            dtsPrinter.write("\(type.name): {")
            dtsPrinter.indent {
                if let constructor = type.constructor {
                    let returnType = BridgeType.jsObject(type.name)
                    dtsPrinter.write(
                        "new\(renderTSSignature(parameters: constructor.parameters, returnType: returnType, effects: Effects(isAsync: false, isThrows: false)));"
                    )
                }
                for method in type.staticMethods {
                    let methodName = method.jsName ?? method.name
                    let signature =
                        "\(renderTSPropertyName(methodName))\(renderTSSignature(parameters: method.parameters, returnType: method.returnType, effects: Effects(isAsync: false, isThrows: false)));"
                    dtsPrinter.write(signature)
                }
            }
            dtsPrinter.write("}")
            importObjectBuilder.appendDts(dtsPrinter.lines)
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
        let thunkBuilder = ImportedThunkBuilder(intrinsicRegistry: intrinsicRegistry)
        for param in constructor.parameters {
            try thunkBuilder.liftParameter(param: param)
        }
        let returnType = BridgeType.jsObject(type.name)
        let importRootExpr = type.from == .global ? "globalThis" : "imports"
        let returnExpr = try thunkBuilder.callConstructor(
            jsName: type.jsName ?? type.name,
            swiftTypeName: type.name,
            fromObjectExpr: importRootExpr
        )
        let abiName = constructor.abiName(context: type)
        let funcLines = thunkBuilder.renderFunction(
            name: abiName,
            returnExpr: returnExpr,
            returnType: returnType
        )
        importObjectBuilder.assignToImportObject(name: abiName, function: funcLines)
    }

    func renderImportedGetter(
        getter: ImportedGetterSkeleton,
        abiName: String,
        emitCall: (ImportedThunkBuilder) throws -> String?
    ) throws -> (js: [String], dts: [String]) {
        let thunkBuilder = ImportedThunkBuilder(intrinsicRegistry: intrinsicRegistry)
        thunkBuilder.liftSelf()
        let returnExpr = try emitCall(thunkBuilder)
        let funcLines = thunkBuilder.renderFunction(
            name: abiName,
            returnExpr: returnExpr,
            returnType: getter.type
        )
        return (funcLines, [])
    }

    func renderImportedSetter(
        setter: ImportedSetterSkeleton,
        abiName: String,
        emitCall: (ImportedThunkBuilder) throws -> String?
    ) throws -> (js: [String], dts: [String]) {
        let thunkBuilder = ImportedThunkBuilder(intrinsicRegistry: intrinsicRegistry)
        thunkBuilder.liftSelf()
        let returnExpr = try emitCall(thunkBuilder)
        let funcLines = thunkBuilder.renderFunction(
            name: abiName,
            returnExpr: returnExpr,
            returnType: .void
        )
        return (funcLines, [])
    }

    func renderImportedStaticMethod(
        context: ImportedTypeSkeleton,
        method: ImportedFunctionSkeleton
    ) throws -> (js: [String], dts: [String]) {
        let thunkBuilder = ImportedThunkBuilder(intrinsicRegistry: intrinsicRegistry)
        for param in method.parameters {
            try thunkBuilder.liftParameter(param: param)
        }
        let importRootExpr = context.from == .global ? "globalThis" : "imports"
        let constructorExpr = ImportedThunkBuilder.propertyAccessExpr(
            objectExpr: importRootExpr,
            propertyName: context.jsName ?? context.name
        )
        let returnExpr = try thunkBuilder.callStaticMethod(
            on: constructorExpr,
            name: method.jsName ?? method.name,
            returnType: method.returnType
        )
        let funcLines = thunkBuilder.renderFunction(
            name: method.abiName(context: context, operation: "static"),
            returnExpr: returnExpr,
            returnType: method.returnType
        )
        return (funcLines, [])
    }

    func renderImportedMethod(
        context: ImportedTypeSkeleton,
        method: ImportedFunctionSkeleton
    ) throws -> (js: [String], dts: [String]) {
        let thunkBuilder = ImportedThunkBuilder(intrinsicRegistry: intrinsicRegistry)
        thunkBuilder.liftSelf()
        for param in method.parameters {
            try thunkBuilder.liftParameter(param: param)
        }
        let returnExpr = try thunkBuilder.callMethod(name: method.jsName ?? method.name, returnType: method.returnType)
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

        let getterThunkBuilder = ImportedThunkBuilder(
            context: .exportSwift,
            intrinsicRegistry: intrinsicRegistry
        )
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
            let setterThunkBuilder = ImportedThunkBuilder(
                context: .exportSwift,
                intrinsicRegistry: intrinsicRegistry
            )
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
        let thunkBuilder = ImportedThunkBuilder(
            context: .exportSwift,
            intrinsicRegistry: intrinsicRegistry
        )
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
        case .array(let elements):
            let elementStrings = elements.map { element in
                DefaultValueUtils.format(element, as: format)
            }
            return "[\(elementStrings.joined(separator: ", "))]"
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
        case .int, .uint:
            return "number"
        case .float:
            return "number"
        case .double:
            return "number"
        case .bool:
            return "boolean"
        case .jsObject(let name):
            return name ?? "any"
        case .jsValue:
            return "any"
        case .swiftHeapObject(let name):
            return name
        case .unsafePointer:
            return "number"
        case .nullable(let wrappedType, let kind):
            return "\(wrappedType.tsType) | \(kind.absenceLiteral)"
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
        case .closure(let signature, _):
            let paramTypes = signature.parameters.enumerated().map { index, param in
                "arg\(index): \(param.tsType)"
            }.joined(separator: ", ")
            return "(\(paramTypes)) => \(signature.returnType.tsType)"
        case .array(let elementType):
            let inner = elementType.tsType
            if inner.contains("|") || inner.contains("=>") {
                return "(\(inner))[]"
            }
            return "\(inner)[]"
        case .dictionary(let valueType):
            return "Record<string, \(valueType.tsType)>"
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
