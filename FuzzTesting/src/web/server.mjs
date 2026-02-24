// @ts-check

import http from 'node:http';
import path from 'node:path';
import fs from 'node:fs';

import { generateTestCase } from '../cli.mjs';
import { emitSwift } from '../emit/swift-emitter.mjs';
import { emitJS } from '../emit/js-emitter.mjs';
import { setupWorkerProject, writeTestCase } from '../emit/project.mjs';
import { buildAndBundle } from '../runner/build.mjs';
import { executeHarness } from '../runner/execute.mjs';
import { FailureTracker } from '../runner/failures.mjs';
import { WorkerPool } from '../runner/worker-pool.mjs';
import { dashboardHTML } from './dashboard.mjs';

/**
 * @typedef {import('../types.mjs').FailurePhase} FailurePhase
 */

/**
 * @typedef {{
 *   port: number,
 *   fuzzTestingDir: string,
 *   jskitPath: string,
 *   numWorkers: number,
 *   iterations: number,
 *   startSeed: number,
 *   maxDepth: number,
 *   maxParams: number,
 *   maxOps: number,
 *   timeout: number,
 *   verbose: boolean,
 *   onFailure?: string,
 * }} ServerOptions
 */

/**
 * Shared fuzzer state visible to API handlers and SSE clients.
 */
class FuzzerState {
  /** @type {number} */ totalIterations = 0;
  /** @type {number} */ totalFailures = 0;
  /** @type {number} */ startTime = Date.now();
  /** @type {boolean} */ running = false;
  /** @type {boolean} */ paused = false;
  /** @type {Map<string, number>} */ typeCoverage = new Map();
  /** @type {Array<{ seed: number, ok: boolean, phase?: string, time: number }>} */ recentResults = [];
  /** @type {number} */ currentSeed = 0;

  /** @type {Set<http.ServerResponse>} */
  sseClients = new Set();

  /**
   * Broadcast a Server-Sent Event to all connected clients.
   * @param {string} event
   * @param {*} data
   */
  broadcast(event, data) {
    const msg = `event: ${event}\ndata: ${JSON.stringify(data)}\n\n`;
    for (const res of this.sseClients) {
      try { res.write(msg); } catch { this.sseClients.delete(res); }
    }
  }

  statusJSON() {
    const elapsed = (Date.now() - this.startTime) / 1000;
    return {
      running: this.running,
      paused: this.paused,
      totalIterations: this.totalIterations,
      totalFailures: this.totalFailures,
      elapsed: elapsed.toFixed(1),
      throughput: elapsed > 0 ? (this.totalIterations / elapsed).toFixed(2) : '0',
      currentSeed: this.currentSeed,
    };
  }
}

/**
 * Start the fuzzer with an HTTP dashboard.
 * @param {ServerOptions} options
 */
export async function startServer(options) {
  const {
    port, fuzzTestingDir, jskitPath, numWorkers, iterations, startSeed,
    maxDepth, maxParams, maxOps, timeout, verbose, onFailure,
  } = options;

  const failCasesDir = path.join(fuzzTestingDir, 'FailCases');
  const tracker = new FailureTracker(failCasesDir, { onFailureHook: onFailure });
  const state = new FuzzerState();
  const genOpts = { maxDepth, maxParams, maxOps };

  // ---- HTTP Server ----
  const server = http.createServer((req, res) => {
    const url = new URL(req.url ?? '/', `http://localhost:${port}`);
    const pathname = url.pathname;

    // CORS for dev convenience
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    if (req.method === 'OPTIONS') { res.writeHead(204); res.end(); return; }

    // ---- Routes ----
    if (pathname === '/' && req.method === 'GET') {
      res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
      res.end(dashboardHTML());
      return;
    }

    if (pathname === '/api/status' && req.method === 'GET') {
      json(res, state.statusJSON());
      return;
    }

    if (pathname === '/api/failures' && req.method === 'GET') {
      json(res, tracker.list());
      return;
    }

    if (pathname.startsWith('/api/failures/') && req.method === 'GET') {
      const id = pathname.slice('/api/failures/'.length);
      const failDir = path.join(failCasesDir, id);
      if (!fs.existsSync(failDir)) { notFound(res); return; }
      const meta = safeReadJSON(path.join(failDir, 'metadata.json'));
      const swift = safeRead(path.join(failDir, 'main.swift'));
      const harness = safeRead(path.join(failDir, 'harness.mjs'));
      const error = safeRead(path.join(failDir, 'error.txt'));
      json(res, { ...meta, files: { 'main.swift': swift, 'harness.mjs': harness, 'error.txt': error } });
      return;
    }

    if (pathname === '/api/coverage' && req.method === 'GET') {
      json(res, Object.fromEntries(state.typeCoverage));
      return;
    }

    if (pathname === '/api/recent' && req.method === 'GET') {
      json(res, state.recentResults.slice(-100));
      return;
    }

    if (pathname === '/api/events' && req.method === 'GET') {
      res.writeHead(200, {
        'Content-Type': 'text/event-stream',
        'Cache-Control': 'no-cache',
        'Connection': 'keep-alive',
      });
      res.write(`data: ${JSON.stringify(state.statusJSON())}\n\n`);
      state.sseClients.add(res);
      req.on('close', () => state.sseClients.delete(res));
      return;
    }

    if (pathname === '/api/control/pause' && req.method === 'POST') {
      state.paused = true;
      state.broadcast('status', state.statusJSON());
      json(res, { ok: true, paused: true });
      return;
    }

    if (pathname === '/api/control/resume' && req.method === 'POST') {
      state.paused = false;
      state.broadcast('status', state.statusJSON());
      json(res, { ok: true, paused: false });
      return;
    }

    notFound(res);
  });

  server.listen(port, () => {
    console.log(`Dashboard: http://localhost:${port}/`);
    console.log(`API:       http://localhost:${port}/api/status`);
    console.log(`SSE:       http://localhost:${port}/api/events`);
    console.log('');
  });

  // ---- Collect types for coverage tracking ----
  /**
   * @param {import('../types.mjs').TestCase} testCase
   */
  function trackCoverage(testCase) {
    /** @param {import('../types.mjs').BridgeType} t */
    function walk(t) {
      state.typeCoverage.set(t.kind, (state.typeCoverage.get(t.kind) ?? 0) + 1);
      if (t.kind === 'nullable') walk(t.wrapped);
      else if (t.kind === 'array') walk(t.element);
      else if (t.kind === 'dictionary') walk(t.value);
    }
    for (const tf of testCase.testFuncs) {
      walk(tf.returnType);
      for (const p of tf.params) walk(p.type);
    }
  }

  /**
   * @param {import('../types.mjs').TestCase} testCase
   * @returns {string[]}
   */
  function collectTypes(testCase) {
    /** @type {Set<string>} */
    const kinds = new Set();
    /** @param {import('../types.mjs').BridgeType} t */
    function walk(t) { kinds.add(t.kind); if (t.kind === 'nullable') walk(t.wrapped); else if (t.kind === 'array') walk(t.element); else if (t.kind === 'dictionary') walk(t.value); }
    for (const func of testCase.env.importedFuncs) { walk(func.returnType); for (const p of func.params) walk(p.type); }
    for (const cls of testCase.env.importedClasses) { for (const p of cls.constructorParams) walk(p.type); }
    for (const tf of testCase.testFuncs) { walk(tf.returnType); for (const p of tf.params) walk(p.type); }
    return [...kinds].sort();
  }

  // ---- Run the fuzzer ----
  state.running = true;
  state.currentSeed = startSeed;

  if (numWorkers > 1) {
    const pool = new WorkerPool({ fuzzTestingDir, jskitPath, numWorkers, timeout, verbose });
    console.log(`Initializing ${numWorkers} workers...`);
    await pool.initialize();

    await pool.run({
      startSeed,
      iterations,
      generateJob(seed) {
        // Respect pause
        state.currentSeed = seed;
        const testCase = generateTestCase(seed, genOpts);
        trackCoverage(testCase);
        return { seed, swiftSource: emitSwift(testCase), jsSource: emitJS(testCase) };
      },
      async onResult(result) {
        state.totalIterations++;
        const entry = { seed: result.seed, ok: result.success, phase: result.phase, time: Date.now() };
        state.recentResults.push(entry);
        if (state.recentResults.length > 500) state.recentResults.shift();

        if (!result.success) {
          state.totalFailures++;
          const testCase = generateTestCase(result.seed, genOpts);
          const phase = /** @type {FailurePhase} */ (result.phase ?? 'runtime-error');
          await tracker.record(
            result.seed, phase, result.error ?? 'Unknown error',
            { 'main.swift': emitSwift(testCase), 'harness.mjs': emitJS(testCase) },
            { typesInvolved: collectTypes(testCase) },
          );
        }

        state.broadcast('result', entry);
        state.broadcast('status', state.statusJSON());
      },
    });

    await pool.shutdown();
  } else {
    // Sequential mode
    const workerDir = path.join(fuzzTestingDir, 'WorkerProject');
    setupWorkerProject(workerDir, jskitPath);

    let seed = startSeed;
    while (true) {
      if (iterations > 0 && state.totalIterations >= iterations) break;
      if (state.paused) { await delay(200); continue; }

      state.currentSeed = seed;
      const testCase = generateTestCase(seed, genOpts);
      trackCoverage(testCase);
      const swiftSource = emitSwift(testCase);
      const jsSource = emitJS(testCase);

      writeTestCase(workerDir, swiftSource);
      const buildResult = await buildAndBundle(workerDir, { timeout, verbose });

      /** @type {{ seed: number, ok: boolean, phase?: string, time: number }} */
      let entry;

      if (!buildResult.success) {
        state.totalFailures++;
        await tracker.record(seed, 'compile-error', buildResult.error ?? '', { 'main.swift': swiftSource, 'harness.mjs': jsSource }, { typesInvolved: collectTypes(testCase) });
        entry = { seed, ok: false, phase: 'compile-error', time: Date.now() };
      } else {
        const outputDir = /** @type {string} */ (buildResult.outputDir);
        const harnessPath = path.join(outputDir, 'harness.mjs');
        fs.writeFileSync(harnessPath, jsSource, 'utf-8');
        const execResult = await executeHarness(harnessPath, { timeout, verbose });

        if (!execResult.success) {
          state.totalFailures++;
          const phase = /** @type {FailurePhase} */ (execResult.phase ?? 'runtime-error');
          await tracker.record(seed, phase, execResult.error ?? '', { 'main.swift': swiftSource, 'harness.mjs': jsSource }, { typesInvolved: collectTypes(testCase) });
          entry = { seed, ok: false, phase, time: Date.now() };
        } else {
          entry = { seed, ok: true, time: Date.now() };
        }
      }

      state.totalIterations++;
      state.recentResults.push(entry);
      if (state.recentResults.length > 500) state.recentResults.shift();
      state.broadcast('result', entry);
      state.broadcast('status', state.statusJSON());
      seed++;
    }
  }

  state.running = false;
  state.broadcast('status', state.statusJSON());
  console.log('\nFuzzing complete. Dashboard remains running. Press Ctrl-C to exit.');
}

// ---- Helpers ----

/** @param {http.ServerResponse} res @param {*} data */
function json(res, data) {
  res.writeHead(200, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify(data));
}

/** @param {http.ServerResponse} res */
function notFound(res) {
  res.writeHead(404, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify({ error: 'not found' }));
}

/** @param {string} p @returns {string} */
function safeRead(p) { try { return fs.readFileSync(p, 'utf-8'); } catch { return ''; } }

/** @param {string} p @returns {*} */
function safeReadJSON(p) { try { return JSON.parse(fs.readFileSync(p, 'utf-8')); } catch { return {}; } }

/** @param {number} ms @returns {Promise<void>} */
function delay(ms) { return new Promise(r => setTimeout(r, ms)); }
