// Function definition to expose console.log to Swift
// Will be imported as a Swift function: consoleLog(message: String)
export function consoleLog(message: string): void

// TypeScript interface types are converted to Swift structs
// This defines a subset of the browser's HTMLElement interface
type HTMLElement = Pick<globalThis.HTMLElement, "innerText"> & {
    // Methods with object parameters are properly handled
    appendChild(child: HTMLElement): void
}

// TypeScript object type with read-only properties
// Properties will become Swift properties with appropriate access level
type Document = {
    // Regular property - will be read/write in Swift
    title: string
    // Read-only property - will be read-only in Swift
    readonly body: HTMLElement
    // Method returning an object - will become a Swift method returning an HTMLElement
    createElement(tagName: string): HTMLElement
}
// Function returning a complex object
// Will be imported as a Swift function: getDocument() -> Document
export function getDocument(): Document
