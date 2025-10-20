// NOTICE: This is auto-generated code by BridgeJS from JavaScriptKit,
// DO NOT EDIT.
//
// To update this file, just rebuild your project or run
// `swift package bridge-js`.

export const ThemeValues: {
    readonly Light: "light";
    readonly Dark: "dark";
    readonly Auto: "auto";
};
export type ThemeTag = typeof ThemeValues[keyof typeof ThemeValues];

export enum TSTheme {
    Light = "light",
    Dark = "dark",
    Auto = "auto",
}

export const FeatureFlagValues: {
    readonly Enabled: true;
    readonly Disabled: false;
};
export type FeatureFlagTag = typeof FeatureFlagValues[keyof typeof FeatureFlagValues];

export const HttpStatusValues: {
    readonly Ok: 200;
    readonly NotFound: 404;
    readonly ServerError: 500;
};
export type HttpStatusTag = typeof HttpStatusValues[keyof typeof HttpStatusValues];

export enum TSHttpStatus {
    Ok = 200,
    NotFound = 404,
    ServerError = 500,
}

export const PriorityValues: {
    readonly Lowest: -1;
    readonly Low: 2;
    readonly Medium: 3;
    readonly High: 4;
    readonly Highest: 5;
};
export type PriorityTag = typeof PriorityValues[keyof typeof PriorityValues];

export const FileSizeValues: {
    readonly Tiny: 1024;
    readonly Small: 10240;
    readonly Medium: 102400;
    readonly Large: 1048576;
};
export type FileSizeTag = typeof FileSizeValues[keyof typeof FileSizeValues];

export const UserIdValues: {
    readonly Guest: 0;
    readonly User: 1000;
    readonly Admin: 9999;
};
export type UserIdTag = typeof UserIdValues[keyof typeof UserIdValues];

export const TokenIdValues: {
    readonly Invalid: 0;
    readonly Session: 12345;
    readonly Refresh: 67890;
};
export type TokenIdTag = typeof TokenIdValues[keyof typeof TokenIdValues];

export const SessionIdValues: {
    readonly None: 0;
    readonly Active: 9876543210;
    readonly Expired: 1234567890;
};
export type SessionIdTag = typeof SessionIdValues[keyof typeof SessionIdValues];

export const PrecisionValues: {
    readonly Rough: 0.1;
    readonly Normal: 0.01;
    readonly Fine: 0.001;
};
export type PrecisionTag = typeof PrecisionValues[keyof typeof PrecisionValues];

export const RatioValues: {
    readonly Quarter: 0.25;
    readonly Half: 0.5;
    readonly Golden: 1.618;
    readonly Pi: 3.14159;
};
export type RatioTag = typeof RatioValues[keyof typeof RatioValues];

export type ThemeObject = typeof ThemeValues;

export type FeatureFlagObject = typeof FeatureFlagValues;

export type HttpStatusObject = typeof HttpStatusValues;

export type PriorityObject = typeof PriorityValues;

export type FileSizeObject = typeof FileSizeValues;

export type UserIdObject = typeof UserIdValues;

export type TokenIdObject = typeof TokenIdValues;

export type SessionIdObject = typeof SessionIdValues;

export type PrecisionObject = typeof PrecisionValues;

export type RatioObject = typeof RatioValues;

export type Exports = {
    setTheme(theme: ThemeTag): void;
    getTheme(): ThemeTag;
    roundTripOptionalTheme(input: ThemeTag | null): ThemeTag | null;
    setTSTheme(theme: TSThemeTag): void;
    getTSTheme(): TSThemeTag;
    roundTripOptionalTSTheme(input: TSThemeTag | null): TSThemeTag | null;
    setFeatureFlag(flag: FeatureFlagTag): void;
    getFeatureFlag(): FeatureFlagTag;
    roundTripOptionalFeatureFlag(input: FeatureFlagTag | null): FeatureFlagTag | null;
    setHttpStatus(status: HttpStatusTag): void;
    getHttpStatus(): HttpStatusTag;
    roundTripOptionalHttpStatus(input: HttpStatusTag | null): HttpStatusTag | null;
    setTSHttpStatus(status: TSHttpStatusTag): void;
    getTSHttpStatus(): TSHttpStatusTag;
    roundTripOptionalHttpStatus(input: TSHttpStatusTag | null): TSHttpStatusTag | null;
    setPriority(priority: PriorityTag): void;
    getPriority(): PriorityTag;
    roundTripOptionalPriority(input: PriorityTag | null): PriorityTag | null;
    setFileSize(size: FileSizeTag): void;
    getFileSize(): FileSizeTag;
    roundTripOptionalFileSize(input: FileSizeTag | null): FileSizeTag | null;
    setUserId(id: UserIdTag): void;
    getUserId(): UserIdTag;
    roundTripOptionalUserId(input: UserIdTag | null): UserIdTag | null;
    setTokenId(token: TokenIdTag): void;
    getTokenId(): TokenIdTag;
    roundTripOptionalTokenId(input: TokenIdTag | null): TokenIdTag | null;
    setSessionId(session: SessionIdTag): void;
    getSessionId(): SessionIdTag;
    roundTripOptionalSessionId(input: SessionIdTag | null): SessionIdTag | null;
    setPrecision(precision: PrecisionTag): void;
    getPrecision(): PrecisionTag;
    roundTripOptionalPrecision(input: PrecisionTag | null): PrecisionTag | null;
    setRatio(ratio: RatioTag): void;
    getRatio(): RatioTag;
    roundTripOptionalRatio(input: RatioTag | null): RatioTag | null;
    processTheme(theme: ThemeTag): HttpStatusTag;
    convertPriority(status: HttpStatusTag): PriorityTag;
    validateSession(session: SessionIdTag): ThemeTag;
    Theme: ThemeObject
    FeatureFlag: FeatureFlagObject
    HttpStatus: HttpStatusObject
    Priority: PriorityObject
    FileSize: FileSizeObject
    UserId: UserIdObject
    TokenId: TokenIdObject
    SessionId: SessionIdObject
    Precision: PrecisionObject
    Ratio: RatioObject
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