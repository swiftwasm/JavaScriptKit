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
