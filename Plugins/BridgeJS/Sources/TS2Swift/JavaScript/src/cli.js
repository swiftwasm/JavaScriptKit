// @ts-check
import * as fs from 'fs';
import { TypeProcessor } from './processor.js';
import { parseArgs } from 'util';
import ts from 'typescript';
import path from 'path';

class DiagnosticEngine {
    /**
     * @param {string} level
     */
    constructor(level) {
        const levelInfo = DiagnosticEngine.LEVELS[level];
        if (!levelInfo) {
            throw new Error(`Invalid log level: ${level}`);
        }
        this.minLevel = levelInfo.level;
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
        process.stderr.write(message, "utf-8");
    }

    static LEVELS = {
        "verbose": {
            color: '\x1b[34m',
            level: 0,
        },
        "info": {
            color: '\x1b[32m',
            level: 1,
        },
        "warning": {
            color: '\x1b[33m',
            level: 2,
        },
        "error": {
            color: '\x1b[31m',
            level: 3,
        },
    }

    /**
     * @param {keyof typeof DiagnosticEngine.LEVELS} level
     * @param {string} message
     * @param {ts.Node | undefined} node
     */
    print(level, message, node = undefined) {
        const levelInfo = DiagnosticEngine.LEVELS[level];
        if (levelInfo.level < this.minLevel) {
            return;
        }
        const color = levelInfo.color;
        if (node) {
            const sourceFile = node.getSourceFile();
            const { line, character } = sourceFile.getLineAndCharacterOfPosition(node.getStart());
            const location = sourceFile.fileName + ":" + (line + 1) + ":" + (character);
            process.stderr.write(`${location}: ${color}${level}\x1b[0m: ${message}\n`);
        } else {
            process.stderr.write(`${color}${level}\x1b[0m: ${message}\n`);
        }
    }
}

function printUsage() {
    console.error('Usage: ts2swift <d.ts file path> -p <tsconfig.json path> [--global <d.ts>]... [-o output.swift]');
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
            },
            global: {
                type: 'string',
                multiple: true,
            },
            "log-level": {
                type: 'string',
                default: 'info',
            },
        },
        allowPositionals: true
    })

    if (options.positionals.length !== 1) {
        printUsage();
        process.exit(1);
    }

    const tsconfigPath = options.values.project;
    if (!tsconfigPath) {
        printUsage();
        process.exit(1);
    }

    const filePath = options.positionals[0];
    const diagnosticEngine = new DiagnosticEngine(options.values["log-level"] || "info");

    diagnosticEngine.print("verbose", `Processing ${filePath}...`);

    // Create TypeScript program and process declarations
    const configFile = ts.readConfigFile(tsconfigPath, ts.sys.readFile);
    const configParseResult = ts.parseJsonConfigFileContent(
        configFile.config,
        ts.sys,
        path.dirname(path.resolve(tsconfigPath))
    );

    if (configParseResult.errors.length > 0) {
        diagnosticEngine.tsDiagnose(configParseResult.errors);
        process.exit(1);
    }

    /** @type {string[]} */
    const globalFiles = Array.isArray(options.values.global)
        ? options.values.global
        : (options.values.global ? [options.values.global] : []);

    const program = TypeProcessor.createProgram([filePath, ...globalFiles], configParseResult.options);
    const diagnostics = program.getSemanticDiagnostics();
    if (diagnostics.length > 0) {
        diagnosticEngine.tsDiagnose(diagnostics);
        process.exit(1);
    }

    const prelude = [
        "// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,",
        "// DO NOT EDIT.",
        "//",
        "// To update this file, just rebuild your project or run",
        "// `swift package bridge-js`.",
        "",
        "@_spi(Experimental) @_spi(BridgeJS) import JavaScriptKit",
        "",
        "",
    ].join("\n");

    /** @type {string[]} */
    const bodies = [];
    const globalFileSet = new Set(globalFiles);
    for (const inputPath of [filePath, ...globalFiles]) {
        const processor = new TypeProcessor(program.getTypeChecker(), diagnosticEngine, {
            defaultImportFromGlobal: globalFileSet.has(inputPath),
        });
        const result = processor.processTypeDeclarations(program, inputPath);
        const body = result.content.trim();
        if (body.length > 0) bodies.push(body);
    }

    const hasAny = bodies.length > 0;
    const swiftOutput = hasAny ? prelude + bodies.join("\n\n") + "\n" : "";

    if (options.values.output) {
        if (hasAny) {
            fs.mkdirSync(path.dirname(options.values.output), { recursive: true });
            fs.writeFileSync(options.values.output, swiftOutput);
        }
    } else {
        process.stdout.write(swiftOutput, "utf-8");
    }
}
