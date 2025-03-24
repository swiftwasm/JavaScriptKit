import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest';
import { writeResults } from '../../../src/utils/io.js';
import * as fs from 'fs';
import * as path from 'path';

// Mock the fs module
vi.mock('fs', () => ({
  writeFileSync: vi.fn(),
  existsSync: vi.fn(),
}));

describe('IO Utilities', () => {
  const testResults = { 
    declarations: [],
    referencedNominalTypes: []
  };
  const testJson = JSON.stringify(testResults, null, 2);
  
  // Spy on console.log and console.error
  beforeEach(() => {
    vi.spyOn(console, 'log').mockImplementation(() => {});
    vi.spyOn(console, 'error').mockImplementation(() => {});
  });
  
  afterEach(() => {
    vi.restoreAllMocks();
  });
  
  it('should write results to a file when outputPath is provided', () => {
    // Arrange
    const outputPath = 'test-output.json';
    fs.writeFileSync.mockImplementation(() => {});
    
    // Act
    const result = writeResults(testResults, outputPath);
    
    // Assert
    expect(result).toBe(true);
    expect(fs.writeFileSync).toHaveBeenCalledWith(outputPath, testJson);
    expect(console.log).toHaveBeenCalledWith(`Results written to ${outputPath}`);
  });
  
  it('should output to console when no outputPath is provided', () => {
    // Act
    const result = writeResults(testResults);
    
    // Assert
    expect(result).toBe(true);
    expect(console.log).toHaveBeenCalledWith(testJson);
    expect(fs.writeFileSync).not.toHaveBeenCalled();
  });
  
  it('should return false and log error when file writing fails', () => {
    // Arrange
    const outputPath = 'test-output.json';
    const errorMessage = 'Failed to write file';
    fs.writeFileSync.mockImplementation(() => {
      throw new Error(errorMessage);
    });
    
    // Act
    const result = writeResults(testResults, outputPath);
    
    // Assert
    expect(result).toBe(false);
    expect(console.error).toHaveBeenCalledWith(`Error writing to output file: ${errorMessage}`);
  });
}); 
