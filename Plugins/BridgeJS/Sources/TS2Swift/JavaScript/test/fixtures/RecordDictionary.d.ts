export interface Box {
    value: number;
}

export function takeRecord(value: Record<string, number>): void;

export function returnRecord(): Record<string, string>;

export function optionalRecord(value: Record<string, boolean> | null): Record<string, boolean> | null;

export function nestedRecord(value: Record<string, Record<string, number>>): Record<string, Record<string, number>>;

export function recordWithArrayValues(values: Record<string, number[]>): Record<string, number[]>;

export function recordWithObjects(values: Record<string, Box | null>): Record<string, Box | null>;

export function unsupportedKeyRecord(values: Record<number, string>): void;
