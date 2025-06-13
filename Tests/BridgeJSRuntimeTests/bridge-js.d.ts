export function jsRoundTripVoid(): void
export function jsRoundTripNumber(v: number): number
export function jsRoundTripBool(v: boolean): boolean
export function jsRoundTripString(v: string): string

export class JsGreeter {
    name: string;
    readonly prefix: string;
    constructor(name: string, prefix: string);
    greet(): string;
    changeName(name: string): void;
}