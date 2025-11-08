# Playwright OnPageLoad Test

This example demonstrates how to expose JavaScript functions to your Swift/WebAssembly tests using Playwright's `page.exposeFunction` API.

## How it works

1. **Expose Script**: A JavaScript file that exports functions to be exposed in the browser context
2. **Swift Tests**: Call these exposed functions using JavaScriptKit's `JSObject.global` API
3. **Test Runner**: The `--playwright-expose` flag loads the script and exposes the functions before running tests

## Usage

### Define exposed functions in a JavaScript file

**Important:** All functions exposed via Playwright's `page.exposeFunction` are async from the browser's perspective, meaning they always return Promises. Define them as `async` for clarity.

#### Option 1: Function with Page Access (Recommended)

Export a function that receives the Playwright `page` object. This allows your exposed functions to interact with the browser page:

```javascript
/**
 * @param {import('playwright').Page} page - The Playwright Page object
 */
export async function exposedFunctions(page) {
    return {
        expectToBeTrue: async () => {
            return true;
        },

        // Use the page object to interact with the browser
        getTitle: async () => {
            return await page.title();
        },

        clickButton: async (selector) => {
            await page.click(selector);
            return true;
        },

        evaluate: async (script) => {
            return await page.evaluate(script);
        },

        screenshot: async () => {
            const buffer = await page.screenshot();
            return buffer.toString('base64');
        }
    };
}
```

#### Option 2: Static Object (Simple Cases)

For simple functions that don't need page access:

```javascript
export const exposedFunctions = {
    expectToBeTrue: async () => {
        return true;
    },

    addNumbers: async (a, b) => {
        return a + b;
    }
};
```

### Use the functions in Swift tests

```swift
import XCTest
import JavaScriptKit
import JavaScriptEventLoop

final class CheckTests: XCTestCase {
    func testExpectToBeTrue() async throws {
        guard let expectToBeTrue = JSObject.global.expectToBeTrue.function
        else { return XCTFail("Function expectToBeTrue not found") }

        // Functions exposed via Playwright return Promises
        guard let promiseObject = expectToBeTrue().object
        else { return XCTFail("expectToBeTrue() did not return an object") }

        guard let promise = JSPromise(promiseObject)
        else { return XCTFail("expectToBeTrue() did not return a Promise") }

        let resultValue = try await promise.value
        guard let result = resultValue.boolean
        else { return XCTFail("expectToBeTrue() returned nil") }

        XCTAssertTrue(result)
    }
}
```

### Run tests with the expose script

```bash
swift package js test --environment browser --playwright-expose path/to/expose.js
```

### Backward Compatibility

You can also use `--prelude` to define exposed functions, which allows combining WASM setup options (`setupOptions`) and Playwright exposed functions in one file:

```bash
swift package js test --environment browser --prelude path/to/prelude.js
```

However, using `--playwright-expose` is recommended for clarity and separation of concerns.

## Advanced Usage

### Access to Page Context

When you export a function (as shown in Option 1), you receive the Playwright `page` object, which gives you full access to the browser page. This is powerful because you can:

- **Query the DOM**: `await page.$('selector')`
- **Execute JavaScript**: `await page.evaluate('...')`
- **Take screenshots**: `await page.screenshot()`
- **Navigate**: `await page.goto('...')`
- **Handle events**: `page.on('console', ...)`

### Async Initialization

You can perform async initialization before returning your functions:

```javascript
export async function exposedFunctions(page) {
    // Perform async setup
    const config = await loadConfiguration();

    // Navigate to a specific page if needed
    await page.goto('http://example.com');

    return {
        expectToBeTrue: async () => true,

        getConfig: async () => config,

        // Function that uses both page and initialization data
        checkElement: async (selector) => {
            const element = await page.$(selector);
            return element !== null;
        }
    };
}
```

### Best Practices

1. **Always use `async` functions**: All exposed functions are async from the browser's perspective
2. **Capture `page` in closures**: Functions returned from `exposedFunctions(page)` can access `page` via closure
3. **Handle errors**: Wrap page interactions in try-catch blocks
4. **Return serializable data**: Functions can only return JSON-serializable values
