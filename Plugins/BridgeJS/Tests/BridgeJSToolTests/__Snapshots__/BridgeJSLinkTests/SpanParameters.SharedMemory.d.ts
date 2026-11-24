// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export interface ByteSink {
    /**
     * @param bytes Read-only bytes from Wasm memory, valid only until this call returns.
     */
    write(bytes: Uint8Array): number;
    /**
     * @param bytes Writable bytes from Wasm memory, valid only until this call returns. Writes are visible to Swift when the call returns.
     */
    read(bytes: Uint8Array): number;
}
export type Exports = {
}
export type Imports = {
    /**
     * @param bytes Read-only bytes from Wasm memory, valid only until this call returns.
     */
    readBytes(bytes: Uint8Array): number;
    /**
     * @param bytes Writable bytes from Wasm memory, valid only until this call returns. Writes are visible to Swift when the call returns.
     */
    fillBytes(bytes: Uint8Array): void;
    /**
     * @param source Read-only bytes from Wasm memory, valid only until this call returns.
     * @param destination Writable bytes from Wasm memory, valid only until this call returns. Writes are visible to Swift when the call returns.
     */
    copyBytes(source: Uint8Array, label: string, destination: Uint8Array): number;
    ByteSink: {
        /**
         * @param header Read-only bytes from Wasm memory, valid only until this call returns.
         */
        new(header: Uint8Array): ByteSink;
        /**
         * @param bytes Read-only bytes from Wasm memory, valid only until this call returns.
         */
        checksum(bytes: Uint8Array): number;
    }
}
export function createInstantiator(options: {
    imports: Imports;
}, swift: any): Promise<{
    addImports: (importObject: WebAssembly.Imports) => void;
    setInstance: (instance: WebAssembly.Instance) => void;
    createExports: (instance: WebAssembly.Instance) => Exports;
}>;