import { describe, it, expect } from 'vitest';
import { createTempDTsFile, cleanupTempFile } from '../../helpers.js';
import { createProgram, processTypeDeclarations } from '../../../src/types/processor.js';

describe('Complex Type Processing', () => {
  let tempFilePath;
  
  afterEach(() => {
    if (tempFilePath) {
      cleanupTempFile(tempFilePath);
      tempFilePath = null;
    }
  });
  
  it('should process interface with nested types correctly', () => {
    // Create a temporary file with complex nested types
    const fileContent = `
    interface NestedInterface {
      // Object type with nested properties
      nestedObject: {
        prop1: string;
        prop2: number;
        prop3?: boolean;
      };
      
      // Array type with generic parameter
      stringArray: Array<string>;
      
      // Union type
      unionType: string | number | null;
      
      // Intersection type
      intersectionType: { id: string } & { name: string };
      
      // Generic type
      genericType: Promise<Array<string>>;
      
      // Function type
      callbackFn: (param1: string, param2?: number) => boolean;
    }
    
    export { NestedInterface };
    `;
    
    tempFilePath = createTempDTsFile(fileContent);
    
    // Process the file 
    const program = createProgram(tempFilePath);
    const result = processTypeDeclarations(program);
    
    // Check that we have the interface
    const nestedInterface = result.referencedNominalTypes.find(
      type => type.name === 'NestedInterface'
    );
    
    expect(nestedInterface).toBeDefined();
    expect(nestedInterface.kind).toBe('InterfaceDeclaration');
    expect(nestedInterface.type.properties.length).toBe(6);
    
    // Check the nested object property 
    const nestedObject = nestedInterface.type.properties.find(
      prop => prop.name === 'nestedObject'
    );
    expect(nestedObject).toBeDefined();
    expect(nestedObject.type.name).toBeDefined();
    
    // Check the array type property
    const stringArray = nestedInterface.type.properties.find(
      prop => prop.name === 'stringArray'
    );
    expect(stringArray).toBeDefined();
    expect(stringArray.type.name).toContain('Array');
    
    // Check the function type property
    const callbackFn = nestedInterface.type.properties.find(
      prop => prop.name === 'callbackFn'
    );
    expect(callbackFn).toBeDefined();
    expect(callbackFn.type.functionType).toBeDefined();
    expect(callbackFn.type.functionType.parameters).toHaveLength(2);
    expect(callbackFn.type.functionType.parameters[0].name).toBe('param1');
    expect(callbackFn.type.functionType.parameters[0].type).toBe('string');
    expect(callbackFn.type.functionType.parameters[1].name).toBe('param2');
    expect(callbackFn.type.functionType.parameters[1].optional).toBe(true);
    expect(callbackFn.type.functionType.returnType).toBe('boolean');
  });
  
  it('should process generic interfaces correctly', () => {
    // Create a temporary file with generic interfaces
    const fileContent = `
    interface GenericInterface<T, U = string> {
      data: T;
      metadata: U;
      process<V>(input: T, options?: U): V;
    }
    
    // Specific usage of the generic interface
    interface StringNumberInterface extends GenericInterface<string, number> {
      additionalProp: boolean;
    }
    
    export { GenericInterface, StringNumberInterface };
    `;
    
    tempFilePath = createTempDTsFile(fileContent);
    
    // Process the file 
    const program = createProgram(tempFilePath);
    const result = processTypeDeclarations(program);
    
    // Check that we have both interfaces
    const genericInterface = result.referencedNominalTypes.find(
      type => type.name === 'GenericInterface'
    );
    
    const stringNumberInterface = result.referencedNominalTypes.find(
      type => type.name === 'StringNumberInterface'
    );
    
    expect(genericInterface).toBeDefined();
    expect(genericInterface.kind).toBe('InterfaceDeclaration');
    
    expect(stringNumberInterface).toBeDefined();
    expect(stringNumberInterface.kind).toBe('InterfaceDeclaration');
    
    // Check that the extending interface has properties from both
    expect(stringNumberInterface.type.properties.length).toBe(4);
    
    // Check that we have the additional property
    const additionalProp = stringNumberInterface.type.properties.find(
      prop => prop.name === 'additionalProp'
    );
    expect(additionalProp).toBeDefined();
    expect(additionalProp.type.name).toBe('boolean');
    
    // Check that we have the process method
    const processMethod = stringNumberInterface.type.properties.find(
      prop => prop.name === 'process'
    );
    expect(processMethod).toBeDefined();
    expect(processMethod.type.functionType).toBeDefined();
  });
  
  it('should process indexed access types correctly', () => {
    // Create a temporary file with indexed access types
    const fileContent = `
    interface Person {
      name: string;
      age: number;
      address: {
        street: string;
        city: string;
        zip: string;
      };
    }
    
    type Name = Person['name']; // string
    type Address = Person['address']; // { street: string; city: string; zip: string; }
    type AddressProp = Person['address']['street']; // string
    
    export { Person, Name, Address, AddressProp };
    `;
    
    tempFilePath = createTempDTsFile(fileContent);
    
    // Process the file 
    const program = createProgram(tempFilePath);
    const result = processTypeDeclarations(program);
    
    // Check that we have the interface and type aliases
    const person = result.referencedNominalTypes.find(
      type => type.name === 'Person'
    );
    
    const nameType = result.referencedNominalTypes.find(
      type => type.name === 'Name'
    );
    
    const addressType = result.referencedNominalTypes.find(
      type => type.name === 'Address'
    );
    
    expect(person).toBeDefined();
    expect(person.kind).toBe('InterfaceDeclaration');
    
    expect(nameType).toBeDefined();
    expect(nameType.kind).toBe('TypeAliasDeclaration');
    
    expect(addressType).toBeDefined();
    expect(addressType.kind).toBe('TypeAliasDeclaration');
  });
}); 
