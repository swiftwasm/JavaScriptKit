export function asyncReturnVoid(): Promise<void>;
export function asyncRoundTripInt(v: number): Promise<number>;
export function asyncRoundTripString(v: string): Promise<string>;
export function asyncRoundTripBool(v: boolean): Promise<boolean>;
export function asyncRoundTripFloat(v: number): Promise<number>;
export function asyncRoundTripDouble(v: number): Promise<number>;
export function asyncRoundTripJSObject(v: any): Promise<any>;