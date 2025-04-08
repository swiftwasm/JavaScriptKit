import Foundation

struct BridgeJSLink {
    /// The exported skeletons
    var exportedSkeletons: [ExportedSkeleton] = []
    var importedSkeletons: [ImportedModuleSkeleton] = []

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
            constructor(pointer, deinit) {
                this.pointer = pointer;
                this.hasReleased = false;
                this.deinit = deinit;
                this.registry = new FinalizationRegistry((pointer) => {
                    deinit(pointer);
                });
                this.registry.register(this, this.pointer);
            }

            release() {
                this.registry.unregister(this);
                this.deinit(this.pointer);
            }
        }
        """

    func link() throws -> (outputJs: String, outputDts: String) {
        var exportsLines: [String] = []
        var importedLines: [String] = []
        var classLines: [String] = []
        var dtsExportLines: [String] = []
        var dtsImportLines: [String] = []
        var dtsClassLines: [String] = []

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
            }

            for function in skeleton.functions {
                var (js, dts) = renderExportedFunction(function: function)
                js[0] = "\(function.name): " + js[0]
                js[js.count - 1] += ","
                exportsLines.append(contentsOf: js)
                dtsExportLines.append(contentsOf: dts)
            }
        }

        for skeletonSet in importedSkeletons {
            importedLines.append("const \(skeletonSet.moduleName) = importObject[\"\(skeletonSet.moduleName)\"] = {};")
            func assignToImportObject(name: String, function: [String]) {
                var js = function
                js[0] = "\(skeletonSet.moduleName)[\"\(name)\"] = " + js[0]
                importedLines.append(contentsOf: js)
            }
            for fileSkeleton in skeletonSet.children {
                for function in fileSkeleton.functions {
                    let (js, dts) = try renderImportedFunction(function: function)
                    assignToImportObject(name: function.abiName(context: nil), function: js)
                    dtsImportLines.append(contentsOf: dts)
                }
                for type in fileSkeleton.types {
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
                        assignToImportObject(name: getterAbiName, function: js)
                        dtsImportLines.append(contentsOf: dts)

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
                            assignToImportObject(name: setterAbiName, function: js)
                            dtsImportLines.append(contentsOf: dts)
                        }
                    }
                    for method in type.methods {
                        let (js, dts) = try renderImportedMethod(context: type, method: method)
                        assignToImportObject(name: method.abiName(context: type), function: js)
                        dtsImportLines.append(contentsOf: dts)
                    }
                }
            }
        }

        let outputJs = """
            // NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
            // DO NOT EDIT.
            //
            // To update this file, just rebuild your project or run
            // `swift package bridge-js`.

            export async function createInstantiator(options, swift) {
                let instance;
                let memory;
                const textDecoder = new TextDecoder("utf-8");
                const textEncoder = new TextEncoder("utf-8");

                let tmpRetString;
                let tmpRetBytes;
                return {
                    /** @param {WebAssembly.Imports} importObject */
                    addImports: (importObject) => {
                        const bjs = {};
                        importObject["bjs"] = bjs;
                        bjs["return_string"] = function(ptr, len) {
                            const bytes = new Uint8Array(memory.buffer, ptr, len);
                            tmpRetString = textDecoder.decode(bytes);
                        }
                        bjs["init_memory"] = function(sourceId, bytesPtr) {
                            const source = swift.memory.getObject(sourceId);
                            const bytes = new Uint8Array(memory.buffer, bytesPtr);
                            bytes.set(source);
                        }
                        bjs["make_jsstring"] = function(ptr, len) {
                            const bytes = new Uint8Array(memory.buffer, ptr, len);
                            return swift.memory.retain(textDecoder.decode(bytes));
                        }
                        bjs["init_memory_with_result"] = function(ptr, len) {
                            const target = new Uint8Array(memory.buffer, ptr, len);
                            target.set(tmpRetBytes);
                            tmpRetBytes = undefined;
                        }
            \(importedLines.map { $0.indent(count: 12) }.joined(separator: "\n"))
                    },
                    setInstance: (i) => {
                        instance = i;
                        memory = instance.exports.memory;
                    },
                    /** @param {WebAssembly.Instance} instance */
                    createExports: (instance) => {
                        const js = swift.memory.heap;
            \(classLines.map { $0.indent(count: 12) }.joined(separator: "\n"))
                        return {
            \(exportsLines.map { $0.indent(count: 16) }.joined(separator: "\n"))
                        };
                    },
                }
            }
            """
        var dtsLines: [String] = []
        dtsLines.append(contentsOf: dtsClassLines)
        dtsLines.append("export type Exports = {")
        dtsLines.append(contentsOf: dtsExportLines.map { $0.indent(count: 4) })
        dtsLines.append("}")
        dtsLines.append("export type Imports = {")
        dtsLines.append(contentsOf: dtsImportLines.map { $0.indent(count: 4) })
        dtsLines.append("}")
        let outputDts = """
            // NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
            // DO NOT EDIT.
            //
            // To update this file, just rebuild your project or run
            // `swift package bridge-js`.

            \(dtsLines.joined(separator: "\n"))
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

    class ExportedThunkBuilder {
        var bodyLines: [String] = []
        var cleanupLines: [String] = []
        var parameterForwardings: [String] = []

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
                bodyLines.append("const ret = new \(name)(\(call));")
                returnExpr = "ret"
            }
            return returnExpr
        }

        func callConstructor(abiName: String) -> String {
            return "instance.exports.\(abiName)(\(parameterForwardings.joined(separator: ", ")))"
        }

        func renderFunction(
            name: String,
            parameters: [Parameter],
            returnType: BridgeType,
            returnExpr: String?,
            isMethod: Bool
        ) -> [String] {
            var funcLines: [String] = []
            funcLines.append(
                "\(isMethod ? "" : "function ")\(name)(\(parameters.map { $0.name }.joined(separator: ", "))) {"
            )
            funcLines.append(contentsOf: bodyLines.map { $0.indent(count: 4) })
            funcLines.append(contentsOf: cleanupLines.map { $0.indent(count: 4) })
            if let returnExpr = returnExpr {
                funcLines.append("return \(returnExpr);".indent(count: 4))
            }
            funcLines.append("}")
            return funcLines
        }
    }

    private func renderTSSignature(parameters: [Parameter], returnType: BridgeType) -> String {
        return "(\(parameters.map { "\($0.name): \($0.type.tsType)" }.joined(separator: ", "))): \(returnType.tsType)"
    }

    func renderExportedFunction(function: ExportedFunction) -> (js: [String], dts: [String]) {
        let thunkBuilder = ExportedThunkBuilder()
        for param in function.parameters {
            thunkBuilder.lowerParameter(param: param)
        }
        let returnExpr = thunkBuilder.call(abiName: function.abiName, returnType: function.returnType)
        let funcLines = thunkBuilder.renderFunction(
            name: function.abiName,
            parameters: function.parameters,
            returnType: function.returnType,
            returnExpr: returnExpr,
            isMethod: false
        )
        var dtsLines: [String] = []
        dtsLines.append(
            "\(function.name)\(renderTSSignature(parameters: function.parameters, returnType: function.returnType));"
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

        if let constructor: ExportedConstructor = klass.constructor {
            let thunkBuilder = ExportedThunkBuilder()
            for param in constructor.parameters {
                thunkBuilder.lowerParameter(param: param)
            }
            let returnExpr = thunkBuilder.callConstructor(abiName: constructor.abiName)
            var funcLines: [String] = []
            funcLines.append("constructor(\(constructor.parameters.map { $0.name }.joined(separator: ", "))) {")
            funcLines.append(contentsOf: thunkBuilder.bodyLines.map { $0.indent(count: 4) })
            funcLines.append("super(\(returnExpr), instance.exports.bjs_\(klass.name)_deinit);".indent(count: 4))
            funcLines.append(contentsOf: thunkBuilder.cleanupLines.map { $0.indent(count: 4) })
            funcLines.append("}")
            jsLines.append(contentsOf: funcLines.map { $0.indent(count: 4) })

            dtsExportEntryLines.append(
                "new\(renderTSSignature(parameters: constructor.parameters, returnType: .swiftHeapObject(klass.name)));"
                    .indent(count: 4)
            )
        }

        for method in klass.methods {
            let thunkBuilder = ExportedThunkBuilder()
            thunkBuilder.lowerSelf()
            for param in method.parameters {
                thunkBuilder.lowerParameter(param: param)
            }
            let returnExpr = thunkBuilder.call(abiName: method.abiName, returnType: method.returnType)
            jsLines.append(
                contentsOf: thunkBuilder.renderFunction(
                    name: method.name,
                    parameters: method.parameters,
                    returnType: method.returnType,
                    returnExpr: returnExpr,
                    isMethod: true
                ).map { $0.indent(count: 4) }
            )
            dtsTypeLines.append(
                "\(method.name)\(renderTSSignature(parameters: method.parameters, returnType: method.returnType));"
                    .indent(count: 4)
            )
        }
        jsLines.append("}")

        dtsTypeLines.append("}")
        dtsExportEntryLines.append("}")

        return (jsLines, dtsTypeLines, dtsExportEntryLines)
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
            case .jsObject:
                parameterForwardings.append("swift.memory.getObject(\(param.name))")
            default:
                parameterForwardings.append(param.name)
            }
        }

        func renderFunction(
            name: String,
            returnExpr: String?
        ) -> [String] {
            var funcLines: [String] = []
            funcLines.append(
                "function \(name)(\(parameterNames.joined(separator: ", "))) {"
            )
            funcLines.append(contentsOf: bodyLines.map { $0.indent(count: 4) })
            if let returnExpr = returnExpr {
                funcLines.append("return \(returnExpr);".indent(count: 4))
            }
            funcLines.append("}")
            return funcLines
        }

        func call(name: String, returnType: BridgeType) {
            let call = "options.imports.\(name)(\(parameterForwardings.joined(separator: ", ")))"
            if returnType == .void {
                bodyLines.append("\(call);")
            } else {
                bodyLines.append("let ret = \(call);")
            }
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

    func renderImportedFunction(function: ImportedFunctionSkeleton) throws -> (js: [String], dts: [String]) {
        let thunkBuilder = ImportedThunkBuilder()
        for param in function.parameters {
            thunkBuilder.liftParameter(param: param)
        }
        thunkBuilder.call(name: function.name, returnType: function.returnType)
        let returnExpr = try thunkBuilder.lowerReturnValue(returnType: function.returnType)
        let funcLines = thunkBuilder.renderFunction(
            name: function.abiName(context: nil),
            returnExpr: returnExpr
        )
        var dtsLines: [String] = []
        dtsLines.append(
            "\(function.name)\(renderTSSignature(parameters: function.parameters, returnType: function.returnType));"
        )
        return (funcLines, dtsLines)
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
            returnExpr: returnExpr
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
            returnExpr: returnExpr
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
        case .jsObject:
            return "any"
        case .swiftHeapObject(let name):
            return name
        }
    }
}
