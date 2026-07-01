// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export type RoleObject = typeof Account.RoleValues;

export namespace Account {
    const RoleValues: {
        readonly Admin: "admin";
        readonly Guest: "guest";
    };
    type RoleTag = typeof RoleValues[keyof typeof RoleValues];
    export interface Credentials {
        token: string;
    }
}
/// Represents a Swift heap object like a class instance or an actor instance.
export interface SwiftHeapObject {
    /// Release the heap object.
    ///
    /// Note: Calling this method will release the heap object and it will no longer be accessible.
    release(): void;
}
export interface Account extends SwiftHeapObject {
    describe(): string;
    name: string;
    readonly role: Account.RoleTag;
}
export type Exports = {
    Account: {
        new(name: string): Account;
        readonly defaultRole: Account.RoleTag;
        Role: RoleObject
        Credentials: {
            init(token: string): Account.Credentials;
            readonly maxLength: number;
            empty(): Account.Credentials;
        },
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