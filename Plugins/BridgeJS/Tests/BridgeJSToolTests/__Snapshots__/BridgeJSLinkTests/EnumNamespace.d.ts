// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export type MethodObject = typeof Networking.API.MethodValues;

export type LogLevelObject = typeof Configuration.LogLevelValues;

export type PortObject = typeof Configuration.PortValues;

export type SupportedMethodObject = typeof Networking.APIV2.Internal.SupportedMethodValues;

export namespace Configuration {
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
export namespace Networking {
    export namespace API {
        const MethodValues: {
            readonly Get: 0;
            readonly Post: 1;
            readonly Put: 2;
            readonly Delete: 3;
        };
        type MethodTag = typeof MethodValues[keyof typeof MethodValues];
    }
    export namespace APIV2 {
        export namespace Internal {
            const SupportedMethodValues: {
                readonly Get: 0;
                readonly Post: 1;
            };
            type SupportedMethodTag = typeof SupportedMethodValues[keyof typeof SupportedMethodValues];
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
    precision: number;
}
export interface HTTPServer extends SwiftHeapObject {
    call(method: Networking.API.MethodTag): void;
}
export interface TestServer extends SwiftHeapObject {
    call(method: Networking.APIV2.Internal.SupportedMethodTag): void;
}
export interface Converter extends SwiftHeapObject {
    format(value: number): string;
}
export type Exports = {
    Configuration: {
        LogLevel: LogLevelObject
        Port: PortObject
    },
    Formatting: {
        Converter: {
            new(): Converter;
        }
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
    Services: {
        Graph: {
            GraphOperations: {
                createGraph(rootId: number): number;
                nodeCount(graphId: number): number;
                validate(graphId: number): boolean;
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