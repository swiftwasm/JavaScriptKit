// @ts-check
import { describe, it, expect } from 'vitest';
import * as path from 'path';
import { resolveFixturePath } from '../helpers.js';
import { createProgram, processTypeDeclarations } from '../../src/types/processor.js';

describe('TypeScript Processor Integration Tests', () => {
  it('should process a simple .d.ts file correctly', () => {
    // Arrange
    const inputFile = resolveFixturePath('simple.d.ts');
    
    // Act
    const program = createProgram(inputFile);
    const result = processTypeDeclarations(program, inputFile);
    
    // Assert
    expect(result).toBeDefined();
    expect(result.referencedNominalTypes).toBeDefined();
    expect(Array.isArray(result.referencedNominalTypes)).toBe(true);
    
    // Check SimpleInterface
    const simpleInterface = result.referencedNominalTypes.find(
      type => type.name === 'SimpleInterface'
    );
    
    expect(simpleInterface).toBeDefined();
    expect(simpleInterface.kind).toBe('InterfaceDeclaration');
    expect(simpleInterface.type.properties).toHaveLength(5); // All 5 properties
    
    // Check property structure
    const stringProperty = simpleInterface.type.properties.find(
      prop => prop.name === 'stringProperty'
    );
    expect(stringProperty).toBeDefined();
    expect(stringProperty.type.name).toBe('string');
    
    // Check optional property
    const optionalProperty = simpleInterface.type.properties.find(
      prop => prop.name === 'optionalProperty'
    );
    expect(optionalProperty).toBeDefined();
    expect(optionalProperty.optional).toBe(true);
    
    // Check function type handling
    const testMethod = simpleInterface.type.properties.find(
      prop => prop.name === 'testMethod'
    );
    expect(testMethod).toBeDefined();
    expect(testMethod.type.functionType).toBeDefined();
    expect(testMethod.type.functionType.parameters).toHaveLength(1);
    expect(testMethod.type.functionType.parameters[0].name).toBe('param');
    expect(testMethod.type.functionType.parameters[0].type).toBe('string');
    expect(testMethod.type.functionType.returnType).toBe('boolean');
    
    // Check complex method with optional parameters
    const complexMethod = simpleInterface.type.properties.find(
      prop => prop.name === 'complexMethod'
    );
    expect(complexMethod).toBeDefined();
    expect(complexMethod.type.functionType).toBeDefined();
    expect(complexMethod.type.functionType.parameters).toHaveLength(2);
    expect(complexMethod.type.functionType.parameters[0].name).toBe('requiredParam');
    expect(complexMethod.type.functionType.parameters[0].type).toBe('number');
    expect(complexMethod.type.functionType.parameters[1].name).toBe('optionalParam');
    expect(complexMethod.type.functionType.parameters[1].type).toBe('string');
    expect(complexMethod.type.functionType.parameters[1].optional).toBe(true);
    
    // Check for enum
    const simpleEnum = result.referencedNominalTypes.find(
      type => type.name === 'SimpleEnum'
    );
    expect(simpleEnum).toBeDefined();
    expect(simpleEnum.kind).toBe('EnumDeclaration');
    
    // Check for type alias
    const simpleType = result.referencedNominalTypes.find(
      type => type.name === 'SimpleType'
    );
    expect(simpleType).toBeDefined();
    expect(simpleType.kind).toBe('TypeAliasDeclaration');
  });

  it('should handle empty files correctly', () => {
    // Create a path to a non-existent TypeScript file
    const emptyFile = resolveFixturePath('empty.d.ts');
    
    // We don't need to actually create the file, just process what happens when
    // there's no content to process
    const program = createProgram(emptyFile);
    const result = processTypeDeclarations(program, emptyFile);
    
    // Should still return a valid but empty result
    expect(result).toBeDefined();
    expect(result.referencedNominalTypes).toBeDefined();
    expect(Array.isArray(result.referencedNominalTypes)).toBe(true);
    expect(result.referencedNominalTypes.length).toBe(0);
  });
}); 
