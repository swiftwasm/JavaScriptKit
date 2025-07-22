export class EditorSystem {
    constructor() {
        this.editors = new Map();
        this.config = {
            input: [
                {
                    key: 'swift',
                    id: 'swiftEditor',
                    language: 'swift',
                    placeholder: '',
                    readOnly: false,
                    modelUri: 'Playground.swift'
                },
                {
                    key: 'dts',
                    id: 'dtsEditor',
                    language: 'typescript',
                    placeholder: '',
                    readOnly: false,
                    modelUri: 'bridge-js.d.ts'
                }
            ],
            output: [
                {
                    key: 'dts-generated',
                    id: 'dtsOutput',
                    language: 'typescript',
                    placeholder: '// Generated TypeScript will appear here...',
                    readOnly: true,
                    modelUri: 'Playground.d.ts'
                },
                {
                    key: 'import-glue',
                    id: 'importGlueOutput',
                    language: 'swift',
                    placeholder: '// Import Swift Glue will appear here...',
                    readOnly: true,
                    modelUri: 'ImportTS.swift'
                },
                {
                    key: 'export-glue',
                    id: 'exportGlueOutput',
                    language: 'swift',
                    placeholder: '// Export Swift Glue will appear here...',
                    readOnly: true,
                    modelUri: 'ExportTS.swift'
                },
                {
                    key: 'js-generated',
                    id: 'jsOutput',
                    language: 'javascript',
                    placeholder: '// Generated JavaScript will appear here...',
                    readOnly: true,
                    modelUri: 'bridge-js.js'
                }
            ]
        };
        this.activeTabs = {
            input: this.config.input[0]?.key,
            output: this.config.output[0]?.key
        };
    }

    async init() {
        await this.loadMonaco();
        this.createEditors();
        this.setupTabSystem();
        this.setupResizeHandling();
    }

    async loadMonaco() {
        return new Promise((resolve) => {
            require.config({ paths: { vs: 'https://unpkg.com/monaco-editor@0.45.0/min/vs' } });
            require(['vs/editor/editor.main'], resolve);
        });
    }

    createEditors() {
        const commonOptions = {
            automaticLayout: true,
            minimap: { enabled: false },
            scrollBeyondLastLine: false,
            fontSize: 14,
            fontFamily: '"SF Mono", Monaco, "Cascadia Code", "Roboto Mono", Consolas, "Courier New", monospace',
            lineNumbers: 'on',
            roundedSelection: false,
            scrollbar: { vertical: 'visible', horizontal: 'visible' },
            fixedOverflowWidgets: true,
            renderWhitespace: 'none',
            wordWrap: 'on'
        };

        // Create all editors from config
        [...this.config.input, ...this.config.output].forEach(config => {
            const element = document.getElementById(config.id);
            if (!element) {
                console.warn(`Editor element not found: ${config.id}`);
                return;
            }

            const model = monaco.editor.createModel(
                config.placeholder,
                config.language,
                monaco.Uri.parse(config.modelUri)
            );

            const editor = monaco.editor.create(element, {
                ...commonOptions,
                value: config.placeholder,
                language: config.language,
                readOnly: config.readOnly,
                model: model
            });

            this.editors.set(config.key, editor);
        });
    }

    setupTabSystem() {
        // Setup tab listeners
        [...this.config.input, ...this.config.output].forEach(config => {
            const button = document.querySelector(`[data-tab="${config.key}"]`);
            if (button) {
                button.addEventListener('click', () => this.switchTab(config.key));
            }
        });

        // Initial tab state
        this.updateTabStates();
    }

    switchTab(tabKey) {
        const config = this.getConfigByKey(tabKey);
        if (!config) return;

        if (this.config.input.some(c => c.key === tabKey)) {
            this.activeTabs.input = tabKey;
        } else {
            this.activeTabs.output = tabKey;
        }

        this.updateTabStates();
        this.updateLayout();
    }

    updateTabStates() {
        // Update all tab buttons
        [...this.config.input, ...this.config.output].forEach(config => {
            const button = document.querySelector(`[data-tab="${config.key}"]`);
            const content = document.getElementById(`${config.id}Tab`);

            if (button) {
                const isActive = config.key === this.activeTabs.input || config.key === this.activeTabs.output;
                button.classList.toggle('active', isActive);
            }

            if (content) {
                const isActive = config.key === this.activeTabs.input || config.key === this.activeTabs.output;
                content.classList.toggle('active', isActive);
            }
        });
    }

    setupResizeHandling() {
        const layoutEditor = (editor) => {
            editor.layout({ width: 0, height: 0 });
            window.requestAnimationFrame(() => {
                const { width, height } = editor.getContainerDomNode().getBoundingClientRect();
                editor.layout({ width, height });
            });
        };

        window.addEventListener("resize", () => {
            this.editors.forEach(editor => layoutEditor(editor));
        });
    }

    // Data access
    getInputs() {
        return {
            swift: this.editors.get('swift')?.getValue() || '',
            dts: this.editors.get('dts')?.getValue() || ''
        };
    }

    updateOutputs(result) {
        const outputMap = {
            'import-glue': () => result.importSwiftGlue(),
            'export-glue': () => result.exportSwiftGlue(),
            'js-generated': () => result.outputJs(),
            'dts-generated': () => result.outputDts()
        };

        Object.entries(outputMap).forEach(([key, getContent]) => {
            const editor = this.editors.get(key);
            if (editor) {
                const content = getContent();
                editor.setValue(content || `// No ${key} output generated`);
            }
        });
    }

    loadSampleCode() {
        const sampleSwift = `import JavaScriptKit

@JS public func calculateTotal(price: Double, quantity: Int) -> Double {
    return price * Double(quantity)
}

@JS class ShoppingCart {
    private var items: [(name: String, price: Double, quantity: Int)] = []

    @JS init() {}

    @JS public func addItem(name: String, price: Double, quantity: Int) {
        items.append((name, price, quantity))
    }

    @JS public func getTotal() -> Double {
        return items.reduce(0) { $0 + $1.price * Double($1.quantity) }
    }
}`;

        const sampleDts = `export type Console = {
    log: (message: string) => void;
}
export function console(): Console;`;

        this.editors.get('swift')?.setValue(sampleSwift);
        this.editors.get('dts')?.setValue(sampleDts);
    }

    addChangeListeners(callback) {
        this.config.input.forEach(config => {
            const editor = this.editors.get(config.key);
            if (editor) {
                editor.onDidChangeModelContent(callback);
            }
        });
    }

    // Utility methods
    getConfigByKey(key) {
        return [...this.config.input, ...this.config.output].find(c => c.key === key);
    }

    getActiveTabs() {
        return this.activeTabs;
    }
}