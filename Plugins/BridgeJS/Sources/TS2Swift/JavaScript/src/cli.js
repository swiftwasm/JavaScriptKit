// @ts-check
import * as fs from 'fs';
import os from 'os';
import path from 'path';
import { parseArgs } from 'util';
import ts from 'typescript';
import { TypeProcessor } from './processor.js';

class DiagnosticEngine {
    /**
     * @param {keyof typeof DiagnosticEngine.LEVELS} level
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
    console.error(`Usage: ts2swift <input> [options]

  <input>    Path to a .d.ts file, or "-" to read from stdin

Options:
  -o, --output <path>     Write Swift to <path>. Use "-" for stdout (default).
  -p, --project <path>    Path to tsconfig.json (default: tsconfig.json).
  --global <path>         Add a .d.ts as a global declaration file (repeatable).
  --log-level <level>     One of: verbose, info, warning, error (default: info).
  -h, --help              Show this help.

Examples:
  ts2swift lib.d.ts
  ts2swift lib.d.ts -o Generated.swift
  ts2swift lib.d.ts -p ./tsconfig.build.json -o Sources/Bridge/API.swift
  cat lib.d.ts | ts2swift - -o Generated.swift
  ts2swift lib.d.ts --global dom.d.ts --global lib.d.ts
`);
}

/**
 * Run ts2swift for a single input file (programmatic API, no process I/O).
 * @param {string[]} filePaths - Paths to the .d.ts files
 * @param {{ tsconfigPath: string, logLevel?: keyof typeof DiagnosticEngine.LEVELS, globalFiles?: string[] }} options
 * @returns {string} Generated Swift source
 * @throws {Error} on parse/type-check errors (diagnostics are included in the message)
 */
export function run(filePaths, options) {
    const { tsconfigPath, logLevel = 'info', globalFiles = [] } = options;
    const diagnosticEngine = new DiagnosticEngine(logLevel);

    const configFile = ts.readConfigFile(tsconfigPath, ts.sys.readFile);
    const configParseResult = ts.parseJsonConfigFileContent(
        configFile.config,
        ts.sys,
        path.dirname(path.resolve(tsconfigPath))
    );

    if (configParseResult.errors.length > 0) {
        const message = ts.formatDiagnosticsWithColorAndContext(configParseResult.errors, {
            getCanonicalFileName: (fileName) => fileName,
            getNewLine: () => ts.sys.newLine,
            getCurrentDirectory: () => ts.sys.getCurrentDirectory(),
        });
        throw new Error(`TypeScript config/parse errors:\n${message}`);
    }

    const program = TypeProcessor.createProgram([...filePaths, ...globalFiles], configParseResult.options);
    const diagnostics = program.getSemanticDiagnostics();
    if (diagnostics.length > 0) {
        const message = ts.formatDiagnosticsWithColorAndContext(diagnostics, {
            getCanonicalFileName: (fileName) => fileName,
            getNewLine: () => ts.sys.newLine,
            getCurrentDirectory: () => ts.sys.getCurrentDirectory(),
        });
        throw new Error(`TypeScript semantic errors:\n${message}`);
    }

    const prelude = [
        "// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,",
        "// DO NOT EDIT.",
        "//",
        "// To update this file, just rebuild your project or run",
        "// `swift package bridge-js`.",
        "",
        "@_spi(BridgeJS) import JavaScriptKit",
        "",
        "",
    ].join("\n");

    /** @type {string[]} */
    const bodies = [];
    const globalFileSet = new Set(globalFiles);
    for (const inputPath of [...filePaths, ...globalFiles]) {
        const processor = new TypeProcessor(program.getTypeChecker(), diagnosticEngine, {
            defaultImportFromGlobal: globalFileSet.has(inputPath),
        });
        const result = processor.processTypeDeclarations(program, inputPath);
        const body = result.content.trim();
        if (body.length > 0) bodies.push(body);
    }

    const hasAny = bodies.length > 0;
    return hasAny ? prelude + bodies.join("\n\n") + "\n" : "";
}

/**
 * Main function to run the CLI
 * @param {string[]} args - Command-line arguments
 * @returns {void}
 */
export function main(args) {
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
            help: {
                type: 'boolean',
                short: 'h',
            },
        },
        allowPositionals: true
    })

    if (options.values.help) {
        printUsage();
        process.exit(0);
    }

    if (options.positionals.length !== 1) {
        printUsage();
        process.exit(1);
    }

    /** @type {string[]} */
    let filePaths = options.positionals;
    /** @type {(() => void)[]} cleanup functions to run after completion */
    const cleanups = [];

    if (filePaths[0] === '-') {
        const content = fs.readFileSync(0, 'utf-8');
        const stdinTempPath = path.join(os.tmpdir(), `ts2swift-stdin-${process.pid}-${Date.now()}.d.ts`);
        fs.writeFileSync(stdinTempPath, content);
        cleanups.push(() => fs.unlinkSync(stdinTempPath));
        filePaths = [stdinTempPath];
    }
    const logLevel = /** @type {keyof typeof DiagnosticEngine.LEVELS} */ ((() => {
        const logLevel = options.values["log-level"] || "info";
        if (!Object.keys(DiagnosticEngine.LEVELS).includes(logLevel)) {
            console.error(`Invalid log level: ${logLevel}. Valid levels are: ${Object.keys(DiagnosticEngine.LEVELS).join(", ")}`);
            process.exit(1);
        }
        return logLevel;
    })());
    const globalFiles = options.values.global || [];
    const tsconfigPath = options.values.project || "tsconfig.json";

    const diagnosticEngine = new DiagnosticEngine(logLevel);
    diagnosticEngine.print("verbose", `Processing ${filePaths.join(", ")}`);

    let swiftOutput;
    try {
        swiftOutput = run(filePaths, { tsconfigPath, logLevel, globalFiles });
    } catch (/** @type {unknown} */ err) {
        if (err instanceof Error) {
            diagnosticEngine.print("error", err.message);
        } else {
            diagnosticEngine.print("error", String(err));
        }
        process.exit(1);
    } finally {
        for (const cleanup of cleanups) {
            cleanup();
        }
    }
    // Write to file or stdout
    if (options.values.output && options.values.output !== "-") {
        if (swiftOutput.length > 0) {
            fs.mkdirSync(path.dirname(options.values.output), { recursive: true });
            fs.writeFileSync(options.values.output, swiftOutput);
        }
    } else {
        process.stdout.write(swiftOutput, "utf-8");
    }
}
