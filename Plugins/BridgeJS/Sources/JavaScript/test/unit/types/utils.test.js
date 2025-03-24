import { describe, it, expect, vi } from 'vitest';
import ts from 'typescript';
import { getFlagNames, getTypeFlags, isPrimitiveType, isNominalType } from '../../../src/types/utils.js';

describe('Type utilities', () => {
  describe('getFlagNames', () => {
    it('should return an array of flag names', () => {
      // Mock flags enum
      const mockEnum = {
        Flag1: 1,
        Flag2: 2,
        Flag4: 4,
        NotAFlag: 'string',
        AnotherNotFlag: () => {}
      };
      
      // Test with various flag combinations
      expect(getFlagNames(0, mockEnum)).toEqual([]);
      expect(getFlagNames(1, mockEnum)).toEqual(['Flag1']);
      expect(getFlagNames(3, mockEnum)).toEqual(['Flag1', 'Flag2']);
      expect(getFlagNames(7, mockEnum)).toEqual(['Flag1', 'Flag2', 'Flag4']);
    });
  });

  describe('isPrimitiveType', () => {
    it('should return true for primitive types', () => {
      // Create mocks for primitive types
      const mockStringType = { flags: ts.TypeFlags.String };
      const mockNumberType = { flags: ts.TypeFlags.Number };
      const mockBooleanType = { flags: ts.TypeFlags.Boolean };
      
      expect(isPrimitiveType(mockStringType)).toBe(true);
      expect(isPrimitiveType(mockNumberType)).toBe(true);
      expect(isPrimitiveType(mockBooleanType)).toBe(true);
    });
    
    it('should return false for non-primitive types', () => {
      // Create mocks for non-primitive types
      const mockObjectType = { flags: ts.TypeFlags.Object };
      const mockUnionType = { flags: ts.TypeFlags.Union };
      
      expect(isPrimitiveType(mockObjectType)).toBe(false);
      expect(isPrimitiveType(mockUnionType)).toBe(false);
    });
  });

  describe('isNominalType', () => {
    it('should return true for nominal types', () => {
      // Create mocks for nominal types
      const mockClassType = { 
        symbol: { 
          name: 'TestClass', 
          flags: ts.SymbolFlags.Class 
        } 
      };
      
      const mockInterfaceType = { 
        symbol: { 
          name: 'TestInterface', 
          flags: ts.SymbolFlags.Interface 
        } 
      };
      
      expect(isNominalType(mockClassType)).toBe(true);
      expect(isNominalType(mockInterfaceType)).toBe(true);
    });
    
    it('should return false for non-nominal types', () => {
      // Create mocks for non-nominal types
      const mockNonNominalType = { symbol: { name: '__type', flags: ts.SymbolFlags.TypeLiteral } };
      const mockNoSymbolType = {};
      
      expect(isNominalType(mockNonNominalType)).toBe(false);
      expect(isNominalType(mockNoSymbolType)).toBe(false);
    });
  });
}); 
