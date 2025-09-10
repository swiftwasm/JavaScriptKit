// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const Theme: {
    readonly Light: "light";
    readonly Dark: "dark";
    readonly Auto: "auto";
};
export type Theme = typeof Theme[keyof typeof Theme];

export enum TSTheme {
    Light = "light",
    Dark = "dark",
    Auto = "auto",
}

export const FeatureFlag: {
    readonly Enabled: true;
    readonly Disabled: false;
};
export type FeatureFlag = typeof FeatureFlag[keyof typeof FeatureFlag];

export const HttpStatus: {
    readonly Ok: 200;
    readonly NotFound: 404;
    readonly ServerError: 500;
};
export type HttpStatus = typeof HttpStatus[keyof typeof HttpStatus];

export enum TSHttpStatus {
    Ok = 200,
    NotFound = 404,
    ServerError = 500,
}

export const Priority: {
    readonly Lowest: 1;
    readonly Low: 2;
    readonly Medium: 3;
    readonly High: 4;
    readonly Highest: 5;
};
export type Priority = typeof Priority[keyof typeof Priority];

export const FileSize: {
    readonly Tiny: 1024;
    readonly Small: 10240;
    readonly Medium: 102400;
    readonly Large: 1048576;
};
export type FileSize = typeof FileSize[keyof typeof FileSize];

export const UserId: {
    readonly Guest: 0;
    readonly User: 1000;
    readonly Admin: 9999;
};
export type UserId = typeof UserId[keyof typeof UserId];

export const TokenId: {
    readonly Invalid: 0;
    readonly Session: 12345;
    readonly Refresh: 67890;
};
export type TokenId = typeof TokenId[keyof typeof TokenId];

export const SessionId: {
    readonly None: 0;
    readonly Active: 9876543210;
    readonly Expired: 1234567890;
};
export type SessionId = typeof SessionId[keyof typeof SessionId];

export const Precision: {
    readonly Rough: 0.1;
    readonly Normal: 0.01;
    readonly Fine: 0.001;
};
export type Precision = typeof Precision[keyof typeof Precision];

export const Ratio: {
    readonly Quarter: 0.25;
    readonly Half: 0.5;
    readonly Golden: 1.618;
    readonly Pi: 3.14159;
};
export type Ratio = typeof Ratio[keyof typeof Ratio];

export type Exports = {
    setTheme(theme: Theme): void;
    getTheme(): Theme;
    roundTripOptionalTheme(input: Theme | null): Theme | null;
    setTSTheme(theme: TSTheme): void;
    getTSTheme(): TSTheme;
    roundTripOptionalTSTheme(input: TSTheme | null): TSTheme | null;
    setFeatureFlag(flag: FeatureFlag): void;
    getFeatureFlag(): FeatureFlag;
    roundTripOptionalFeatureFlag(input: FeatureFlag | null): FeatureFlag | null;
    setHttpStatus(status: HttpStatus): void;
    getHttpStatus(): HttpStatus;
    roundTripOptionalHttpStatus(input: HttpStatus | null): HttpStatus | null;
    setTSHttpStatus(status: TSHttpStatus): void;
    getTSHttpStatus(): TSHttpStatus;
    roundTripOptionalHttpStatus(input: TSHttpStatus | null): TSHttpStatus | null;
    setPriority(priority: Priority): void;
    getPriority(): Priority;
    roundTripOptionalPriority(input: Priority | null): Priority | null;
    setFileSize(size: FileSize): void;
    getFileSize(): FileSize;
    roundTripOptionalFileSize(input: FileSize | null): FileSize | null;
    setUserId(id: UserId): void;
    getUserId(): UserId;
    roundTripOptionalUserId(input: UserId | null): UserId | null;
    setTokenId(token: TokenId): void;
    getTokenId(): TokenId;
    roundTripOptionalTokenId(input: TokenId | null): TokenId | null;
    setSessionId(session: SessionId): void;
    getSessionId(): SessionId;
    roundTripOptionalSessionId(input: SessionId | null): SessionId | null;
    setPrecision(precision: Precision): void;
    getPrecision(): Precision;
    roundTripOptionalPrecision(input: Precision | null): Precision | null;
    setRatio(ratio: Ratio): void;
    getRatio(): Ratio;
    roundTripOptionalRatio(input: Ratio | null): Ratio | null;
    processTheme(theme: Theme): HttpStatus;
    convertPriority(status: HttpStatus): Priority;
    validateSession(session: SessionId): Theme;
}
export type Imports = {
}
export function createInstantiator(options: {
    imports: Imports;
}, swift: any): Promise<{
    addImports: (importObject: WebAssembly.Imports) => void;
    setInstance: (instance: WebAssembly.Instance) => void;
    createExports: (instance: WebAssembly.Instance) => Exports;
}>;