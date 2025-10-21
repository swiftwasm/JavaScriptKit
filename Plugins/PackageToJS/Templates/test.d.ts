import type { InstantiateOptions, instantiate } from "./instantiate";

export type SetupOptionsFn = (
    options: InstantiateOptions,
    context: {
        isMainThread: boolean,
    }
) => Promise<InstantiateOptions>

export function testBrowser(
    options: {
        /** Path to the prelude script to be injected before tests run */
        preludeScript?: string,
        /** Command-line arguments to pass to the test runner */
        args?: string[],
        /** Options for Playwright browser */
        playwright?: {
            browser?: string,
            launchOptions?: import("playwright").LaunchOptions
        }
    }
): Promise<number>

export function testBrowserInPage(
    options: InstantiateOptions
): ReturnType<typeof instantiate>
