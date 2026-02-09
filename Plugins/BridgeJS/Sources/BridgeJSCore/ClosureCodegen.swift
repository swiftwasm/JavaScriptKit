import SwiftBasicFormat
import SwiftSyntax
import SwiftSyntaxBuilder
#if canImport(BridgeJSSkeleton)
import BridgeJSSkeleton
#endif

public struct ClosureCodegen {
    public init() {}

    func collectClosureSignatures(from parameters: [Parameter], into signatures: inout Set<ClosureSignature>) {
        for param in parameters {
            collectClosureSignatures(from: param.type, into: &signatures)
        }
    }

    func collectClosureSignatures(from type: BridgeType, into signatures: inout Set<ClosureSignature>) {
        switch type {
        case .closure(let signature, _):
            signatures.insert(signature)
            for paramType in signature.parameters {
                collectClosureSignatures(from: paramType, into: &signatures)
            }
            collectClosureSignatures(from: signature.returnType, into: &signatures)
        case .nullable(let wrapped, _):
            collectClosureSignatures(from: wrapped, into: &signatures)
        default:
            break
        }
    }

    func renderClosureHelpers(_ signature: ClosureSignature) throws -> [DeclSyntax] {
        let mangledName = signature.mangleName
        let helperName = "_BJS_Closure_\(mangledName)"

        let closureParams = signature.parameters.enumerated().map { _, type in
            "\(type.swiftType)"
        }.joined(separator: ", ")

        let swiftEffects = (signature.isAsync ? " async" : "") + (signature.isThrows ? " throws" : "")
        let swiftReturnType = signature.returnType.swiftType
        let swiftClosureType = "(\(closureParams))\(swiftEffects) -> \(swiftReturnType)"

        let externName = "invoke_js_callback_\(signature.moduleName)_\(mangledName)"

        // Use CallJSEmission to generate the callback invocation
        let builder = ImportTS.CallJSEmission(
            moduleName: "bjs",
            abiName: externName,
            context: .exportSwift
        )

        // Lower the callback parameter
        try builder.lowerParameter(param: Parameter(label: nil, name: "callback", type: .jsObject(nil)))

        // Lower each closure parameter
        for (index, paramType) in signature.parameters.enumerated() {
            try builder.lowerParameter(param: Parameter(label: nil, name: "param\(index)", type: paramType))
        }

        // Generate the call and return value lifting
        try builder.call(returnType: signature.returnType)
        try builder.liftReturnValue(returnType: signature.returnType)

        // Get the body code
        let bodyCode = builder.getBody()

        // Generate extern declaration using CallJSEmission
        let externDecl = builder.renderImportDecl()

        let makeClosureExternDecl: DeclSyntax = """
            #if arch(wasm32)
            @_extern(wasm, module: "bjs", name: "make_swift_closure_\(raw: signature.moduleName)_\(raw: signature.mangleName)")
            fileprivate func make_swift_closure_\(raw: signature.moduleName)_\(raw: signature.mangleName)(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32
            #else
            fileprivate func make_swift_closure_\(raw: signature.moduleName)_\(raw: signature.mangleName)(_ boxPtr: UnsafeMutableRawPointer, _ file: UnsafePointer<UInt8>, _ line: UInt32) -> Int32 {
                fatalError("Only available on WebAssembly")
            }
            #endif
            """

        let helperEnumDecl = EnumDeclSyntax(
            modifiers: DeclModifierListSyntax {
                DeclModifierSyntax(name: .keyword(.private))
            },
            name: .identifier(helperName),
            memberBlockBuilder: {
                DeclSyntax(
                    FunctionDeclSyntax(
                        modifiers: DeclModifierListSyntax {
                            DeclModifierSyntax(name: .keyword(.static))
                        },
                        name: .identifier("bridgeJSLift"),
                        signature: FunctionSignatureSyntax(
                            parameterClause: FunctionParameterClauseSyntax {
                                FunctionParameterSyntax(
                                    firstName: .wildcardToken(),
                                    secondName: .identifier("callbackId"),
                                    colon: .colonToken(),
                                    type: IdentifierTypeSyntax(name: .identifier("Int32"))
                                )
                            },
                            returnClause: ReturnClauseSyntax(
                                arrow: .arrowToken(),
                                type: IdentifierTypeSyntax(name: .identifier(swiftClosureType))
                            )
                        ),
                        body: CodeBlockSyntax {
                            "let callback = JSObject.bridgeJSLiftParameter(callbackId)"
                            ReturnStmtSyntax(
                                expression: ClosureExprSyntax(
                                    leftBrace: .leftBraceToken(),
                                    signature: ClosureSignatureSyntax(
                                        capture: ClosureCaptureClauseSyntax(
                                            leftSquare: .leftSquareToken(),
                                            items: ClosureCaptureListSyntax {
                                                #if canImport(SwiftSyntax602)
                                                ClosureCaptureSyntax(
                                                    name: .identifier("", presence: .missing),
                                                    initializer: InitializerClauseSyntax(
                                                        equal: .equalToken(presence: .missing),
                                                        nil,
                                                        value: ExprSyntax("callback")
                                                    ),
                                                    trailingTrivia: nil
                                                )
                                                #else
                                                ClosureCaptureSyntax(
                                                    expression: ExprSyntax("callback")
                                                )
                                                #endif
                                            },
                                            rightSquare: .rightSquareToken()
                                        ),
                                        parameterClause: .simpleInput(
                                            ClosureShorthandParameterListSyntax {
                                                for (index, _) in signature.parameters.enumerated() {
                                                    ClosureShorthandParameterSyntax(name: .identifier("param\(index)"))
                                                }
                                            }
                                        ),
                                        inKeyword: .keyword(.in)
                                    ),
                                    statements: CodeBlockItemListSyntax {
                                        SwiftCodePattern.buildWasmConditionalCompilation(wasmBody: bodyCode.statements)
                                    },
                                    rightBrace: .rightBraceToken()
                                )
                            )
                        }
                    )
                )
            }
        )
        let typedClosureExtension: DeclSyntax = """
            extension JSTypedClosure where Signature == \(raw: swiftClosureType) {
                init(fileID: StaticString = #fileID, line: UInt32 = #line, _ body: @escaping \(raw: swiftClosureType)) {
                    self.init(
                        makeClosure: make_swift_closure_\(raw: signature.moduleName)_\(raw: signature.mangleName),
                        body: body,
                        fileID: fileID,
                        line: line
                    )
                }
            }
            """

        return [
            externDecl, makeClosureExternDecl, DeclSyntax(helperEnumDecl), typedClosureExtension,
        ]
    }

    func renderClosureInvokeHandler(_ signature: ClosureSignature) throws -> DeclSyntax {
        let closureParams = signature.parameters.enumerated().map { _, type in
            "\(type.swiftType)"
        }.joined(separator: ", ")
        let swiftEffects = (signature.isAsync ? " async" : "") + (signature.isThrows ? " throws" : "")
        let swiftReturnType = signature.returnType.swiftType
        let swiftClosureType = "(\(closureParams))\(swiftEffects) -> \(swiftReturnType)"
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

        // Determine return type
        let abiReturnWasmType: WasmCoreType?
        if signature.returnType == .void {
            abiReturnWasmType = nil
        } else if let wasmType = try signature.returnType.loweringReturnInfo().returnType {
            abiReturnWasmType = wasmType
        } else {
            abiReturnWasmType = nil
        }

        let throwReturn = abiReturnWasmType?.swiftReturnPlaceholderStmt ?? "return"

        // Build signature using SwiftSignatureBuilder
        let funcSignature = SwiftSignatureBuilder.buildABIFunctionSignature(
            abiParameters: abiParams,
            returnType: abiReturnWasmType
        )

        // Build body
        let body = CodeBlockItemListSyntax {
            "let closure = Unmanaged<\(raw: boxType)>.fromOpaque(boxPtr).takeUnretainedValue().closure"
            if signature.returnType == .void {
                closureCallExpr
            } else {
                "let result = \(closureCallExpr)"
                "return result.bridgeJSLowerReturn()"
            }
        }

        // Build function declaration using helper
        let funcDecl = SwiftCodePattern.buildExposedFunctionDecl(
            abiName: abiName,
            signature: funcSignature,
            body: body
        )

        return DeclSyntax(funcDecl)
    }

    public func renderSupport(for skeleton: BridgeJSSkeleton) throws -> String? {
        var closureSignatures: Set<ClosureSignature> = []

        if let exported = skeleton.exported {
            for function in exported.functions {
                collectClosureSignatures(from: function.parameters, into: &closureSignatures)
                collectClosureSignatures(from: function.returnType, into: &closureSignatures)
            }
            for klass in exported.classes {
                if let constructor = klass.constructor {
                    collectClosureSignatures(from: constructor.parameters, into: &closureSignatures)
                }
                for method in klass.methods {
                    collectClosureSignatures(from: method.parameters, into: &closureSignatures)
                    collectClosureSignatures(from: method.returnType, into: &closureSignatures)
                }
                for property in klass.properties {
                    collectClosureSignatures(from: property.type, into: &closureSignatures)
                }
            }
            for proto in exported.protocols {
                for method in proto.methods {
                    collectClosureSignatures(from: method.parameters, into: &closureSignatures)
                    collectClosureSignatures(from: method.returnType, into: &closureSignatures)
                }
                for property in proto.properties {
                    collectClosureSignatures(from: property.type, into: &closureSignatures)
                }
            }
            for structDecl in exported.structs {
                for property in structDecl.properties {
                    collectClosureSignatures(from: property.type, into: &closureSignatures)
                }
                if let constructor = structDecl.constructor {
                    collectClosureSignatures(from: constructor.parameters, into: &closureSignatures)
                }
                for method in structDecl.methods {
                    collectClosureSignatures(from: method.parameters, into: &closureSignatures)
                    collectClosureSignatures(from: method.returnType, into: &closureSignatures)
                }
            }
            for enumDecl in exported.enums {
                for method in enumDecl.staticMethods {
                    collectClosureSignatures(from: method.parameters, into: &closureSignatures)
                    collectClosureSignatures(from: method.returnType, into: &closureSignatures)
                }
                for property in enumDecl.staticProperties {
                    collectClosureSignatures(from: property.type, into: &closureSignatures)
                }
            }
        }

        if let imported = skeleton.imported {
            for fileSkeleton in imported.children {
                for getter in fileSkeleton.globalGetters {
                    collectClosureSignatures(from: getter.type, into: &closureSignatures)
                }
                for function in fileSkeleton.functions {
                    collectClosureSignatures(from: function.parameters, into: &closureSignatures)
                    collectClosureSignatures(from: function.returnType, into: &closureSignatures)
                }
                for type in fileSkeleton.types {
                    if let constructor = type.constructor {
                        collectClosureSignatures(from: constructor.parameters, into: &closureSignatures)
                    }
                    for getter in type.getters {
                        collectClosureSignatures(from: getter.type, into: &closureSignatures)
                    }
                    for setter in type.setters {
                        collectClosureSignatures(from: setter.type, into: &closureSignatures)
                    }
                    for method in type.methods + type.staticMethods {
                        collectClosureSignatures(from: method.parameters, into: &closureSignatures)
                        collectClosureSignatures(from: method.returnType, into: &closureSignatures)
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
