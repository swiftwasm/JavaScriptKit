/**
 * Type processing functionality
 * @module types/processor
 */

// @ts-check
import ts from 'typescript';
import { visitNode } from './collector.js';

/**
 * @typedef {import('./index.js').TypeScript} TypeScript
 */

/**
 * Create a TypeScript program from a d.ts file
 * @param {string} filePath - Path to the d.ts file
 * @returns {ts.Program} TypeScript program object
 */
export function createProgram(filePath) {
    const tsModule = ts;

    const options = {
        target: tsModule.ScriptTarget.ESNext,
        module: tsModule.ModuleKind.ESNext,
        moduleResolution: tsModule.ModuleResolutionKind.NodeJs,
        esModuleInterop: true,
        strict: true,
    };

    const host = tsModule.createCompilerHost(options);
    return tsModule.createProgram([filePath], options, host);
}

/**
 * Process a declaration node
 * @param {ts.Node} node - The AST node
 * @param {ts.TypeChecker} checker - TypeScript type checker
 * @param {Array} declarations - Array to collect declarations
 * @param {Map} typeCache - Cache for type information
 * @param {Map} nominalTypesMap - Map of nominal types
 */
export function processDeclaration(node, checker, declarations, typeCache, nominalTypesMap) {
    const tsModule = ts;

    if (node.name) {
        let name = node.name.text;
        let type = getNodeType(node, checker, typeCache, nominalTypesMap);

        declarations.push({
            kind: tsModule.SyntaxKind[node.kind],
            name: name,
            type: type,
            location: {
                start: node.getStart(),
                end: node.getEnd()
            }
        });
    } else if (tsModule.isVariableStatement(node)) {
        // Handle variable declarations
        for (const declaration of node.declarationList.declarations) {
            if (declaration.name && tsModule.isIdentifier(declaration.name)) {
                let name = declaration.name.text;
                let type = checker.getTypeAtLocation(declaration);

                declarations.push({
                    kind: "VariableDeclaration",
                    name: name,
                    type: serializeType(type, checker, typeCache, nominalTypesMap),
                    location: {
                        start: declaration.getStart(),
                        end: declaration.getEnd()
                    }
                });
            }
        }
    } else if (tsModule.isModuleDeclaration(node)) {
        // Handle module declarations
        let name = node.name.text;

        declarations.push({
            kind: "ModuleDeclaration",
            name: name,
            location: {
                start: node.getStart(),
                end: node.getEnd()
            }
        });

        // Process declarations inside the module
        if (node.body && tsModule.isModuleBlock(node.body)) {
            tsModule.forEachChild(node.body, child => {
                if (child.kind) {
                    processDeclaration(child, checker, declarations, typeCache, nominalTypesMap);
                }
            });
        }
    }
}

/**
 * Get the node type from declaration
 * @param {ts.Node} node - The AST node
 * @param {ts.TypeChecker} checker - TypeScript type checker
 * @param {Map} typeCache - Cache for type information
 * @param {Map} nominalTypesMap - Map of nominal types
 * @param {Object} deps - Dependencies
 * @param {Object} deps.ts - TypeScript module
 * @returns {Object} Serialized type information
 */
export function getNodeType(node, checker, typeCache, nominalTypesMap) {
    const tsModule = ts;

    if (tsModule.isInterfaceDeclaration(node) || tsModule.isClassDeclaration(node)) {
        const symbol = checker.getSymbolAtLocation(node.name);
        if (symbol) {
            const type = checker.getDeclaredTypeOfSymbol(symbol);
            return serializeType(type, checker, typeCache, nominalTypesMap);
        }
    } else if (tsModule.isTypeAliasDeclaration(node)) {
        const type = checker.getTypeAtLocation(node.name);
        return serializeType(type, checker, typeCache, nominalTypesMap);
    } else if (tsModule.isEnumDeclaration(node)) {
        const symbol = checker.getSymbolAtLocation(node.name);
        if (symbol) {
            const type = checker.getDeclaredTypeOfSymbol(symbol);
            return serializeType(type, checker, typeCache, nominalTypesMap);
        }
    } else if (tsModule.isFunctionDeclaration(node)) {
        const signature = checker.getSignatureFromDeclaration(node);
        if (signature) {
            return serializeSignature(signature, checker, typeCache, nominalTypesMap);
        }
    } else if (tsModule.isModuleDeclaration(node)) {
        // For module declarations, return a reference to the module
        return {
            kind: "module",
            name: node.name.text
        };
    }

    return "unknown";
}

/**
 * Process the type declarations and resolve non-nominal types
 * @param {ts.Program} program - TypeScript program
 * @param {string} inputFilePath - Path to the input file
 * @returns {Object} Processed type declarations
 */
export function processTypeDeclarations(program, inputFilePath) {
    const tsModule = ts;
    const consoleObj = console;
    const collectorModule = { visitNode };

    const checker = program.getTypeChecker();
    const sourceFiles = program.getSourceFiles().filter(
        sf => !sf.isDeclarationFile || sf.fileName === inputFilePath
    );

    const typeCache = new Map();
    const nominalTypesMap = new Map();
    const results = {};

    // Store all declarations in a single array for easier access
    const allDeclarations = [];
    const moduleTypes = [];
    const interfaceTypes = [];

    for (const sourceFile of sourceFiles) {
        // Skip internal TypeScript library files
        if (sourceFile.fileName.includes('node_modules/typescript/lib')) continue;

        results[sourceFile.fileName] = {
            fileName: sourceFile.fileName,
            declarations: []
        };

        // Visit each node in the source file
        try {
            // First pass: collect all interface and module declarations
            tsModule.forEachChild(sourceFile, node => {
                if (tsModule.isModuleDeclaration(node)) {
                    const moduleName = node.name.text;
                    const moduleDecl = {
                        kind: "ModuleDeclaration",
                        name: moduleName,
                        location: {
                            start: node.getStart(),
                            end: node.getEnd()
                        }
                    };

                    moduleTypes.push(moduleDecl);
                    results[sourceFile.fileName].declarations.push(moduleDecl);
                }
                else if (tsModule.isInterfaceDeclaration(node)) {
                    const interfaceName = node.name.text;
                    const symbol = checker.getSymbolAtLocation(node.name);

                    if (symbol) {
                        const type = checker.getDeclaredTypeOfSymbol(symbol);
                        const serializedType = serializeType(type, checker, typeCache, nominalTypesMap);

                        const interfaceDecl = {
                            kind: "InterfaceDeclaration",
                            name: interfaceName,
                            type: serializedType,
                            location: {
                                start: node.getStart(),
                                end: node.getEnd()
                            }
                        };

                        interfaceTypes.push(interfaceDecl);
                        results[sourceFile.fileName].declarations.push(interfaceDecl);
                    }
                }
            });

            // Then process all other nodes regularly
            tsModule.forEachChild(sourceFile, node => {
                if (!tsModule.isModuleDeclaration(node) && !tsModule.isInterfaceDeclaration(node)) {
                    collectorModule.visitNode(node, checker, results[sourceFile.fileName].declarations, typeCache, nominalTypesMap);
                }
            });

            // Add these declarations to our master list
            allDeclarations.push(...results[sourceFile.fileName].declarations);
        } catch (error) {
            consoleObj.error(`Error processing ${sourceFile.fileName}: ${error.message}`);
        }
    }

    // Add the collected nominal types to the results
    const referencedNominalTypes = [];
    nominalTypesMap.forEach((typeInfo) => {
        // Convert to the same format as declarations
        referencedNominalTypes.push({
            kind: typeInfo.symbolFlags.includes("Class") ? "ClassDeclaration" :
                typeInfo.symbolFlags.includes("Interface") ? "InterfaceDeclaration" :
                    typeInfo.symbolFlags.includes("TypeAlias") ? "TypeAliasDeclaration" :
                        typeInfo.symbolFlags.includes("Enum") ? "EnumDeclaration" :
                            typeInfo.symbolFlags.includes("Function") ? "FunctionDeclaration" :
                                typeInfo.symbolFlags.includes("Variable") ? "VariableDeclaration" :
                                    typeInfo.symbolFlags.includes("Module") ? "ModuleDeclaration" :
                                        "UnknownDeclaration",
            name: typeInfo.symbolName,
            type: typeInfo,  // Keep the full type info in the "type" field
            location: typeInfo.location || {}
        });
    });

    // Add referenced nominal types to the results
    results.referencedNominalTypes = referencedNominalTypes;

    // Add the moduleTypes and interfaceTypes to the results
    results.moduleTypes = moduleTypes;
    results.interfaceTypes = interfaceTypes;

    return results;
}

// Import serialization functions after we've declared the main processor functions to avoid circular references
import { serializeType, serializeSignature } from './serializer.js'; 
