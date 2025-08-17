// BridgeJS Playground Main Application
import { EditorSystem } from './editor.js';
import ts from 'typescript';
import { TypeProcessor } from './processor.js';

export class BridgeJSPlayground {
    constructor() {
        this.editorSystem = new EditorSystem();
        this.playBridgeJS = null;
        this.generateTimeout = null;
        this.isInitialized = false;

        // DOM Elements
        this.errorDisplay = document.getElementById('errorDisplay');
        this.errorMessage = document.getElementById('errorMessage');
    }

    // Initialize the application
    async initialize() {
        if (this.isInitialized) {
            return;
        }

        try {
            // Initialize editor system
            await this.editorSystem.init();

            // Initialize BridgeJS
            await this.initializeBridgeJS();

            // Set up event listeners
            this.setupEventListeners();

            // Load sample code
            this.editorSystem.loadSampleCode();

            this.isInitialized = true;
            console.log('BridgeJS Playground initialized successfully');
        } catch (error) {
            console.error('Failed to initialize BridgeJS Playground:', error);
            this.showError('Failed to initialize application: ' + error.message);
        }
    }

    // Initialize BridgeJS
    async initializeBridgeJS() {
        try {
            // Import the BridgeJS module
            const { init } = await import("../../.build/plugins/PackageToJS/outputs/Package/index.js");
            const { exports } = await init({
                getImports: () => {
                    return {
                        createTS2Skeleton: this.createTS2Skeleton
                    };
                }
            });
            this.playBridgeJS = new exports.PlayBridgeJS();
            console.log('BridgeJS initialized successfully');
        } catch (error) {
            console.error('Failed to initialize BridgeJS:', error);
            throw new Error('BridgeJS initialization failed: ' + error.message);
        }
    }

    // Set up event listeners
    setupEventListeners() {
        // Add change listeners for real-time generation
        this.editorSystem.addChangeListeners(() => {
            // Debounce generation to avoid excessive calls
            if (this.generateTimeout) {
                clearTimeout(this.generateTimeout);
            }
            this.generateTimeout = setTimeout(() => this.generateCode(), 300);
        });
    }

    createTS2Skeleton() {
        return {
            convert: (dtsCode) => {
                const virtualFilePath = "bridge-js.d.ts"
                const virtualHost = {
                    fileExists: fileName => fileName === virtualFilePath,
                    readFile: fileName => dtsCode,
                    getSourceFile: (fileName, languageVersion) => {
                        const sourceText = dtsCode;
                        if (sourceText === undefined) return undefined;
                        return ts.createSourceFile(fileName, sourceText, languageVersion);
                    },
                    getDefaultLibFileName: options => "lib.d.ts",
                    writeFile: (fileName, data) => {
                        console.log(`[emit] ${fileName}:\n${data}`);
                    },
                    getCurrentDirectory: () => "",
                    getDirectories: () => [],
                    getCanonicalFileName: fileName => fileName,
                    getNewLine: () => "\n",
                    useCaseSensitiveFileNames: () => true
                }
                // Create TypeScript program from d.ts content
                const tsProgram = ts.createProgram({
                    rootNames: [virtualFilePath],
                    host: virtualHost,
                    options: {
                        noEmit: true,
                        declaration: true,
                    }
                })

                // Create diagnostic engine for error reporting
                const diagnosticEngine = {
                    print: (level, message, node) => {
                        console.log(`[${level}] ${message}`);
                        if (level === 'error') {
                            this.showError(`TypeScript Error: ${message}`);
                        }
                    }
                };

                // Process the TypeScript definitions to generate skeleton
                const processor = new TypeProcessor(tsProgram.getTypeChecker(), diagnosticEngine);

                const skeleton = processor.processTypeDeclarations(tsProgram, virtualFilePath);

                return JSON.stringify(skeleton);
            }
        }
    }

    // Generate code through BridgeJS
    async generateCode() {
        if (!this.playBridgeJS) {
            this.showError('BridgeJS is not initialized');
            return;
        }

        try {
            this.hideError();

            const inputs = this.editorSystem.getInputs();
            const swiftCode = inputs.swift;
            const dtsCode = inputs.dts;

            // Process the code and get PlayBridgeJSOutput
            const result = this.playBridgeJS.update(swiftCode, dtsCode);

            // Update outputs using the PlayBridgeJSOutput object
            this.editorSystem.updateOutputs(result);

            console.log('Code generated successfully');

        } catch (error) {
            console.error('Error generating code:', error);
            this.showError('Error generating code: ' + error.message);
        }
    }

    // Show error message
    showError(message) {
        this.errorMessage.textContent = message;
        this.errorDisplay.classList.add('show');
    }

    // Hide error message
    hideError() {
        this.errorDisplay.classList.remove('show');
    }
}