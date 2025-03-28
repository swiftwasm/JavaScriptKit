// import type { createImports } from "../JavaScript/index.mjs"
// import type chroma from "chroma-js"

// declare class Greeter {
//     constructor(name: string);
//     greet(nTimes: number): string;
//     changeName(name: string): void;
// }

// export type Exports = {
//     // log: (message: string) => void;
//     // chroma: typeof chroma;
//     // Greeter: typeof Greeter;
// }

type Prettify<T> = {
    [K in keyof T]: T[K];
  } & {};

type _Document = Pick<Document, "createElement">

export declare function getDocument(): Document
