import typescript from "@rollup/plugin-typescript";

/** @type {import('rollup').RollupOptions} */
export default {
    input: "bench/bench-runner.ts",
    output: {
        file: "bench/dist/bench.mjs",
        format: "esm",
    },
    plugins: [typescript({ tsconfig: "tsconfig.bench.json" })],
};
