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
 * @returns {Object} Processed type declarations
 */
export function processTypeDeclarations(program, inputFilePath) {
    const checker = program.getTypeChecker();
    const sourceFiles = program.getSourceFiles().filter(
        sf => !sf.isDeclarationFile || sf.fileName === inputFilePath
    );

    const results = {};
    const typeCache = new Map();
    const nominalTypesMap = new Map();

    for (const sourceFile of sourceFiles) {
        if (sourceFile.fileName.includes('node_modules/typescript/lib')) continue;

        results[sourceFile.fileName] = {
            fileName: sourceFile.fileName,
            declarations: []
        };

        try {
            ts.forEachChild(sourceFile, node => {
                if (isDeclarationNode(node)) {
                    processDeclaration(node, checker, results[sourceFile.fileName].declarations, typeCache, nominalTypesMap);
                }
            });
        } catch (error) {
            console.error(`Error processing ${sourceFile.fileName}: ${error.message}`);
        }
    }

    // Add referenced nominal types to results
    results.referencedNominalTypes = Array.from(nominalTypesMap.values());

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
 * @param {Array} declarations - Array to collect declarations
 * @param {Map} typeCache - Cache for type information
 * @param {Map} nominalTypesMap - Map of nominal types
 */
function processDeclaration(node, checker, declarations, typeCache, nominalTypesMap) {
    if (ts.isInterfaceDeclaration(node) || 
        ts.isClassDeclaration(node) || 
        ts.isTypeAliasDeclaration(node) || 
        ts.isEnumDeclaration(node) || 
        ts.isFunctionDeclaration(node)) {
        
        if (node.name) {
            const type = getNodeType(node, checker, typeCache, nominalTypesMap);
            declarations.push({
                kind: ts.SyntaxKind[node.kind],
                name: node.name.text,
                type,
                location: {
                    start: node.getStart(),
                    end: node.getEnd()
                }
            });
        }
    } else if (ts.isVariableStatement(node)) {
        for (const declaration of node.declarationList.declarations) {
            if (declaration.name && ts.isIdentifier(declaration.name)) {
                const type = checker.getTypeAtLocation(declaration);
                declarations.push({
                    kind: "VariableDeclaration",
                    name: declaration.name.text,
                    type: serializeType(type, checker, typeCache, nominalTypesMap),
                    location: {
                        start: declaration.getStart(),
                        end: declaration.getEnd()
                    }
                });
            }
        }
    } else if (ts.isModuleDeclaration(node)) {
        declarations.push({
            kind: "ModuleDeclaration",
            name: node.name.text,
            location: {
                start: node.getStart(),
                end: node.getEnd()
            }
        });

        if (node.body && ts.isModuleBlock(node.body)) {
            ts.forEachChild(node.body, child => {
                if (isDeclarationNode(child)) {
                    processDeclaration(child, checker, declarations, typeCache, nominalTypesMap);
                }
            });
        }
    }
}

/**
 * Get the type of a node
 * @param {ts.Node} node - The AST node
 * @param {ts.TypeChecker} checker - TypeScript type checker
 * @param {Map} typeCache - Cache for type information
 * @param {Map} nominalTypesMap - Map of nominal types
 * @returns {Object} Serialized type information
 */
function getNodeType(node, checker, typeCache, nominalTypesMap) {
    if (ts.isInterfaceDeclaration(node) || ts.isClassDeclaration(node)) {
        if (node.name) {
            const symbol = checker.getSymbolAtLocation(node.name);
            if (symbol) {
                const type = checker.getDeclaredTypeOfSymbol(symbol);
                return serializeType(type, checker, typeCache, nominalTypesMap);
            }
        }
    } else if (ts.isTypeAliasDeclaration(node)) {
        if (node.name) {
            const type = checker.getTypeAtLocation(node.name);
            return serializeType(type, checker, typeCache, nominalTypesMap);
        }
    } else if (ts.isEnumDeclaration(node)) {
        if (node.name) {
            const symbol = checker.getSymbolAtLocation(node.name);
            if (symbol) {
                const type = checker.getDeclaredTypeOfSymbol(symbol);
                return serializeType(type, checker, typeCache, nominalTypesMap);
            }
        }
    } else if (ts.isFunctionDeclaration(node)) {
        const signature = checker.getSignatureFromDeclaration(node);
        if (signature) {
            return serializeSignature(signature, checker, typeCache, nominalTypesMap);
        }
    }

    return "unknown";
}

/**
 * Serialize a TypeScript type
 * @param {ts.Type} type - The TypeScript type
 * @param {ts.TypeChecker} checker - TypeScript type checker
 * @param {Map} typeCache - Cache for type information
 * @param {Map} nominalTypesMap - Map of nominal types
 * @returns {Object} Serialized type information
 */
function serializeType(type, checker, typeCache, nominalTypesMap) {
    if (!type) return "unknown";

    // Check cache first
    const typeId = type.id;
    if (typeCache.has(typeId)) {
        return typeCache.get(typeId);
    }

    const result = {
        name: checker.typeToString(type),
        flags: getFlagNames(type.flags, ts.TypeFlags)
    };

    // Handle different type kinds
    if (type.isUnion && type.isUnion()) {
        result.unionTypes = type.types.map(t => serializeType(t, checker, typeCache, nominalTypesMap));
    } else if (type.isIntersection && type.isIntersection()) {
        result.intersectionTypes = type.types.map(t => serializeType(t, checker, typeCache, nominalTypesMap));
    }

    // Handle call signatures
    if (type.getCallSignatures && type.getCallSignatures().length) {
        result.callSignatures = type.getCallSignatures().map(s => 
            serializeSignature(s, checker, typeCache, nominalTypesMap));
    }

    // Handle construct signatures
    if (type.getConstructSignatures && type.getConstructSignatures().length) {
        result.constructSignatures = type.getConstructSignatures().map(s => 
            serializeSignature(s, checker, typeCache, nominalTypesMap));
    }

    // Handle properties
    if (type.getProperties && type.getProperties().length) {
        result.properties = type.getProperties().map(p => {
            const propInfo = {
                name: p.name,
                flags: getFlagNames(p.flags, ts.SymbolFlags)
            };

            if (p.valueDeclaration) {
                try {
                    const propType = checker.getTypeOfSymbolAtLocation(p, p.valueDeclaration);
                    propInfo.type = serializeType(propType, checker, typeCache, nominalTypesMap);
                    propInfo.optional = !!p.valueDeclaration.questionToken;

                    if (propInfo.flags.includes("Method") || 
                        (propType.getCallSignatures && propType.getCallSignatures().length > 0)) {
                        const signatures = propType.getCallSignatures();
                        if (signatures && signatures.length > 0) {
                            propInfo.functionType = processFunctionType(signatures[0], checker);
                        }
                    }
                } catch (typeError) {
                    propInfo.typeError = `Error getting property type: ${typeError.message}`;
                }
            }

            return propInfo;
        });
    }

    // Cache the result
    typeCache.set(typeId, result);
    return result;
}

/**
 * Serialize a function signature
 * @param {ts.Signature} signature - The function signature
 * @param {ts.TypeChecker} checker - TypeScript type checker
 * @param {Map} typeCache - Cache for type information
 * @param {Map} nominalTypesMap - Map of nominal types
 * @returns {Object} Serialized signature information
 */
function serializeSignature(signature, checker, typeCache, nominalTypesMap) {
    if (!signature) return null;

    const parameters = signature.getParameters();
    const returnType = signature.getReturnType();

    return {
        parameters: parameters.map(p => ({
            name: p.name,
            type: serializeType(checker.getTypeOfSymbolAtLocation(p, p.valueDeclaration), checker, typeCache, nominalTypesMap),
            optional: !!p.valueDeclaration?.questionToken
        })),
        returnType: serializeType(returnType, checker, typeCache, nominalTypesMap)
    };
}

/**
 * Process function type information
 * @param {ts.Signature} signature - The function signature
 * @param {ts.TypeChecker} checker - TypeScript type checker
 * @returns {Object} Processed function type information
 */
function processFunctionType(signature, checker) {
    if (!signature || !checker) return null;
    
    const parameters = signature.getParameters();
    const returnType = signature.getReturnType();

    return {
        parameters: parameters.map(p => ({
            name: p.name,
            type: checker.typeToString(checker.getTypeOfSymbolAtLocation(p, p.valueDeclaration)),
            optional: !!p.valueDeclaration?.questionToken
        })),
        returnType: checker.typeToString(returnType)
    };
}

/**
 * Get flag names from a bit flag value
 * @param {number} flags - The bit flags
 * @param {Object} flagsEnum - The enum with flag definitions
 * @returns {string[]} Array of flag names
 */
function getFlagNames(flags, flagsEnum) {
    const result = [];
    for (const flag in flagsEnum) {
        if (typeof flagsEnum[flag] === 'number' && (flags & flagsEnum[flag]) !== 0) {
            result.push(flag);
        }
    }
    return result;
}
