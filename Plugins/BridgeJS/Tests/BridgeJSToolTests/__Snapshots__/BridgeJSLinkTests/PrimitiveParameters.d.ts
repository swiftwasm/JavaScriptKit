export type Export = {
    check(a: number, b: number, c: number, d: boolean): void;
}
export function createInstantiator(options: {}, swift: any): Promise<{
    addImports: (importObject: WebAssembly.Imports) => void;
    setInstance: (instance: WebAssembly.Instance) => void;
    createExports: (instance: WebAssembly.Instance) => Export;
}>;