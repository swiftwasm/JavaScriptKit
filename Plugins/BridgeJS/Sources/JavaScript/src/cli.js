/**
 * Command-line interface for the ts2swift tool
 * @module cli
 */

// @ts-check
import * as fs from 'fs';
import { TypeProcessor } from './processor.js';
import { parseArgs } from 'util';
import ts from 'typescript';
import path from 'path';

class DiagnosticEngine {
    constructor() {
        /** @type {ts.FormatDiagnosticsHost} */
        this.formattHost = {
            getCanonicalFileName: (fileName) => fileName,
            getNewLine: () => ts.sys.newLine,
            getCurrentDirectory: () => ts.sys.getCurrentDirectory(),
        };
    }
    
    /**
     * @param {readonly ts.Diagnostic[]} diagnostics
     */
    tsDiagnose(diagnostics) {
        const message = ts.formatDiagnosticsWithColorAndContext(diagnostics, this.formattHost);
        console.log(message);
    }

    /**
     * @param {string} message
     */
    warn(message) {
        console.warn(message);
    }

    /**
     * @param {string} message
     */
    error(message) {
        console.error(message);
    }
}

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
            },
            project: {
                type: 'string',
                short: 'p',
            }
        },
        allowPositionals: true
    })

    if (options.positionals.length !== 1) {
        console.error('Usage: ts2swift <d.ts file path> [-o output.json]');
        process.exit(1);
    }

    const tsconfigPath = options.values.project;
    if (!tsconfigPath) {
        console.error('Usage: ts2swift <d.ts file path> [-o output.json]');
        process.exit(1);
    }

    const filePath = options.positionals[0];

    console.log(`Processing ${filePath}...`);

    // Create TypeScript program and process declarations
    const configFile = ts.readConfigFile(tsconfigPath, ts.sys.readFile);
    const configParseResult = ts.parseJsonConfigFileContent(
        configFile.config,
        ts.sys,
        path.dirname(path.resolve(tsconfigPath))
    );

    const diagnosticEngine = new DiagnosticEngine();

    if (configParseResult.errors.length > 0) {
        diagnosticEngine.tsDiagnose(configParseResult.errors);
        process.exit(1);
    }

    const program = TypeProcessor.createProgram(filePath, configParseResult.options);
    const diagnostics = program.getSemanticDiagnostics();
    if (diagnostics.length > 0) {
        diagnosticEngine.tsDiagnose(diagnostics);
        process.exit(1);
    }

    const processor = new TypeProcessor(program.getTypeChecker(), diagnosticEngine);
    const results = processor.processTypeDeclarations(program, filePath);

    // Write results to file or stdout
    const jsonOutput = JSON.stringify(results, null, 2);
    if (options.values.output) {
        fs.writeFileSync(options.values.output, jsonOutput);
    } else {
        process.stdout.write(jsonOutput, "utf-8");
    }
}
