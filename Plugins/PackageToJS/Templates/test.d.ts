import type { InstantiateOptions, instantiate } from "./instantiate";

export type SetupOptionsFn = (
    options: InstantiateOptions,
    context: {
        isMainThread: boolean,
    }
) => Promise<InstantiateOptions>

export function testBrowser(
    options: {
        preludeScript?: string,
        args?: string[],
    }
): Promise<number>

export function testBrowserInPage(
    options: InstantiateOptions
): ReturnType<typeof instantiate>
