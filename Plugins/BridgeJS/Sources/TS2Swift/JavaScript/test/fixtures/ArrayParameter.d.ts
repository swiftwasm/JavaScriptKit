// Array as parameter
export function processNumbers(values: number[]): void;

// Array as return value
export function getNumbers(): number[];

// Array as both parameter and return value
export function transformNumbers(values: number[]): number[];

// String arrays
export function processStrings(values: string[]): string[];

// Boolean arrays
export function processBooleans(values: boolean[]): boolean[];

// Using Array<T> syntax
export function processArraySyntax(values: Array<number>): Array<number>;
