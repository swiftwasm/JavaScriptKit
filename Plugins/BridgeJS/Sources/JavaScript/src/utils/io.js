/**
 * File I/O utilities
 * @module utils/io
 */

import * as fs from 'fs';

/**
 * Write results to file or stdout
 * @param {Object} results - The results to write
 * @param {string} outputPath - The file path to write to (optional)
 * @returns {boolean} True if successful, false otherwise
 */
export function writeResults(results, outputPath) {
    // Convert results to JSON
    const jsonOutput = JSON.stringify(results, null, 2);
    
    // Output the results either to a file or stdout
    if (outputPath) {
        try {
            fs.writeFileSync(outputPath, jsonOutput);
            console.log(`Results written to ${outputPath}`);
            return true;
        } catch (error) {
            console.error(`Error writing to output file: ${error.message}`);
            return false;
        }
    } else {
        // Output to stdout
        console.log(jsonOutput);
        return true;
    }
} 
