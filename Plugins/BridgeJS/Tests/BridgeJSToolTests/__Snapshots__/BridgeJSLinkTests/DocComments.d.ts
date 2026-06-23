// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

/**
 * Receives lifecycle callbacks.
 */
export interface Listener {
    /**
     * Called when an event fires.
     * @param id The event identifier.
     */
    onEvent(id: number): void;
    /**
     * The listener's display name.
     */
    readonly name: string;
}

/**
 * A primary color channel.
 */
export const ColorValues: {
    readonly Red: 0;
    readonly Green: 1;
    readonly Blue: 2;
};
export type ColorTag = typeof ColorValues[keyof typeof ColorValues];

/**
 * A 2D point in space.
 */
export interface Point {
    /**
     * The horizontal position.
     */
    x: number;
    /**
     * The vertical position.
     */
    y: number;
}
export type ColorObject = typeof ColorValues & {
    /**
     * Returns the canonical name for a channel label.
     * @param label The raw label.
     * @returns The canonical channel name.
     */
    canonical(label: string): string;
    /**
     * The default channel.
     */
    readonly fallback: string;
};

/// Represents a Swift heap object like a class instance or an actor instance.
export interface SwiftHeapObject {
    /// Release the heap object.
    ///
    /// Note: Calling this method will release the heap object and it will no longer be accessible.
    release(): void;
}
/**
 * A greeter that keeps the target name.
 */
export interface Greeter extends SwiftHeapObject {
    /**
     * Returns a greeting for the configured name.
     * @returns The greeting message.
     */
    greet(): string;
    /**
     * The configured name.
     */
    name: string;
}
export type Exports = {
    Greeter: {
        /**
         * Create a greeter.
         * @param name The name to greet.
         */
        new(name: string): Greeter;
    }
    /**
     * Returns a greeting for a user.
     * @param name The user's name.
     * @param greeting The greeting word to use. (default: "Hello")
     * @returns The composed greeting message.
     */
    greet(name: string, greeting?: string): string;
    /**
     * Adds two numbers together.
     * @param a The first addend.
     * @param b The second addend.
     * @returns The sum of the inputs.
     */
    add(a: number, b: number): number;
    /**
     * Has blank doc lines around the summary; boundaries should be trimmed.
     */
    trimmed(): void;
    /**
     * Says hello to the world.
     *
     * Demonstrates that block doc comments are supported too.
     */
    hello(): void;
    /**
     * Parses an integer from text.
     * @param text The text to parse.
     * @returns The parsed integer.
     * @throws A `JSException` when the text is not a valid integer.
     */
    parseInt(text: string): number;
    /**
     * Returns the JSDoc terminator *\/ embedded mid-sentence.
     */
    terminator(): string;
    Color: ColorObject
    MathUtils: {
        /**
         * Doubles a value, in a namespace.
         * @param value The value to double.
         * @returns Twice the input.
         */
        double(value: number): number;
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