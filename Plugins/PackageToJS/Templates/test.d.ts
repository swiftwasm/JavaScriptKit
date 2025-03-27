import type { InstantiateOptions, instantiate } from "./instantiate";

export function testBrowser(
    options: {
        preludeScript?: string,
        args?: string[],
    }
): Promise<number>

export function testBrowserInPage(
    options: InstantiateOptions
): ReturnType<typeof instantiate>
