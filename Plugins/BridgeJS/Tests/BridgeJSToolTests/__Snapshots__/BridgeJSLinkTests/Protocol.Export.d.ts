// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export interface MyViewControllerDelegate {
    onSomethingHappened(): void;
    onValueChanged(value: string): void;
    onCountUpdated(count: number): boolean;
    onLabelUpdated(prefix: string, suffix: string): void;
    isCountEven(): boolean;
    onHelperUpdated(helper: Helper): void;
    createHelper(): Helper;
    onOptionalHelperUpdated(helper: Helper | null): void;
    createOptionalHelper(): Helper | null;
    createEnum(): ExampleEnumTag;
    handleResult(result: ResultTag): void;
    getResult(): ResultTag;
    eventCount: number;
    readonly delegateName: string;
    optionalName: string | null;
    myEnum: ExampleEnumTag;
    result: ResultTag | null;
}

export const ExampleEnumValues: {
    readonly Test: "test";
    readonly Test2: "test2";
};
export type ExampleEnumTag = typeof ExampleEnumValues[keyof typeof ExampleEnumValues];

export const ResultValues: {
    readonly Tag: {
        readonly Success: 0;
        readonly Failure: 1;
    };
};

export type ResultTag =
  { tag: typeof ResultValues.Tag.Success; param0: string } | { tag: typeof ResultValues.Tag.Failure; param0: number }

export type ExampleEnumObject = typeof ExampleEnumValues;

export type ResultObject = typeof ResultValues;

/// Represents a Swift heap object like a class instance or an actor instance.
export interface SwiftHeapObject {
    /// Release the heap object.
    ///
    /// Note: Calling this method will release the heap object and it will no longer be accessible.
    release(): void;
}
export interface Helper extends SwiftHeapObject {
    increment(): void;
    value: number;
}
export interface MyViewController extends SwiftHeapObject {
    triggerEvent(): void;
    updateValue(value: string): void;
    updateCount(count: number): boolean;
    updateLabel(prefix: string, suffix: string): void;
    checkEvenCount(): boolean;
    sendHelper(helper: Helper): void;
    delegate: MyViewControllerDelegate;
    secondDelegate: MyViewControllerDelegate | null;
}
export type Exports = {
    Helper: {
        new(value: number): Helper;
    }
    MyViewController: {
        new(delegate: MyViewControllerDelegate): MyViewController;
    }
    ExampleEnum: ExampleEnumObject
    Result: ResultObject
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