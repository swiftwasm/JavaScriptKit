/**
 * TypeScript type processing functionality
 * @module processor
 */

// @ts-check
import ts from 'typescript';

/** @typedef {import('./index.d.ts').Parameter} Parameter */

/**
 * @typedef {{
 *   print: (level: "warning" | "error", message: string, node?: ts.Node) => void,
 * }} DiagnosticEngine
 */

/**
 * TypeScript type processor class
 */
export class TypeProcessor {
    /**
     * Create a TypeScript program from a d.ts file
     * @param {string} filePath - Path to the d.ts file
     * @param {ts.CompilerOptions} options - Compiler options
     * @returns {ts.Program} TypeScript program object
     */
    static createProgram(filePath, options) {
        const host = ts.createCompilerHost(options);
        return ts.createProgram([filePath], options, host);
    }

    /**
     * @param {ts.TypeChecker} checker - TypeScript type checker
     * @param {DiagnosticEngine} diagnosticEngine - Diagnostic engine
     */
    constructor(checker, diagnosticEngine, options = {
        inheritIterable: true,
        inheritArraylike: true,
        inheritPromiselike: true,
        addAllParentMembersToClass: true,
        replaceAliasToFunction: true,
        replaceRankNFunction: true,
        replaceNewableFunction: true,
        noExtendsInTyprm: false,
    }) {
        this.checker = checker;
        this.diagnosticEngine = diagnosticEngine;
        this.options = options;

        /** @type {Map<ts.Type, string>} */
        this.processedTypes = new Map();
        /** @type {Map<ts.Type, ts.Node>} Seen position by type */
        this.seenTypes = new Map();
        /** @type {string[]} Collected Swift code lines */
        this.swiftLines = [];

        /** @type {Set<string>} */
        this.visitedDeclarationKeys = new Set();
    }

    /**
     * Process type declarations from a TypeScript program and render Swift code
     * @param {ts.Program} program - TypeScript program
     * @param {string} inputFilePath - Path to the input file
     * @returns {{ content: string, hasAny: boolean }} Rendered Swift code
     */
    processTypeDeclarations(program, inputFilePath) {
        const sourceFiles = program.getSourceFiles().filter(
            sf => !sf.isDeclarationFile || sf.fileName === inputFilePath
        );

        // Add prelude
        this.swiftLines.push(
            "// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,",
            "// DO NOT EDIT.",
            "//",
            "// To update this file, just rebuild your project or run",
            "// `swift package bridge-js`.",
            "",
            "@_spi(Experimental) import JavaScriptKit",
            ""
        );

        for (const sourceFile of sourceFiles) {
            if (sourceFile.fileName.includes('node_modules/typescript/lib')) continue;

            Error.stackTraceLimit = 100;

            try {
                sourceFile.forEachChild(node => {
                    this.visitNode(node);

                    for (const [type, node] of this.seenTypes) {
                        this.seenTypes.delete(type);
                        const typeString = this.checker.typeToString(type);
                        const members = type.getProperties();
                        if (members) {
                            this.visitStructuredType(typeString, members);
                        }
                    }
                });
            } catch (error) {
                this.diagnosticEngine.print("error", `Error processing ${sourceFile.fileName}: ${error.message}`);
            }
        }

        const content = this.swiftLines.join("\n").trimEnd() + "\n";
        const hasAny = this.swiftLines.length > 9; // More than just the prelude
        return { content, hasAny };
    }


    /**
     * Visit a node and process it
     * @param {ts.Node} node - The node to visit
     */
    visitNode(node) {
        if (ts.isFunctionDeclaration(node)) {
            this.visitFunctionDeclaration(node);
        } else if (ts.isClassDeclaration(node)) {
            this.visitClassDecl(node);
        } else if (ts.isExportDeclaration(node)) {
            this.visitExportDeclaration(node);
        }
    }

    /**
     * Visit an export declaration and process re-exports like:
     * - export { Thing } from "./module";
     * - export { Thing as Alias } from "./module";
     * - export * from "./module";
     * @param {ts.ExportDeclaration} node
     */
    visitExportDeclaration(node) {
        if (!node.moduleSpecifier) return;

        const moduleSymbol = this.checker.getSymbolAtLocation(node.moduleSpecifier);
        if (!moduleSymbol) {
            this.diagnosticEngine.print("warning", "Failed to resolve module for export declaration", node);
            return;
        }

        /** @type {ts.Symbol[]} */
        let targetSymbols = [];

        if (!node.exportClause) {
            // export * from "..."
            targetSymbols = this.checker.getExportsOfModule(moduleSymbol);
        } else if (ts.isNamedExports(node.exportClause)) {
            const moduleExports = this.checker.getExportsOfModule(moduleSymbol);
            for (const element of node.exportClause.elements) {
                const originalName = element.propertyName?.text ?? element.name.text;

                const match = moduleExports.find(s => s.name === originalName);
                if (match) {
                    targetSymbols.push(match);
                    continue;
                }

                // Fallback for unusual bindings/resolution failures.
                const fallback = this.checker.getSymbolAtLocation(element.propertyName ?? element.name);
                if (fallback) {
                    targetSymbols.push(fallback);
                    continue;
                }

                this.diagnosticEngine.print("warning", `Failed to resolve re-exported symbol '${originalName}'`, node);
            }
        } else {
            // export * as ns from "..." is not currently supported by BridgeJS imports.
            return;
        }

        for (const symbol of targetSymbols) {
            const declarations = symbol.getDeclarations() ?? [];
            for (const declaration of declarations) {
                // Avoid duplicate emission when the same declaration is reached via multiple re-exports.
                const sourceFile = declaration.getSourceFile();
                const key = `${sourceFile.fileName}:${declaration.pos}:${declaration.end}`;
                if (this.visitedDeclarationKeys.has(key)) continue;
                this.visitedDeclarationKeys.add(key);

                this.visitNode(declaration);
            }
        }
    }

    /**
     * Visit a function declaration and render Swift code
     * @param {ts.FunctionDeclaration} node - The function node
     * @private
     */
    visitFunctionDeclaration(node) {
        if (!node.name) return;
        const name = node.name.getText();
        if (!isValidSwiftDeclName(name)) {
            return;
        }

        const signature = this.checker.getSignatureFromDeclaration(node);
        if (!signature) return;

        const params = this.renderParameters(signature.getParameters(), node);
        const returnType = this.visitType(signature.getReturnType(), node);
        const effects = this.renderEffects({ isAsync: false });
        const swiftName = this.renderIdentifier(name);

        this.swiftLines.push(`@JSFunction func ${swiftName}(${params}) ${effects} -> ${returnType}`);
        this.swiftLines.push("");
    }

    /**
     * Get the full JSDoc text from a node
     * @param {ts.Node} node - The node to get the JSDoc text from
     * @returns {string | undefined} The full JSDoc text
     */
    getFullJSDocText(node) {
        const docs = ts.getJSDocCommentsAndTags(node);
        const parts = [];
        for (const doc of docs) {
            if (ts.isJSDoc(doc)) {
                parts.push(doc.comment ?? "");
            }
        }
        if (parts.length === 0) return undefined;
        return parts.join("\n");
    }

    /**
     * Render constructor parameters
     * @param {ts.ConstructorDeclaration} node
     * @returns {string} Rendered parameters
     * @private
     */
    renderConstructorParameters(node) {
        const signature = this.checker.getSignatureFromDeclaration(node);
        if (!signature) return "";

        return this.renderParameters(signature.getParameters(), node);
    }

    /**
     * @param {ts.PropertyDeclaration | ts.PropertySignature} node
     * @returns {{ name: string, type: string, isReadonly: boolean, documentation: string | undefined } | null}
     */
    visitPropertyDecl(node) {
        if (!node.name) return null;

        const propertyName = node.name.getText();
        if (!isValidSwiftDeclName(propertyName)) {
            return null;
        }

        const type = this.checker.getTypeAtLocation(node)
        const swiftType = this.visitType(type, node);
        const isReadonly = node.modifiers?.some(m => m.kind === ts.SyntaxKind.ReadonlyKeyword) ?? false;
        const documentation = this.getFullJSDocText(node);
        return { name: propertyName, type: swiftType, isReadonly, documentation };
    }

    /**
     * @param {ts.Symbol} symbol
     * @param {ts.Node} node
     * @returns {Parameter}
     */
    visitSignatureParameter(symbol, node) {
        const type = this.checker.getTypeOfSymbolAtLocation(symbol, node);
        const swiftType = this.visitType(type, node);
        return { name: symbol.name, type: swiftType };
    }

    /**
     * Visit a class declaration and render Swift code
     * @param {ts.ClassDeclaration} node
     * @private
     */
    visitClassDecl(node) {
        if (!node.name) return;

        const className = this.renderIdentifier(node.name.text);
        this.swiftLines.push(`@JSClass struct ${className} {`);

        // Process members in declaration order
        for (const member of node.members) {
            if (ts.isPropertyDeclaration(member)) {
                this.renderProperty(member);
            } else if (ts.isMethodDeclaration(member)) {
                this.renderMethod(member);
            } else if (ts.isConstructorDeclaration(member)) {
                this.renderConstructor(member);
            }
        }

        this.swiftLines.push("}");
        this.swiftLines.push("");
    }

    /**
     * @param {ts.SymbolFlags} flags
     * @returns {string[]}
     */
    debugSymbolFlags(flags) {
        const result = [];
        for (const key in ts.SymbolFlags) {
            const val = (ts.SymbolFlags)[key];
            if (typeof val === "number" && (flags & val) !== 0) {
                result.push(key);
            }
        }
        return result;
    }

    /**
     * @param {ts.TypeFlags} flags
     * @returns {string[]}
     */
    debugTypeFlags(flags) {
        const result = [];
        for (const key in ts.TypeFlags) {
            const val = (ts.TypeFlags)[key];
            if (typeof val === "number" && (flags & val) !== 0) {
                result.push(key);
            }
        }
        return result;
    }

    /**
     * Visit a structured type (interface) and render Swift code
     * @param {string} name
     * @param {ts.Symbol[]} members
     * @private
     */
    visitStructuredType(name, members) {
        const typeName = this.renderIdentifier(name);
        this.swiftLines.push(`@JSClass struct ${typeName} {`);

        // Collect all declarations with their positions to preserve order
        /** @type {Array<{ decl: ts.Node, symbol: ts.Symbol, position: number }>} */
        const allDecls = [];

        for (const symbol of members) {
            for (const decl of symbol.getDeclarations() ?? []) {
                const sourceFile = decl.getSourceFile();
                const pos = sourceFile ? decl.getStart() : 0;
                allDecls.push({ decl, symbol, position: pos });
            }
        }

        // Sort by position to preserve declaration order
        allDecls.sort((a, b) => a.position - b.position);

        // Process declarations in order
        for (const { decl, symbol } of allDecls) {
            if (symbol.flags & ts.SymbolFlags.Property) {
                if (ts.isPropertyDeclaration(decl) || ts.isPropertySignature(decl)) {
                    this.renderProperty(decl);
                } else if (ts.isMethodSignature(decl)) {
                    this.renderMethodSignature(decl);
                }
            } else if (symbol.flags & ts.SymbolFlags.Method) {
                if (ts.isMethodSignature(decl)) {
                    this.renderMethodSignature(decl);
                }
            } else if (symbol.flags & ts.SymbolFlags.Constructor) {
                if (ts.isConstructorDeclaration(decl)) {
                    this.renderConstructor(decl);
                }
            }
        }

        this.swiftLines.push("}");
        this.swiftLines.push("");
    }

    /**
     * Convert TypeScript type to Swift type string
     * @param {ts.Type} type - TypeScript type
     * @param {ts.Node} node - Node
     * @returns {string} Swift type string
     * @private
     */
    visitType(type, node) {
        // Treat A<B> and A<C> as the same type
        if (isTypeReference(type)) {
            type = type.target;
        }
        const maybeProcessed = this.processedTypes.get(type);
        if (maybeProcessed) {
            return maybeProcessed;
        }
        /**
         * @param {ts.Type} type
         * @returns {string}
         */
        const convert = (type) => {
            /** @type {Record<string, string>} */
            const typeMap = {
                "number": "Double",
                "string": "String",
                "boolean": "Bool",
                "void": "Void",
                "any": "JSObject",
                "unknown": "JSObject",
                "null": "Void",
                "undefined": "Void",
                "bigint": "Int",
                "object": "JSObject",
                "symbol": "JSObject",
                "never": "Void",
                "Promise": "JSPromise",
            };
            const typeString = type.getSymbol()?.name ?? this.checker.typeToString(type);
            if (typeMap[typeString]) {
                return typeMap[typeString];
            }

            if (this.checker.isArrayType(type) || this.checker.isTupleType(type) || type.getCallSignatures().length > 0) {
                return "JSObject";
            }
            // "a" | "b" -> string
            if (this.checker.isTypeAssignableTo(type, this.checker.getStringType())) {
                return "String";
            }
            if (type.isTypeParameter()) {
                return "JSObject";
            }

            const typeName = this.deriveTypeName(type);
            if (!typeName) {
                this.diagnosticEngine.print("warning", `Unknown non-nominal type: ${typeString}`, node);
                return "JSObject";
            }
            this.seenTypes.set(type, node);
            return this.renderIdentifier(typeName);
        }
        const swiftType = convert(type);
        this.processedTypes.set(type, swiftType);
        return swiftType;
    }

    /**
     * Derive the type name from a type
     * @param {ts.Type} type - TypeScript type
     * @returns {string | undefined} Type name
     * @private
     */
    deriveTypeName(type) {
        const aliasSymbol = type.aliasSymbol;
        if (aliasSymbol) {
            return aliasSymbol.name;
        }
        const typeSymbol = type.getSymbol();
        if (typeSymbol) {
            return typeSymbol.name;
        }
        return undefined;
    }

    /**
     * Render a property declaration
     * @param {ts.PropertyDeclaration | ts.PropertySignature} node
     * @private
     */
    renderProperty(node) {
        const property = this.visitPropertyDecl(node);
        if (!property) return;

        const type = property.type;
        const name = this.renderIdentifier(property.name);

        // Always render getter
        this.swiftLines.push(`    @JSGetter var ${name}: ${type}`);

        // Render setter if not readonly
        if (!property.isReadonly) {
            const capitalizedName = property.name.charAt(0).toUpperCase() + property.name.slice(1);
            const needsJSNameField = property.name.charAt(0) != capitalizedName.charAt(0).toLowerCase();
            const setterName = `set${capitalizedName}`;
            const annotation = needsJSNameField ? `@JSSetter(jsName: "${property.name}")` : "@JSSetter";
            this.swiftLines.push(`    ${annotation} func ${this.renderIdentifier(setterName)}(_ value: ${type}) ${this.renderEffects({ isAsync: false })}`);
        }
    }

    /**
     * Render a method declaration
     * @param {ts.MethodDeclaration | ts.MethodSignature} node
     * @private
     */
    renderMethod(node) {
        if (!node.name) return;
        const name = node.name.getText();
        if (!isValidSwiftDeclName(name)) return;

        const signature = this.checker.getSignatureFromDeclaration(node);
        if (!signature) return;

        const params = this.renderParameters(signature.getParameters(), node);
        const returnType = this.visitType(signature.getReturnType(), node);
        const effects = this.renderEffects({ isAsync: false });
        const swiftName = this.renderIdentifier(name);

        this.swiftLines.push(`    @JSFunction func ${swiftName}(${params}) ${effects} -> ${returnType}`);
    }

    /**
     * Render a method signature (from interface)
     * @param {ts.MethodSignature} node
     * @private
     */
    renderMethodSignature(node) {
        this.renderMethod(node);
    }

    /**
     * Render a constructor declaration
     * @param {ts.ConstructorDeclaration} node
     * @private
     */
    renderConstructor(node) {
        const params = this.renderConstructorParameters(node);
        const effects = this.renderEffects({ isAsync: false });
        this.swiftLines.push(`    @JSFunction init(${params}) ${effects}`);
    }

    /**
     * Render function parameters
     * @param {ts.Symbol[]} parameters
     * @param {ts.Node} node
     * @returns {string}
     * @private
     */
    renderParameters(parameters, node) {
        const params = [];
        for (const p of parameters) {
            const param = this.visitSignatureParameter(p, node);
            const paramName = this.renderIdentifier(p.name);
            const type = param.type;
            params.push(`_ ${paramName}: ${type}`);
        }
        return params.join(", ");
    }

    /**
     * Render effects (async/throws)
     * @param {{ isAsync: boolean }} effects
     * @returns {string}
     * @private
     */
    renderEffects(effects) {
        const parts = [];
        if (effects?.isAsync) {
            parts.push("async");
        }
        parts.push("throws (JSException)");
        return parts.join(" ");
    }

    /**
     * Render identifier with backticks if needed
     * @param {string} name
     * @returns {string}
     * @private
     */
    renderIdentifier(name) {
        if (!name) return name;
        if (!isValidSwiftDeclName(name) || isSwiftKeyword(name)) {
            return `\`${name}\``;
        }
        return name;
    }
}


const SWIFT_KEYWORDS = new Set([
    "associatedtype", "class", "deinit", "enum", "extension", "fileprivate",
    "func", "import", "init", "inout", "internal", "let", "open", "operator",
    "private", "protocol", "public", "static", "struct", "subscript", "typealias",
    "var", "break", "case", "continue", "default", "defer", "do", "else",
    "fallthrough", "for", "guard", "if", "in", "repeat", "return", "switch",
    "where", "while", "as", "Any", "catch", "false", "is", "nil", "rethrows",
    "super", "self", "Self", "throw", "throws", "true", "try",
    "prefix", "postfix", "infix"  // Contextual keywords for operator declarations
]);

/**
 * @param {string} name
 * @returns {boolean}
 */
function isSwiftKeyword(name) {
    return SWIFT_KEYWORDS.has(name);
}

/**
 * @param {ts.Type} type
 * @returns {type is ts.ObjectType}
 */
function isObjectType(type) {
    // @ts-ignore
    return typeof type.objectFlags === "number";
}

/**
 *
 * @param {ts.Type} type
 * @returns {type is ts.TypeReference}
 */
function isTypeReference(type) {
    return (
        isObjectType(type) &&
        (type.objectFlags & ts.ObjectFlags.Reference) !== 0
    );
}

/**
 * Check if a declaration name is valid for Swift generation
 * @param {string} name - Declaration name to check
 * @returns {boolean} True if the name is valid for Swift
 * @private
 */
export function isValidSwiftDeclName(name) {
    // https://docs.swift.org/swift-book/documentation/the-swift-programming-language/lexicalstructure/
    const swiftIdentifierRegex = /^[_\p{ID_Start}][\p{ID_Continue}\u{200C}\u{200D}]*$/u;
    return swiftIdentifierRegex.test(name);
}
