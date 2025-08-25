interface ArrayBufferLike {
    readonly byteLength: number;
    readonly [Symbol.toStringTag]: string;
    slice(begin: number, end: number): ArrayBufferLike;
}

interface WeirdNaming {
    normalProperty: string;
    "property-with-dashes": number;
    "123invalidStart": boolean;
    "property with spaces": string;
    readonly [Symbol.species]: any;
    [Symbol.asyncIterator](): AsyncIterator<any>;
    "@specialChar": number;
    "constructor": string; // This should be valid
    for: string;
    Any: string;
    as(): void;
    "try"(): void;
}

export function createArrayBuffer(): ArrayBufferLike;
export function createWeirdObject(): WeirdNaming;
