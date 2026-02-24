// @ts-check

import { spawn } from 'node:child_process';
import fs from 'node:fs';
import path from 'node:path';

/**
 * @typedef {{
 *   swiftSdkId?: string,
 *   timeout?: number,
 *   verbose?: boolean
 * }} BuildOptions
 */

/**
 * @typedef {{
 *   success: boolean,
 *   error?: string,
 *   outputDir?: string
 * }} BuildResult
 */

/**
 * Run a command in a child process and capture stdout+stderr.
 * @param {string} cmd
 * @param {string[]} args
 * @param {string} cwd
 * @param {{ timeout?: number, verbose?: boolean }} options
 * @returns {Promise<{ code: number|null, stdout: string, stderr: string }>}
 */
function runProcess(cmd, args, cwd, options = {}) {
  const { timeout = 120_000, verbose = false } = options;
  return new Promise((resolve, reject) => {
    const child = spawn(cmd, args, {
      cwd,
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
      reject(err);
    });

    child.on('close', (code) => {
      resolve({
        code,
        stdout: stdoutChunks.join(''),
        stderr: stderrChunks.join(''),
      });
    });
  });
}

/**
 * Build the Swift package and bundle it for Node.js using `swift package js`.
 *
 * @param {string} workerDir — Path to the Swift package directory
 * @param {BuildOptions} [options]
 * @returns {Promise<BuildResult>}
 */
export async function buildAndBundle(workerDir, options = {}) {
  const {
    swiftSdkId = process.env.SWIFT_SDK_ID ?? 'wasm32-unknown-wasi',
    timeout = 120_000,
    verbose = false,
  } = options;

  // `swift package js` does both the build and the JS bundling in one step.
  const outputDir = path.join(workerDir, '.build', 'plugins', 'PackageToJS', 'outputs', 'Package');
  const result = await runProcess(
    'swift',
    [
      'package',
      '--swift-sdk', swiftSdkId,
      '--disable-sandbox',
      'js',
    ],
    workerDir,
    { timeout, verbose },
  );

  if (result.code !== 0) {
    const combined = (result.stderr + '\n' + result.stdout).trim();

    // Classify: if the Swift source compiled but packaging failed, it's still compile-error
    // from the fuzzer's perspective — the generated code didn't produce a runnable bundle.
    return {
      success: false,
      error: combined,
    };
  }

  // Install npm dependencies (e.g. @bjorn3/browser_wasi_shim) if package.json exists
  const pkgJson = path.join(outputDir, 'package.json');
  const nodeModules = path.join(outputDir, 'node_modules');
  if (fs.existsSync(pkgJson) && !fs.existsSync(nodeModules)) {
    const npmResult = await runProcess(
      'npm',
      ['install', '--no-audit', '--no-fund'],
      outputDir,
      { timeout: 60_000, verbose },
    );
    if (npmResult.code !== 0) {
      return {
        success: false,
        error: 'npm install failed:\n' + (npmResult.stderr + '\n' + npmResult.stdout).trim(),
      };
    }
  }

  return {
    success: true,
    outputDir,
  };
}
