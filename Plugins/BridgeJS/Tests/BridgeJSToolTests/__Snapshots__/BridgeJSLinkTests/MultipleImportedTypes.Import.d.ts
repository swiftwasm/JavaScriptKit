// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export interface DatabaseConnection {
    connect(url: string): void;
    execute(query: string): any;
    readonly isConnected: boolean;
    connectionTimeout: number;
}
export interface Logger {
    log(message: string): void;
    error(message: string, error: any): void;
    readonly level: string;
}
export interface ConfigManager {
    get(key: string): any;
    set(key: string, value: any): void;
    readonly configPath: string;
}
export type Exports = {
}
export type Imports = {
    createDatabaseConnection(config: any): DatabaseConnection;
    createLogger(level: string): Logger;
    getConfigManager(): ConfigManager;
}
export function createInstantiator(options: {
    imports: Imports;
}, swift: any): Promise<{
    addImports: (importObject: WebAssembly.Imports) => void;
    setInstance: (instance: WebAssembly.Instance) => void;
    createExports: (instance: WebAssembly.Instance) => Exports;
}>;