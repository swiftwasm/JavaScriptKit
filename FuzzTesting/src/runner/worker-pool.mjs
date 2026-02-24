// @ts-check

import os from 'node:os';
import fs from 'node:fs';
import path from 'node:path';

import { setupWorkerProject, writeTestCase, getOutputDir } from '../emit/project.mjs';
import { buildAndBundle } from './build.mjs';
import { executeHarness } from './execute.mjs';

/**
 * @typedef {import('../types.mjs').FailurePhase} FailurePhase
 */

/**
 * A single unit of work submitted to the pool.
 * @typedef {{
 *   seed: number,
 *   swiftSource: string,
 *   jsSource: string,
 * }} Job
 */

/**
 * The result returned after a job completes.
 * @typedef {{
 *   success: boolean,
 *   seed: number,
 *   phase?: FailurePhase,
 *   error?: string,
 *   workerIndex: number,
 * }} JobResult
 */

/**
 * Options for constructing a {@link WorkerPool}.
 * @typedef {{
 *   fuzzTestingDir: string,
 *   jskitPath: string,
 *   numWorkers?: number,
 *   timeout?: number,
 *   verbose?: boolean,
 * }} WorkerPoolOptions
 */

/**
 * Snapshot of pool activity counters.
 * @typedef {{
 *   active: number,
 *   idle: number,
 *   completed: number,
 *   failed: number,
 * }} PoolStats
 */

/**
 * Options accepted by {@link WorkerPool.run}.
 * @typedef {{
 *   generateJob: (seed: number) => Job,
 *   onResult: (result: JobResult) => void,
 *   startSeed?: number,
 *   iterations?: number,
 * }} RunOptions
 */

// ============================================================
// Internal types
// ============================================================

/**
 * Internal bookkeeping for a single worker slot.
 * @typedef {{
 *   index: number,
 *   dir: string,
 *   busy: boolean,
 * }} WorkerSlot
 */

/**
 * A queued job together with its settlement callbacks.
 * @typedef {{
 *   job: Job,
 *   resolve: (result: JobResult) => void,
 *   reject: (err: Error) => void,
 * }} PendingJob
 */

// ============================================================
// WorkerPool
// ============================================================

/**
 * Manages N parallel worker directories for fuzz testing.
 *
 * Each worker gets its own SPM project under `Workers/worker-{i}/` with a
 * persistent `.build/` cache.  Jobs are dispatched to the next free worker
 * using a simple internal queue and Promise-based concurrency — no
 * `worker_threads` needed.
 *
 * @example
 * ```js
 * const pool = new WorkerPool({
 *   fuzzTestingDir: '/path/to/FuzzTesting',
 *   jskitPath: '/path/to/JavaScriptKit',
 *   numWorkers: 4,
 * });
 * await pool.initialize();
 *
 * const result = await pool.submit({ seed: 42, swiftSource: '...', jsSource: '...' });
 * console.log(result);
 *
 * await pool.shutdown();
 * ```
 */
export class WorkerPool {
  /** @type {string} */
  #fuzzTestingDir;
  /** @type {string} */
  #jskitPath;
  /** @type {number} */
  #numWorkers;
  /** @type {number} */
  #timeout;
  /** @type {boolean} */
  #verbose;

  /** @type {WorkerSlot[]} */
  #workers;
  /** @type {boolean} */
  #initialized;
  /** @type {boolean} */
  #shuttingDown;

  /** @type {PendingJob[]} */
  #queue;

  // Counters
  /** @type {number} */
  #completed;
  /** @type {number} */
  #failed;

  /**
   * @param {WorkerPoolOptions} options
   */
  constructor(options) {
    this.#fuzzTestingDir = options.fuzzTestingDir;
    this.#jskitPath = options.jskitPath;
    this.#numWorkers = options.numWorkers ?? Math.max(1, Math.floor(os.cpus().length / 2));
    this.#timeout = options.timeout ?? 120_000;
    this.#verbose = options.verbose ?? false;
    this.#workers = [];
    this.#initialized = false;
    this.#shuttingDown = false;
    this.#queue = [];
    this.#completed = 0;
    this.#failed = 0;
  }

  /**
   * Path to the `Workers/` directory that contains all worker subdirectories.
   * @returns {string}
   */
  get workersDir() {
    return path.join(this.#fuzzTestingDir, 'Workers');
  }

  /**
   * Number of workers in the pool.
   * @returns {number}
   */
  get numWorkers() {
    return this.#numWorkers;
  }

  // ============================================================
  // Lifecycle
  // ============================================================

  /**
   * Initialize all worker directories.
   *
   * Creates `Workers/worker-{i}/` with `Package.swift` and `Sources/` for
   * each worker.  If a legacy `WorkerProject/.build/` cache exists, it is
   * copied to every worker that does not yet have its own `.build/`
   * directory, giving cold builds a head start.
   *
   * @returns {Promise<void>}
   */
  async initialize() {
    const workersBase = this.workersDir;
    fs.mkdirSync(workersBase, { recursive: true });

    // Legacy single-worker build cache from the original sequential runner
    const legacyBuildDir = path.join(this.#fuzzTestingDir, 'WorkerProject', '.build');
    const hasLegacyCache = fs.existsSync(legacyBuildDir);

    this.#workers = [];

    for (let i = 0; i < this.#numWorkers; i++) {
      const workerDir = path.join(workersBase, `worker-${i}`);

      // Set up SPM project structure (Package.swift + Sources/FuzzTarget/)
      setupWorkerProject(workerDir, this.#jskitPath);

      // Seed the build cache from the legacy WorkerProject if this worker
      // doesn't already have one.
      const workerBuildDir = path.join(workerDir, '.build');
      if (hasLegacyCache && !fs.existsSync(workerBuildDir)) {
        if (this.#verbose) {
          console.log(`worker-${i}: copying build cache from WorkerProject`);
        }
        fs.cpSync(legacyBuildDir, workerBuildDir, { recursive: true });
      }

      this.#workers.push({
        index: i,
        dir: workerDir,
        busy: false,
      });
    }

    this.#initialized = true;
  }

  /**
   * Gracefully shut down the pool.
   *
   * Signals the {@link run} loop to stop dispatching new jobs.  Jobs that
   * have already been submitted will still run to completion.
   *
   * @returns {Promise<void>}
   */
  async shutdown() {
    this.#shuttingDown = true;

    // Wait for every worker to become idle
    while (this.#workers.some((w) => w.busy)) {
      await delay(50);
    }
  }

  // ============================================================
  // Job submission
  // ============================================================

  /**
   * Submit a single job to the pool.
   *
   * If a worker is immediately available the job starts right away;
   * otherwise it is placed in an internal FIFO queue and will be picked up
   * as soon as a worker finishes its current job.
   *
   * @param {Job} job
   * @returns {Promise<JobResult>}
   */
  submit(job) {
    this.#assertInitialized();

    return new Promise((resolve, reject) => {
      this.#queue.push({ job, resolve, reject });
      this.#dispatch();
    });
  }

  /**
   * Run an iteration loop, dispatching jobs across all workers in parallel.
   *
   * Generates jobs via `generateJob(seed)` and reports each result via
   * `onResult`.  Runs `iterations` total jobs; pass 0 for unlimited
   * (runs until {@link shutdown} is called).
   *
   * @param {RunOptions} options
   * @returns {Promise<void>}
   */
  async run(options) {
    this.#assertInitialized();

    const { generateJob, onResult, startSeed = 0, iterations = 0 } = options;
    const unlimited = iterations === 0;

    let nextSeed = startSeed;
    let dispatched = 0;

    /** @type {Set<Promise<void>>} */
    const inflight = new Set();

    while (!this.#shuttingDown && (unlimited || dispatched < iterations)) {
      // Back-pressure: don't enqueue faster than workers can drain.
      // Wait for at least one slot when all workers are busy.
      if (inflight.size >= this.#numWorkers) {
        await Promise.race(inflight);
        continue; // re-check loop condition after a job completes
      }

      const seed = nextSeed++;
      dispatched++;

      const job = generateJob(seed);

      /** @type {Promise<void>} */
      const p = this.submit(job).then(
        (result) => {
          inflight.delete(p);
          onResult(result);
        },
        (err) => {
          inflight.delete(p);
          // Surface unexpected internal errors as a failed result so the
          // caller's onResult still fires and the loop doesn't silently
          // swallow the error.
          onResult({
            success: false,
            seed,
            phase: 'runtime-error',
            error: err instanceof Error ? err.message : String(err),
            workerIndex: -1,
          });
        },
      );
      inflight.add(p);
    }

    // Drain all remaining in-flight jobs
    await Promise.all(inflight);
  }

  // ============================================================
  // Stats
  // ============================================================

  /**
   * Get a snapshot of current pool statistics.
   * @returns {PoolStats}
   */
  stats() {
    const active = this.#workers.filter((w) => w.busy).length;
    return {
      active,
      idle: this.#numWorkers - active,
      completed: this.#completed,
      failed: this.#failed,
    };
  }

  // ============================================================
  // Private — dispatch / execution
  // ============================================================

  /**
   * Try to pair queued jobs with idle workers.  Called after a job is
   * enqueued and after a worker finishes its current job.
   */
  #dispatch() {
    while (this.#queue.length > 0) {
      const worker = this.#workers.find((w) => !w.busy);
      if (!worker) break; // all workers busy — wait for one to finish

      const pending = /** @type {PendingJob} */ (this.#queue.shift());
      worker.busy = true;

      this.#executeJob(worker, pending.job).then(
        (result) => {
          worker.busy = false;
          pending.resolve(result);
          // Kick the dispatcher — the now-idle worker can pick up another job
          this.#dispatch();
        },
        (err) => {
          worker.busy = false;
          pending.reject(err);
          this.#dispatch();
        },
      );
    }
  }

  /**
   * Execute a single job on a specific worker: write sources, build, run.
   *
   * @param {WorkerSlot} worker
   * @param {Job} job
   * @returns {Promise<JobResult>}
   */
  async #executeJob(worker, job) {
    const { seed, swiftSource, jsSource } = job;
    const workerDir = worker.dir;

    if (this.#verbose) {
      console.log(`worker-${worker.index}: starting seed ${seed}`);
    }

    // (1) Write the generated Swift source into the worker project
    writeTestCase(workerDir, swiftSource);

    // (2) Build and bundle
    const buildResult = await buildAndBundle(workerDir, {
      timeout: this.#timeout,
      verbose: this.#verbose,
    });

    if (!buildResult.success) {
      this.#completed++;
      this.#failed++;
      return {
        success: false,
        seed,
        phase: 'compile-error',
        error: buildResult.error,
        workerIndex: worker.index,
      };
    }

    // (3) Write the JS harness into the output directory and execute it
    const outputDir = /** @type {string} */ (buildResult.outputDir);
    const harnessPath = path.join(outputDir, 'harness.mjs');
    fs.writeFileSync(harnessPath, jsSource, 'utf-8');

    const execResult = await executeHarness(harnessPath, {
      timeout: this.#timeout,
      verbose: this.#verbose,
    });

    this.#completed++;

    if (!execResult.success) {
      this.#failed++;
      return {
        success: false,
        seed,
        phase: execResult.phase,
        error: execResult.error,
        workerIndex: worker.index,
      };
    }

    return {
      success: true,
      seed,
      workerIndex: worker.index,
    };
  }

  // ============================================================
  // Private — guards
  // ============================================================

  /**
   * Throw if {@link initialize} has not been called yet.
   */
  #assertInitialized() {
    if (!this.#initialized) {
      throw new Error('WorkerPool.initialize() must be called before submitting jobs');
    }
  }
}

// ============================================================
// Utility helpers
// ============================================================

/**
 * Sleep for the given number of milliseconds.
 * @param {number} ms
 * @returns {Promise<void>}
 */
function delay(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
