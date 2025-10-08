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
    eventCount: number;
    readonly delegateName: string;
}

/// Represents a Swift heap object like a class instance or an actor instance.
export interface SwiftHeapObject {
    /// Release the heap object.
    ///
    /// Note: Calling this method will release the heap object and it will no longer be accessible.
    release(): void;
}
export interface MyViewController extends SwiftHeapObject {
    triggerEvent(): void;
    updateValue(value: string): void;
    updateCount(count: number): boolean;
    updateLabel(prefix: string, suffix: string): void;
    checkEvenCount(): boolean;
    delegate: MyViewControllerDelegate;
    secondDelegate: MyViewControllerDelegate | null;
}
export type Exports = {
    MyViewController: {
        new(delegate: MyViewControllerDelegate): MyViewController;
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