export class Greeter {
    name: string;
    readonly age: number;
    constructor(name: string);
    greet(): string;
    changeName(name: string): void;

    static staticMethod(p1: number, p2: string): string;
}
