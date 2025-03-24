/**
 * Command-line interface for the ts2swift tool
 * @module cli
 */

// @ts-check
import * as fs from 'fs';
import { createProgram, processTypeDeclarations } from './types/processor.js';
import { parseArgs } from 'util';

/**
 * Main function to run the CLI
 * @param {string[]} args - Command-line arguments
 * @returns {void}
 */
export function main(args) {
    // Parse command line arguments
    const options = parseArgs({
        args,
        options: {
            output: {
                type: 'string',
                short: 'o',
            }
        },
        allowPositionals: true
    })

    if (options.positionals.length !== 1) {
        console.error('Usage: ts2swift <d.ts file path> [-o output.json]');
        process.exit(1);
    }

    const filePath = options.positionals[0];

    console.log(`Processing ${filePath}...`);

    // Create TypeScript program and process declarations
    const program = createProgram(filePath);
    const results = processTypeDeclarations(program, filePath);

    // Write results to file or stdout
    const jsonOutput = JSON.stringify(results, null, 2);
    if (options.values.output) {
        fs.writeFileSync(options.values.output, jsonOutput);
    } else {
        process.stdout.write(jsonOutput, "utf-8");
    }
}
