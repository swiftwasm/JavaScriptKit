import { describe, it, expect, vi } from 'vitest';
import { main, parseCommandLineArgs } from '../../src/cli.js';

describe('CLI Module', () => {
  it('should process a file and write results', async () => {
    // Arrange
    const inputFile = 'input.d.ts';
    const outputFile = 'output.json';
    const args = [inputFile, '-o', outputFile];
    
    const mockResults = {
      referencedNominalTypes: [],
      declarations: []
    };
    
    const mockDeps = {
      fs: {
        existsSync: vi.fn().mockReturnValue(true)
      },
      console: {
        log: vi.fn(),
        error: vi.fn()
      },
      process: {
        exit: vi.fn()
      },
      processor: {
        createProgram: vi.fn().mockReturnValue('mock-program'),
        processTypeDeclarations: vi.fn().mockReturnValue(mockResults)
      },
      io: {
        writeResults: vi.fn().mockReturnValue(true)
      }
    };
    
    // Act
    await main(args, mockDeps);
    
    // Assert
    expect(mockDeps.fs.existsSync).toHaveBeenCalledWith(inputFile);
    expect(mockDeps.processor.createProgram).toHaveBeenCalledWith(inputFile);
    expect(mockDeps.processor.processTypeDeclarations).toHaveBeenCalledWith('mock-program', inputFile);
    expect(mockDeps.io.writeResults).toHaveBeenCalledWith(mockResults, outputFile);
    expect(mockDeps.console.log).toHaveBeenCalledWith(`Processing ${inputFile}...`);
    expect(mockDeps.process.exit).not.toHaveBeenCalled();
  });
  
  it('should exit when file not found', async () => {
    // Arrange
    const inputFile = 'nonexistent.d.ts';
    const args = [inputFile];
    
    const mockDeps = {
      fs: {
        existsSync: vi.fn().mockReturnValue(false)
      },
      console: {
        log: vi.fn(),
        error: vi.fn()
      },
      process: {
        exit: vi.fn()
      }
    };
    
    // Act
    await main(args, mockDeps);
    
    // Assert
    expect(mockDeps.fs.existsSync).toHaveBeenCalledWith(inputFile);
    expect(mockDeps.console.error).toHaveBeenCalledWith(`File not found: ${inputFile}`);
    expect(mockDeps.process.exit).toHaveBeenCalledWith(1);
  });
  
  it('should exit when no input file provided', async () => {
    // Arrange
    const args = [];
    
    const mockDeps = {
      console: {
        log: vi.fn(),
        error: vi.fn()
      },
      process: {
        exit: vi.fn()
      }
    };
    
    // Act
    await main(args, mockDeps);
    
    // Assert
    expect(mockDeps.console.error).toHaveBeenCalledWith('Usage: ts2swift <d.ts file path> [-o output.json]');
    expect(mockDeps.process.exit).toHaveBeenCalledWith(1);
  });
  
  it('should exit when write fails', async () => {
    // Arrange
    const inputFile = 'input.d.ts';
    const outputFile = 'output.json';
    const args = [inputFile, '-o', outputFile];
    
    const mockResults = {
      referencedNominalTypes: [],
      declarations: []
    };
    
    const mockDeps = {
      fs: {
        existsSync: vi.fn().mockReturnValue(true)
      },
      console: {
        log: vi.fn(),
        error: vi.fn()
      },
      process: {
        exit: vi.fn()
      },
      processor: {
        createProgram: vi.fn().mockReturnValue('mock-program'),
        processTypeDeclarations: vi.fn().mockReturnValue(mockResults)
      },
      io: {
        writeResults: vi.fn().mockReturnValue(false)
      }
    };
    
    // Act
    await main(args, mockDeps);
    
    // Assert
    expect(mockDeps.io.writeResults).toHaveBeenCalledWith(mockResults, outputFile);
    expect(mockDeps.process.exit).toHaveBeenCalledWith(1);
  });
  
  describe('parseCommandLineArgs', () => {
    it('should parse command line arguments correctly', () => {
      // Arrange
      const inputFile = 'input.d.ts';
      const outputFile = 'output.json';
      const args = [inputFile, '-o', outputFile];
      
      const mockDeps = {
        fs: {
          existsSync: vi.fn().mockReturnValue(true)
        },
        console: {
          error: vi.fn()
        },
        process: {
          exit: vi.fn()
        }
      };
      
      // Act
      const result = parseCommandLineArgs(args, mockDeps);
      
      // Assert
      expect(result).toEqual({
        filePath: inputFile,
        outputPath: outputFile
      });
      expect(mockDeps.fs.existsSync).toHaveBeenCalledWith(inputFile);
    });
    
    it('should handle missing output file', () => {
      // Arrange
      const inputFile = 'input.d.ts';
      const args = [inputFile];
      
      const mockDeps = {
        fs: {
          existsSync: vi.fn().mockReturnValue(true)
        },
        console: {
          error: vi.fn()
        },
        process: {
          exit: vi.fn()
        }
      };
      
      // Act
      const result = parseCommandLineArgs(args, mockDeps);
      
      // Assert
      expect(result).toEqual({
        filePath: inputFile,
        outputPath: ''
      });
    });
  });
}); 
