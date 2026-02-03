// @ts-check
import { describe, it, expect } from 'vitest';
import { readdirSync } from 'fs';
import { fileURLToPath } from 'url';
import path from 'path';
import { run } from '../src/cli.js';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

/** Path to BridgeJSToolTests/Inputs/TypeScript (.d.ts fixtures and tsconfig). */
const inputsDir = path.resolve(__dirname, 'fixtures');
const tsconfigPath = path.join(inputsDir, 'tsconfig.json');

function runTs2Swift(dtsPath) {
    return run(dtsPath, { tsconfigPath, logLevel: 'error' });
}

function collectDtsInputs() {
    const entries = readdirSync(inputsDir, { withFileTypes: true });
    return entries
        .filter((e) => e.isFile() && e.name.endsWith('.d.ts'))
        .map((e) => e.name)
        .sort();
}

describe('ts2swift', () => {
    const dtsFiles = collectDtsInputs();
    if (dtsFiles.length === 0) {
        it.skip('no .d.ts fixtures found in BridgeJSToolTests/Inputs', () => {});
        return;
    }

    for (const dtsFile of dtsFiles) {
        it(`snapshots Swift output for ${dtsFile}`, () => {
            const dtsPath = path.join(inputsDir, dtsFile);
            const swiftOutput = runTs2Swift(dtsPath);
            const name = dtsFile.replace(/\.d\.ts$/, '');
            expect(swiftOutput).toMatchSnapshot(name);
        });
    }
});
