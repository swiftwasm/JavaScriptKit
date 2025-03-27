export type BridgeType = "int" | "float" | "double" | "string" | "bool" | "void" | "unknown"

export type Parameter = {
    name: string;
    type: BridgeType;
}

export type ImportFunctionSkeleton = {
    name: string;
    parameters: Parameter[];
    returnType: BridgeType;
}

export type ImportClassSkeleton = {
    name: string;
    constructor: ImportFunctionSkeleton;
    methods: ImportFunctionSkeleton[];
}

export type ImportSkeleton = {
    functions: ImportFunctionSkeleton[];
    classes: ImportClassSkeleton[];
}
