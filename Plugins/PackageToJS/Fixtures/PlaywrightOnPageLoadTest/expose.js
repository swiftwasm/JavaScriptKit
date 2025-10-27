/**
 * Playwright exposed functions for PlaywrightOnPageLoadTest
 * These functions will be exposed to the browser context and available as global functions
 * in the WASM environment (accessible via JSObject.global)
 *
 * IMPORTANT: All exposed functions are async from the browser's perspective.
 * Playwright's page.exposeFunction automatically wraps them to return Promises.
 * Therefore, you must use JSPromise to await them in Swift.
 */

/**
 * Export a function that receives the Playwright Page object and returns the exposed functions.
 * This allows your functions to interact with the page (click, query DOM, etc.)
 *
 * @param {import('playwright').Page} page - The Playwright Page object
 * @returns {Object} An object mapping function names to async functions
 */
export async function exposedFunctions(page) {
    return {
        expectToBeTrue: async () => {
            return true;
        },

        getTitle: async () => {
            return await page.title();
        },

        // clickButton: async (selector) => {
        //     await page.click(selector);
        //     return true;
        // },

        // screenshot: async () => {
        //     const buffer = await page.screenshot();
        //     return buffer.toString('base64');
        // }
    };
}

/**
 * Alternative: Export a static object if you don't need page access
 * (Note: This approach doesn't have access to the page object)
 */
// export const exposedFunctions = {
//     expectToBeTrue: async () => {
//         return true;
//     },
//     addNumbers: async (a, b) => a + b,
// };
