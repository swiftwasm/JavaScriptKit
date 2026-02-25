/**
 * Benchmark runner for JSObjectSpace implementations.
 * Run with: npm run bench (builds via rollup.bench.mjs, then node bench/dist/bench.mjs)
 */

import { JSObjectSpace } from "../src/object-heap.js";
import { JSObjectSpaceOriginal } from "./_original.js";

export interface HeapLike {
    retain(value: unknown): number;
    release(ref: number): void;
    getObject(ref: number): unknown;
}

const ITERATIONS = 5;
const HEAVY_OPS = 200_000;
const FILL_LEVELS = [1_000, 10_000, 50_000] as const;
const MIXED_OPS_PER_LEVEL = 100_000;

function median(numbers: number[]): number {
    const sorted = [...numbers].sort((a, b) => a - b);
    const mid = Math.floor(sorted.length / 2);
    return sorted.length % 2 !== 0
        ? sorted[mid]!
        : (sorted[mid - 1]! + sorted[mid]!) / 2;
}

function runHeavyRetain(Heap: new () => HeapLike): number {
    const times: number[] = [];
    for (let iter = 0; iter < ITERATIONS; iter++) {
        const heap = new Heap();
        const start = performance.now();
        for (let i = 0; i < HEAVY_OPS; i++) {
            heap.retain({ __i: i });
        }
        times.push(performance.now() - start);
    }
    return median(times);
}

function runHeavyRelease(Heap: new () => HeapLike): number {
    const times: number[] = [];
    for (let iter = 0; iter < ITERATIONS; iter++) {
        const heap = new Heap();
        const refs: number[] = [];
        for (let i = 0; i < HEAVY_OPS; i++) {
            refs.push(heap.retain({ __i: i }));
        }
        const start = performance.now();
        for (let i = 0; i < HEAVY_OPS; i++) {
            heap.release(refs[i]!);
        }
        times.push(performance.now() - start);
    }
    return median(times);
}

function runMixedFillLevel(Heap: new () => HeapLike, fillLevel: number): number {
    const times: number[] = [];
    for (let iter = 0; iter < ITERATIONS; iter++) {
        const heap = new Heap();
        const refs: number[] = [];
        for (let i = 0; i < fillLevel; i++) {
            refs.push(heap.retain({ __i: i }));
        }
        let nextId = fillLevel;
        const start = performance.now();
        for (let i = 0; i < MIXED_OPS_PER_LEVEL; i++) {
            const idx = i % fillLevel;
            heap.release(refs[idx]!);
            refs[idx] = heap.retain({ __i: nextId++ });
        }
        times.push(performance.now() - start);
    }
    return median(times);
}

function runBenchmark(
    name: string,
    Heap: new () => HeapLike,
): { name: string; heavyRetain: number; heavyRelease: number; mixed: Record<string, number> } {
    return {
        name,
        heavyRetain: runHeavyRetain(Heap),
        heavyRelease: runHeavyRelease(Heap),
        mixed: {
            "1k": runMixedFillLevel(Heap, 1_000),
            "10k": runMixedFillLevel(Heap, 10_000),
            "50k": runMixedFillLevel(Heap, 50_000),
        },
    };
}

function main() {
    const implementations: Array<{ name: string; Heap: new () => HeapLike }> = [
        { name: "JSObjectSpaceOriginal", Heap: JSObjectSpaceOriginal },
        { name: "JSObjectSpace (current)", Heap: JSObjectSpace },
    ];

    console.log("JSObjectSpace benchmark");
    console.log("======================\n");
    console.log(
        `Heavy retain: ${HEAVY_OPS} ops, Heavy release: ${HEAVY_OPS} ops`,
    );
    console.log(
        `Mixed: ${MIXED_OPS_PER_LEVEL} ops per fill level (${FILL_LEVELS.join(", ")})`,
    );
    console.log(`Median of ${ITERATIONS} runs per scenario.\n`);

    const results: Array<ReturnType<typeof runBenchmark>> = [];
    for (const { name, Heap } of implementations) {
        console.log(`Running ${name}...`);
        runBenchmark(name, Heap);
        results.push(runBenchmark(name, Heap));
    }

    console.log("\nResults (median ms):\n");
    const pad = Math.max(...results.map((r) => r.name.length));
    for (const r of results) {
        console.log(
            `${r.name.padEnd(pad)}  retain: ${r.heavyRetain.toFixed(2)}ms  release: ${r.heavyRelease.toFixed(2)}ms  mixed(1k): ${r.mixed["1k"].toFixed(2)}ms  mixed(10k): ${r.mixed["10k"].toFixed(2)}ms  mixed(50k): ${r.mixed["50k"].toFixed(2)}ms`,
        );
    }

    const total = (r: (typeof results)[0]) =>
        r.heavyRetain + r.heavyRelease + r.mixed["1k"] + r.mixed["10k"] + r.mixed["50k"];
    const best = results.reduce((a, b) => (total(a) <= total(b) ? a : b));
    console.log(`\nFastest overall (sum of medians): ${best.name}`);
}

main();
