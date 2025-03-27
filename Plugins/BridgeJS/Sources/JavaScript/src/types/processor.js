/**
 * TypeScript type processing functionality
 * @module types/processor
 */

// @ts-check
import ts from 'typescript';

/**
 * @typedef {{
 *   warn: (message: string) => void,
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
    constructor(checker, diagnosticEngine) {
        this.checker = checker;
        this.diagnosticEngine = diagnosticEngine;

        /** @type {Map<string, ts.Type>} */
        this.processedTypes = new Map();
        /** @type {import('./index.d.ts').ImportSkeleton} */
        this.results = {
            functions: [],
            types: []
        };
    }

    /**
     * Process type declarations from a TypeScript program
     * @param {ts.Program} program - TypeScript program
     * @param {string} inputFilePath - Path to the input file
     * @returns {Object} Processed type declarations in ImportSkeleton format
     */
    processTypeDeclarations(program, inputFilePath) {
        const sourceFiles = program.getSourceFiles().filter(
            sf => !sf.isDeclarationFile || sf.fileName === inputFilePath
        );

        for (const sourceFile of sourceFiles) {
            if (sourceFile.fileName.includes('node_modules/typescript/lib')) continue;

            try {
                ts.forEachChild(sourceFile, node => {
                    if (this.isDeclarationNode(node)) {
                        this.processDeclaration(node);
                    }
                });
            } catch (error) {
                console.error(`Error processing ${sourceFile.fileName}: ${error.message}`);
            }
        }

        return this.results;
    }

    /**
     * Check if a node is a declaration node
     * @param {ts.Node} node - The AST node
     * @returns {boolean} True if the node is a declaration
     * @private
     */
    isDeclarationNode(node) {
        return ts.isInterfaceDeclaration(node) ||
            ts.isClassDeclaration(node) ||
            ts.isTypeAliasDeclaration(node) ||
            ts.isEnumDeclaration(node) ||
            ts.isFunctionDeclaration(node) ||
            ts.isVariableStatement(node) ||
            ts.isModuleDeclaration(node);
    }

    /**
     * Process a declaration node
     * @param {ts.Node} node - The AST node
     * @private
     */
    processDeclaration(node) {
        console.log("processDeclaration", "kind", ts.SyntaxKind[node.kind], "name", node.name?.text, "pos", node.pos);
        if ((ts.isClassDeclaration(node) || ts.isInterfaceDeclaration(node)) && node.name) {
            /** @type {import('./index.d.ts').ImportTypeSkeleton} */
            const typeInfo = {
                name: node.name.text,
                properties: [],
                methods: []
            };

            // Process properties
            node.members.forEach(member => {
                if (ts.isPropertyDeclaration(member) && member.name) {
                    const type = this.checker.getTypeAtLocation(member);
                    const typeString = this.checker.typeToString(type);
                    const bridgeType = this.convertToBridgeType(typeString);

                    typeInfo.properties.push({
                        name: ts.isIdentifier(member.name) ? member.name.text : String(member.name),
                        type: bridgeType
                    });

                    this.visitType(type, member);
                } else if (ts.isMethodDeclaration(member) && member.name) {
                    const signature = this.checker.getSignatureFromDeclaration(member);
                    if (signature) {
                        /** @type {import('./index.d.ts').ImportMethodSkeleton} */
                        const methodSignature = this.processFunctionSignature(signature, member.name.text, node);
                        typeInfo.methods.push(methodSignature);
                    }
                }
            });

            this.results.types.push(typeInfo);
        } else if (ts.isFunctionDeclaration(node) && node.name) {
            const signature = this.checker.getSignatureFromDeclaration(node);
            if (signature) {
                /** @type {import('./index.d.ts').ImportFunctionSkeleton} */
                const functionSignature = this.processFunctionSignature(signature, node.name.text, node);
                this.results.functions.push(functionSignature);
            }
        } else if (ts.isVariableStatement(node)) {
            for (const declaration of node.declarationList.declarations) {
                if (declaration.name && ts.isIdentifier(declaration.name)) {
                    const type = this.checker.getTypeAtLocation(declaration);
                    const typeString = this.checker.typeToString(type);
                    const bridgeType = this.convertToBridgeType(typeString);

                    if (bridgeType) {
                        /** @type {import('./index.d.ts').ImportFunctionSkeleton} */
                        const functionSignature = {
                            name: declaration.name.text,
                            parameters: [],
                            returnType: bridgeType
                        };
                        this.results.functions.push(functionSignature);
                    }

                    this.visitType(type, declaration);
                }
            }
        } else {
            const sourceFile = node.getSourceFile();
            const { line, character } = sourceFile.getLineAndCharacterOfPosition(node.getStart());
            this.diagnosticEngine.warn(`Unknown node: ${ts.SyntaxKind[node.kind]} at ${sourceFile.fileName}:${line + 1}:${character + 1}`);
        }
    }

    /**
     * Process a function signature into ImportFunctionSkeleton format
     * @param {ts.Signature} signature - The function signature
     * @param {string} functionName - The name of the function
     * @param {ts.FunctionDeclaration | ts.MethodDeclaration} node - The AST node that the function appears in
     * @returns {import('./index.d.ts').ImportFunctionSkeleton} Processed function signature
     * @private
     */
    processFunctionSignature(signature, functionName, node) {
        const parameters = signature.getParameters();
        const returnType = signature.getReturnType();
        const returnTypeString = this.checker.typeToString(returnType);
        const bridgeReturnType = this.convertToBridgeType(returnTypeString);

        this.visitType(returnType, node);

        /** @type {import('./index.d.ts').ImportFunctionSkeleton} */
        return {
            name: functionName,
            parameters: parameters.map(p => {
                const declaration = /** @type {ts.Node} */ (p.valueDeclaration || p.declarations?.[0] || p);
                const type = this.checker.getTypeOfSymbolAtLocation(p, declaration);
                const typeString = this.checker.typeToString(type);
                const bridgeType = this.convertToBridgeType(typeString);

                this.visitType(type, declaration);

                return {
                    name: p.name,
                    type: bridgeType || "void"
                };
            }),
            returnType: bridgeReturnType || "void"
        };
    }

    /**
     * Visit a TypeScript type and add it to results if it's a non-primitive type
     * @param {ts.Type} type - The TypeScript type to visit
     * @param {ts.Node} node - The AST node that the type appears in
     * @returns {boolean} True if the type was visited, false if it's not supported
     * @private
     */
    visitType(type, node) {
        if (this.isPrimitiveType(type)) {
            return true;
        }

        const typeString = this.checker.typeToString(type);
        if (this.processedTypes.has(typeString)) {
            return true;
        }

        this.processedTypes.set(typeString, type);

        if (type.isClassOrInterface()) {
            const symbol = type.getSymbol();
            if (symbol) {
                const declarations = symbol.getDeclarations();
                if (declarations && declarations.length > 0) {
                    const declaration = declarations[0];
                    if (ts.isClassDeclaration(declaration) || ts.isInterfaceDeclaration(declaration)) {
                        this.processDeclaration(declaration);
                    }
                }
            }
        } else {
            const sourceFile = node.getSourceFile();
            const { line, character } = sourceFile.getLineAndCharacterOfPosition(node.getStart());
            this.diagnosticEngine.warn(`Unsupported type: ${typeString} at ${sourceFile.fileName}:${line + 1}:${character + 1}`);
        }
        return false;
    }

    /**
     * Check if a type is a primitive type
     * @param {ts.Type} type - The TypeScript type to check
     * @returns {boolean} True if the type is a primitive type
     * @private
     */
    isPrimitiveType(type) {
        const typeString = this.checker.typeToString(type);
        const primitiveTypes = ["number", "string", "boolean", "void", "any", "unknown", "null", "undefined"];
        return primitiveTypes.includes(typeString) ||
            typeString.endsWith("[]") ||
            typeString.includes("|") ||
            typeString.includes("&") ||
            typeString.includes("=>");
    }

    /**
     * Convert TypeScript type string to BridgeType
     * @param {string} typeString - TypeScript type string
     * @returns {import('./index.d.ts').BridgeType} Bridge type
     * @private
     */
    convertToBridgeType(typeString) {
        const typeMap = {
            "number": "float",
            "string": "string",
            "boolean": "bool",
            "void": "void",
            "any": "unknown",
            "unknown": "unknown",
            "null": "void",
            "undefined": "void"
        };

        // Handle array types
        if (typeString.endsWith("[]")) {
            return "string"; // Arrays are converted to strings in bridge
        }

        // Handle union types
        if (typeString.includes("|")) {
            return "string"; // Union types are converted to strings in bridge
        }

        // Handle intersection types
        if (typeString.includes("&")) {
            return "string"; // Intersection types are converted to strings in bridge
        }

        // Handle function types
        if (typeString.includes("=>")) {
            return "void"; // Function types are converted to void in bridge
        }

        return typeMap[typeString] || typeString;
    }
}
