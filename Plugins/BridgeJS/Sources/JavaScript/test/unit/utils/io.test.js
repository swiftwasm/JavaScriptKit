import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest';
import { writeResults } from '../../../src/utils/io.js';

describe('IO Utilities', () => {
  const testResults = { 
    declarations: [],
    referencedNominalTypes: []
  };
  const testJson = JSON.stringify(testResults, null, 2);
  
  it('should write results to a file when outputPath is provided', () => {
    // Arrange
    const outputPath = 'test-output.json';
    const mockFs = {
      writeFileSync: vi.fn()
    };
    const mockConsole = {
      log: vi.fn(),
      error: vi.fn()
    };
    
    // Act
    const result = writeResults(testResults, outputPath, { fs: mockFs, console: mockConsole });
    
    // Assert
    expect(result).toBe(true);
    expect(mockFs.writeFileSync).toHaveBeenCalledWith(outputPath, testJson);
    expect(mockConsole.log).toHaveBeenCalledWith(`Results written to ${outputPath}`);
  });
  
  it('should output to console when no outputPath is provided', () => {
    // Arrange
    const mockFs = {
      writeFileSync: vi.fn()
    };
    const mockConsole = {
      log: vi.fn(),
      error: vi.fn()
    };
    
    // Act
    const result = writeResults(testResults, null, { fs: mockFs, console: mockConsole });
    
    // Assert
    expect(result).toBe(true);
    expect(mockConsole.log).toHaveBeenCalledWith(testJson);
    expect(mockFs.writeFileSync).not.toHaveBeenCalled();
  });
  
  it('should return false and log error when file writing fails', () => {
    // Arrange
    const outputPath = 'test-output.json';
    const errorMessage = 'Failed to write file';
    const mockFs = {
      writeFileSync: vi.fn(() => {
        throw new Error(errorMessage);
      })
    };
    const mockConsole = {
      log: vi.fn(),
      error: vi.fn()
    };
    
    // Act
    const result = writeResults(testResults, outputPath, { fs: mockFs, console: mockConsole });
    
    // Assert
    expect(result).toBe(false);
    expect(mockConsole.error).toHaveBeenCalledWith(`Error writing to output file: ${errorMessage}`);
  });
}); 
