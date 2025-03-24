import { describe, it, expect, vi } from 'vitest';
import * as fs from 'fs';
import * as path from 'path';
import { createProgram, processTypeDeclarations } from '../../src/types/processor.js';

describe('Examples Integration Test', () => {
  // Mock fs.existsSync to return true for our test file
  vi.mock('fs', async () => {
    const actual = await vi.importActual('fs');
    return {
      ...actual,
      existsSync: (path) => true,
    };
  });
  
  it('should process the chroma-js example file', async () => {
    // Create a temporary TypeScript definition file based on the example
    const exampleDTs = `
    // Typings for chroma-js library
    declare module 'chroma-js' {
      interface ChromaStatic {
        (color: string): Color;
        valid(color: string): boolean;
      }
      
      interface Color {
        darken(): Color;
        brighten(): Color;
        hex(): string;
      }
      
      const chroma: ChromaStatic;
      export default chroma;
    }
    
    declare interface Document {
      getElementById(id: string): HTMLElement | null;
      body: HTMLElement;
    }
    
    declare interface HTMLElement {
      style: {
        backgroundColor: string;
      };
    }
    `;
    
    // Write temp file
    const tempFilePath = path.resolve('./test/temp/example.d.ts');
    
    // Ensure the directory exists
    const tempDir = path.dirname(tempFilePath);
    if (!fs.existsSync(tempDir)) {
      fs.mkdirSync(tempDir, { recursive: true });
    }
    
    try {
      fs.writeFileSync(tempFilePath, exampleDTs);
      
      // Process the file
      const program = createProgram(tempFilePath);
      const result = processTypeDeclarations(program);
      
      // Check for common structures and patterns
      expect(result).toBeDefined();
      
      // Basic output structure
      expect(result).toHaveProperty('referencedNominalTypes');
      expect(Array.isArray(result.referencedNominalTypes)).toBe(true);
      
      // Look for the chroma module
      const moduleTypes = result.referencedNominalTypes.filter(
        type => type.kind === 'ModuleDeclaration'
      );
      expect(moduleTypes.length).toBeGreaterThan(0);
      
      // Note: For this test to pass, the full implementation needs to be completed.
      // The test validates the basic structure, not the details of the output.
      
    } finally {
      // Clean up - remove the temp file
      if (fs.existsSync(tempFilePath)) {
        fs.unlinkSync(tempFilePath);
      }
    }
  });
}); 
