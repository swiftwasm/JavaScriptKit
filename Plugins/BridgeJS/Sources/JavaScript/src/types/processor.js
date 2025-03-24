/**
 * Type processing functionality
 * @module types/processor
 */

import ts from 'typescript';
import { visitNode } from './collector.js';

/**
 * Create a TypeScript program from a d.ts file
 * @param {string} filePath - Path to the d.ts file
 * @param {Object} deps - Dependencies
 * @param {Object} deps.ts - TypeScript module
 * @returns {ts.Program} TypeScript program object
 */
export function createProgram(filePath, deps = { ts }) {
    const tsModule = deps.ts || ts;
    
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
 * @param {Object} deps - Dependencies
 * @param {Object} deps.ts - TypeScript module 
 */
export function processDeclaration(node, checker, declarations, typeCache, nominalTypesMap, deps = { ts }) {
    const tsModule = deps.ts || ts;
    
    if (node.name) {
        let name = node.name.text;
        let type = getNodeType(node, checker, typeCache, nominalTypesMap, deps);

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
                    type: serializeType(type, checker, typeCache, nominalTypesMap, deps),
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
                    processDeclaration(child, checker, declarations, typeCache, nominalTypesMap, deps);
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
export function getNodeType(node, checker, typeCache, nominalTypesMap, deps = { ts }) {
    const tsModule = deps.ts || ts;
    
    if (tsModule.isInterfaceDeclaration(node) || tsModule.isClassDeclaration(node)) {
        const symbol = checker.getSymbolAtLocation(node.name);
        if (symbol) {
            const type = checker.getDeclaredTypeOfSymbol(symbol);
            return serializeType(type, checker, typeCache, nominalTypesMap, deps);
        }
    } else if (tsModule.isTypeAliasDeclaration(node)) {
        const type = checker.getTypeAtLocation(node.name);
        return serializeType(type, checker, typeCache, nominalTypesMap, deps);
    } else if (tsModule.isEnumDeclaration(node)) {
        const symbol = checker.getSymbolAtLocation(node.name);
        if (symbol) {
            const type = checker.getDeclaredTypeOfSymbol(symbol);
            return serializeType(type, checker, typeCache, nominalTypesMap, deps);
        }
    } else if (tsModule.isFunctionDeclaration(node)) {
        const signature = checker.getSignatureFromDeclaration(node);
        if (signature) {
            return serializeSignature(signature, checker, typeCache, nominalTypesMap, deps);
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
 * @param {Object} deps - Dependencies
 * @param {Object} deps.ts - TypeScript module
 * @param {Object} deps.console - Console object
 * @param {Object} deps.collector - Collector module
 * @returns {Object} Processed type declarations
 */
export function processTypeDeclarations(program, inputFilePath, deps = {}) {
    const tsModule = deps.ts || ts;
    const consoleObj = deps.console || console;
    const collectorModule = deps.collector || { visitNode };
    
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

    for (const sourceFile of sourceFiles) {
        // Skip internal TypeScript library files
        if (sourceFile.fileName.includes('node_modules/typescript/lib')) continue;

        results[sourceFile.fileName] = {
            fileName: sourceFile.fileName,
            declarations: []
        };

        // Visit each node in the source file
        try {
            // Explicitly look for module declarations first
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
            });
            
            // Then process all nodes regularly
            tsModule.forEachChild(sourceFile, node => {
                if (!tsModule.isModuleDeclaration(node)) { // Skip modules as we already processed them
                    collectorModule.visitNode(node, checker, results[sourceFile.fileName].declarations, typeCache, nominalTypesMap, deps);
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
    
    // Add the moduleTypes to the results - this is what examples.test.js is checking for
    results.moduleTypes = moduleTypes;

    return results;
}

// Import serialization functions after we've declared the main processor functions to avoid circular references
import { serializeType, serializeSignature } from './serializer.js'; 
