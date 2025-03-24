/**
 * Type processing functionality
 * @module types/processor
 */

import ts from 'typescript';
import { visitNode } from './collector.js';

/**
 * Create a TypeScript program from a d.ts file
 * @param {string} filePath - Path to the d.ts file
 * @returns {ts.Program} TypeScript program object
 */
export function createProgram(filePath) {
    const options = {
        target: ts.ScriptTarget.ESNext,
        module: ts.ModuleKind.ESNext,
        moduleResolution: ts.ModuleResolutionKind.NodeJs,
        esModuleInterop: true,
        strict: true,
    };

    const host = ts.createCompilerHost(options);
    return ts.createProgram([filePath], options, host);
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
    if (node.name) {
        let name = node.name.text;
        let type = getNodeType(node, checker, typeCache, nominalTypesMap);

        declarations.push({
            kind: ts.SyntaxKind[node.kind],
            name: name,
            type: type,
            location: {
                start: node.getStart(),
                end: node.getEnd()
            }
        });
    } else if (ts.isVariableStatement(node)) {
        // Handle variable declarations
        for (const declaration of node.declarationList.declarations) {
            if (declaration.name && ts.isIdentifier(declaration.name)) {
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
    }
}

/**
 * Get the node type from declaration
 * @param {ts.Node} node - The AST node
 * @param {ts.TypeChecker} checker - TypeScript type checker
 * @param {Map} typeCache - Cache for type information
 * @param {Map} nominalTypesMap - Map of nominal types
 * @returns {Object} Serialized type information
 */
export function getNodeType(node, checker, typeCache, nominalTypesMap) {
    if (ts.isInterfaceDeclaration(node) || ts.isClassDeclaration(node)) {
        const symbol = checker.getSymbolAtLocation(node.name);
        if (symbol) {
            const type = checker.getDeclaredTypeOfSymbol(symbol);
            return serializeType(type, checker, typeCache, nominalTypesMap);
        }
    } else if (ts.isTypeAliasDeclaration(node)) {
        const type = checker.getTypeAtLocation(node.name);
        return serializeType(type, checker, typeCache, nominalTypesMap);
    } else if (ts.isEnumDeclaration(node)) {
        const symbol = checker.getSymbolAtLocation(node.name);
        if (symbol) {
            const type = checker.getDeclaredTypeOfSymbol(symbol);
            return serializeType(type, checker, typeCache, nominalTypesMap);
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
 * Process the type declarations and resolve non-nominal types
 * @param {ts.Program} program - TypeScript program
 * @param {string} inputFilePath - Path to the input file
 * @returns {Object} Processed type declarations
 */
export function processTypeDeclarations(program, inputFilePath) {
    const checker = program.getTypeChecker();
    const sourceFiles = program.getSourceFiles().filter(
        sf => !sf.isDeclarationFile || sf.fileName === inputFilePath
    );

    const typeCache = new Map();
    const nominalTypesMap = new Map();
    const results = {};

    for (const sourceFile of sourceFiles) {
        // Skip internal TypeScript library files
        if (sourceFile.fileName.includes('node_modules/typescript/lib')) continue;

        results[sourceFile.fileName] = {
            fileName: sourceFile.fileName,
            declarations: []
        };

        // Visit each node in the source file
        try {
            ts.forEachChild(sourceFile, node => {
                visitNode(node, checker, results[sourceFile.fileName].declarations, typeCache, nominalTypesMap);
            });
        } catch (error) {
            console.error(`Error processing ${sourceFile.fileName}: ${error.message}`);
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
                  "UnknownDeclaration",
            name: typeInfo.symbolName,
            type: typeInfo,  // Keep the full type info in the "type" field
            location: typeInfo.location || {}
        });
    });

    // Add referenced nominal types to the results
    results.referencedNominalTypes = referencedNominalTypes;

    return results;
}

// Import serialization functions after we've declared the main processor functions to avoid circular references
import { serializeType, serializeSignature } from './serializer.js'; 
