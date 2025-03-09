export type Export = {
    checkString(): string;
}
export function createInstantiator(options: {}, swift: any): Promise<{
    addImports: (importObject: WebAssembly.Imports) => void;
    setInstance: (instance: WebAssembly.Instance) => void;
    createExports: (instance: WebAssembly.Instance) => Export;
}>;