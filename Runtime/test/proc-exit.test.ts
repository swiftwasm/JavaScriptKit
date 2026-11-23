import { describe, expect, test } from "vitest";
import { ProcessExit, SwiftRuntime } from "../src/index.js";

describe("swjs_proc_exit", () => {
    test("throws ProcessExit with the exit code", () => {
        const runtime = new SwiftRuntime();
        const imports = runtime.wasmImports as any;
        let thrown: unknown;
        try {
            imports.swjs_proc_exit(7);
        } catch (error) {
            thrown = error;
        }
        expect(thrown).toBeInstanceOf(ProcessExit);
        expect((thrown as ProcessExit).code).toBe(7);
    });
});
