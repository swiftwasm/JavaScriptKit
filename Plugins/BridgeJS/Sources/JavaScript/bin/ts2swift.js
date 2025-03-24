#!/usr/bin/env node

import ts from 'typescript';
import * as path from 'path';
import * as fs from 'fs';

// Command line argument parsing
function parseCommandLineArgs() {
    const args = process.argv.slice(2);
    let filePath = '';
    let outputPath = '';

    for (let i = 0; i < args.length; i++) {
        if (args[i] === '-o' || args[i] === '--output') {
            if (i + 1 < args.length) {
                outputPath = args[i + 1];
                i++; // Skip the next arg since it's the output path
            } else {
                console.error('Error: -o option requires a file path.');
                process.exit(1);
            }
        } else if (!filePath) {
            filePath = args[i];
        }
    }

    if (!filePath) {
        console.error('Usage: ts2swift <d.ts file path> [-o output.json]');
        process.exit(1);
    }

    if (!fs.existsSync(filePath)) {
        console.error(`File not found: ${filePath}`);
        process.exit(1);
    }

    return { filePath, outputPath };
}

// Create a TypeScript program from the d.ts file
function createProgram(filePath) {
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

// Helper functions for type processing
function getFlagNames(flags, flagsEnum) {
    const result = [];
    for (const flag in flagsEnum) {
        if (typeof flagsEnum[flag] === 'number' && (flags & flagsEnum[flag]) !== 0) {
            result.push(flag);
        }
    }
    return result;
}

function getTypeFlags(type) {
    return getFlagNames(type.flags, ts.TypeFlags);
}

function getTypeId(type) {
    return type.id;
}

// Check if a type is a primitive type
function isPrimitiveType(type) {
    // TypeScript primitive types have specific flags
    const primitiveFlags = [
        ts.TypeFlags.String,
        ts.TypeFlags.Number,
        ts.TypeFlags.Boolean,
        ts.TypeFlags.Null,
        ts.TypeFlags.Undefined,
        ts.TypeFlags.Void,
        ts.TypeFlags.Symbol,
        ts.TypeFlags.BigInt,
        ts.TypeFlags.StringLiteral,
        ts.TypeFlags.NumberLiteral,
        ts.TypeFlags.BooleanLiteral,
        ts.TypeFlags.EnumLiteral
    ];
    
    return primitiveFlags.some(flag => (type.flags & flag) !== 0);
}

// Check if a type is a nominal type (named type)
function isNominalType(type) {
    if (!type || !type.symbol) return false;
    
    // Check for named types with declarations
    const isNamed = type.symbol && type.symbol.name && type.symbol.name !== "__type";
    
    // Check for specific symbol flags that indicate nominal types
    const hasNominalFlag = type.symbol.flags && (
        !!(type.symbol.flags & ts.SymbolFlags.Class) ||
        !!(type.symbol.flags & ts.SymbolFlags.Interface) ||
        !!(type.symbol.flags & ts.SymbolFlags.TypeAlias) ||
        !!(type.symbol.flags & ts.SymbolFlags.Enum) ||
        !!(type.symbol.flags & ts.SymbolFlags.Function) ||
        !!(type.symbol.flags & ts.SymbolFlags.Variable)
    );
    
    return isNamed && hasNominalFlag;
}

// Process the function type information
function processFunctionType(signature, checker) {
    if (!signature || !signature.parameters) return null;
    
    return {
        parameters: signature.parameters.map(p => ({
            name: p.name,
            type: p.valueDeclaration 
                ? checker.typeToString(checker.getTypeOfSymbolAtLocation(p, p.valueDeclaration))
                : 'any',
            optional: !!(p.valueDeclaration && p.valueDeclaration.questionToken)
        })),
        returnType: checker.typeToString(signature.getReturnType())
    };
}

// Process property information with function type detection
function processProperty(property, checker) {
    const propInfo = {
        name: property.name,
        flags: getFlagNames(property.flags, ts.SymbolFlags),
    };
    
    // Get property type if possible
    try {
        if (property.valueDeclaration) {
            const propType = checker.getTypeOfSymbolAtLocation(property, property.valueDeclaration);
            propInfo.type = {
                name: checker.typeToString(propType),
                flags: getTypeFlags(propType)
            };
            
            // Check if the property type is a nominal type and add a reference
            if (propType.symbol && propType.symbol.name && propType.symbol.name !== "__type") {
                propInfo.type.isNominal = true;
                propInfo.type.symbolName = propType.symbol.name;
            }
            
            // Check if it's a primitive type
            if (isPrimitiveType(propType)) {
                propInfo.type.isPrimitive = true;
            }
            
            // For function/method types, add structured parameter and return type information
            if (propInfo.flags.includes("Method") || 
                (propType.getCallSignatures && propType.getCallSignatures().length > 0)) {
                const signatures = propType.getCallSignatures();
                if (signatures && signatures.length > 0) {
                    propInfo.type.functionType = processFunctionType(signatures[0], checker);
                }
            }
            
            // Check if optional
            if (property.valueDeclaration.questionToken) {
                propInfo.optional = true;
            }
            
            // Get documentation if available
            const docs = ts.getJSDocCommentRanges(property.valueDeclaration, property.valueDeclaration.getSourceFile());
            if (docs && docs.length > 0) {
                const docText = property.valueDeclaration.getSourceFile().text.substring(docs[0].pos, docs[0].end);
                propInfo.documentation = docText;
            }
        }
    } catch (error) {
        propInfo.typeError = `Error getting property type: ${error.message}`;
    }
    
    return propInfo;
}

// Collect information about a nominal type
function collectNominalTypeInfo(type, checker, nominalTypesMap) {
    if (!type || !type.symbol) return;
    
    const symbolName = type.symbol.name;
    if (!symbolName || symbolName === "__type") return;
    
    // Create a unique ID for the type
    const id = `${symbolName}_${type.id}`;
    
    // Skip if already collected
    if (nominalTypesMap.has(id)) return;
    
    // Get symbol flags first for kind detection
    const symbolFlags = getFlagNames(type.symbol.flags, ts.SymbolFlags);
    
    // Determine the kind based on symbol flags
    let kind = "unknown";
    if (symbolFlags.includes("Class")) kind = "class";
    else if (symbolFlags.includes("Interface")) kind = "interface";
    else if (symbolFlags.includes("TypeAlias")) kind = "type";
    else if (symbolFlags.includes("Enum")) kind = "enum";
    else if (symbolFlags.includes("Function")) kind = "function";
    else if (symbolFlags.includes("Variable")) kind = "variable";
    
    // Collect basic information about the type
    const typeInfo = {
        id,
        name: checker.typeToString(type),
        symbolName,
        symbolFlags,
        kind
    };
    
    // Try to collect additional information based on declaration
    collectDeclarationInfo(type, typeInfo);
    
    // Add members (properties, methods, etc.)
    collectTypeStructure(type, checker, typeInfo);
    
    // Store the type info
    nominalTypesMap.set(id, typeInfo);
}

// Collect information from type declarations
function collectDeclarationInfo(type, typeInfo) {
    try {
        if (type.symbol.declarations && type.symbol.declarations.length > 0) {
            const declaration = type.symbol.declarations[0];
            
            // Add location information
            typeInfo.location = {
                fileName: declaration.getSourceFile().fileName,
                start: declaration.getStart(),
                end: declaration.getEnd()
            };
            
            // Add documentation if available
            const docs = ts.getJSDocCommentRanges(declaration, declaration.getSourceFile());
            if (docs && docs.length > 0) {
                const docText = declaration.getSourceFile().text.substring(docs[0].pos, docs[0].end);
                typeInfo.documentation = docText;
            }
            
            // Add type parameters if available
            if (declaration.typeParameters) {
                typeInfo.typeParameters = declaration.typeParameters.map(tp => tp.name.text);
            }

            // Get the actual text of the declaration
            const sourceFile = declaration.getSourceFile();
            if (sourceFile) {
                typeInfo.declarationText = sourceFile.text.substring(
                    declaration.getStart(), 
                    declaration.getEnd()
                );
            }

            // For interface or class declarations, add more detailed structure information
            if (ts.isInterfaceDeclaration(declaration) || ts.isClassDeclaration(declaration)) {
                // Add extends information if available
                if (declaration.heritageClauses) {
                    typeInfo.extends = declaration.heritageClauses
                        .filter(c => c.token === ts.SyntaxKind.ExtendsKeyword)
                        .flatMap(c => c.types.map(t => t.expression.getText()));
                        
                    typeInfo.implements = declaration.heritageClauses
                        .filter(c => c.token === ts.SyntaxKind.ImplementsKeyword)
                        .flatMap(c => c.types.map(t => t.expression.getText()));
                }
            }
        }
    } catch (error) {
        typeInfo.error = `Error collecting declaration info: ${error.message}`;
    }
}

// Collect structure information from a type
function collectTypeStructure(type, checker, typeInfo) {
    try {
        // Add properties
        collectProperties(type, checker, typeInfo);
        
        // Add call signatures (for functions and methods)
        collectCallSignatures(type, checker, typeInfo);
        
        // Add construct signatures (for classes and constructors)
        collectConstructSignatures(type, checker, typeInfo);
        
        // For enums, add enum members
        collectEnumMembers(type, checker, typeInfo);
        
        // For type aliases, try to get the aliased type
        collectTypeAliasInfo(type, checker, typeInfo);
    } catch (error) {
        typeInfo.structureError = `Error collecting type structure: ${error.message}`;
    }
}

// Collect properties from a type
function collectProperties(type, checker, typeInfo) {
    if (type.getProperties) {
        const properties = type.getProperties();
        if (properties.length > 0) {
            typeInfo.properties = properties.map(property => processProperty(property, checker));
        }
    }
}

// Collect call signatures from a type
function collectCallSignatures(type, checker, typeInfo) {
    if (type.getCallSignatures) {
        const callSignatures = type.getCallSignatures();
        if (callSignatures.length > 0) {
            typeInfo.callSignatures = callSignatures.map(signature => processFunctionType(signature, checker));
        }
    }
}

// Collect construct signatures from a type
function collectConstructSignatures(type, checker, typeInfo) {
    if (type.getConstructSignatures) {
        const constructSignatures = type.getConstructSignatures();
        if (constructSignatures.length > 0) {
            typeInfo.constructSignatures = constructSignatures.map(signature => processFunctionType(signature, checker));
        }
    }
}

// Collect enum members from a type
function collectEnumMembers(type, checker, typeInfo) {
    if (type.symbol && (type.symbol.flags & ts.SymbolFlags.Enum)) {
        const enumMembers = type.symbol.exports;
        if (enumMembers) {
            typeInfo.enumMembers = [];
            enumMembers.forEach((value, key) => {
                if (value.valueDeclaration && ts.isEnumMember(value.valueDeclaration)) {
                    const initializer = value.valueDeclaration.initializer;
                    let enumValue = undefined;
                    
                    if (initializer) {
                        if (ts.isNumericLiteral(initializer)) {
                            enumValue = parseInt(initializer.text, 10);
                        } else if (ts.isStringLiteral(initializer)) {
                            enumValue = initializer.text;
                        } else {
                            enumValue = initializer.getText();
                        }
                    }
                    
                    typeInfo.enumMembers.push({
                        name: key,
                        value: enumValue
                    });
                }
            });
        }
    }
}

// Collect type alias information
function collectTypeAliasInfo(type, checker, typeInfo) {
    if (type.symbol && (type.symbol.flags & ts.SymbolFlags.TypeAlias)) {
        if (type.aliasSymbol && type.aliasTypeArguments) {
            typeInfo.aliasTo = {
                name: type.aliasSymbol.name,
                typeArguments: type.aliasTypeArguments.map(t => checker.typeToString(t))
            };
        }
    }
}

// Serialize a function or method signature
function serializeSignature(signature, checker, typeCache, nominalTypesMap, depth = 0) {
    if (depth > 10) {
        return { exceeded_max_depth: true };
    }
    
    try {
        return {
            parameters: signature.parameters.map(p => {
                try {
                    return {
                        name: p.name,
                        type: p.valueDeclaration 
                            ? serializeType(checker.getTypeOfSymbolAtLocation(p, p.valueDeclaration), checker, typeCache, nominalTypesMap, depth + 1)
                            : { kind: "unknown" },
                        optional: !!(p.valueDeclaration && p.valueDeclaration.questionToken)
                    };
                } catch (error) {
                    return {
                        name: p.name,
                        error: `Error processing parameter: ${error.message}`
                    };
                }
            }),
            returnType: serializeType(signature.getReturnType(), checker, typeCache, nominalTypesMap, depth + 1)
        };
    } catch (error) {
        return {
            error: `Error serializing signature: ${error.message}`
        };
    }
}

// Serialize a TypeScript type into a descriptive object
function serializeType(type, checker, typeCache, nominalTypesMap, depth = 0) {
    // Prevent infinite recursion with a depth limit
    const MAX_DEPTH = 10;
    if (depth > MAX_DEPTH) {
        return { 
            exceeded_max_depth: true,
            name: checker.typeToString(type)
        };
    }
    
    // Skip processing if the type is undefined or null
    if (!type) {
        return { kind: "unknown" };
    }
    
    // Get a better type ID that's consistent
    const id = getTypeId(type);
    
    // Check if it's a primitive type and return it directly without further resolution
    if (isPrimitiveType(type)) {
        return {
            kind: "primitive",
            name: checker.typeToString(type),
            flags: getTypeFlags(type)
        };
    }
    
    // Check if it's a nominal type, collect its info, and return a reference
    if (isNominalType(type)) {
        // Collect information about this nominal type
        collectNominalTypeInfo(type, checker, nominalTypesMap);
        
        // Return a reference to this nominal type
        return {
            kind: "nominal_ref",
            name: checker.typeToString(type),
            symbolName: type.symbol ? type.symbol.name : undefined,
            ref: type.symbol ? `${type.symbol.name}_${type.id}` : undefined
        };
    }
    
    // Return cached type if available to handle recursive types
    if (typeCache.has(id)) {
        return { ref: id };
    }
    
    try {
        // Create a placeholder to avoid infinite recursion
        typeCache.set(id, { id });
        
        const result = {
            id,
            flags: getTypeFlags(type),
            name: checker.typeToString(type)
        };
        
        if (type.symbol) {
            result.symbolName = type.symbol.name;
            result.symbolFlags = getFlagNames(type.symbol.flags, ts.SymbolFlags);
        }
        
        if (type.aliasSymbol) {
            result.aliasSymbolName = type.aliasSymbol.name;
        }

        // Handle specific type kind serialization
        serializeTypeKinds(type, checker, typeCache, nominalTypesMap, depth, result);
        
        // Update cached value with complete information
        typeCache.set(id, result);
        return result;
    } catch (error) {
        return {
            error: `Error serializing type: ${error.message}`,
            name: type ? checker.typeToString(type) : 'unknown'
        };
    }
}

// Handle serialization of special type kinds (union, intersection, etc.)
function serializeTypeKinds(type, checker, typeCache, nominalTypesMap, depth, result) {
    try {
        // Handle union types
        if (type.isUnion && type.isUnion()) {
            result.unionTypes = type.types.map(t => serializeType(t, checker, typeCache, nominalTypesMap, depth + 1));
        } 
        // Handle intersection types
        else if (type.isIntersection && type.isIntersection()) {
            result.intersectionTypes = type.types.map(t => serializeType(t, checker, typeCache, nominalTypesMap, depth + 1));
        }
        
        // Handle call signatures
        if (type.getCallSignatures && type.getCallSignatures().length) {
            result.callSignatures = type.getCallSignatures().map(s => 
                serializeSignature(s, checker, typeCache, nominalTypesMap, depth + 1));
        }
        
        // Handle construct signatures
        if (type.getConstructSignatures && type.getConstructSignatures().length) {
            result.constructSignatures = type.getConstructSignatures().map(s => 
                serializeSignature(s, checker, typeCache, nominalTypesMap, depth + 1));
        }
        
        // Handle properties
        if (type.getProperties && type.getProperties().length) {
            result.properties = type.getProperties().map(p => {
                try {
                    return {
                        name: p.name,
                        flags: getFlagNames(p.flags, ts.SymbolFlags),
                        type: p.valueDeclaration 
                            ? serializeType(checker.getTypeOfSymbolAtLocation(p, p.valueDeclaration), checker, typeCache, nominalTypesMap, depth + 1)
                            : { kind: "unknown" }
                    };
                } catch (error) {
                    return {
                        name: p.name,
                        error: `Error processing property: ${error.message}`
                    };
                }
            });
        }
        
        // Handle array types
        if (checker.isArrayType && checker.isArrayType(type)) {
            const typeArgs = checker.getTypeArguments(type);
            if (typeArgs && typeArgs.length > 0) {
                const arrayType = typeArgs[0];
                result.arrayElementType = serializeType(arrayType, checker, typeCache, nominalTypesMap, depth + 1);
            }
        }
    } catch (error) {
        result.error = `Error processing type: ${error.message}`;
    }
}

// Get the node type from declaration
function getNodeType(node, checker, typeCache, nominalTypesMap) {
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

// Visit each node and extract type information
function visitNode(node, checker, declarations, typeCache, nominalTypesMap) {
    if (ts.isInterfaceDeclaration(node) ||
        ts.isTypeAliasDeclaration(node) ||
        ts.isEnumDeclaration(node) ||
        ts.isFunctionDeclaration(node) ||
        ts.isClassDeclaration(node) ||
        ts.isVariableStatement(node)) {

        processDeclaration(node, checker, declarations, typeCache, nominalTypesMap);
    }

    // Recursively visit child nodes
    ts.forEachChild(node, child => visitNode(child, checker, declarations, typeCache, nominalTypesMap));
}

// Process a declaration node
function processDeclaration(node, checker, declarations, typeCache, nominalTypesMap) {
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

// Process the type declarations and resolve non-nominal types
function processTypeDeclarations(program, inputFilePath) {
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

// Write results to file or stdout
function writeResults(results, outputPath) {
    // Convert results to JSON
    const jsonOutput = JSON.stringify(results, null, 2);
    
    // Output the results either to a file or stdout
    if (outputPath) {
        try {
            fs.writeFileSync(outputPath, jsonOutput);
            console.log(`Results written to ${outputPath}`);
            return true;
        } catch (error) {
            console.error(`Error writing to output file: ${error.message}`);
            return false;
        }
    } else {
        // Output to stdout
        console.log(jsonOutput);
        return true;
    }
}

// Main function
async function main() {
    // Parse command line arguments
    const { filePath, outputPath } = parseCommandLineArgs();
    
    console.log(`Processing ${filePath}...`);

    // Create TypeScript program and process declarations
    const program = createProgram(filePath);
    const results = processTypeDeclarations(program, filePath);

    // Write results to file or stdout
    const success = writeResults(results, outputPath);
    
    if (!success) {
        process.exit(1);
    }
}

// Execute the main function
main().catch(error => {
    console.error('Error:', error);
    process.exit(1);
}); 
