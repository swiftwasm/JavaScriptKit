// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export namespace Library {
    export interface Shelf {
    }
    export namespace Shelf {
        export interface Divider {
            slot: number;
        }
    }
}
export namespace Outer {
    export interface Inner {
        marker(): number;
    }
    export namespace Inner {
        export interface Outer {
        }
        export namespace Outer {
            export interface Inner {
            }
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
export interface Library extends SwiftHeapObject {
    divider(value: Library.Shelf.Divider): Library.Shelf.Divider;
}
export interface Outer extends SwiftHeapObject {
}
export type Exports = {
    Library: {
        new(): Library;
        Shelf: {
            Divider: {
                init(slot: number): Library.Shelf.Divider;
            },
        },
    },
    Outer: {
        new(): Outer;
        Inner: {
            init(): Outer.Inner;
            Outer: {
                Inner: {
                    init(): Outer.Inner.Outer.Inner;
                },
            },
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