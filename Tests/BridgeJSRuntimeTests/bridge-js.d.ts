export function jsRoundTripVoid(): void
export function jsRoundTripNumber(v: number): number
export function jsRoundTripBool(v: boolean): boolean
export function jsRoundTripString(v: string): string

export class JsGreeter {
    constructor(name: string);
    greet(): string;
    changeName(name: string): void;
}