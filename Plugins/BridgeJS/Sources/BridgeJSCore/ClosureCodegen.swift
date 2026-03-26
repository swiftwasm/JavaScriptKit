import SwiftBasicFormat
import SwiftSyntax
import SwiftSyntaxBuilder
#if canImport(BridgeJSSkeleton)
import BridgeJSSkeleton
#endif
#if canImport(BridgeJSUtilities)
import BridgeJSUtilities
#endif

public struct ClosureCodegen {
    public init() {}

    private func swiftClosureType(for signature: ClosureSignature) -> String {
        let sendingPrefix = signature.sendingParameters ? "sending " : ""
        let closureParams = signature.parameters.map { "\(sendingPrefix)\($0.closureSwiftType)" }.joined(
            separator: ", "
        )
        let swiftEffects = (signature.isAsync ? " async" : "") + (signature.isThrows ? " throws" : "")
        let swiftReturnType = signature.returnType.closureSwiftType
        return "(\(closureParams))\(swiftEffects) -> \(swiftReturnType)"
    }

    func renderClosureHelpers(_ signature: ClosureSignature) throws -> [DeclSyntax] {
        let mangledName = signature.mangleName
        let helperName = "_BJS_Closure_\(mangledName)"
        let swiftClosureType = swiftClosureType(for: signature)

        let externName = "invoke_js_callback_\(signature.moduleName)_\(mangledName)"

        // Use CallJSEmission to generate the callback invocation
        let builder = try ImportTS.CallJSEmission(
            moduleName: "bjs",
            abiName: externName,
            returnType: signature.returnType,
            context: .exportSwift
        )

        // Lower the callback parameter
        try builder.lowerParameter(param: Parameter(label: nil, name: "callback", type: .jsObject(nil)))

        // Lower each closure parameter
        for (index, paramType) in signature.parameters.enumerated() {
            try builder.lowerParameter(param: Parameter(label: nil, name: "param\(index)", type: paramType))
        }

        // Generate the call and return value lifting
        try builder.call()
        try builder.liftReturnValue()

        // Generate extern declaration using CallJSEmission
        let externDecl = builder.renderImportDecl()
        let externABIName = "make_swift_closure_\(signature.moduleName)_\(signature.mangleName)"
        let externDeclPrinter = CodeFragmentPrinter()
        SwiftCodePattern.buildExternFunctionDecl(
            printer: externDeclPrinter,
            moduleName: "bjs",
            abiName: externABIName,
            functionName: externABIName,
            signature: "(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32",
            parameterNames: ["boxPtr", "file", "line"]
        )
        let makeClosureExternDecl: DeclSyntax = "\(raw: externDeclPrinter.lines.joined(separator: "\n"))"

        let helperEnumDeclPrinter = CodeFragmentPrinter()
        helperEnumDeclPrinter.write("private enum \(helperName) {")
        helperEnumDeclPrinter.indent {
            helperEnumDeclPrinter.write("static func bridgeJSLift(_ callbackId: Int32) -> \(swiftClosureType) {")
            helperEnumDeclPrinter.indent {
                helperEnumDeclPrinter.write("let callback = JSObject.bridgeJSLiftParameter(callbackId)")
                let parameters: String
                if signature.parameters.isEmpty {
                    parameters = ""
                } else if signature.parameters.count == 1 {
                    parameters = " param0"
                } else {
                    parameters =
                        " ("
                        + signature.parameters.enumerated().map { index, _ in
                            "param\(index)"
                        }.joined(separator: ", ") + ")"
                }
                helperEnumDeclPrinter.write("return { [callback]\(parameters) in")
                helperEnumDeclPrinter.indent {
                    SwiftCodePattern.buildWasmConditionalCompilation(
                        printer: helperEnumDeclPrinter,
                        wasmBody: { printer in
                            printer.write(lines: builder.body.lines)
                        }
                    )
                }
                helperEnumDeclPrinter.write("}")

            }
            helperEnumDeclPrinter.write("}")
        }
        helperEnumDeclPrinter.write("}")

        let helperEnumDecl: DeclSyntax = "\(raw: helperEnumDeclPrinter.lines.joined(separator: "\n"))"

        let typedClosureExtension: DeclSyntax = """
            extension JSTypedClosure where Signature == \(raw: swiftClosureType) {
                init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping \(raw: swiftClosureType)) {
                    self.init(
                        makeClosure: \(raw: externABIName),
                        body: body,
                        fileID: fileID,
                        line: line
                    )
                }
            }
            """

        return [
            externDecl, makeClosureExternDecl, helperEnumDecl, typedClosureExtension,
        ]
    }

    func renderClosureInvokeHandler(_ signature: ClosureSignature) throws -> DeclSyntax {
        let swiftClosureType = swiftClosureType(for: signature)
        let boxType = "_BridgeJSTypedClosureBox<\(swiftClosureType)>"
        let abiName = "invoke_swift_closure_\(signature.moduleName)_\(signature.mangleName)"

        // Build ABI parameters directly with WasmCoreType (no string conversion needed)
        var abiParams: [(name: String, type: WasmCoreType)] = [("boxPtr", .pointer)]
        var liftedParams: [String] = []

        for (index, paramType) in signature.parameters.enumerated() {
            let paramName = "param\(index)"
            let liftInfo = try paramType.liftParameterInfo()

            for (argName, wasmType) in liftInfo.parameters {
                let fullName =
                    liftInfo.parameters.count > 1 ? "\(paramName)\(argName.capitalizedFirstLetter)" : paramName
                abiParams.append((fullName, wasmType))
            }

            let argNames = liftInfo.parameters.map { (argName, _) in
                liftInfo.parameters.count > 1 ? "\(paramName)\(argName.capitalizedFirstLetter)" : paramName
            }
            liftedParams.append("\(paramType.swiftType).bridgeJSLiftParameter(\(argNames.joined(separator: ", ")))")
        }

        let closureCallExpr = ExprSyntax("closure(\(raw: liftedParams.joined(separator: ", ")))")

        let abiReturnWasmType = try signature.returnType.loweringReturnInfo().returnType

        // Build signature using SwiftSignatureBuilder
        let funcSignature = SwiftSignatureBuilder.buildABIFunctionSignature(
            abiParameters: abiParams,
            returnType: abiReturnWasmType
        )

        // Build function declaration using helper
        let funcDecl = SwiftCodePattern.buildExposedFunctionDecl(
            abiName: abiName,
            signature: funcSignature
        ) { printer in
            printer.write("let closure = Unmanaged<\(boxType)>.fromOpaque(boxPtr).takeUnretainedValue().closure")
            if signature.returnType == .void {
                printer.write(closureCallExpr.description)
            } else {
                printer.write("let result = \(closureCallExpr)")
                switch signature.returnType {
                case .swiftProtocol:
                    printer.write(
                        "return (result as! _BridgedSwiftProtocolExportable).bridgeJSLowerAsProtocolReturn()"
                    )
                case .nullable(.swiftProtocol, _):
                    printer.write("if let result {")
                    printer.indent {
                        printer.write(
                            "_swift_js_return_optional_object(1, (result as! _BridgedSwiftProtocolExportable).bridgeJSLowerAsProtocolReturn())"
                        )
                    }
                    printer.write("} else {")
                    printer.indent {
                        printer.write("_swift_js_return_optional_object(0, 0)")
                    }
                    printer.write("}")
                default:
                    printer.write("return result.bridgeJSLowerReturn()")
                }
            }
        }

        return DeclSyntax(funcDecl)
    }

    public func renderSupport(for skeleton: BridgeJSSkeleton) throws -> String? {
        let collector = ClosureSignatureCollectorVisitor()
        var walker = BridgeTypeWalker(visitor: collector)
        walker.walk(skeleton)
        var closureSignatures = walker.visitor.signatures

        // When async imports exist, inject closure signatures for the typed resolve
        // and reject callbacks used by _bjs_awaitPromise.
        // - Reject always uses (sending JSValue) -> Void
        // - Resolve uses a typed closure matching the return type (or () -> Void for void)
        // All async callback closures use `sending` parameters so values can be
        // transferred through the checked continuation without Sendable constraints.
        if let imported = skeleton.imported {
            for file in imported.children {
                for function in file.functions where function.effects.isAsync {
                    // Reject callback
                    closureSignatures.insert(
                        ClosureSignature(
                            parameters: [.jsValue],
                            returnType: .void,
                            moduleName: skeleton.moduleName,
                            sendingParameters: true
                        )
                    )
                    // Resolve callback (typed per return type)
                    if function.returnType == .void {
                        closureSignatures.insert(
                            ClosureSignature(
                                parameters: [],
                                returnType: .void,
                                moduleName: skeleton.moduleName
                            )
                        )
                    } else {
                        closureSignatures.insert(
                            ClosureSignature(
                                parameters: [function.returnType],
                                returnType: .void,
                                moduleName: skeleton.moduleName,
                                sendingParameters: true
                            )
                        )
                    }
                }
                for type in file.types {
                    for method in (type.methods + type.staticMethods) where method.effects.isAsync {
                        closureSignatures.insert(
                            ClosureSignature(
                                parameters: [.jsValue],
                                returnType: .void,
                                moduleName: skeleton.moduleName,
                                sendingParameters: true
                            )
                        )
                        if method.returnType == .void {
                            closureSignatures.insert(
                                ClosureSignature(
                                    parameters: [],
                                    returnType: .void,
                                    moduleName: skeleton.moduleName
                                )
                            )
                        } else {
                            closureSignatures.insert(
                                ClosureSignature(
                                    parameters: [method.returnType],
                                    returnType: .void,
                                    moduleName: skeleton.moduleName,
                                    sendingParameters: true
                                )
                            )
                        }
                    }
                }
            }
        }

        guard !closureSignatures.isEmpty else { return nil }

        var decls: [DeclSyntax] = []
        for signature in closureSignatures.sorted(by: { $0.mangleName < $1.mangleName }) {
            decls.append(contentsOf: try renderClosureHelpers(signature))
            decls.append(try renderClosureInvokeHandler(signature))
        }

        return withSpan("Format Closure Glue") {
            let format = BasicFormat()
            return decls.map { $0.formatted(using: format).description }.joined(separator: "\n\n")
        }
    }
}
