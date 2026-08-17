// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export interface Entry {
    identifier: number;
}
export namespace Catalog {
    export interface Entry {
        title: string;
    }
}
export type Exports = {
    takeEntry(entry: Entry): Entry;
    takeCatalogEntry(entry: Catalog.Entry): Catalog.Entry;
    Catalog: {
        Entry: {
            init(title: string): Catalog.Entry;
        },
    },
    Entry: {
        init(identifier: number): Entry;
    },
}
export type Imports = {
}
export function createInstantiator(options: {
    imports: Imports;
}, swift: any): Promise<{
    addImports: (importObject: WebAssembly.Imports) => void;
    setInstance: (instance: WebAssembly.Instance) => void;
    createExports: (instance: WebAssembly.Instance) => Exports;
}>;