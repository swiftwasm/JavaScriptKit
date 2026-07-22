export function moduleAdd(lhs, rhs) {
    return lhs + rhs;
}

export function renamedFunction() {
    return "loaded from a module";
}

export const version = "module-v1";

export class ModuleCounter {
    constructor(value) {
        this.value = value;
    }

    static create(value) {
        return new ModuleCounter(value);
    }

    increment() {
        return ++this.value;
    }

    setValue(value) {
        this.value = value;
    }
}
