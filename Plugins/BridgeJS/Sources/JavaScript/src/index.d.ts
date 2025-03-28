export type BridgeType =
    | { "int": {} }
    | { "float": {} }
    | { "double": {} }
    | { "string": {} }
    | { "bool": {} }
    | { "jsObject": {} }
    | { "unknown": {} }
    | { "void": {} }

export type Parameter = {
    name: string;
    type: BridgeType;
}

export type ImportFunctionSkeleton = {
    name: string;
    parameters: Parameter[];
    returnType: BridgeType;
}

export type ImportPropertySkeleton = {
    name: string;
    type: BridgeType;
}

export type ImportMethodSkeleton = {
    name: string;
    parameters: Parameter[];
    returnType: BridgeType;
}

export type ImportTypeSkeleton = {
    name: string;
    properties: ImportPropertySkeleton[];
    methods: ImportMethodSkeleton[];
}

export type ImportSkeleton = {
    functions: ImportFunctionSkeleton[];
    types: ImportTypeSkeleton[];
}
