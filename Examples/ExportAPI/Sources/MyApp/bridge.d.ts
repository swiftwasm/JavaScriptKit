// import type { createImports } from "../JavaScript/index.mjs"
import type chroma from "chroma-js"

export type Exports = {
    log: (message: string) => void;
    chroma: typeof chroma;
}
