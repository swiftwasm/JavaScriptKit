export interface Greeter {
    greet(): string;
    changeName(name: string): void;
}
export type Export = {
    Greeter: {
        new(name: string): Greeter;
    }
}
export function createInstantiator(options: {}, swift: any): Promise<{
    addImports: (importObject: WebAssembly.Imports) => void;
    setInstance: (instance: WebAssembly.Instance) => void;
    createExports: (instance: WebAssembly.Instance) => Export;
}>;