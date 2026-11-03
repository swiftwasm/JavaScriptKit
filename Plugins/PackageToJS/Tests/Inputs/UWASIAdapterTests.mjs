import assert from "node:assert/strict";
import { test } from "node:test";
import {
    MemoryFileSystem,
    useArgs,
    useClock,
    useEnviron,
    useMemoryFS,
    usePoll,
    useProc,
    useRandom,
    useStdio,
    WASI,
} from "uwasi";

import {
    browserMainThreadSleep,
    createUwasi,
} from "../../Templates/platforms/uwasi.js";

const minimalRuntime = {
    WASI,
    useStdio,
    useArgs,
    useEnviron,
    useClock,
    usePoll,
    useProc,
    useRandom,
};
const fileSystemRuntime = { ...minimalRuntime, MemoryFileSystem, useMemoryFS };
const WASI_ERRNO_NOSYS = 52;

function recordingLineBuffered() {
    const calls = { count: 0 };
    const lineBuffered = (writeLine) => {
        calls.count += 1;
        return (chunk) => {
            const line = new TextDecoder().decode(chunk).replace(/\n$/, "");
            writeLine(line);
        };
    };
    return { calls, lineBuffered };
}

function bindMemory(wasi) {
    const memory = new WebAssembly.Memory({ initial: 1 });
    wasi.setInstance({ exports: { memory } });
    return {
        view: new DataView(memory.buffer),
        bytes: new Uint8Array(memory.buffer),
    };
}

function writeTo(wasi, { view, bytes }, fd, text) {
    const chunk = new TextEncoder().encode(text);
    bytes.set(chunk, 64);
    view.setUint32(0, 64, true);
    view.setUint32(4, chunk.length, true);
    assert.equal(wasi.wasiImport.fd_write(fd, 0, 1, 8), 0);
    assert.equal(view.getUint32(8, true), chunk.length);
}

test("PackageToJS UWASI adapter preserves its host contracts with a file system", () => {
    const stdout = [];
    const stderr = [];
    const { calls, lineBuffered } = recordingLineBuffered();
    const { wasi, fileSystem } = createUwasi(
        { ...fileSystemRuntime, lineBuffered },
        {
            modulePath: "main.wasm",
            onStdoutLine: (line) => stdout.push(line),
            onStderrLine: (line) => stderr.push(line),
            withExtractFile: true,
        },
    );
    const memory = bindMemory(wasi);

    writeTo(wasi, memory, 1, "output\n");
    writeTo(wasi, memory, 2, "error\n");
    assert.equal(calls.count, 2);
    assert.deepEqual(stdout, ["output"]);
    assert.deepEqual(stderr, ["error"]);

    fileSystem.addFile("/output.txt", "result");
    assert.equal(
        new TextDecoder().decode(wasi.extractFile("/output.txt")),
        "result",
    );
});

test("PackageToJS UWASI adapter omits the file system by default", () => {
    const stdout = [];
    const stderr = [];
    const { calls, lineBuffered } = recordingLineBuffered();
    const { wasi, fileSystem } = createUwasi(
        { ...minimalRuntime, lineBuffered },
        {
            modulePath: "main.wasm",
            onStdoutLine: (line) => stdout.push(line),
            onStderrLine: (line) => stderr.push(line),
            withExtractFile: true,
        },
    );
    const memory = bindMemory(wasi);

    writeTo(wasi, memory, 1, "output\n");
    writeTo(wasi, memory, 2, "error\n");
    assert.equal(calls.count, 2);
    assert.deepEqual(stdout, ["output"]);
    assert.deepEqual(stderr, ["error"]);

    assert.equal(fileSystem, undefined);
    assert.equal("extractFile" in wasi, false);
    assert.equal(wasi.wasiImport.fd_prestat_get(3, 0), 8);
    assert.equal(
        wasi.wasiImport.path_open(3, 0, 0, 0, 0, 0n, 0n, 0, 0),
        WASI_ERRNO_NOSYS,
    );
    for (const name of [
        "args_get",
        "environ_get",
        "clock_time_get",
        "poll_oneoff",
        "proc_exit",
        "random_get",
    ]) {
        assert.ok(wasi.wasiImport[name].length > 0, `${name} must be provided`);
    }
});

for (const [name, runtime] of [
    ["minimal", minimalRuntime],
    ["file system", fileSystemRuntime],
]) {
    test(`PackageToJS forwards the host sleep policy (${name})`, (t) => {
        t.mock.method(performance, "now", () => 0);
        const { wasi } = createUwasi(
            { ...runtime, lineBuffered: (writeLine) => writeLine },
            {
                modulePath: "main.wasm",
                sleep(milliseconds) {
                    throw new Error(`cannot block for ${milliseconds}ms`);
                },
            },
        );
        const { view } = bindMemory(wasi);

        view.setBigUint64(0, 0n, true);
        view.setUint8(8, 0);
        view.setUint32(16, 1, true);
        view.setBigUint64(24, 1_000_000n, true);
        view.setBigUint64(32, 0n, true);
        view.setUint16(40, 0, true);

        assert.throws(
            () => wasi.wasiImport.poll_oneoff(0, 128, 1, 256),
            /cannot block for 1ms/,
        );
    });
}

test("PackageToJS blocks waits only on the browser main thread", () => {
    assert.equal(browserMainThreadSleep(), undefined);

    globalThis.document = {};
    try {
        const sleep = browserMainThreadSleep();
        assert.equal(typeof sleep, "function");
        assert.throws(
            () => sleep(5),
            /cannot block the browser main thread.*Run the guest in a worker/,
        );
    } finally {
        delete globalThis.document;
    }
});
