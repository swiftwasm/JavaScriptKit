/**
 * TypeScript type processing functionality
 * @module processor
 */

// @ts-check
import ts from 'typescript';

/** @typedef {import('./index').ImportSkeleton} ImportSkeleton */
/** @typedef {import('./index').ImportFunctionSkeleton} ImportFunctionSkeleton */
/** @typedef {import('./index').ImportTypeSkeleton} ImportTypeSkeleton */
/** @typedef {import('./index').ImportPropertySkeleton} ImportPropertySkeleton */
/** @typedef {import('./index').ImportConstructorSkeleton} ImportConstructorSkeleton */
/** @typedef {import('./index').Parameter} Parameter */
/** @typedef {import('./index').BridgeType} BridgeType */

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

        /** @type {Map<ts.Type, BridgeType>} */
        this.processedTypes = new Map();
        /** @type {Map<ts.Type, ts.Node>} Seen position by type */
        this.seenTypes = new Map();
        /** @type {ImportFunctionSkeleton[]} */
        this.functions = [];
        /** @type {ImportTypeSkeleton[]} */
        this.types = [];
    }

    /**
     * Process type declarations from a TypeScript program
     * @param {ts.Program} program - TypeScript program
     * @param {string} inputFilePath - Path to the input file
     * @returns {ImportSkeleton} Processed type declarations
     */
    processTypeDeclarations(program, inputFilePath) {
        const sourceFiles = program.getSourceFiles().filter(
            sf => !sf.isDeclarationFile || sf.fileName === inputFilePath
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
                            const type = this.visitStructuredType(typeString, members);
                            this.types.push(type);
                        } else {
                            this.types.push(this.createUnknownType(typeString));
                        }
                    }
                });
            } catch (error) {
                this.diagnosticEngine.print("error", `Error processing ${sourceFile.fileName}: ${error.message}`);
            }
        }

        return { functions: this.functions, types: this.types };
    }

    /**
     * Create an unknown type
     * @param {string} typeString - Type string
     * @returns {ImportTypeSkeleton} Unknown type
     */
    createUnknownType(typeString) {
        return {
            name: typeString,
            documentation: undefined,
            properties: [],
            methods: [],
            constructor: undefined,
        };
    }

    /**
     * Visit a node and process it
     * @param {ts.Node} node - The node to visit
     */
    visitNode(node) {
        if (ts.isFunctionDeclaration(node)) {
            const func = this.visitFunctionLikeDecl(node);
            if (func && node.name) {
                this.functions.push({ ...func, name: node.name.getText() });
            }
        } else if (ts.isClassDeclaration(node)) {
            const cls = this.visitClassDecl(node);
            if (cls) this.types.push(cls);
        }
    }

    /**
     * Process a function declaration into ImportFunctionSkeleton format
     * @param {ts.SignatureDeclaration} node - The function node
     * @returns {ImportFunctionSkeleton | null} Processed function
     * @private
     */
    visitFunctionLikeDecl(node) {
        if (!node.name) return null;

        const signature = this.checker.getSignatureFromDeclaration(node);
        if (!signature) return null;

        /** @type {Parameter[]} */
        const parameters = [];
        for (const p of signature.getParameters()) {
            const bridgeType = this.visitSignatureParameter(p, node);
            parameters.push(bridgeType);
        }

        const returnType = signature.getReturnType();
        const bridgeReturnType = this.visitType(returnType, node);
        const documentation = this.getFullJSDocText(node);

        return {
            name: node.name.getText(),
            parameters,
            returnType: bridgeReturnType,
            documentation,
        };
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
     * @param {ts.ConstructorDeclaration} node
     * @returns {ImportConstructorSkeleton | null}
     */
    visitConstructorDecl(node) {
        const signature = this.checker.getSignatureFromDeclaration(node);
        if (!signature) return null;

        const parameters = [];
        for (const p of signature.getParameters()) {
            const bridgeType = this.visitSignatureParameter(p, node);
            parameters.push(bridgeType);
        }

        return { parameters };
    }

    /**
     * @param {ts.PropertyDeclaration | ts.PropertySignature} node
     * @returns {ImportPropertySkeleton | null}
     */
    visitPropertyDecl(node) {
        if (!node.name) return null;
        const type = this.checker.getTypeAtLocation(node)
        const bridgeType = this.visitType(type, node);
        const isReadonly = node.modifiers?.some(m => m.kind === ts.SyntaxKind.ReadonlyKeyword) ?? false;
        const documentation = this.getFullJSDocText(node);
        return { name: node.name.getText(), type: bridgeType, isReadonly, documentation };
    }

    /**
     * @param {ts.Symbol} symbol
     * @param {ts.Node} node
     * @returns {Parameter}
     */
    visitSignatureParameter(symbol, node) {
        const type = this.checker.getTypeOfSymbolAtLocation(symbol, node);
        const bridgeType = this.visitType(type, node);
        return { name: symbol.name, type: bridgeType };
    }

    /**
     * @param {ts.ClassDeclaration} node 
     * @returns {ImportTypeSkeleton | null}
     */
    visitClassDecl(node) {
        if (!node.name) return null;

        const name = node.name.text;
        const properties = [];
        const methods = [];
        /** @type {ImportConstructorSkeleton | undefined} */
        let constructor = undefined;

        for (const member of node.members) {
            if (ts.isPropertyDeclaration(member)) {
                // TODO
            } else if (ts.isMethodDeclaration(member)) {
                const decl = this.visitFunctionLikeDecl(member);
                if (decl) methods.push(decl);
            } else if (ts.isConstructorDeclaration(member)) {
                const decl = this.visitConstructorDecl(member);
                if (decl) constructor = decl;
            }
        }

        const documentation = this.getFullJSDocText(node);
        return {
            name,
            constructor,
            properties,
            methods,
            documentation,
        };
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
     * @param {string} name
     * @param {ts.Symbol[]} members
     * @returns {ImportTypeSkeleton}
     */
    visitStructuredType(name, members) {
        /** @type {ImportPropertySkeleton[]} */
        const properties = [];
        /** @type {ImportFunctionSkeleton[]} */
        const methods = [];
        /** @type {ImportConstructorSkeleton | undefined} */
        let constructor = undefined;
        for (const symbol of members) {
            if (symbol.flags & ts.SymbolFlags.Property) {
                for (const decl of symbol.getDeclarations() ?? []) {
                    if (ts.isPropertyDeclaration(decl) || ts.isPropertySignature(decl)) {
                        const property = this.visitPropertyDecl(decl);
                        if (property) properties.push(property);
                    } else if (ts.isMethodSignature(decl)) {
                        const method = this.visitFunctionLikeDecl(decl);
                        if (method) methods.push(method);
                    }
                }
            } else if (symbol.flags & ts.SymbolFlags.Method) {
                for (const decl of symbol.getDeclarations() ?? []) {
                    if (!ts.isMethodSignature(decl)) {
                        continue;
                    }
                    const method = this.visitFunctionLikeDecl(decl);
                    if (method) methods.push(method);
                }
            } else if (symbol.flags & ts.SymbolFlags.Constructor) {
                for (const decl of symbol.getDeclarations() ?? []) {
                    if (!ts.isConstructorDeclaration(decl)) {
                        continue;
                    }
                    const ctor = this.visitConstructorDecl(decl);
                    if (ctor) constructor = ctor;
                }
            }
        }
        return { name, properties, methods, constructor, documentation: undefined };
    }

    /**
     * Convert TypeScript type string to BridgeType
     * @param {ts.Type} type - TypeScript type string
     * @param {ts.Node} node - Node
     * @returns {BridgeType} Bridge type
     * @private
     */
    visitType(type, node) {
        const maybeProcessed = this.processedTypes.get(type);
        if (maybeProcessed) {
            return maybeProcessed;
        }
        /**
         * @param {ts.Type} type
         * @returns {BridgeType}
         */
        const convert = (type) => {
            /** @type {Record<string, BridgeType>} */
            const typeMap = {
                "number": { "double": {} },
                "string": { "string": {} },
                "boolean": { "bool": {} },
                "void": { "void": {} },
                "any": { "jsObject": {} },
                "unknown": { "jsObject": {} },
                "null": { "void": {} },
                "undefined": { "void": {} },
                "bigint": { "int": {} },
                "object": { "jsObject": {} },
                "symbol": { "jsObject": {} },
                "never": { "void": {} },
            };
            const typeString = this.checker.typeToString(type);
            if (typeMap[typeString]) {
                return typeMap[typeString];
            }

            if (this.checker.isArrayType(type) || this.checker.isTupleType(type) || type.getCallSignatures().length > 0) {
                return { "jsObject": {} };
            }
            // "a" | "b" -> string
            if (this.checker.isTypeAssignableTo(type, this.checker.getStringType())) {
                return { "string": {} };
            }
            if (type.getFlags() & ts.TypeFlags.TypeParameter) {
                return { "jsObject": {} };
            }

            const typeName = this.deriveTypeName(type);
            if (!typeName) {
                this.diagnosticEngine.print("warning", `Unknown non-nominal type: ${typeString}`, node);
                return { "jsObject": {} };
            }
            this.seenTypes.set(type, node);
            return { "jsObject": { "_0": typeName } };
        }
        const bridgeType = convert(type);
        this.processedTypes.set(type, bridgeType);
        return bridgeType;
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
}
