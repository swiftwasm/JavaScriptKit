import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest';
import fs from 'fs';
import * as processor from '../../src/types/processor.js';
import * as io from '../../src/utils/io.js';
import { main } from '../../src/cli.js';
import { resolveFixturePath } from '../helpers.js';

// Mock dependencies
vi.mock('fs', () => ({
  existsSync: vi.fn()
}));

vi.mock('../../src/types/processor.js', () => ({
  createProgram: vi.fn(),
  processTypeDeclarations: vi.fn()
}));

vi.mock('../../src/utils/io.js', () => ({
  writeResults: vi.fn()
}));

describe('CLI module', () => {
  // Spies for console.log/error and process.exit
  let consoleLogSpy;
  let consoleErrorSpy;
  let processExitSpy;
  
  // Save original argv
  const originalArgv = process.argv;
  
  beforeEach(() => {
    // Mock console and process
    consoleLogSpy = vi.spyOn(console, 'log').mockImplementation(() => {});
    consoleErrorSpy = vi.spyOn(console, 'error').mockImplementation(() => {});
    processExitSpy = vi.spyOn(process, 'exit').mockImplementation(() => {});
    
    // Reset all mocks
    vi.clearAllMocks();
  });
  
  afterEach(() => {
    // Restore mocks
    consoleLogSpy.mockRestore();
    consoleErrorSpy.mockRestore();
    processExitSpy.mockRestore();
    
    // Restore argv
    process.argv = originalArgv;
  });
  
  describe('main function', () => {
    it('should process a file and write results', async () => {
      // Setup mocks
      const inputFile = resolveFixturePath('simple.d.ts');
      const outputFile = 'output.json';
      process.argv = ['node', 'ts2swift', inputFile, '-o', outputFile];
      
      fs.existsSync.mockReturnValue(true);
      
      const mockProgram = { /* mock program */ };
      processor.createProgram.mockReturnValue(mockProgram);
      
      const mockResults = { data: 'test results' };
      processor.processTypeDeclarations.mockReturnValue(mockResults);
      
      io.writeResults.mockReturnValue(true);
      
      // Run the function
      await main();
      
      // Verify results
      expect(fs.existsSync).toHaveBeenCalledWith(inputFile);
      expect(processor.createProgram).toHaveBeenCalledWith(inputFile);
      expect(processor.processTypeDeclarations).toHaveBeenCalledWith(mockProgram, inputFile);
      expect(io.writeResults).toHaveBeenCalledWith(mockResults, outputFile);
      expect(consoleLogSpy).toHaveBeenCalledWith(`Processing ${inputFile}...`);
      expect(processExitSpy).not.toHaveBeenCalled();
    });
    
    it('should exit when file not found', async () => {
      // Setup mocks
      const inputFile = 'not-existing-file.d.ts';
      process.argv = ['node', 'ts2swift', inputFile];
      
      fs.existsSync.mockReturnValue(false);
      
      // Run the function
      await main();
      
      // Verify results
      expect(fs.existsSync).toHaveBeenCalledWith(inputFile);
      expect(consoleErrorSpy).toHaveBeenCalledWith(`File not found: ${inputFile}`);
      expect(processExitSpy).toHaveBeenCalledWith(1);
    });
    
    it('should exit when no input file provided', async () => {
      // Setup mocks
      process.argv = ['node', 'ts2swift'];
      
      // Run the function
      await main();
      
      // Verify results
      expect(consoleErrorSpy).toHaveBeenCalledWith('Usage: ts2swift <d.ts file path> [-o output.json]');
      expect(processExitSpy).toHaveBeenCalledWith(1);
    });
    
    it('should exit when write fails', async () => {
      // Setup mocks
      const inputFile = resolveFixturePath('simple.d.ts');
      const outputFile = 'output.json';
      process.argv = ['node', 'ts2swift', inputFile, '-o', outputFile];
      
      fs.existsSync.mockReturnValue(true);
      
      const mockProgram = { /* mock program */ };
      processor.createProgram.mockReturnValue(mockProgram);
      
      const mockResults = { data: 'test results' };
      processor.processTypeDeclarations.mockReturnValue(mockResults);
      
      io.writeResults.mockReturnValue(false);
      
      // Run the function
      await main();
      
      // Verify results
      expect(io.writeResults).toHaveBeenCalledWith(mockResults, outputFile);
      expect(processExitSpy).toHaveBeenCalledWith(1);
    });
  });
}); 
