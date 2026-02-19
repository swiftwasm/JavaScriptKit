// @ts-check
import { describe, it, expect, vi } from 'vitest';
import { readdirSync, mkdtempSync, writeFileSync, rmSync } from 'fs';
import { fileURLToPath } from 'url';
import path from 'path';
import os from 'os';
import { run } from '../src/cli.js';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

/** Path to BridgeJSToolTests/Inputs/TypeScript (.d.ts fixtures and tsconfig). */
const inputsDir = path.resolve(__dirname, 'fixtures');
const tsconfigPath = path.join(inputsDir, 'tsconfig.json');

function runTs2Swift(dtsPath) {
    return run([dtsPath], { tsconfigPath, logLevel: 'error' });
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

    it('reports TypeScript syntax errors via thrown message', () => {
        const tmpDir = mkdtempSync(path.join(os.tmpdir(), 'ts2swift-invalid-'));
        const invalidPath = path.join(tmpDir, 'invalid.d.ts');
        writeFileSync(invalidPath, 'function foo(x');
        try {
            expect(() => runTs2Swift(invalidPath)).toThrowError(/TypeScript syntax errors/);
        } finally {
            rmSync(tmpDir, { recursive: true, force: true });
        }
    });

    it('emits a warning when export assignments cannot be generated', () => {
        const dtsPath = path.join(inputsDir, 'ExportAssignment.d.ts');
        const stderrSpy = vi.spyOn(process.stderr, 'write').mockImplementation(() => true);
        try {
            run([dtsPath], { tsconfigPath, logLevel: 'warning' });
            const combined = stderrSpy.mock.calls.map(args => String(args[0])).join('');
            expect(combined).toMatch(/Skipping export assignment/);
            // Only warn once for the export assignment node
            const occurrences = (combined.match(/Skipping export assignment/g) || []).length;
            expect(occurrences).toBe(1);
        } finally {
            stderrSpy.mockRestore();
        }
    });
});
