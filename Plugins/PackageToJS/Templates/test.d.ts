import type { InstantiateOptions, instantiate } from "./instantiate";

export async function testBrowser(
    options: {
        preludeScript?: string,
        args?: string[],
    }
): Promise<number>

export async function testBrowserInPage(
    options: InstantiateOptions
): ReturnType<typeof instantiate>
