/**
 * TypeScript type utilities
 * @module types/utils
 */

import ts from 'typescript';

/**
 * Get flag names from a bit flag value
 * @param {number} flags - The bit flags
 * @param {Object} flagsEnum - The enum with flag definitions
 * @returns {string[]} Array of flag names
 */
export function getFlagNames(flags, flagsEnum) {
    const result = [];
    for (const flag in flagsEnum) {
        if (typeof flagsEnum[flag] === 'number' && (flags & flagsEnum[flag]) !== 0) {
            result.push(flag);
        }
    }
    return result;
}

/**
 * Get type flags as string array
 * @param {ts.Type} type - The TypeScript type
 * @returns {string[]} Array of type flag names
 */
export function getTypeFlags(type) {
    return getFlagNames(type.flags, ts.TypeFlags);
}

/**
 * Get type ID 
 * @param {ts.Type} type - The TypeScript type
 * @returns {number} The type ID
 */
export function getTypeId(type) {
    return type.id;
}

/**
 * Check if a type is a primitive type
 * @param {ts.Type} type - The TypeScript type to check
 * @returns {boolean} True if the type is a primitive
 */
export function isPrimitiveType(type) {
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

/**
 * Check if a type is a nominal type (named type)
 * @param {ts.Type} type - The TypeScript type to check
 * @returns {boolean} True if the type is nominal (has a name)
 */
export function isNominalType(type) {
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
