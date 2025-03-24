import * as path from 'path';
import { fileURLToPath } from 'url';
import { createProgram, processTypeDeclarations } from '../src/types/processor.js';
import * as fs from 'fs';

// Get the directory name of the current module
const __dirname = path.dirname(fileURLToPath(import.meta.url));

/**
 * Helper function to resolve test fixture path
 * @param {string} fixtureName - Name of the fixture file
 * @returns {string} Absolute path to the fixture file
 */
export function resolveFixturePath(fixtureName) {
  return path.resolve(__dirname, 'fixtures', fixtureName);
}

/**
 * Helper function to process a test fixture file
 * @param {string} fixtureName - Name of the fixture file
 * @returns {Object} Processed type declarations
 */
export function processFixture(fixtureName) {
  const filePath = resolveFixturePath(fixtureName);
  const program = createProgram(filePath);
  return processTypeDeclarations(program, filePath);
}

/**
 * Helper function to find a type in the results by name
 * @param {Object} results - Processed type declarations
 * @param {string} typeName - Name of the type to find
 * @returns {Object|undefined} The type object or undefined if not found
 */
export function findTypeByName(results, typeName) {
  // Check in referenced nominal types
  if (results.referencedNominalTypes) {
    const foundType = results.referencedNominalTypes.find(type => type.name === typeName);
    if (foundType) return foundType;
  }

  // Check in each source file's declarations
  for (const fileName in results) {
    if (typeof results[fileName] === 'object' && results[fileName].declarations) {
      const foundType = results[fileName].declarations.find(decl => decl.name === typeName);
      if (foundType) return foundType;
    }
  }

  return undefined;
}

/**
 * Helper function to find a property in a type by name
 * @param {Object} type - Type object
 * @param {string} propertyName - Name of the property to find
 * @returns {Object|undefined} The property object or undefined if not found
 */
export function findPropertyByName(type, propertyName) {
  if (type && type.type && type.type.properties) {
    return type.type.properties.find(prop => prop.name === propertyName);
  }
  return undefined;
}

/**
 * Create a temporary TypeScript definition file with the given content
 * @param {string} content - The content of the definition file
 * @returns {string} The path to the created file
 */
export function createTempDTsFile(content) {
  const tempDir = path.resolve(__dirname, 'temp');
  
  // Ensure temp directory exists
  if (!fs.existsSync(tempDir)) {
    fs.mkdirSync(tempDir, { recursive: true });
  }
  
  const tempFile = path.resolve(tempDir, `temp-${Date.now()}.d.ts`);
  fs.writeFileSync(tempFile, content);
  
  return tempFile;
}

/**
 * Clean up a temporary file
 * @param {string} filePath - The path to the file to clean up
 */
export function cleanupTempFile(filePath) {
  if (fs.existsSync(filePath)) {
    fs.unlinkSync(filePath);
  }
} 
