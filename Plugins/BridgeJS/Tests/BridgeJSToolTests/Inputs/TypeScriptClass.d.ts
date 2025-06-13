export class Greeter {
    name: string;
    readonly age: number;
    constructor(name: string);
    greet(): string;
    changeName(name: string): void;
}
