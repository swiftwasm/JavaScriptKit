/**
 * Represents a node in the DOM tree.
 */
export interface Node {
    /**
     * Returns the name of the node, depending on its type.
     */
    readonly nodeName: string;
}

/**
 * A string tokenizer that supports adding and removing tokens.
 *
 * Mirrors DOMTokenList in lib.dom.d.ts.
 */
export interface DOMTokenList {
    /**
     * Adds the specified token(s) to the list.
     * @param tokens A set of space-separated tokens to add to the list.
     */
    add(...tokens: string[]): void;

    /**
     * Returns true if the list contains a given token, otherwise false.
     * @param token Token to locate in the list.
     * @returns True if the token is present, otherwise false.
     */
    contains(token: string): boolean;
}

/**
 * Represents an element in the document.
 */
export interface Element extends Node {
    /**
     * Returns a live DOMTokenList of class values.
     */
    readonly classList: DOMTokenList;

    /**
     * Returns the first element that is a descendant of node that matches selectors.
     * @param selectors Selectors to match against.
     * @returns The first matching element or null if there is no such element.
     */
    querySelector(selectors: string): Element | null;

    /**
     * Appends nodes or strings after the last child of this element.
     * @param nodes Nodes or strings to append.
     */
    append(...nodes: (Node | string)[]): void;
}

/**
 * Schedules a function to be run after a delay.
 * @param handler A function to execute after the timer expires.
 * @param timeout The time, in milliseconds, the timer should wait before the handler is executed.
 * @param args Additional arguments to pass to the handler.
 * @returns A numeric identifier for the timer.
 */
export function setTimeout(handler: (...args: any[]) => void, timeout?: number, ...args: any[]): number;
