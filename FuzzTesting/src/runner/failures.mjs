// @ts-check

import fs from 'node:fs';
import path from 'node:path';
import { createHash } from 'node:crypto';
import { spawn } from 'node:child_process';

/**
 * @typedef {import('../types.mjs').FailurePhase} FailurePhase
 * @typedef {import('../types.mjs').FailureMetadata} FailureMetadata
 */

/**
 * Extract the first meaningful line from an error string.
 * Skips empty lines and lines starting with "node:".
 * @param {string} error
 * @returns {string}
 */
function firstMeaningfulLine(error) {
  const lines = error.split('\n');
  for (const line of lines) {
    const trimmed = line.trim();
    if (trimmed === '') continue;
    if (trimmed.startsWith('node:')) continue;
    return trimmed;
  }
  return error.trim().slice(0, 200);
}

/**
 * Compute a fingerprint hash for deduplication.
 * @param {FailurePhase} phase
 * @param {string} error
 * @returns {string}
 */
function computeFingerprint(phase, error) {
  const key = phase + '\n' + firstMeaningfulLine(error);
  return createHash('sha256').update(key).digest('hex').slice(0, 16);
}

/**
 * @typedef {{
 *   onFailureHook?: string
 * }} FailureTrackerOptions
 */

/**
 * Tracks and deduplicates failures, writing them to disk.
 */
export class FailureTracker {
  /** @type {string} */
  #failCasesDir;
  /** @type {string|undefined} */
  #onFailureHook;
  /** @type {Map<string, string>} fingerprint -> dirName */
  #known;
  /** @type {number} */
  #nextId;

  /**
   * @param {string} failCasesDir
   * @param {FailureTrackerOptions} [options]
   */
  constructor(failCasesDir, options = {}) {
    this.#failCasesDir = failCasesDir;
    this.#onFailureHook = options.onFailureHook;
    this.#known = new Map();
    this.#nextId = 1;

    // Scan existing failure directories to resume numbering and dedup
    if (fs.existsSync(failCasesDir)) {
      const entries = fs.readdirSync(failCasesDir, { withFileTypes: true });
      for (const entry of entries) {
        if (!entry.isDirectory()) continue;
        const match = entry.name.match(/^(\d+)-/);
        if (!match) continue;
        const id = parseInt(match[1], 10);
        if (id >= this.#nextId) {
          this.#nextId = id + 1;
        }
        // Load fingerprint from metadata if available
        const metaPath = path.join(failCasesDir, entry.name, 'metadata.json');
        if (fs.existsSync(metaPath)) {
          try {
            const meta = JSON.parse(fs.readFileSync(metaPath, 'utf-8'));
            if (meta.fingerprint) {
              this.#known.set(meta.fingerprint, entry.name);
            }
          } catch {
            // Ignore corrupt metadata
          }
        }
      }
    }
  }

  /**
   * Record a failure. Returns the failure directory path if new, null if duplicate.
   *
   * @param {number} seed
   * @param {FailurePhase} phase
   * @param {string} error
   * @param {{ 'main.swift': string, 'harness.mjs': string }} files
   * @param {{ typesInvolved?: string[] }} [extra]
   * @returns {Promise<string|null>}
   */
  async record(seed, phase, error, files, extra = {}) {
    const fingerprint = computeFingerprint(phase, error);

    // Check for duplicate
    if (this.#known.has(fingerprint)) {
      return null;
    }

    // Create failure directory
    const idStr = String(this.#nextId).padStart(3, '0');
    const dirName = `${idStr}-${phase}`;
    const failDir = path.join(this.#failCasesDir, dirName);
    fs.mkdirSync(failDir, { recursive: true });

    this.#known.set(fingerprint, dirName);
    this.#nextId++;

    // Write files
    fs.writeFileSync(path.join(failDir, 'seed.json'), JSON.stringify({ seed }, null, 2) + '\n');
    fs.writeFileSync(path.join(failDir, 'main.swift'), files['main.swift']);
    fs.writeFileSync(path.join(failDir, 'harness.mjs'), files['harness.mjs']);
    fs.writeFileSync(path.join(failDir, 'error.txt'), error);

    /** @type {FailureMetadata} */
    const metadata = {
      id: dirName,
      phase,
      fingerprint,
      timestamp: new Date().toISOString(),
      seed,
      typesInvolved: extra.typesInvolved ?? [],
      error: error.slice(0, 2000),
    };
    const metadataJson = JSON.stringify(metadata, null, 2) + '\n';
    fs.writeFileSync(path.join(failDir, 'metadata.json'), metadataJson);

    // Invoke hook if configured
    if (this.#onFailureHook) {
      try {
        const hook = spawn(this.#onFailureHook, [failDir, phase, fingerprint], {
          stdio: ['pipe', 'inherit', 'inherit'],
        });
        hook.stdin.write(metadataJson);
        hook.stdin.end();
        // Don't await — fire and forget
        hook.on('error', () => { /* ignore hook errors */ });
      } catch {
        // Ignore hook spawn errors
      }
    }

    return failDir;
  }

  /**
   * List all recorded failures.
   * @returns {FailureMetadata[]}
   */
  list() {
    /** @type {FailureMetadata[]} */
    const results = [];

    if (!fs.existsSync(this.#failCasesDir)) {
      return results;
    }

    const entries = fs.readdirSync(this.#failCasesDir, { withFileTypes: true });
    for (const entry of entries) {
      if (!entry.isDirectory()) continue;
      const metaPath = path.join(this.#failCasesDir, entry.name, 'metadata.json');
      if (!fs.existsSync(metaPath)) continue;
      try {
        const meta = JSON.parse(fs.readFileSync(metaPath, 'utf-8'));
        results.push(meta);
      } catch {
        // Skip corrupt entries
      }
    }

    return results.sort((a, b) => a.id.localeCompare(b.id));
  }
}
