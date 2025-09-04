export function roundTripOptionalNumber(value: number | null): number | null;
export function roundTripOptionalString(value: string | null): string | null;
export function roundTripOptionalBool(value: boolean | null): boolean | null;
export function roundTripOptionalClass(value: TestClass | null): TestClass | null;
export function testMixedOptionals(required: string, optional: number | null): boolean | null;

export class TestClass {
    optionalProperty: string | null;

    constructor(param: number | null);

    methodWithOptional(value: boolean | null): void;
    methodReturningOptional(): string | null;
}
