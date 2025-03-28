/**
 * TypeScript type processing functionality
 * @module types/processor
 */

// @ts-check
import ts from 'typescript';

/**
 * @typedef {{
 *   warn: (message: string) => void,
 *   error: (message: string) => void,
 * }} DiagnosticEngine
 */

/**
 * @typedef {{
 *   inheritIterable: boolean,
 *   inheritArraylike: boolean,
 *   inheritPromiselike: boolean,
 *   addAllParentMembersToClass: boolean,
 *   replaceAliasToFunction: boolean,
 *   replaceRankNFunction: boolean,
 *   replaceNewableFunction: boolean,
 *   noExtendsInTyprm: boolean,
 * }} TyperOptions
 */

/**
 * @typedef {{
 *   currentSourceFile: string,
 *   currentNamespace: string[],
 *   info: Map<string, SourceFileInfo>,
 *   state: any,
 *   cache: TyperCache,
 *   options: TyperOptions,
 *   logger: DiagnosticEngine,
 * }} TyperContext
 */

/**
 * @typedef {{
 *   sourceFile: ts.SourceFile,
 *   definitionsMap: Map<string, Definition[]>,
 *   typeLiteralsMap: Map<string, number>,
 *   anonymousInterfacesMap: Map<string, AnonymousInterfaceInfo>,
 *   exportMap: Map<string, ExportType>,
 *   unknownIdentTypes: Map<string, Set<number>>,
 * }} SourceFileInfo
 */

/**
 * @typedef {{
 *   inheritCache: Map<string, [InheritingType, number][]>,
 *   hasNoInherits: Set<string>,
 * }} TyperCache
 */

/**
 * @typedef {{
 *   id: number,
 *   namespace: string[],
 *   origin: {
 *     typeName?: string,
 *     valueName?: string,
 *     argName?: string,
 *   },
 * }} AnonymousInterfaceInfo
 */

/**
 * @typedef {{
 *   fullName: string[],
 *   tyargs: ts.Type[],
 * }} InheritingType
 */

/**
 * @typedef {{
 *   name: string,
 *   properties: Property[],
 *   methods: Method[],
 * }} Definition
 */

/**
 * @typedef {{
 *   name: string,
 *   type: string,
 * }} Property
 */

/**
 * @typedef {{
 *   name: string,
 *   parameters: Parameter[],
 *   returnType: string,
 * }} Method
 */

/**
 * @typedef {{
 *   name: string,
 *   type: string,
 * }} Parameter
 */

/**
 * @typedef {{
 *   type: 'CommonJS' | 'ES6Default' | 'ES6',
 *   renameAs?: string,
 *   path?: string[],
 * }} ExportType
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
     * @param {TyperOptions} options - Type processing options
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

        /** @type {Map<string, ts.Type>} */
        this.processedTypes = new Map();
        /** @type {Map<string, Definition[]>} */
        this.definitionsMap = new Map();
        /** @type {Map<string, number>} */
        this.typeLiteralsMap = new Map();
        /** @type {Map<string, AnonymousInterfaceInfo>} */
        this.anonymousInterfacesMap = new Map();
        /** @type {Map<string, Set<number>>} */
        this.unknownIdentTypes = new Map();
        /** @type {Map<string, [InheritingType, number][]>} */
        this.inheritCache = new Map();
        /** @type {Set<string>} */
        this.hasNoInherits = new Set();

        /** @type {TyperContext} */
        this.context = {
            currentSourceFile: '',
            currentNamespace: [],
            info: new Map(),
            state: {},
            cache: {
                inheritCache: this.inheritCache,
                hasNoInherits: this.hasNoInherits,
            },
            options: this.options,
            logger: diagnosticEngine,
        };
    }

    /**
     * Process type declarations from a TypeScript program
     * @param {ts.Program} program - TypeScript program
     * @param {string} inputFilePath - Path to the input file
     * @returns {Object} Processed type declarations
     */
    processTypeDeclarations(program, inputFilePath) {
        const sourceFiles = program.getSourceFiles().filter(
            sf => !sf.isDeclarationFile || sf.fileName === inputFilePath
        );

        for (const sourceFile of sourceFiles) {
            if (sourceFile.fileName.includes('node_modules/typescript/lib')) continue;

            this.context.currentSourceFile = sourceFile.fileName;
            this.context.currentNamespace = [];

            try {
                const sourceFileInfo = this.processSourceFile(sourceFile);
                this.context.info.set(sourceFile.fileName, sourceFileInfo);
            } catch (error) {
                this.diagnosticEngine.error(`Error processing ${sourceFile.fileName}: ${error.message}`);
            }
        }

        return {
            definitions: this.definitionsMap,
            typeLiterals: this.typeLiteralsMap,
            anonymousInterfaces: this.anonymousInterfacesMap,
            unknownIdentTypes: this.unknownIdentTypes,
        };
    }

    /**
     * Process a source file
     * @param {ts.SourceFile} sourceFile - TypeScript source file
     * @returns {SourceFileInfo} Processed source file information
     * @private
     */
    processSourceFile(sourceFile) {
        const definitions = [];
        const typeLiterals = new Map();
        const anonymousInterfaces = new Map();
        const exportMap = new Map();
        const unknownIdentTypes = new Map();

        sourceFile.forEachChild(node => {
            const definition = this.processDeclaration(node);
            if (definition) {
                definitions.push(definition);
            }
        });

        const sourceFileInfo = {
            sourceFile,
            definitionsMap: new Map(Object.entries(this.groupDefinitionsByNamespace(definitions))),
            typeLiteralsMap: typeLiterals,
            anonymousInterfacesMap: anonymousInterfaces,
            exportMap,
            unknownIdentTypes,
        };

        // Add definitions to global maps
        for (const [namespace, defs] of sourceFileInfo.definitionsMap) {
            this.definitionsMap.set(namespace, defs);
        }

        // Add type literals to global map
        for (const [key, value] of sourceFileInfo.typeLiteralsMap) {
            this.typeLiteralsMap.set(key, value);
        }

        // Add anonymous interfaces to global map
        for (const [key, value] of sourceFileInfo.anonymousInterfacesMap) {
            this.anonymousInterfacesMap.set(key, value);
        }

        // Add unknown ident types to global map
        for (const [key, value] of sourceFileInfo.unknownIdentTypes) {
            this.unknownIdentTypes.set(key, value);
        }

        return sourceFileInfo;
    }

    /**
     * Process a declaration node
     * @param {ts.Node} node - The AST node
     * @returns {Definition | null} Processed definition
     * @private
     */
    processDeclaration(node) {
        if (ts.isInterfaceDeclaration(node) || ts.isClassDeclaration(node)) {
            return this.processInterfaceOrClass(node);
        } else if (ts.isTypeAliasDeclaration(node)) {
            return this.processTypeAlias(node);
        } else if (ts.isEnumDeclaration(node)) {
            return this.processEnum(node);
        } else if (ts.isFunctionDeclaration(node)) {
            return this.processFunction(node);
        } else if (ts.isVariableStatement(node)) {
            return this.processVariable(node);
        }
        return null;
    }

    /**
     * Process an interface or class declaration
     * @param {ts.InterfaceDeclaration | ts.ClassDeclaration} node - The interface/class node
     * @returns {Definition} Processed interface/class definition
     * @private
     */
    processInterfaceOrClass(node) {
        const properties = [];
        const methods = [];

        for (const member of node.members) {
            if (ts.isPropertyDeclaration(member) || ts.isPropertySignature(member)) {
                const property = this.processProperty(member);
                if (property) {
                    properties.push(property);
                }
            } else if (ts.isMethodDeclaration(member) || ts.isMethodSignature(member)) {
                const method = this.processMethod(member);
                if (method) {
                    methods.push(method);
                }
            }
        }

        return {
            name: node.name ? (ts.isIdentifier(node.name) ? node.name.text : String(node.name)) : 'Anonymous',
            properties,
            methods,
        };
    }

    /**
     * Process a property declaration
     * @param {ts.PropertyDeclaration | ts.PropertySignature} node - The property node
     * @returns {Property | null} Processed property
     * @private
     */
    processProperty(node) {
        if (!node.name) return null;

        const type = this.checker.getTypeAtLocation(node);
        const typeString = this.checker.typeToString(type);
        const bridgeType = this.convertToBridgeType(typeString);

        return {
            name: ts.isIdentifier(node.name) ? node.name.text :
                ts.isComputedPropertyName(node.name) ? String(node.name.expression) :
                    String(node.name),
            type: bridgeType,
        };
    }

    /**
     * Process a method declaration
     * @param {ts.MethodDeclaration | ts.MethodSignature} node - The method node
     * @returns {Method | null} Processed method
     * @private
     */
    processMethod(node) {
        if (!node.name) return null;

        const signature = this.checker.getSignatureFromDeclaration(node);
        if (!signature) return null;

        const parameters = [];
        for (const p of signature.getParameters()) {
            const type = this.checker.getTypeOfSymbolAtLocation(p, node);
            const typeString = this.checker.typeToString(type);
            const bridgeType = this.convertToBridgeType(typeString);

            parameters.push({
                name: p.name,
                type: bridgeType,
            });
        }

        const returnType = signature.getReturnType();
        const returnTypeString = this.checker.typeToString(returnType);
        const bridgeReturnType = this.convertToBridgeType(returnTypeString);

        return {
            name: ts.isIdentifier(node.name) ? node.name.text : String(node.name),
            parameters,
            returnType: bridgeReturnType,
        };
    }

    /**
     * Process a type alias declaration
     * @param {ts.TypeAliasDeclaration} node - The type alias node
     * @returns {Definition | null} Processed type alias definition
     * @private
     */
    processTypeAlias(node) {
        if (!node.name) return null;

        const type = this.checker.getTypeAtLocation(node);
        const typeString = this.checker.typeToString(type);
        const bridgeType = this.convertToBridgeType(typeString);

        return {
            name: node.name.text,
            properties: [],
            methods: [{
                name: 'type',
                parameters: [],
                returnType: bridgeType,
            }],
        };
    }

    /**
     * Process an enum declaration
     * @param {ts.EnumDeclaration} node - The enum node
     * @returns {Definition | null} Processed enum definition
     * @private
     */
    processEnum(node) {
        if (!node.name) return null;

        const properties = [];
        for (const member of node.members) {
            const type = this.checker.getTypeAtLocation(member);
            const typeString = this.checker.typeToString(type);
            const bridgeType = this.convertToBridgeType(typeString);

            properties.push({
                name: ts.isIdentifier(member.name) ? member.name.text : String(member.name),
                type: bridgeType,
            });
        }

        return {
            name: node.name.text,
            properties,
            methods: [],
        };
    }

    /**
     * Process a function declaration
     * @param {ts.FunctionDeclaration} node - The function node
     * @returns {Definition | null} Processed function definition
     * @private
     */
    processFunction(node) {
        if (!node.name) return null;

        const signature = this.checker.getSignatureFromDeclaration(node);
        if (!signature) return null;

        const parameters = [];
        for (const p of signature.getParameters()) {
            const type = this.checker.getTypeOfSymbolAtLocation(p, node);
            const typeString = this.checker.typeToString(type);
            const bridgeType = this.convertToBridgeType(typeString);

            parameters.push({
                name: p.name,
                type: bridgeType,
            });
        }

        const returnType = signature.getReturnType();
        const returnTypeString = this.checker.typeToString(returnType);
        const bridgeReturnType = this.convertToBridgeType(returnTypeString);

        return {
            name: node.name.text,
            properties: [],
            methods: [{
                name: 'call',
                parameters,
                returnType: bridgeReturnType,
            }],
        };
    }

    /**
     * Process a variable statement
     * @param {ts.VariableStatement} node - The variable statement node
     * @returns {Definition | null} Processed variable definition
     * @private
     */
    processVariable(node) {
        const declarations = node.declarationList.declarations;
        if (declarations.length !== 1) return null;

        const declaration = declarations[0];
        if (!ts.isIdentifier(declaration.name)) return null;

        const type = this.checker.getTypeAtLocation(declaration);
        const typeString = this.checker.typeToString(type);
        const bridgeType = this.convertToBridgeType(typeString);

        return {
            name: declaration.name.text,
            properties: [],
            methods: [{
                name: 'get',
                parameters: [],
                returnType: bridgeType,
            }],
        };
    }

    /**
     * Convert TypeScript type string to BridgeType
     * @param {string} typeString - TypeScript type string
     * @returns {string} Bridge type
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

    /**
     * Group definitions by namespace
     * @param {Definition[]} definitions - List of definitions
     * @returns {Object.<string, Definition[]>} Definitions grouped by namespace
     * @private
     */
    groupDefinitionsByNamespace(definitions) {
        /** @type {Object.<string, Definition[]>} */
        const grouped = {};
        const currentNamespace = this.context.currentNamespace.join('.');

        if (currentNamespace) {
            grouped[currentNamespace] = definitions;
        } else {
            grouped['global'] = definitions;
        }

        return grouped;
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
            ts.isVariableStatement(node);
    }
}
