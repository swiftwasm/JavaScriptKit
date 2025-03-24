/**
 * File I/O utilities
 * @module utils/io
 */

import * as fs from 'fs';

/**
 * Write results to file or stdout
 * @param {Object} results - The results to write
 * @param {string} outputPath - The file path to write to (optional)
 * @param {Object} deps - Dependencies (optional)
 * @param {Object} deps.fs - File system module
 * @param {Object} deps.console - Console object
 * @returns {boolean} True if successful, false otherwise
 */
export function writeResults(results, outputPath, deps = { fs, console }) {
    // Convert results to JSON
    const jsonOutput = JSON.stringify(results, null, 2);
    
    // Output the results either to a file or stdout
    if (outputPath) {
        try {
            deps.fs.writeFileSync(outputPath, jsonOutput);
            deps.console.log(`Results written to ${outputPath}`);
            return true;
        } catch (error) {
            deps.console.error(`Error writing to output file: ${error.message}`);
            return false;
        }
    } else {
        // Output to stdout
        deps.console.log(jsonOutput);
        return true;
    }
} 
