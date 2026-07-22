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
