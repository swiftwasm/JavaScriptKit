export interface TS2Skeleton {
    convert(ts: string): string;
}

export function createTS2Skeleton(): TS2Skeleton;