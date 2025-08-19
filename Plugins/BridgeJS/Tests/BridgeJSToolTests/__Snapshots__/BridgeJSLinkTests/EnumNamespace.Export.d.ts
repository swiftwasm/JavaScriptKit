// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export {};

declare global {
    namespace Configuration {
        const LogLevel: {
            readonly Debug: "debug";
            readonly Info: "info";
            readonly Warning: "warning";
            readonly Error: "error";
        };
        type LogLevel = typeof LogLevel[keyof typeof LogLevel];
        const Port: {
            readonly Http: 80;
            readonly Https: 443;
            readonly Development: 3000;
        };
        type Port = typeof Port[keyof typeof Port];
    }
    namespace Networking {
        namespace API {
            class HTTPServer {
                constructor();
                call(method: Networking.API.Method): void;
            }
            const Method: {
                readonly Get: 0;
                readonly Post: 1;
                readonly Put: 2;
                readonly Delete: 3;
            };
            type Method = typeof Method[keyof typeof Method];
        }
        namespace APIV2 {
            namespace Internal {
                class TestServer {
                    constructor();
                    call(method: Internal.SupportedMethod): void;
                }
                const SupportedMethod: {
                    readonly Get: 0;
                    readonly Post: 1;
                };
                type SupportedMethod = typeof SupportedMethod[keyof typeof SupportedMethod];
            }
        }
    }
    namespace Utils {
        class Converter {
            constructor();
            toString(value: number): string;
        }
    }
}

/// Represents a Swift heap object like a class instance or an actor instance.
export interface SwiftHeapObject {
    /// Release the heap object.
    ///
    /// Note: Calling this method will release the heap object and it will no longer be accessible.
    release(): void;
}
export interface Converter extends SwiftHeapObject {
    toString(value: number): string;
}
export interface HTTPServer extends SwiftHeapObject {
    call(method: Networking.API.Method): void;
}
export interface TestServer extends SwiftHeapObject {
    call(method: Internal.SupportedMethod): void;
}
export type Exports = {
    Converter: {
        new(): Converter;
    }
    HTTPServer: {
        new(): HTTPServer;
    }
    TestServer: {
        new(): TestServer;
    }
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