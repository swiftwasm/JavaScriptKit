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
        let swiftEffects = (signature.isAsync ? " async" : "") + (signature.isThrows ? " throws(JSException)" : "")
        let swiftReturnType = signature.returnType.closureSwiftType
        return "(\(closureParams))\(swiftEffects) -> \(swiftReturnType)"
    }

    func renderClosureHelpers(
        _ signature: ClosureSignature,
        accessLevel: BridgeJSAccessLevel = .internal
    ) throws -> [DeclSyntax] {
        let mangledName = signature.mangleName
        let helperName = "_BJS_Closure_\(mangledName)"
        let swiftClosureType = swiftClosureType(for: signature)

        let externName = "invoke_js_callback_\(signature.moduleName)_\(mangledName)"

        // Use CallJSEmission to generate the callback invocation
        let builder = try ImportTS.CallJSEmission(
            moduleName: "bjs",
            abiName: externName,
            effects: Effects(isAsync: signature.isAsync, isThrows: signature.isThrows),
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
                if signature.isThrows || signature.isAsync {
                    let sendingPrefix = signature.sendingParameters ? "sending " : ""
                    let typedParams =
                        signature.parameters.enumerated().map { index, paramType in
                            "param\(index): \(sendingPrefix)\(paramType.closureSwiftType)"
                        }.joined(separator: ", ")
                    let returnType = signature.returnType.closureSwiftType
                    let effects =
                        (signature.isAsync ? " async" : "") + (signature.isThrows ? " throws(JSException)" : "")
                    parameters = " (\(typedParams))\(effects) -> \(returnType)"
                } else if signature.parameters.isEmpty {
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

        let initAccessModifier = accessLevel.modifierKeyword.map { "\($0) " } ?? ""
        let typedClosureExtension: DeclSyntax = """
            extension JSTypedClosure where Signature == \(raw: swiftClosureType) {
                \(raw: initAccessModifier)init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping \(raw: swiftClosureType)) {
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
            liftedParams.append(
                "\(paramType.swiftType).bridgeJSLiftParameter(\(argNames.joined(separator: ", ")))"
            )
        }

        let tryPrefix = signature.isThrows ? "try " : ""
        let closureCallExpr = ExprSyntax("\(raw: tryPrefix)closure(\(raw: liftedParams.joined(separator: ", ")))")
        let asyncTryPrefix = (signature.isThrows ? "try " : "") + "await "
        let asyncClosureCallExpr = ExprSyntax(
            "\(raw: asyncTryPrefix)closure(\(raw: liftedParams.joined(separator: ", ")))"
        )

        let abiReturnWasmType =
            signature.isAsync
            ? try BridgeType.jsObject(nil).loweringReturnInfo().returnType
            : try signature.returnType.loweringReturnInfo().returnType

        // Build signature using SwiftSignatureBuilder
        let funcSignature = SwiftSignatureBuilder.buildABIFunctionSignature(
            abiParameters: abiParams,
            returnType: abiReturnWasmType
        )

        let emitCallAndLower: (CodeFragmentPrinter) -> Void = { printer in
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

        let emitAsyncCallAndLower: (CodeFragmentPrinter) -> Void = { printer in
            printer.write("let closure = Unmanaged<\(boxType)>.fromOpaque(boxPtr).takeUnretainedValue().closure")
            let resolveType = signature.returnType
            let resolveName = "Promise_resolve_\(resolveType.mangleTypeName)"
            let rejectName = "Promise_reject"
            let closureHead: String
            if signature.isThrows {
                let returnSpelling = resolveType == .void ? "" : " -> \(resolveType.closureSwiftType)"
                closureHead = " () async throws(JSException)\(returnSpelling) in"
            } else {
                closureHead = ""
            }
            printer.write("return _bjs_makePromise(resolve: \(resolveName), reject: \(rejectName)) {\(closureHead)")
            printer.indent {
                if resolveType == .void {
                    printer.write(asyncClosureCallExpr.description)
                } else {
                    printer.write("return \(asyncClosureCallExpr)")
                }
            }
            printer.write("}")
        }

        let catchPlaceholderStmt = abiReturnWasmType?.swiftReturnPlaceholderStmt

        // Build function declaration using helper
        let funcDecl = SwiftCodePattern.buildExposedFunctionDecl(
            abiName: abiName,
            signature: funcSignature
        ) { printer in
            if signature.isAsync {
                emitAsyncCallAndLower(printer)
            } else if signature.isThrows {
                printer.write(
                    "let closure = Unmanaged<\(boxType)>.fromOpaque(boxPtr).takeUnretainedValue().closure"
                )
                printer.write("do {")
                printer.indent {
                    emitCallAndLower(printer)
                }
                printer.write("} catch let error {")
                printer.indent {
                    printer.write("if let error = error.thrownValue.object {")
                    printer.indent {
                        printer.write("withExtendedLifetime(error) {")
                        printer.indent {
                            printer.write("_swift_js_throw(Int32(bitPattern: $0.id))")
                        }
                        printer.write("}")
                    }
                    printer.write("} else {")
                    printer.indent {
                        printer.write("let jsError = JSError(message: error.description)")
                        printer.write("withExtendedLifetime(jsError.jsObject) {")
                        printer.indent {
                            printer.write("_swift_js_throw(Int32(bitPattern: $0.id))")
                        }
                        printer.write("}")
                    }
                    printer.write("}")
                    if let catchPlaceholderStmt {
                        printer.write(catchPlaceholderStmt)
                    }
                }
                printer.write("}")
            } else {
                printer.write(
                    "let closure = Unmanaged<\(boxType)>.fromOpaque(boxPtr).takeUnretainedValue().closure"
                )
                emitCallAndLower(printer)
            }
        }

        return DeclSyntax(funcDecl)
    }

    public func renderSupport(for skeleton: BridgeJSSkeleton) throws -> String? {
        let collector = ClosureSignatureCollectorVisitor(moduleName: skeleton.moduleName)
        var walker = BridgeSkeletonWalker(visitor: collector)
        walker.walk(skeleton)
        let signatureAccessLevels = walker.visitor.signatureAccessLevels
        guard !signatureAccessLevels.isEmpty else { return nil }

        var decls: [DeclSyntax] = []
        for signature in signatureAccessLevels.keys.sorted(by: { $0.mangleName < $1.mangleName }) {
            let accessLevel = signatureAccessLevels[signature] ?? .internal
            decls.append(contentsOf: try renderClosureHelpers(signature, accessLevel: accessLevel))
            decls.append(try renderClosureInvokeHandler(signature))
        }

        return withSpan("Format Closure Glue") {
            let format = BasicFormat()
            return decls.map { $0.formatted(using: format).description }.joined(separator: "\n\n")
        }
    }
}
