// Positions where noncopyable mode replaces JSUndefinedOr or a Record of a wrapper
export interface Item {
    value(): number;
    maybe?: Item;
    later: Item | undefined;
    byName: Record<string, Item>;
}
export function findUndefined(start: number): Item | undefined;
export function useOptional(item?: Item): number;
export function useUndefined(item: Item | undefined): number;
export function makeByName(): Record<string, Item>;
export function useByName(items: Record<string, Item>): number;
export function useNullableByName(items: Record<string, Item | null>): number;
export function useArraysByName(items: Record<string, Item[]>): number;
