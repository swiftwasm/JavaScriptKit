import chroma from "chroma-js"

export function createImports() {
    return {
        /**
         * @param {string} message 
         * @returns {void}
         */
        log: (message) => console.log(message),
        chroma,
        /** @type {Pick<typeof document, "getElementById" | "body">} */
        document,
    }
}
