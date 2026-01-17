export interface TS2Swift {
    convert(ts: string): string;
}

export function createTS2Swift(): TS2Swift;