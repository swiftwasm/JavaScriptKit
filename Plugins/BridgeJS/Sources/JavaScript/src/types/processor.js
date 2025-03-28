/**
 * TypeScript type processing functionality
 * @module types/processor
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
 *   properties: ImportPropertySkeleton[],
 *   methods: ImportMethodSkeleton[],
 * }} Definition
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

        /** @type {Map<ts.Type, BridgeType>} */
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

        /** @type {ImportFunctionSkeleton[]} */
        this.functions = [];
        /** @type {ImportTypeSkeleton[]} */
        this.types = [];
        /** @type {Map<ts.Type, string>} */
        this.typeExpansions = new Map();

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
     * @returns {ImportSkeleton} Processed type declarations
     */
    processTypeDeclarations(program, inputFilePath) {
        const sourceFiles = program.getSourceFiles().filter(
            sf => !sf.isDeclarationFile || sf.fileName === inputFilePath
        );

        /** @type {ImportFunctionSkeleton[]} */
        const functions = [];
        /** @type {ImportTypeSkeleton[]} */
        const types = [];

        for (const sourceFile of sourceFiles) {
            if (sourceFile.fileName.includes('node_modules/typescript/lib')) continue;

            this.context.currentSourceFile = sourceFile.fileName;
            this.context.currentNamespace = [];
            Error.stackTraceLimit = 100;

            // try {
                sourceFile.forEachChild(node => {
                    if (ts.isFunctionDeclaration(node)) {
                        const func = this.processFunctionToSkeleton(node);
                        if (func) functions.push(func);
                    } else if (ts.isInterfaceDeclaration(node) || ts.isClassDeclaration(node) || 
                             ts.isTypeAliasDeclaration(node) || ts.isEnumDeclaration(node)) {
                        const type = this.processTypeToSkeleton(node);
                        if (type) types.push(type);
                    }
                });
            // } catch (error) {
            //     this.diagnosticEngine.error(`Error processing ${sourceFile.fileName}: ${error.message}`);
            // }
        }

        return { functions, types };
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
     * Process a type declaration into ImportTypeSkeleton format
     * @param {ts.InterfaceDeclaration | ts.ClassDeclaration | ts.TypeAliasDeclaration | ts.EnumDeclaration} node - The type node
     * @returns {ImportTypeSkeleton | null} Processed type
     * @private
     */
    processTypeToSkeleton(node) {
        if (!node.name) return null;

        /** @type {ImportPropertySkeleton[]} */
        const properties = [];
        /** @type {ImportMethodSkeleton[]} */
        const methods = [];

        if (ts.isInterfaceDeclaration(node) || ts.isClassDeclaration(node)) {
            for (const member of node.members) {
                if (ts.isPropertyDeclaration(member) || ts.isPropertySignature(member)) {
                    const property = this.processProperty(member);
                    if (property) properties.push(property);
                } else if (ts.isMethodDeclaration(member) || ts.isMethodSignature(member)) {
                    const method = this.processMethod(member);
                    if (method) methods.push(method);
                }
            }
        } else if (ts.isEnumDeclaration(node)) {
            for (const member of node.members) {
                const type = this.checker.getTypeAtLocation(member);
                const bridgeType = this.convertToBridgeType(type);

                properties.push({
                    name: ts.isIdentifier(member.name) ? member.name.text : String(member.name),
                    type: bridgeType,
                });
            }
        }
        // For TypeAlias, we'll just create an empty type since it's handled differently
        // and might need special handling depending on the use case

        return {
            name: node.name.text,
            properties,
            methods,
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
     * @returns {ImportPropertySkeleton | null} Processed property
     * @private
     */
    processProperty(node) {
        if (!node.name) return null;

        const type = this.checker.getTypeAtLocation(node);
        const bridgeType = this.convertToBridgeType(type);

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
     * @returns {ImportMethodSkeleton | null} Processed method
     * @private
     */
    processMethod(node) {
        if (!node.name) return null;

        const signature = this.checker.getSignatureFromDeclaration(node);
        if (!signature) return null;

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
        const type = this.checker.getTypeAtLocation(node);
        return {
            name: node.name.text,
            properties: [],
            methods: [],
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
            const bridgeType = this.convertToBridgeType(type);

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
        const bridgeType = this.convertToBridgeType(type);

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
                "number": "float",
                "string": "string",
                "boolean": "bool",
                "void": "void",
                "any": "unknown",
                "unknown": "unknown",
                "null": "void",
                "undefined": "void",
                "bigint": "int",
                "object": "unknown",
                "symbol": "unknown",
                "never": "void",
            };
            const typeString = this.checker.typeToString(type);
            if (typeMap[typeString]) {
                return typeMap[typeString];
            }
            const typeName = this.deriveTypeName(type);
            if (!typeName) return "unknown";
            return { kind: "named", name: typeName };
        };
        const bridgeType = convert(type);
        this.processedTypes.set(type, bridgeType);
        return bridgeType;
    }

    /**
     * Pick the best overload from a list of signatures
     * @param {readonly ts.Signature[]} signatures - List of signatures
     * @returns {ts.Signature} Selected signature
     * @private
     */
    pickOverload(signatures) {
        for (const signature of signatures) {
            if (signature.typeParameters) {
                // Skip signatures if it has generic parameters
                continue;
            }
            return signature;
        }
        return signatures[0];
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

    /**
     * Expend known non-recursive type operators like `keyof` and `typeof`
     * @param {ts.Type} type - TypeScript type
     * @returns {BridgeType} Expanded type
     * @private
     */
    expendType(type) {
        const typeName = this.deriveTypeName(type);
        if (!typeName) return "unknown";

        /** @type {ImportTypeSkeleton} */
        const skeleton = {
            name: typeName,
            properties: [],
            methods: [],
        };
        this.types.push(skeleton);

        for (const member of this.checker.getPropertiesOfType(type)) {
            const type = this.checker.getTypeOfSymbol(member);
            const maybeMethod = this.checker.getSignaturesOfType(type, ts.SignatureKind.Call);
            if (maybeMethod.length > 0) {
                const signature = this.pickOverload(maybeMethod);
                const bridgeType = this.convertToBridgeType(signature.getReturnType());
                skeleton.methods.push({
                    name: member.name.text,
                    parameters: [],
                    returnType: bridgeType,
                });
            } else {
                const bridgeType = this.convertToBridgeType(type);
                skeleton.properties.push({
                    name: member.name.text,
                    type: bridgeType,
                });
            }
        }

        return { kind: "named", name: typeName };
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
}
