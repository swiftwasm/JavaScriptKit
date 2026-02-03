// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export interface MyViewControllerDelegate {
    setEventCount(value: number): void;
    setOptionalName(value: string | null): void;
    setOptionalRawEnum(value: ExampleEnumTag | null): void;
    setRawStringEnum(value: ExampleEnumTag): void;
    setResult(value: ResultTag): void;
    setOptionalResult(value: ResultTag | null): void;
    setDirection(value: DirectionTag): void;
    setDirectionOptional(value: DirectionTag | null): void;
    setPriority(value: PriorityTag): void;
    setPriorityOptional(value: PriorityTag | null): void;
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
    readonly eventCount: number;
    readonly delegateName: string;
    readonly optionalName: string | null;
    readonly optionalRawEnum: ExampleEnumTag | null;
    readonly rawStringEnum: ExampleEnumTag;
    readonly result: ResultTag;
    readonly optionalResult: ResultTag | null;
    readonly direction: DirectionTag;
    readonly directionOptional: DirectionTag | null;
    readonly priority: PriorityTag;
    readonly priorityOptional: PriorityTag | null;
}

export const DirectionValues: {
    readonly North: 0;
    readonly South: 1;
    readonly East: 2;
    readonly West: 3;
};
export type DirectionTag = typeof DirectionValues[keyof typeof DirectionValues];

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

export const PriorityValues: {
    readonly Low: -1;
    readonly Medium: 0;
    readonly High: 1;
};
export type PriorityTag = typeof PriorityValues[keyof typeof PriorityValues];

export type DirectionObject = typeof DirectionValues;

export type ExampleEnumObject = typeof ExampleEnumValues;

export type ResultObject = typeof ResultValues;

export type PriorityObject = typeof PriorityValues;

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
export interface DelegateManager extends SwiftHeapObject {
    notifyAll(): void;
    delegates: MyViewControllerDelegate[];
}
export type Exports = {
    Helper: {
        new(value: number): Helper;
    }
    MyViewController: {
        new(delegate: MyViewControllerDelegate): MyViewController;
    }
    DelegateManager: {
        new(delegates: MyViewControllerDelegate[]): DelegateManager;
    }
    processDelegates(delegates: MyViewControllerDelegate[]): MyViewControllerDelegate[];
    Direction: DirectionObject
    ExampleEnum: ExampleEnumObject
    Result: ResultObject
    Priority: PriorityObject
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