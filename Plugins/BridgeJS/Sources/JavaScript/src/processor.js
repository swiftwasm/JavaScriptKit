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
/** @typedef {import('./index').ImportMethodSkeleton} ImportMethodSkeleton */
/** @typedef {import('./index').Parameter} Parameter */
/** @typedef {import('./index').BridgeType} BridgeType */

/**
 * @typedef {{
 *   warn: (message: string) => void,
 *   error: (message: string) => void,
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
                });
            } catch (error) {
                this.diagnosticEngine.error(`Error processing ${sourceFile.fileName}: ${error.message}`);
            }
        }

        return { functions: this.functions, types: this.types };
    }

    /**
     * Visit a node and process it
     * @param {ts.Node} node - The node to visit
     */
    visitNode(node) {
        if (ts.isFunctionDeclaration(node)) {
            const func = this.processFunctionToSkeleton(node);
            if (func) this.functions.push(func);
        }
    }

    /**
     * Process a function declaration into ImportFunctionSkeleton format
     * @param {ts.FunctionDeclaration} node - The function node
     * @returns {ImportFunctionSkeleton | null} Processed function
     * @private
     */
    processFunctionToSkeleton(node) {
        if (!node.name) return null;

        const signature = this.checker.getSignatureFromDeclaration(node);
        if (!signature) return null;

        /** @type {Parameter[]} */
        const parameters = [];
        for (const p of signature.getParameters()) {
            const type = this.checker.getTypeOfSymbolAtLocation(p, node);
            const bridgeType = this.convertToBridgeType(type);

            parameters.push({
                name: p.name,
                type: bridgeType,
            });
        }

        const returnType = signature.getReturnType();
        const bridgeReturnType = this.convertToBridgeType(returnType);

        return {
            name: node.name.text,
            parameters,
            returnType: bridgeReturnType,
        };
    }

    /**
     * Convert TypeScript type string to BridgeType
     * @param {ts.Type} type - TypeScript type string
     * @returns {BridgeType} Bridge type
     * @private
     */
    convertToBridgeType(type) {
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
                "number": { "float": {} },
                "string": { "string": {} },
                "boolean": { "bool": {} },
                "void": { "void": {} },
                "any": { "unknown": {} },
                "unknown": { "unknown": {} },
                "null": { "void": {} },
                "undefined": { "void": {} },
                "bigint": { "int": {} },
                "object": { "unknown": {} },
                "symbol": { "unknown": {} },
                "never": { "void": {} },
            };
            const typeString = this.checker.typeToString(type);
            if (typeMap[typeString]) {
                return typeMap[typeString];
            }
            const typeName = this.deriveTypeName(type);
            if (!typeName) return { "unknown": {} };
            this.diagnosticEngine.warn(`Unknown type: ${typeString}`);
            return { "unknown": {} };
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
        const typeSymbol = type.getSymbol();
        if (typeSymbol) {
            return typeSymbol.name;
        }
        const aliasSymbol = type.aliasSymbol;
        if (aliasSymbol) {
            return aliasSymbol.name;
        }
        return undefined;
    }
}
