// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export interface Observer {
    if(value: number): boolean;
    else(): string;
    do: number;
    readonly for: string;
}

export const TokenValues: {
    readonly Tag: {
        readonly Break: 0;
        readonly Return: 1;
    };
};

export type TokenTag =
  { tag: typeof TokenValues.Tag.Break } | { tag: typeof TokenValues.Tag.Return; param0: string }

export interface Record {
    case: number;
    continue: string;
    as(): string;
}
export type TokenObject = typeof TokenValues & {
    switch(value: number): number;
};

/// Represents a Swift heap object like a class instance or an actor instance.
export interface SwiftHeapObject {
    /// Release the heap object.
    ///
    /// Note: Calling this method will release the heap object and it will no longer be accessible.
    release(): void;
}
export interface Parser extends SwiftHeapObject {
    class(): number;
    in: number;
}
export type Exports = {
    default(): void;
    delete(value: number): number;
    Token: TokenObject
    Parser: {
        new(in: number): Parser;
        where(value: number): number;
        readonly self: string;
    },
    Record: {
        init(case: number, continue: string): Record;
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