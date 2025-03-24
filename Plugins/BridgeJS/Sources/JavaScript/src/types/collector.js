/**
 * Type collection functionality
 * @module types/collector
 */

import ts from 'typescript';
import { isNominalType, getFlagNames } from './utils.js';
import { processDeclaration } from './processor.js';
import { processFunctionType } from './serializer.js';

/**
 * Visit each node and extract type information
 * @param {ts.Node} node - The TypeScript AST node
 * @param {ts.TypeChecker} checker - TypeScript type checker
 * @param {Array} declarations - Array to collect declarations
 * @param {Map} typeCache - Cache for type information
 * @param {Map} nominalTypesMap - Map of nominal types
 */
export function visitNode(node, checker, declarations, typeCache, nominalTypesMap) {
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

/**
 * Collect information about a nominal type
 * @param {ts.Type} type - The TypeScript type
 * @param {ts.TypeChecker} checker - TypeScript type checker
 * @param {Map} nominalTypesMap - Map to store collected type info
 */
export function collectNominalTypeInfo(type, checker, nominalTypesMap) {
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

/**
 * Collect information from type declarations
 * @param {ts.Type} type - The TypeScript type
 * @param {Object} typeInfo - Object to store collected info
 */
export function collectDeclarationInfo(type, typeInfo) {
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

/**
 * Collect structure information from a type
 * @param {ts.Type} type - The TypeScript type
 * @param {ts.TypeChecker} checker - TypeScript type checker
 * @param {Object} typeInfo - Object to store collected info
 */
export function collectTypeStructure(type, checker, typeInfo) {
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

/**
 * Collect properties from a type
 * @param {ts.Type} type - The TypeScript type
 * @param {ts.TypeChecker} checker - TypeScript type checker
 * @param {Object} typeInfo - Object to store collected info
 */
export function collectProperties(type, checker, typeInfo) {
    if (type.getProperties) {
        const properties = type.getProperties();
        if (properties.length > 0) {
            typeInfo.properties = properties.map(property => processProperty(property, checker));
        }
    }
}

/**
 * Collect call signatures from a type
 * @param {ts.Type} type - The TypeScript type
 * @param {ts.TypeChecker} checker - TypeScript type checker
 * @param {Object} typeInfo - Object to store collected info
 */
export function collectCallSignatures(type, checker, typeInfo) {
    if (type.getCallSignatures) {
        const callSignatures = type.getCallSignatures();
        if (callSignatures.length > 0) {
            typeInfo.callSignatures = callSignatures.map(signature => processFunctionType(signature, checker));
        }
    }
}

/**
 * Collect construct signatures from a type
 * @param {ts.Type} type - The TypeScript type
 * @param {ts.TypeChecker} checker - TypeScript type checker
 * @param {Object} typeInfo - Object to store collected info
 */
export function collectConstructSignatures(type, checker, typeInfo) {
    if (type.getConstructSignatures) {
        const constructSignatures = type.getConstructSignatures();
        if (constructSignatures.length > 0) {
            typeInfo.constructSignatures = constructSignatures.map(signature => processFunctionType(signature, checker));
        }
    }
}

/**
 * Collect enum members from a type
 * @param {ts.Type} type - The TypeScript type
 * @param {ts.TypeChecker} checker - TypeScript type checker
 * @param {Object} typeInfo - Object to store collected info
 */
export function collectEnumMembers(type, checker, typeInfo) {
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

/**
 * Collect type alias information
 * @param {ts.Type} type - The TypeScript type
 * @param {ts.TypeChecker} checker - TypeScript type checker
 * @param {Object} typeInfo - Object to store collected info
 */
export function collectTypeAliasInfo(type, checker, typeInfo) {
    if (type.symbol && (type.symbol.flags & ts.SymbolFlags.TypeAlias)) {
        if (type.aliasSymbol && type.aliasTypeArguments) {
            typeInfo.aliasTo = {
                name: type.aliasSymbol.name,
                typeArguments: type.aliasTypeArguments.map(t => checker.typeToString(t))
            };
        }
    }
}

/**
 * Process property information with function type detection
 * @param {ts.Symbol} property - The property symbol
 * @param {ts.TypeChecker} checker - TypeScript type checker
 * @returns {Object} Processed property info
 */
export function processProperty(property, checker) {
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
                flags: getFlagNames(propType.flags, ts.TypeFlags)
            };
            
            // Check if the property type is a nominal type and add a reference
            if (propType.symbol && propType.symbol.name && propType.symbol.name !== "__type") {
                propInfo.type.isNominal = true;
                propInfo.type.symbolName = propType.symbol.name;
            }
            
            // Check if it's a primitive type
            if (propType.isStringLiteral || propType.isNumberLiteral || propType.isBooleanLiteral) {
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
