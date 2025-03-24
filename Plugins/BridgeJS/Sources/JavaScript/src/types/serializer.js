/**
 * Type serialization functionality
 * @module types/serializer
 */

// @ts-check
import ts from 'typescript';
import { getFlagNames, getTypeId, isNominalType, isPrimitiveType } from './utils.js';
import { collectNominalTypeInfo } from './collector.js';

/**
 * Process the function type information
 * @param {ts.Signature} signature - TypeScript function signature
 * @param {ts.TypeChecker} checker - TypeScript type checker
 * @returns {Object} Structured function type information
 */
export function processFunctionType(signature, checker) {
    if (!signature || !checker) return null;
    if (!signature.parameters && !signature.getParameters) return null;
    
    // Handle different ways parameters might be accessed in the signature
    let parameters = [];
    if (typeof signature.getParameters === 'function') {
        parameters = signature.getParameters();
    } else if (Array.isArray(signature.parameters)) {
        parameters = signature.parameters;
    }
    
    // Return information about the parameters and return type
    return {
        parameters: parameters.map(p => {
            // Handle potentially missing properties safely
            const name = p.name ? (typeof p.name === 'string' ? p.name : 
                      (p.name.escapedText ? p.name.escapedText : 'param')) : 'param';
            
            let type = 'any';
            try {
                if (p.valueDeclaration) {
                    type = checker.typeToString(checker.getTypeOfSymbolAtLocation(p, p.valueDeclaration));
                } else if (p.type && p.type.getFlags) {
                    // Support for mock types used in tests
                    type = checker.typeToString(p.type);
                }
            } catch (error) {
                // In case of errors, default to 'any'
                type = 'any';
            }
            
            // Check different ways a parameter might be marked as optional
            let optional = false;
            if (p.valueDeclaration && p.valueDeclaration.questionToken) {
                optional = true;
            } else if (typeof p.isOptional === 'function') {
                optional = p.isOptional();
            }
            
            return { name, type, optional };
        }),
        returnType: signature.getReturnType ? 
                    checker.typeToString(signature.getReturnType()) : 
                    'any'
    };
}

/**
 * Serialize a function or method signature
 * @param {ts.Signature} signature - TypeScript function signature
 * @param {ts.TypeChecker} checker - TypeScript type checker 
 * @param {Map} typeCache - Cache for type information
 * @param {Map} nominalTypesMap - Map of nominal types
 * @param {number} depth - Current recursion depth
 * @returns {Object} Serialized signature
 */
export function serializeSignature(signature, checker, typeCache, nominalTypesMap, depth = 0) {
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

/**
 * Serialize a TypeScript type into a descriptive object
 * @param {ts.Type} type - TypeScript type to serialize
 * @param {ts.TypeChecker} checker - TypeScript type checker
 * @param {Map} typeCache - Cache for type information
 * @param {Map} nominalTypesMap - Map of nominal types
 * @param {number} depth - Current recursion depth
 * @returns {Object} Serialized type
 */
export function serializeType(type, checker, typeCache, nominalTypesMap, depth = 0) {
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
            flags: getFlagNames(type.flags, ts.TypeFlags)
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
            flags: getFlagNames(type.flags, ts.TypeFlags),
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

/**
 * Handle serialization of special type kinds (union, intersection, etc.)
 * @param {ts.Type} type - TypeScript type
 * @param {ts.TypeChecker} checker - TypeScript type checker
 * @param {Map} typeCache - Cache for type information
 * @param {Map} nominalTypesMap - Map of nominal types
 * @param {number} depth - Current recursion depth
 * @param {Object} result - Object to store serialized info
 */
export function serializeTypeKinds(type, checker, typeCache, nominalTypesMap, depth, result) {
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
            const properties = type.getProperties();
            result.properties = properties.map(p => {
                try {
                    // Get basic property info
                    const propInfo = {
                        name: p.name,
                        flags: getFlagNames(p.flags, ts.SymbolFlags),
                    };
                    
                    // Get type info if valueDeclaration is available
                    if (p.valueDeclaration) {
                        try {
                            const propType = checker.getTypeOfSymbolAtLocation(p, p.valueDeclaration);
                            
                            // Set property type info
                            propInfo.type = serializeType(propType, checker, typeCache, nominalTypesMap, depth + 1);
                            
                            // Check if optional
                            if (p.valueDeclaration.questionToken) {
                                propInfo.optional = true;
                            } else {
                                propInfo.optional = false;
                            }
                            
                            // Handle function types (methods)
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
                    } else {
                        propInfo.type = { kind: "unknown" };
                        propInfo.optional = false;
                    }
                    
                    return propInfo;
                } catch (error) {
                    return {
                        name: p.name || "unknown",
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
