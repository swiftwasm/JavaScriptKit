/**
 * Command-line interface for the ts2swift tool
 * @module cli
 */

import * as fs from 'fs';
import { createProgram, processTypeDeclarations } from './types/processor.js';
import { writeResults } from './utils/io.js';


/**
 * Parse command-line arguments
 * @returns {{filePath: string, outputPath: string}} Object containing the parsed arguments
 */
function parseCommandLineArgs() {
    const args = process.argv.slice(2);
    let filePath = '';
    let outputPath = '';

    for (let i = 0; i < args.length; i++) {
        if (args[i] === '-o' || args[i] === '--output') {
            if (i + 1 < args.length) {
                outputPath = args[i + 1];
                i++; // Skip the next arg since it's the output path
            } else {
                console.error('Error: -o option requires a file path.');
                process.exit(1);
            }
        } else if (!filePath) {
            filePath = args[i];
        }
    }

    if (!filePath) {
        console.error('Usage: ts2swift <d.ts file path> [-o output.json]');
        process.exit(1);
    }

    if (!fs.existsSync(filePath)) {
        console.error(`File not found: ${filePath}`);
        process.exit(1);
    }

    return { filePath, outputPath };
} 

/**
 * Main function that orchestrates the entire process
 * @returns {Promise<void>}
 */
export async function main() {
    // Parse command line arguments
    const { filePath, outputPath } = parseCommandLineArgs();
    
    console.log(`Processing ${filePath}...`);

    // Create TypeScript program and process declarations
    const program = createProgram(filePath);
    const results = processTypeDeclarations(program, filePath);

    // Write results to file or stdout
    const success = writeResults(results, outputPath);
    
    if (!success) {
        process.exit(1);
    }
}
