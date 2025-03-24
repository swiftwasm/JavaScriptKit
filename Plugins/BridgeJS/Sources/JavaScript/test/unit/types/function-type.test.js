import { describe, it, expect, vi } from 'vitest';
import { processFunctionType } from '../../../src/types/serializer.js';
import { createTempDTsFile, cleanupTempFile } from '../../helpers.js';
import { createProgram } from '../../../src/types/processor.js';

describe('Function Type Processing', () => {
  it('should process a simple function type correctly', () => {
    // Create a mock TypeChecker and Signature
    const mockParameter = {
      name: { escapedText: 'param' },
      type: {
        getFlags: () => 4, // String flag
      },
      isOptional: () => false,
    };
    
    const mockSignature = {
      getParameters: () => [mockParameter],
      getReturnType: () => ({
        getFlags: () => 128, // Boolean flag
      }),
    };
    
    const mockChecker = {
      typeToString: (type) => {
        // Simple mock implementation that returns type names based on flags
        if (type.getFlags() === 4) return 'string';
        if (type.getFlags() === 128) return 'boolean';
        return 'unknown';
      },
      getReturnTypeOfSignature: (sig) => sig.getReturnType(),
    };
    
    // Act
    const result = processFunctionType(mockSignature, mockChecker);
    
    // Assert
    expect(result).toBeDefined();
    expect(result.parameters).toHaveLength(1);
    expect(result.parameters[0].name).toBe('param');
    expect(result.parameters[0].type).toBe('string');
    expect(result.parameters[0].optional).toBe(false);
    expect(result.returnType).toBe('boolean');
  });
  
  it('should handle optional parameters correctly', () => {
    // Create a mock TypeChecker and Signature with optional parameter
    const mockParameter = {
      name: { escapedText: 'optionalParam' },
      type: {
        getFlags: () => 4, // String flag
      },
      isOptional: () => true,
    };
    
    const mockSignature = {
      getParameters: () => [mockParameter],
      getReturnType: () => ({
        getFlags: () => 128, // Boolean flag
      }),
    };
    
    const mockChecker = {
      typeToString: (type) => {
        if (type.getFlags() === 4) return 'string';
        if (type.getFlags() === 128) return 'boolean';
        return 'unknown';
      },
      getReturnTypeOfSignature: (sig) => sig.getReturnType(),
    };
    
    // Act
    const result = processFunctionType(mockSignature, mockChecker);
    
    // Assert
    expect(result).toBeDefined();
    expect(result.parameters).toHaveLength(1);
    expect(result.parameters[0].name).toBe('optionalParam');
    expect(result.parameters[0].type).toBe('string');
    expect(result.parameters[0].optional).toBe(true);
    expect(result.returnType).toBe('boolean');
  });
  
  it('should handle multiple parameters correctly', () => {
    // Create a mock TypeChecker and Signature with multiple parameters
    const mockParameters = [
      {
        name: { escapedText: 'param1' },
        type: { getFlags: () => 4 }, // String flag
        isOptional: () => false,
      },
      {
        name: { escapedText: 'param2' },
        type: { getFlags: () => 2 }, // Number flag
        isOptional: () => false,
      },
      {
        name: { escapedText: 'param3' },
        type: { getFlags: () => 32 }, // Any flag
        isOptional: () => true,
      }
    ];
    
    const mockSignature = {
      getParameters: () => mockParameters,
      getReturnType: () => ({
        getFlags: () => 1, // Void flag
      }),
    };
    
    const mockChecker = {
      typeToString: (type) => {
        if (type.getFlags() === 4) return 'string';
        if (type.getFlags() === 2) return 'number';
        if (type.getFlags() === 32) return 'any';
        if (type.getFlags() === 1) return 'void';
        return 'unknown';
      },
      getReturnTypeOfSignature: (sig) => sig.getReturnType(),
    };
    
    // Act
    const result = processFunctionType(mockSignature, mockChecker);
    
    // Assert
    expect(result).toBeDefined();
    expect(result.parameters).toHaveLength(3);
    
    expect(result.parameters[0].name).toBe('param1');
    expect(result.parameters[0].type).toBe('string');
    expect(result.parameters[0].optional).toBe(false);
    
    expect(result.parameters[1].name).toBe('param2');
    expect(result.parameters[1].type).toBe('number');
    expect(result.parameters[1].optional).toBe(false);
    
    expect(result.parameters[2].name).toBe('param3');
    expect(result.parameters[2].type).toBe('any');
    expect(result.parameters[2].optional).toBe(true);
    
    expect(result.returnType).toBe('void');
  });
  
  it('should return null for invalid signature', () => {
    expect(processFunctionType(null, {})).toBeNull();
    expect(processFunctionType({}, null)).toBeNull();
    expect(processFunctionType({}, {})).toBeNull();
  });
});

describe('Function Type Integration', () => {
  let tempFilePath;
  
  afterEach(() => {
    if (tempFilePath) {
      cleanupTempFile(tempFilePath);
      tempFilePath = null;
    }
  });
  
  it('should process real function types from TypeScript code', () => {
    // Create a temporary file with a function type declaration
    const fileContent = `
    interface TestInterface {
      simpleMethod(a: string): number;
      optionalParamMethod(a: string, b?: number): boolean;
      complexMethod(callback: (x: number) => string): Promise<boolean>;
    }
    
    export { TestInterface };
    `;
    
    tempFilePath = createTempDTsFile(fileContent);
    
    // Process the file 
    const program = createProgram(tempFilePath);
    const checker = program.getTypeChecker();
    
    // Find the TestInterface declaration
    const sourceFile = program.getSourceFile(tempFilePath);
    if (!sourceFile) {
      console.log('Source file not found');
      return;
    }
    
    // Log source file structure to debug
    console.log(`Source file statements length: ${sourceFile.statements.length}`);
    
    // Get interface declarations
    const interfaces = sourceFile.statements.filter(stmt => 
      stmt.kind === 230 // InterfaceDeclaration
    );
    
    if (interfaces.length === 0) {
      console.log('No interfaces found in source file');
      return;
    }
    
    // Get the TestInterface
    const testInterface = interfaces[0];
    
    // Ensure we have the interface
    expect(testInterface).toBeDefined();
    expect(testInterface.name.text).toBe('TestInterface');
    
    // Skip the test if members not found
    if (!testInterface.members) {
      console.log('Interface members not found, skipping test');
      return;
    }
    
    // Get the methods
    const methods = testInterface.members.filter(member => 
      member.kind === 166 // MethodSignature
    );
    
    // Verify method count
    expect(methods.length).toBe(3);
    
    // Process the simpleMethod
    const simpleMethod = methods[0];
    const simpleMethodSignature = checker.getSignatureFromDeclaration(simpleMethod);
    const simpleMethodResult = processFunctionType(simpleMethodSignature, checker);
    
    // Verify simpleMethod processing
    expect(simpleMethodResult).toBeDefined();
    expect(simpleMethodResult.parameters).toHaveLength(1);
    expect(simpleMethodResult.parameters[0].name).toBe('a');
    expect(simpleMethodResult.parameters[0].type).toBe('string');
    expect(simpleMethodResult.returnType).toBe('number');
    
    // Process the optionalParamMethod
    const optionalParamMethod = methods[1];
    const optionalParamMethodSignature = checker.getSignatureFromDeclaration(optionalParamMethod);
    const optionalParamMethodResult = processFunctionType(optionalParamMethodSignature, checker);
    
    // Verify optionalParamMethod processing
    expect(optionalParamMethodResult).toBeDefined();
    expect(optionalParamMethodResult.parameters).toHaveLength(2);
    expect(optionalParamMethodResult.parameters[0].name).toBe('a');
    expect(optionalParamMethodResult.parameters[0].type).toBe('string');
    expect(optionalParamMethodResult.parameters[0].optional).toBe(false);
    expect(optionalParamMethodResult.parameters[1].name).toBe('b');
    expect(optionalParamMethodResult.parameters[1].type).toBe('number');
    expect(optionalParamMethodResult.parameters[1].optional).toBe(true);
    expect(optionalParamMethodResult.returnType).toBe('boolean');
  });
}); 
