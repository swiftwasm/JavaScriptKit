export function testOptionalNumber(value: number | null): void;
export function testOptionalString(value: string | undefined): void;
export function testOptionalBool(value: boolean | null | undefined): void;
export function testOptionalReturn(): string | null;
export function testOptionalNumberReturn(): number | undefined;
export function testMixedOptionals(required: string, optional: number | null): boolean | undefined;

export class TestClass {
    optionalProperty: string | null;

    constructor(param: number | undefined);

    methodWithOptional(value: boolean | null): void;
    methodReturningOptional(): string | undefined;
}