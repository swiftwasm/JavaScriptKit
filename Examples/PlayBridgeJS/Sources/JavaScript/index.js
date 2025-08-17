// @ts-check
import { BridgeJSPlayground } from './app.js';

Error.stackTraceLimit = Infinity;

const SWIFT_INPUT = `import JavaScriptKit

@JS public func calculateTotal(price: Double, quantity: Int) -> Double {
    return price * Double(quantity)
}

@JS class ShoppingCart {
    private var items: [(name: String, price: Double, quantity: Int)] = []

    @JS init() {}

    @JS public func addItem(name: String, price: Double, quantity: Int) {
        items.append((name, price, quantity))
    }

    @JS public func getTotal() -> Double {
        return items.reduce(0) { $0 + $1.price * Double($1.quantity) }
    }
}`

const DTS_INPUT = `export type Console = {
    log(message: string): void;
}
export function console(): Console;`

// Initialize the playground when the page loads
document.addEventListener('DOMContentLoaded', async () => {
    try {
        const playground = new BridgeJSPlayground();
        await playground.initialize({
            swift: SWIFT_INPUT,
            dts: DTS_INPUT
        });
    } catch (error) {
        console.error('Failed to initialize playground:', error);
    }
});
