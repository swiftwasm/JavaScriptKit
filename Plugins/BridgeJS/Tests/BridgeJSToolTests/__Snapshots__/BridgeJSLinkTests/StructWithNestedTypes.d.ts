// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export interface Shape {
    label: string;
}
export interface Widget {
    name: string;
}
export type KindObject = typeof Shape.KindValues;

export type VariantObject = typeof Widget.VariantValues;

export type AlignmentObject = typeof Widget.Layout.AlignmentValues;

export namespace Shape {
    const KindValues: {
        readonly Circle: "circle";
        readonly Square: "square";
    };
    type KindTag = typeof KindValues[keyof typeof KindValues];
}
export namespace Widget {
    const VariantValues: {
        readonly Button: "button";
        readonly Slider: "slider";
    };
    type VariantTag = typeof VariantValues[keyof typeof VariantValues];
    export interface Bounds {
        width: number;
        height: number;
    }
    export interface Layout {
        padding: number;
    }
    export namespace Layout {
        const AlignmentValues: {
            readonly Leading: "leading";
            readonly Trailing: "trailing";
        };
        type AlignmentTag = typeof AlignmentValues[keyof typeof AlignmentValues];
    }
}
export type Exports = {
    Shape: {
        init(label: string): Shape;
        Kind: KindObject
    },
    Widget: {
        init(name: string): Widget;
        Variant: VariantObject
        Bounds: {
            init(width: number, height: number): Widget.Bounds;
            readonly dimensions: number;
            zero(): Widget.Bounds;
        },
        Layout: {
            Alignment: AlignmentObject
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