// @ts-check
import { BridgeJSPlayground } from './app.js';

Error.stackTraceLimit = Infinity;

// Initialize the playground when the page loads
document.addEventListener('DOMContentLoaded', async () => {
    try {
        const playground = new BridgeJSPlayground();
        await playground.initialize();
    } catch (error) {
        console.error('Failed to initialize playground:', error);
    }
});
