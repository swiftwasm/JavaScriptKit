// A wrapper type in every position ts2swift maps
export interface Item {
    value(): number;
    readonly child: Item;
    sibling: Item | null;
    maybe?: Item;
    items: Item[];
    byName: Record<string, Item>;
}
export class Factory {
    constructor(seed: Item);
    make(start: number): Item;
    makeMany(count: number): Item[];
    find(start: number): Item | null;
    findUndefined(start: number): Item | undefined;
    load(start: number): Promise<Item>;
    loadOptional(start: number): Promise<Item | null>;
    use(item: Item): number;
    useMany(items: Item[]): number;
    useOptional(item?: Item): number;
    useNullable(item: Item | null): number;
    each(callback: (item: Item) => void): void;
}
export const defaultItem: Item;
export function makeItem(start: number): Item;
