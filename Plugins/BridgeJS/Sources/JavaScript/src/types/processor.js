/**
 * TypeScript type processing functionality
 * @module types/processor
 */

// @ts-check
import ts from 'typescript';

/**
 * Create a TypeScript program from a d.ts file
 * @param {string} filePath - Path to the d.ts file
 * @returns {ts.Program} TypeScript program object
 */
export function createProgram(filePath) {
    /** @type {ts.CompilerOptions} */
    const options = {
        target: ts.ScriptTarget.ESNext,
        module: ts.ModuleKind.ESNext,
        moduleResolution: ts.ModuleResolutionKind.NodeJs,
        esModuleInterop: true,
        strict: true,
        lib: ["DOM"]
    };

    const host = ts.createCompilerHost(options);
    return ts.createProgram([filePath], options, host);
}

/**
 * Process type declarations from a TypeScript program
 * @param {ts.Program} program - TypeScript program
 * @param {string} inputFilePath - Path to the input file
 * @returns {Object} Processed type declarations in ImportSkeleton format
 */
export function processTypeDeclarations(program, inputFilePath) {
    const checker = program.getTypeChecker();
    const sourceFiles = program.getSourceFiles().filter(
        sf => !sf.isDeclarationFile || sf.fileName === inputFilePath
    );

    /** @type {import('./index.d.ts').ImportSkeleton} */
    const results = {
        functions: [],
        classes: []
    };

    for (const sourceFile of sourceFiles) {
        if (sourceFile.fileName.includes('node_modules/typescript/lib')) continue;

        try {
            ts.forEachChild(sourceFile, node => {
                if (isDeclarationNode(node)) {
                    processDeclaration(node, checker, results);
                }
            });
        } catch (error) {
            console.error(`Error processing ${sourceFile.fileName}: ${error.message}`);
        }
    }

    return results;
}

/**
 * Check if a node is a declaration node
 * @param {ts.Node} node - The AST node
 * @returns {boolean} True if the node is a declaration
 */
function isDeclarationNode(node) {
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
 * @param {ts.TypeChecker} checker - TypeScript type checker
 * @param {import('./index.d.ts').ImportSkeleton} results - Results object to store processed declarations
 */
function processDeclaration(node, checker, results) {
    if (ts.isClassDeclaration(node) && node.name) {
        /** @type {import('./index.d.ts').ImportClassSkeleton} */
        const classInfo = {
            name: node.name.text,
            constructor: {
                name: "constructor",
                parameters: [],
                returnType: "void"
            },
            methods: []
        };

        // Process constructor
        const constructor = node.members.find(member => 
            ts.isConstructorDeclaration(member)
        );
        if (constructor) {
            const signature = checker.getSignatureFromDeclaration(constructor);
            if (signature) {
                classInfo.constructor = processFunctionSignature(signature, checker);
            }
        }

        // Process methods
        node.members.forEach(member => {
            if (ts.isMethodDeclaration(member) && member.name) {
                const signature = checker.getSignatureFromDeclaration(member);
                if (signature) {
                    /** @type {import('./index.d.ts').ImportFunctionSkeleton} */
                    const methodSignature = processFunctionSignature(signature, checker);
                    classInfo.methods.push(methodSignature);
                }
            }
        });

        results.classes.push(classInfo);
    } else if (ts.isFunctionDeclaration(node) && node.name) {
        const signature = checker.getSignatureFromDeclaration(node);
        if (signature) {
            /** @type {import('./index.d.ts').ImportFunctionSkeleton} */
            const functionSignature = processFunctionSignature(signature, checker);
            results.functions.push(functionSignature);
        }
    } else if (ts.isVariableStatement(node)) {
        for (const declaration of node.declarationList.declarations) {
            if (declaration.name && ts.isIdentifier(declaration.name)) {
                const type = checker.getTypeAtLocation(declaration);
                const typeString = checker.typeToString(type);
                const bridgeType = convertToBridgeType(typeString);
                
                if (bridgeType) {
                    /** @type {import('./index.d.ts').ImportFunctionSkeleton} */
                    const functionSignature = {
                        name: declaration.name.text,
                        parameters: [],
                        returnType: bridgeType
                    };
                    results.functions.push(functionSignature);
                }
            }
        }
    }
}

/**
 * Process a function signature into ImportFunctionSkeleton format
 * @param {ts.Signature} signature - The function signature
 * @param {ts.TypeChecker} checker - TypeScript type checker
 * @returns {import('./index.d.ts').ImportFunctionSkeleton} Processed function signature
 */
function processFunctionSignature(signature, checker) {
    if (!signature) {
        /** @type {import('./index.d.ts').ImportFunctionSkeleton} */
        return {
            name: "unknown",
            parameters: [],
            returnType: "void"
        };
    }

    const parameters = signature.getParameters();
    const returnType = signature.getReturnType();
    const returnTypeString = checker.typeToString(returnType);
    const bridgeReturnType = convertToBridgeType(returnTypeString);

    /** @type {import('./index.d.ts').ImportFunctionSkeleton} */
    return {
        name: parameters[0]?.name || "unknown",
        parameters: parameters.map(p => {
            /** @type {ts.Node} */
            const declaration = p.valueDeclaration || p.declarations?.[0] || p;
            const type = checker.getTypeOfSymbolAtLocation(p, declaration);
            const typeString = checker.typeToString(type);
            const bridgeType = convertToBridgeType(typeString);
            
            return {
                name: p.name,
                type: bridgeType || "void"
            };
        }),
        returnType: bridgeReturnType || "void"
    };
}

/**
 * Convert TypeScript type string to BridgeType
 * @param {string} typeString - TypeScript type string
 * @returns {import('./index.d.ts').BridgeType} Bridge type
 */
function convertToBridgeType(typeString) {
    const typeMap = {
        "number": "float",
        "string": "string",
        "boolean": "bool",
        "void": "void",
        "any": "void",
        "unknown": "void",
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

    return typeMap[typeString] || "void";
}
