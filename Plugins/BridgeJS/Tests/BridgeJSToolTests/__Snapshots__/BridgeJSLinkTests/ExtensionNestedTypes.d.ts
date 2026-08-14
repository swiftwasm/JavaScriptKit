// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const MessageValues: {
    readonly Tag: {
        readonly Update: 0;
        readonly Delete: 1;
    };
};

export type MessageTag =
  { tag: typeof MessageValues.Tag.Update; param0: UpdateTag } | { tag: typeof MessageValues.Tag.Delete }

export const UpdateValues: {
    readonly Flip: 0;
    readonly Rotate: 1;
};
export type UpdateTag = typeof UpdateValues[keyof typeof UpdateValues];

export type MessageObject = typeof MessageValues;

export type GenreObject = typeof Library.GenreValues;

export type UpdateObject = typeof UpdateValues;

export namespace Library {
    const GenreValues: {
        readonly Fiction: "fiction";
        readonly Reference: "reference";
    };
    type GenreTag = typeof GenreValues[keyof typeof GenreValues];
    export interface Shelf {
        label: string;
        describeShelf(): string;
    }
    export namespace Shelf {
        export interface Divider {
            slot: number;
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
    describe(): string;
    rename(title: string): string;
    shelf(label: string): Library.Shelf;
    name: string;
}
export type Exports = {
    roundTripMessage(message: MessageTag): MessageTag;
    Message: MessageObject
    Update: UpdateObject
    Library: {
        new(name: string): Library;
        Genre: GenreObject
        Shelf: {
            init(label: string): Library.Shelf;
            readonly capacity: number;
            Divider: {
                init(slot: number): Library.Shelf.Divider;
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