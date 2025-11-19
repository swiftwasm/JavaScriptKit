// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export type MethodObject = typeof MethodValues;

export type LogLevelObject = typeof LogLevelValues;

export type PortObject = typeof PortValues;

export type SupportedMethodObject = typeof SupportedMethodValues;

export {};

declare global {
    namespace Configuration {
        const LogLevelValues: {
            readonly Debug: "debug";
            readonly Info: "info";
            readonly Warning: "warning";
            readonly Error: "error";
        };
        type LogLevelTag = typeof LogLevelValues[keyof typeof LogLevelValues];
        const PortValues: {
            readonly Http: 80;
            readonly Https: 443;
            readonly Development: 3000;
        };
        type PortTag = typeof PortValues[keyof typeof PortValues];
    }
    namespace Networking {
        namespace API {
            class HTTPServer {
                constructor();
                call(method: Networking.API.MethodTag): void;
            }
            const MethodValues: {
                readonly Get: 0;
                readonly Post: 1;
                readonly Put: 2;
                readonly Delete: 3;
            };
            type MethodTag = typeof MethodValues[keyof typeof MethodValues];
        }
        namespace APIV2 {
            namespace Internal {
                class TestServer {
                    constructor();
                    call(method: Internal.SupportedMethodTag): void;
                }
                const SupportedMethodValues: {
                    readonly Get: 0;
                    readonly Post: 1;
                };
                type SupportedMethodTag = typeof SupportedMethodValues[keyof typeof SupportedMethodValues];
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
    call(method: Networking.API.MethodTag): void;
}
export interface TestServer extends SwiftHeapObject {
    call(method: Internal.SupportedMethodTag): void;
}
export type Exports = {
    Configuration: {
        LogLevel: LogLevelObject
        Port: PortObject
    },
    Networking: {
        API: {
            HTTPServer: {
                new(): HTTPServer;
            }
            Method: MethodObject
        },
        APIV2: {
            Internal: {
                TestServer: {
                    new(): TestServer;
                }
                SupportedMethod: SupportedMethodObject
            },
        },
    },
    Utils: {
        Converter: {
            new(): Converter;
        }
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