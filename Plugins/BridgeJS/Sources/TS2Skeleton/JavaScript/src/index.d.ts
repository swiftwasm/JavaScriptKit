export type BridgeType =
    | { "int": {} }
    | { "float": {} }
    | { "double": {} }
    | { "string": {} }
    | { "bool": {} }
    | { "jsObject": { "_0": string } | {} }
    | { "void": {} }

export type Parameter = {
    name: string;
    type: BridgeType;
}

export type Effects = {
    isAsync: boolean;
}

export type ImportFunctionSkeleton = {
    name: string;
    parameters: Parameter[];
    returnType: BridgeType;
    effects: Effects;
    documentation: string | undefined;
}

export type ImportConstructorSkeleton = {
    parameters: Parameter[];
}

export type ImportPropertySkeleton = {
    name: string;
    type: BridgeType;
    isReadonly: boolean;
    documentation: string | undefined;
}

export type ImportTypeSkeleton = {
    name: string;
    documentation: string | undefined;
    constructor?: ImportConstructorSkeleton;
    properties: ImportPropertySkeleton[];
    methods: ImportFunctionSkeleton[];
}

export type ImportSkeleton = {
    functions: ImportFunctionSkeleton[];
    types: ImportTypeSkeleton[];
}
