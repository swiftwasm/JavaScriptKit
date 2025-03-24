import typescript from "@rollup/plugin-typescript";
import dts from "rollup-plugin-dts";

/** @type {import('rollup').RollupOptions} */
const config = [
    {
        input: "src/index.ts",
        output: [
            {
                file: "lib/index.mjs",
                format: "esm",
            },
            {
                file: "lib/index.js",
                format: "umd",
                name: "JavaScriptKit",
            },
        ],
        plugins: [typescript()],
    },
    {
        input: "src/index.ts",
        output: {
            file: "lib/index.d.ts",
            format: "esm",
        },
        plugins: [dts()],
    },
];

export default config;
