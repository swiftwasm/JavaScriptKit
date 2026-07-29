export function moduleAdd(lhs, rhs) {
    return lhs + rhs;
}

export function renamedFunction() {
    return "loaded from a module";
}

export function moduleThrow() {
    throw new Error("module failure");
}

export const version = "module-v1";
