import { describe, it, expect, beforeAll, afterAll } from 'vitest';
import * as fs from 'fs';
import * as path from 'path';
import { fileURLToPath } from 'url';
import { execSync } from 'child_process';
import { resolveFixturePath } from '../helpers.js';

// Get the directory name of the current module
const __dirname = path.dirname(fileURLToPath(import.meta.url));
const rootDir = path.resolve(__dirname, '../../');
const binPath = path.resolve(rootDir, 'bin/ts2swift.js');
const tempOutputPath = path.resolve(rootDir, 'test/temp-output.json');

describe('End-to-End Integration Tests', () => {
  // Clean up before and after tests
  beforeAll(() => {
    // Ensure the script is executable
    try {
      execSync(`chmod +x ${binPath}`);
    } catch (error) {
      console.error(`Error making script executable: ${error.message}`);
    }
    
    // Remove any previous output file
    if (fs.existsSync(tempOutputPath)) {
      fs.unlinkSync(tempOutputPath);
    }
  });
  
  afterAll(() => {
    // Clean up output file
    if (fs.existsSync(tempOutputPath)) {
      fs.unlinkSync(tempOutputPath);
    }
  });
  
  it('should process a d.ts file and generate valid JSON output', () => {
    // Test fixtures
    const inputFile = resolveFixturePath('simple.d.ts');
    
    // Run the command
    const command = `node ${binPath} ${inputFile} -o ${tempOutputPath}`;
    execSync(command);
    
    // Verify output file exists
    expect(fs.existsSync(tempOutputPath)).toBe(true);
    
    // Parse and validate the content
    const outputContent = fs.readFileSync(tempOutputPath, 'utf-8');
    const parsedOutput = JSON.parse(outputContent);
    
    // Check that we have some basic expected structure
    expect(parsedOutput).toHaveProperty('referencedNominalTypes');
    expect(Array.isArray(parsedOutput.referencedNominalTypes)).toBe(true);
    
    // Verify that at least the SimpleInterface is parsed correctly
    const simpleInterface = parsedOutput.referencedNominalTypes.find(
      type => type.name === 'SimpleInterface'
    );
    
    expect(simpleInterface).toBeDefined();
    expect(simpleInterface.kind).toBe('InterfaceDeclaration');
    
    // Check that we have properties with the right information
    expect(simpleInterface.type.properties).toBeDefined();
    expect(simpleInterface.type.properties.length).toBeGreaterThanOrEqual(4); // The 4 properties we defined
    
    // Verify function type handling
    const testMethod = simpleInterface.type.properties.find(prop => prop.name === 'testMethod');
    expect(testMethod).toBeDefined();
    expect(testMethod.type.functionType).toBeDefined();
    expect(testMethod.type.functionType.parameters).toHaveLength(1);
    expect(testMethod.type.functionType.parameters[0].name).toBe('param');
    expect(testMethod.type.functionType.parameters[0].type).toBe('string');
    expect(testMethod.type.functionType.returnType).toBe('boolean');
  });
  
  it('should handle error conditions', () => {
    // Test non-existent file
    const nonExistentFile = 'non-existent-file.d.ts';
    const command = `node ${binPath} ${nonExistentFile} -o ${tempOutputPath} 2>&1 || true`;
    
    const output = execSync(command).toString();
    expect(output).toContain('File not found');
  });
}); 
