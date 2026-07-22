// bridge-js-modules/TestModule/Modules/JSImportModule.mjs
export function moduleAdd(lhs, rhs) {
    return lhs + rhs;
}

export function renamedFunction() {
    return "renamed";
}

export const version = "1.0";

// bridge-js-modules/TestModule/Modules/ModuleCounter.mjs
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
