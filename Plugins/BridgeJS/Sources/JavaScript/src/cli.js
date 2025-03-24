/**
 * Command-line interface for the ts2swift tool
 * @module cli
 */

import * as fs from 'fs';
import { createProgram, processTypeDeclarations } from './types/processor.js';
import { writeResults } from './utils/io.js';

/**
 * Parse command-line arguments
 * @param {string[]} args - Command line arguments
 * @param {Object} deps - Dependencies
 * @param {Object} deps.fs - File system module
 * @param {Function} deps.console.error - Console error function
 * @param {Function} deps.process.exit - Process exit function
 * @returns {{filePath: string, outputPath: string}} Object containing the parsed arguments
 */
export function parseCommandLineArgs(args, deps = { fs, console, process }) {
    if (!args) {
        args = process.argv.slice(2);
    }
    
    let filePath = '';
    let outputPath = '';

    for (let i = 0; i < args.length; i++) {
        if (args[i] === '-o' || args[i] === '--output') {
            if (i + 1 < args.length) {
                outputPath = args[i + 1];
                i++; // Skip the next arg since it's the output path
            } else {
                deps.console.error('Error: -o option requires a file path.');
                deps.process.exit(1);
            }
        } else if (!filePath) {
            filePath = args[i];
        }
    }

    if (!filePath) {
        deps.console.error('Usage: ts2swift <d.ts file path> [-o output.json]');
        deps.process.exit(1);
    }

    if (!deps.fs.existsSync(filePath)) {
        deps.console.error(`File not found: ${filePath}`);
        deps.process.exit(1);
    }

    return { filePath, outputPath };
} 

/**
 * Main function that orchestrates the entire process
 * @param {string[]} args - Command line arguments (optional)
 * @param {Object} deps - Dependencies (optional)
 * @returns {Promise<void>}
 */
export async function main(args, deps = {}) {
    // Setup dependencies with defaults
    const dependencies = {
        fs: deps.fs || fs,
        console: deps.console || console,
        process: deps.process || process,
        processor: deps.processor || { createProgram, processTypeDeclarations },
        io: deps.io || { writeResults }
    };
    
    // Parse command line arguments
    const { filePath, outputPath } = parseCommandLineArgs(args, dependencies);
    
    dependencies.console.log(`Processing ${filePath}...`);

    // Create TypeScript program and process declarations
    const program = dependencies.processor.createProgram(filePath);
    const results = dependencies.processor.processTypeDeclarations(program, filePath);

    // Write results to file or stdout
    const success = dependencies.io.writeResults(results, outputPath);
    
    if (!success) {
        dependencies.process.exit(1);
    }
}
