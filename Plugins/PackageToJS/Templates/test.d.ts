import type { InstantiateOptions, instantiate } from "./instantiate";

export type SetupOptionsFn = (
    options: InstantiateOptions,
    context: {
        isMainThread: boolean,
    }
) => Promise<InstantiateOptions>

/**
 * Functions to be exposed to the browser context via Playwright's page.exposeFunction.
 * Note: All functions are treated as async from the browser's perspective and will
 * return Promises when called from Swift/WebAssembly via JavaScriptKit.
 */
export type ExposedFunctions = Record<string, (...args: any[]) => Promise<any>>

/**
 * A function that receives the Playwright Page object and returns exposed functions.
 * This allows the exposed functions to interact with the browser page (click, query DOM, etc.)
 * Can also be used for async initialization before returning the functions.
 *
 * @param page - The Playwright Page object for browser interaction
 * @returns An object mapping function names to async functions, or a Promise resolving to such an object
 */
export type ExposedFunctionsFn = (page: import('playwright').Page) => ExposedFunctions | Promise<ExposedFunctions>

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
            onPageLoad?: (page: import("playwright").Page) => Promise<void>
        }
    }
): Promise<number>

export function testBrowserInPage(
    options: InstantiateOptions
): ReturnType<typeof instantiate>
