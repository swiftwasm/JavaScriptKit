// Test case similar to the TS2Skeleton use case that caused the original bug
export interface TypeScriptProcessor {
    convert(ts: string): string;
    validate(ts: string): boolean;
    readonly version: string;
}

export interface CodeGenerator {
    generate(input: any): string;
    readonly outputFormat: string;
}

export function createTS2Skeleton(): TypeScriptProcessor;
export function createCodeGenerator(format: string): CodeGenerator;