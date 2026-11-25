// A wrapper type in every array position
export interface Item {
    value(): number;
}
export interface Shelf {
    items: Item[];
    readonly fixed: Item[];
    slots: (Item | null)[];
    maybeItems: Item[] | null;
    grid: Item[][];
    byName: Record<string, Item[]>;
}
export class Store {
    constructor(seed: Item[]);
    take(items: Item[]): number;
    takeGeneric(items: Array<Item>): number;
    takeReadonly(items: readonly Item[]): number;
    takeSlots(slots: (Item | null)[]): number;
    takeMaybe(items: Item[] | null): number;
    takeUndefined(items?: Item[]): number;
    make(count: number): Item[];
    makeSlots(count: number): (Item | null)[];
    makeMaybe(count: number): Item[] | null;
    makeGrid(count: number): Item[][];
    load(count: number): Promise<Item[]>;
    each(callback: (items: Item[]) => void): void;
    numbers(values: number[]): number[];
    shelf(): Shelf;
}
export const allItems: Item[];
export function makeItems(count: number): Item[];
