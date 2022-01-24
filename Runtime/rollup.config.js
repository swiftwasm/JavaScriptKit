import typescript from "@rollup/plugin-typescript";

/** @type {import('rollup').RollupOptions} */
const config = {
    input: "src/index.ts",
    output: [
        {
            file: "lib/index.mjs",
            format: "esm",
        },
        {
            dir: "lib",
            format: "umd",
            name: "JavaScriptKit",
        },
    ],
    plugins: [typescript()],
};

export default config;
