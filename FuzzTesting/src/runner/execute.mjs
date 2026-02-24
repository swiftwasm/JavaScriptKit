// @ts-check

import { spawn } from 'node:child_process';

/**
 * @typedef {import('../types.mjs').FailurePhase} FailurePhase
 */

/**
 * @typedef {{
 *   timeout?: number,
 *   verbose?: boolean
 * }} ExecuteOptions
 */

/**
 * @typedef {{
 *   success: boolean,
 *   phase?: FailurePhase,
 *   error?: string
 * }} ExecuteResult
 */

/**
 * Classify stderr output into a FailurePhase.
 * @param {string} stderr
 * @returns {FailurePhase}
 */
function classifyError(stderr) {
  if (/RuntimeError|unreachable/i.test(stderr)) {
    return 'runtime-trap';
  }
  if (/LinkError|import/i.test(stderr)) {
    return 'link-error';
  }
  if (/AssertionError/i.test(stderr)) {
    return 'wrong-result';
  }
  return 'runtime-error';
}

/**
 * Execute a Node.js harness script and classify the result.
 *
 * @param {string} harnessPath — Absolute path to the harness .mjs file
 * @param {ExecuteOptions} [options]
 * @returns {Promise<ExecuteResult>}
 */
export async function executeHarness(harnessPath, options = {}) {
  const { timeout = 30_000, verbose = false } = options;

  return new Promise((resolve, reject) => {
    const child = spawn('node', [harnessPath], {
      stdio: ['ignore', 'pipe', 'pipe'],
      timeout,
    });

    /** @type {string[]} */
    const stdoutChunks = [];
    /** @type {string[]} */
    const stderrChunks = [];

    child.stdout.on('data', (/** @type {Buffer} */ chunk) => {
      const text = chunk.toString();
      stdoutChunks.push(text);
      if (verbose) process.stdout.write(text);
    });

    child.stderr.on('data', (/** @type {Buffer} */ chunk) => {
      const text = chunk.toString();
      stderrChunks.push(text);
      if (verbose) process.stderr.write(text);
    });

    child.on('error', (err) => {
      resolve({
        success: false,
        phase: 'runtime-error',
        error: err.message,
      });
    });

    child.on('close', (code) => {
      const stderr = stderrChunks.join('');
      const stdout = stdoutChunks.join('');

      if (code === 0) {
        resolve({ success: true });
      } else {
        const combined = (stderr + '\n' + stdout).trim();
        resolve({
          success: false,
          phase: classifyError(combined),
          error: combined,
        });
      }
    });
  });
}
