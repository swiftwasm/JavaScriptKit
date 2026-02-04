export function roundTripNumberNull(value: number | null): number | null;
export function roundTripNumberUndefined(value: number | undefined): number | undefined;

export function roundTripStringNull(value: string | null): string | null;
export function roundTripStringUndefined(value: string | undefined): string | undefined;

export function roundTripBooleanNull(value: boolean | null): boolean | null;
export function roundTripBooleanUndefined(value: boolean | undefined): boolean | undefined;

export function optionalNumberParamNull(x: number, maybe: number | null): number;
export function optionalNumberParamUndefined(x: number, maybe: number | undefined): number;

export interface MyInterface {}
export function roundTripMyInterfaceNull(value: MyInterface | null): MyInterface | null;
export function roundTripMyInterfaceUndefined(value: MyInterface | undefined): MyInterface | undefined;

export class WithOptionalFields {
    valueOrNull: MyInterface | null;
    valueOrUndefined: MyInterface | undefined;
}