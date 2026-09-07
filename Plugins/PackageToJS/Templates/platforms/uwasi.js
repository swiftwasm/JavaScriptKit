// @ts-check

/**
 * Refuse blocking waits on the browser main thread, where UWASI would otherwise
 * busy-wait. Workers and non-browser hosts can use UWASI's blocking default.
 *
 * @returns {((milliseconds: number) => void) | undefined}
 */
export function browserMainThreadSleep() {
    if (typeof document === "undefined") return undefined;
    return (milliseconds) => {
        throw new Error(
            `A WASI poll_oneoff wait of ${milliseconds}ms cannot block the browser main thread. ` +
                "Run the guest in a worker to support blocking waits.",
        );
    };
}

/**
 * @param {{ WASI: any, MemoryFileSystem: any, useAll: any, lineBuffered: any }} runtime
 * @param {{
 *   modulePath: string,
 *   args?: string[],
 *   onStdoutLine?: (line: string) => void,
 *   onStderrLine?: (line: string) => void,
 *   sleep?: (milliseconds: number) => void,
 *   withExtractFile?: boolean,
 * }} options
 */
export function createUwasi(runtime, options) {
    const args = options.args ?? [];
    const onStdoutLine = options.onStdoutLine ?? ((line) => console.log(line));
    const onStderrLine =
        options.onStderrLine ?? ((line) => console.error(line));
    const fileSystem = new runtime.MemoryFileSystem({ "/": "/" });
    const stdout = runtime.lineBuffered(onStdoutLine);
    const stderr = runtime.lineBuffered(onStderrLine);
    const wasi = new runtime.WASI({
        args: [options.modulePath, ...args],
        env: {},
        features: [
            runtime.useAll({
                withFileSystem: fileSystem,
                withStdio: {
                    stdin: () => "",
                    stdout,
                    stderr,
                    outputBuffers: true,
                },
                sleep: options.sleep,
            }),
        ],
    });

    if (options.withExtractFile) {
        Object.assign(wasi, {
            extractFile(filePath) {
                const node = fileSystem.lookup(filePath);
                return node && node.type === "file" ? node.content : undefined;
            },
        });
    }

    return { wasi, fileSystem };
}
