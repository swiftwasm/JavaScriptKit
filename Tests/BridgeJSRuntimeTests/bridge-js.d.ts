export function jsRoundTripVoid(): void
export function jsRoundTripNumber(v: number): number
export function jsRoundTripBool(v: boolean): boolean
export function jsRoundTripString(v: string): string
export type JSValue = any
export function jsRoundTripJSValue(v: JSValue): JSValue
export function jsRoundTripJSValueArray(v: JSValue[]): JSValue[]
export function jsRoundTripOptionalJSValueArray(v: JSValue[] | null): JSValue[] | null
export function jsThrowOrVoid(shouldThrow: boolean): void
export function jsThrowOrNumber(shouldThrow: boolean): number
export function jsThrowOrBool(shouldThrow: boolean): boolean
export function jsThrowOrString(shouldThrow: boolean): string

export enum FeatureFlag {
    foo = "foo",
    bar = "bar",
}

export function jsRoundTripFeatureFlag(flag: FeatureFlag): FeatureFlag

export class JsGreeter {
    name: string;
    readonly prefix: string;
    constructor(name: string, prefix: string);
    greet(): string;
    changeName(name: string): void;
}

export function runAsyncWorks(): Promise<void>;

// jsName tests
export function $jsWeirdFunction(): number;

export class $WeirdClass {
    constructor();
    "method-with-dashes"(): string;
}

export class StaticBox {
    constructor(value: number);
    value(): number;
    static create(value: number): StaticBox;
    static value(): number;
    static makeDefault(): StaticBox;
    static "with-dashes"(): StaticBox;
}

export function jsRoundTripNumberArray(values: number[]): number[];
export function jsRoundTripStringArray(values: string[]): string[];
export function jsRoundTripBoolArray(values: boolean[]): boolean[];
export function jsSumNumberArray(values: number[]): number;
export function jsCreateNumberArray(): number[];
