import assert from "node:assert/strict";
import { test } from "node:test";
import { MemoryFileSystem, useAll, WASI } from "uwasi";

import {
    browserMainThreadSleep,
    createUwasi,
} from "../../Templates/platforms/uwasi.js";

test("PackageToJS UWASI adapter preserves its host contracts", () => {
    const stdout = [];
    const stderr = [];
    let lineBufferedCalls = 0;
    const lineBuffered = (writeLine) => {
        lineBufferedCalls += 1;
        return (chunk) => {
            const line = new TextDecoder().decode(chunk).replace(/\n$/, "");
            writeLine(line);
        };
    };
    const { wasi, fileSystem } = createUwasi(
        { WASI, MemoryFileSystem, useAll, lineBuffered },
        {
            modulePath: "main.wasm",
            onStdoutLine: (line) => stdout.push(line),
            onStderrLine: (line) => stderr.push(line),
            withExtractFile: true,
        },
    );
    const memory = new WebAssembly.Memory({ initial: 1 });
    wasi.setInstance({ exports: { memory } });

    const view = new DataView(memory.buffer);
    const bytes = new Uint8Array(memory.buffer);
    const write = (fd, chunk) => {
        bytes.set(chunk, 64);
        view.setUint32(0, 64, true);
        view.setUint32(4, chunk.length, true);
        assert.equal(wasi.wasiImport.fd_write(fd, 0, 1, 8), 0);
        assert.equal(view.getUint32(8, true), chunk.length);
    };

    write(1, new TextEncoder().encode("output\n"));
    write(2, new TextEncoder().encode("error\n"));
    assert.equal(lineBufferedCalls, 2);
    assert.deepEqual(stdout, ["output"]);
    assert.deepEqual(stderr, ["error"]);

    fileSystem.addFile("/output.txt", "result");
    assert.equal(
        new TextDecoder().decode(wasi.extractFile("/output.txt")),
        "result",
    );
});

test("PackageToJS forwards the host sleep policy", (t) => {
    t.mock.method(performance, "now", () => 0);
    const { wasi } = createUwasi(
        {
            WASI,
            MemoryFileSystem,
            useAll,
            lineBuffered: (writeLine) => writeLine,
        },
        {
            modulePath: "main.wasm",
            sleep(milliseconds) {
                throw new Error(`cannot block for ${milliseconds}ms`);
            },
        },
    );
    const memory = new WebAssembly.Memory({ initial: 1 });
    wasi.setInstance({ exports: { memory } });

    const view = new DataView(memory.buffer);
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
