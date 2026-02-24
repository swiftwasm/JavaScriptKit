// @ts-check

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

import { Random } from './smith/random.mjs';
import { TypeSmith } from './smith/type-smith.mjs';
import { DeclSmith } from './smith/decl-smith.mjs';
import { OpSmith } from './smith/op-smith.mjs';
import { emitSwift } from './emit/swift-emitter.mjs';
import { emitJS } from './emit/js-emitter.mjs';
import { setupWorkerProject, writeTestCase } from './emit/project.mjs';
import { buildAndBundle } from './runner/build.mjs';
import { executeHarness } from './runner/execute.mjs';
import { FailureTracker } from './runner/failures.mjs';
import { WorkerPool } from './runner/worker-pool.mjs';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// ============================================================
// Argument parsing
// ============================================================

/**
 * Parse CLI arguments into a map of flags and positional args.
 * @param {string[]} argv
 * @returns {{ flags: Record<string, string|boolean>, positional: string[] }}
 */
function parseArgs(argv) {
  /** @type {Record<string, string|boolean>} */
  const flags = {};
  /** @type {string[]} */
  const positional = [];

  for (let i = 0; i < argv.length; i++) {
    const arg = argv[i];
    if (arg.startsWith('--')) {
      const key = arg.slice(2);
      // Check if next arg is a value (not another flag)
      if (i + 1 < argv.length && !argv[i + 1].startsWith('--')) {
        flags[key] = argv[i + 1];
        i++;
      } else {
        flags[key] = true;
      }
    } else {
      positional.push(arg);
    }
  }

  return { flags, positional };
}

/**
 * Collect BridgeType kind strings from a TestCase for metadata.
 * @param {import('./types.mjs').TestCase} testCase
 * @returns {string[]}
 */
function collectTypesInvolved(testCase) {
  /** @type {Set<string>} */
  const kinds = new Set();

  /** @param {import('./types.mjs').BridgeType} t */
  function walk(t) {
    kinds.add(t.kind);
    if (t.kind === 'nullable') walk(t.wrapped);
    else if (t.kind === 'array') walk(t.element);
    else if (t.kind === 'dictionary') walk(t.value);
  }

  for (const func of testCase.env.importedFuncs) {
    walk(func.returnType);
    for (const p of func.params) walk(p.type);
  }
  for (const cls of testCase.env.importedClasses) {
    for (const p of cls.constructorParams) walk(p.type);
  }
  for (const tf of testCase.testFuncs) {
    walk(tf.returnType);
    for (const p of tf.params) walk(p.type);
  }

  return [...kinds].sort();
}

// ============================================================
// Test case generation
// ============================================================

/**
 * Generate a complete test case from a seed and options.
 * @param {number} seed
 * @param {{ maxDepth?: number, maxParams?: number, maxOps?: number }} options
 * @returns {import('./types.mjs').TestCase}
 */
export function generateTestCase(seed, options = {}) {
  const { maxDepth = 3, maxParams = 4, maxOps = 6 } = options;

  const rng = new Random(seed);
  const typeSmith = new TypeSmith(rng, { maxDepth });
  const declSmith = new DeclSmith(rng, typeSmith, { maxParams });
  const opSmith = new OpSmith(rng, { maxOps, maxParams });

  // Generate declaration environment
  const env = declSmith.generate();

  // Generate 1-3 test functions
  const numFuncs = rng.nextInt(1, 3);
  /** @type {import('./types.mjs').TestFunc[]} */
  const testFuncs = [];
  for (let i = 0; i < numFuncs; i++) {
    testFuncs.push(opSmith.generateFunc(`testFunc${i}`, env));
  }

  /** @type {import('./types.mjs').TestCase} */
  const testCase = {
    seed,
    env,
    testFuncs,
    jsExpected: [],
  };

  return testCase;
}

// ============================================================
// "run" command
// ============================================================

/**
 * @param {Record<string, string|boolean>} flags
 */
async function cmdRun(flags) {
  const iterations = Number(flags['iterations'] ?? 0);
  const startSeed = Number(flags['seed'] ?? 0);
  const maxDepth = Number(flags['max-depth'] ?? 3);
  const maxParams = Number(flags['max-params'] ?? 4);
  const maxOps = Number(flags['max-ops'] ?? 6);
  const numWorkers = Number(flags['workers'] ?? 1);
  const onFailure = typeof flags['on-failure'] === 'string' ? flags['on-failure'] : undefined;
  const timeout = Number(flags['timeout'] ?? 120) * 1000;
  const verbose = Boolean(flags['verbose']);

  // Resolve paths
  const fuzzTestingDir = path.resolve(__dirname, '..');
  const jskitPath = path.resolve(fuzzTestingDir, '..');
  const failCasesDir = path.join(fuzzTestingDir, 'FailCases');

  const tracker = new FailureTracker(failCasesDir, { onFailureHook: onFailure });

  let totalIterations = 0;
  let totalFailures = 0;
  const startTime = Date.now();

  const genOpts = { maxDepth, maxParams, maxOps };

  if (numWorkers > 1) {
    // ---- Parallel mode via WorkerPool ----
    console.log(`Starting ${numWorkers} parallel workers...`);
    const pool = new WorkerPool({
      fuzzTestingDir,
      jskitPath,
      numWorkers,
      timeout,
      verbose,
    });
    await pool.initialize();

    await pool.run({
      startSeed,
      iterations,
      generateJob(seed) {
        const testCase = generateTestCase(seed, genOpts);
        return {
          seed,
          swiftSource: emitSwift(testCase),
          jsSource: emitJS(testCase),
          /** @type {any} */ testCase,
        };
      },
      async onResult(result) {
        totalIterations++;
        if (!result.success) {
          // Re-generate test case for metadata (cheap)
          const testCase = generateTestCase(result.seed, genOpts);
          const swiftSource = emitSwift(testCase);
          const jsSource = emitJS(testCase);
          const phase = /** @type {import('./types.mjs').FailurePhase} */ (result.phase ?? 'runtime-error');
          const failDir = await tracker.record(
            result.seed,
            phase,
            result.error ?? 'Unknown error',
            { 'main.swift': swiftSource, 'harness.mjs': jsSource },
            { typesInvolved: collectTypesInvolved(testCase) },
          );
          if (failDir) {
            totalFailures++;
            console.log(`seed ${result.seed}: FAIL (${phase}) -> ${path.basename(failDir)}`);
          } else {
            console.log(`seed ${result.seed}: FAIL (${phase}) [duplicate]`);
          }
        } else {
          console.log(`seed ${result.seed}: OK`);
        }
      },
    });

    await pool.shutdown();
  } else {
    // ---- Sequential mode (single worker, original behavior) ----
    const workerDir = path.join(fuzzTestingDir, 'WorkerProject');
    console.log('Setting up worker project...');
    setupWorkerProject(workerDir, jskitPath);

    let seed = startSeed;
    while (true) {
      if (iterations > 0 && totalIterations >= iterations) break;

      const testCase = generateTestCase(seed, genOpts);
      const swiftSource = emitSwift(testCase);
      const jsSource = emitJS(testCase);

      writeTestCase(workerDir, swiftSource);

      const buildResult = await buildAndBundle(workerDir, { timeout, verbose });

      if (!buildResult.success) {
        const failDir = await tracker.record(
          seed,
          'compile-error',
          buildResult.error ?? 'Unknown build error',
          { 'main.swift': swiftSource, 'harness.mjs': jsSource },
          { typesInvolved: collectTypesInvolved(testCase) },
        );
        if (failDir) {
          totalFailures++;
          console.log(`seed ${seed}: FAIL (compile-error) -> ${path.basename(failDir)}`);
        } else {
          console.log(`seed ${seed}: FAIL (compile-error) [duplicate]`);
        }
        seed++;
        totalIterations++;
        continue;
      }

      const outputDir = /** @type {string} */ (buildResult.outputDir);
      const harnessPath = path.join(outputDir, 'harness.mjs');
      fs.writeFileSync(harnessPath, jsSource, 'utf-8');

      const execResult = await executeHarness(harnessPath, { timeout, verbose });

      if (!execResult.success) {
        const phase = execResult.phase ?? 'runtime-error';
        const failDir = await tracker.record(
          seed,
          phase,
          execResult.error ?? 'Unknown execution error',
          { 'main.swift': swiftSource, 'harness.mjs': jsSource },
          { typesInvolved: collectTypesInvolved(testCase) },
        );
        if (failDir) {
          totalFailures++;
          console.log(`seed ${seed}: FAIL (${phase}) -> ${path.basename(failDir)}`);
        } else {
          console.log(`seed ${seed}: FAIL (${phase}) [duplicate]`);
        }
      } else {
        console.log(`seed ${seed}: OK`);
      }

      seed++;
      totalIterations++;
    }
  }

  // Summary
  const elapsed = ((Date.now() - startTime) / 1000).toFixed(1);
  console.log('');
  console.log(`=== Summary ===`);
  console.log(`Iterations: ${totalIterations}`);
  console.log(`Failures:   ${totalFailures}`);
  console.log(`Elapsed:    ${elapsed}s`);
}

// ============================================================
// "reproduce" command
// ============================================================

/**
 * @param {string} failurePath
 * @param {Record<string, string|boolean>} flags
 */
async function cmdReproduce(failurePath, flags) {
  const resolvedPath = path.resolve(failurePath);

  const seedFile = path.join(resolvedPath, 'seed.json');
  if (!fs.existsSync(seedFile)) {
    console.error(`Error: ${seedFile} not found. Is this a failure directory?`);
    process.exit(1);
  }

  const { seed } = JSON.parse(fs.readFileSync(seedFile, 'utf-8'));
  console.log(`Reproducing seed ${seed} from ${resolvedPath}`);

  const maxDepth = Number(flags['max-depth'] ?? 3);
  const maxParams = Number(flags['max-params'] ?? 4);
  const maxOps = Number(flags['max-ops'] ?? 6);
  const timeout = Number(flags['timeout'] ?? 120) * 1000;

  const fuzzTestingDir = path.resolve(__dirname, '..');
  const jskitPath = path.resolve(fuzzTestingDir, '..');
  const workerDir = path.join(fuzzTestingDir, 'WorkerProject');

  setupWorkerProject(workerDir, jskitPath);

  const testCase = generateTestCase(seed, { maxDepth, maxParams, maxOps });
  const swiftSource = emitSwift(testCase);
  const jsSource = emitJS(testCase);

  console.log('\n--- Generated Swift ---');
  console.log(swiftSource);
  console.log('\n--- Generated JS ---');
  console.log(jsSource);

  writeTestCase(workerDir, swiftSource);

  console.log('\nBuilding...');
  const buildResult = await buildAndBundle(workerDir, { timeout, verbose: true });

  if (!buildResult.success) {
    console.error('\nBuild FAILED:');
    console.error(buildResult.error);
    process.exit(1);
  }

  const outputDir = /** @type {string} */ (buildResult.outputDir);
  const harnessPath = path.join(outputDir, 'harness.mjs');
  fs.writeFileSync(harnessPath, jsSource, 'utf-8');

  console.log('\nExecuting...');
  const execResult = await executeHarness(harnessPath, { timeout, verbose: true });

  if (!execResult.success) {
    console.error(`\nExecution FAILED (${execResult.phase}):`);
    console.error(execResult.error);
    process.exit(1);
  } else {
    console.log('\nExecution OK');
  }
}

// ============================================================
// "minimize" command
// ============================================================

/**
 * Try to minimize a failure by reducing the test case.
 * Strategies: remove test functions, remove operations, simplify types.
 *
 * @param {string} failurePath
 * @param {Record<string, string|boolean>} flags
 */
async function cmdMinimize(failurePath, flags) {
  const resolvedPath = path.resolve(failurePath);

  const seedFile = path.join(resolvedPath, 'seed.json');
  if (!fs.existsSync(seedFile)) {
    console.error(`Error: ${seedFile} not found. Is this a failure directory?`);
    process.exit(1);
  }

  const metaFile = path.join(resolvedPath, 'metadata.json');
  if (!fs.existsSync(metaFile)) {
    console.error(`Error: ${metaFile} not found.`);
    process.exit(1);
  }

  const { seed } = JSON.parse(fs.readFileSync(seedFile, 'utf-8'));
  const meta = JSON.parse(fs.readFileSync(metaFile, 'utf-8'));
  const originalPhase = meta.phase;

  console.log(`Minimizing seed ${seed} (phase: ${originalPhase})`);

  const maxDepth = Number(flags['max-depth'] ?? 3);
  const maxParams = Number(flags['max-params'] ?? 4);
  const maxOps = Number(flags['max-ops'] ?? 6);
  const timeout = Number(flags['timeout'] ?? 120) * 1000;

  const fuzzTestingDir = path.resolve(__dirname, '..');
  const jskitPath = path.resolve(fuzzTestingDir, '..');
  const workerDir = path.join(fuzzTestingDir, 'WorkerProject');

  setupWorkerProject(workerDir, jskitPath);

  // Generate the original test case
  let testCase = generateTestCase(seed, { maxDepth, maxParams, maxOps });

  /**
   * Check if a test case still fails with the same phase.
   * @param {import('./types.mjs').TestCase} tc
   * @returns {Promise<boolean>}
   */
  async function stillFails(tc) {
    const swift = emitSwift(tc);
    const js = emitJS(tc);
    writeTestCase(workerDir, swift);

    const buildResult = await buildAndBundle(workerDir, { timeout, verbose: false });
    if (!buildResult.success) {
      return originalPhase === 'compile-error';
    }

    const outputDir = /** @type {string} */ (buildResult.outputDir);
    const harnessPath = path.join(outputDir, 'harness.mjs');
    fs.writeFileSync(harnessPath, js, 'utf-8');

    const execResult = await executeHarness(harnessPath, { timeout, verbose: false });
    if (execResult.success) return false;
    return execResult.phase === originalPhase;
  }

  let reduced = false;

  // Strategy 1: Remove test functions one at a time
  console.log('\nTrying to remove test functions...');
  for (let i = testCase.testFuncs.length - 1; i >= 0; i--) {
    if (testCase.testFuncs.length <= 1) break;
    const candidate = {
      ...testCase,
      testFuncs: [...testCase.testFuncs.slice(0, i), ...testCase.testFuncs.slice(i + 1)],
    };
    process.stdout.write(`  Remove testFunc${i}... `);
    if (await stillFails(candidate)) {
      console.log('still fails ✓');
      testCase = candidate;
      reduced = true;
    } else {
      console.log('needed');
    }
  }

  // Strategy 2: Remove operations from each remaining function
  console.log('\nTrying to remove operations...');
  for (let fi = 0; fi < testCase.testFuncs.length; fi++) {
    const tf = testCase.testFuncs[fi];
    for (let oi = tf.ops.length - 2; oi >= 0; oi--) {
      // Don't remove the return op (last op)
      if (tf.ops[oi].kind === 'return') continue;

      // Check if any later op references the variable this op defines
      const opVar = 'var' in tf.ops[oi] ? /** @type {any} */ (tf.ops[oi]).var?.name : null;
      if (opVar) {
        const isUsed = tf.ops.slice(oi + 1).some(laterOp => {
          if (laterOp.kind === 'return') return laterOp.value.name === opVar;
          if (laterOp.kind === 'callImport') return laterOp.args.some(a => a.name === opVar);
          if (laterOp.kind === 'construct') return laterOp.args.some(a => a.name === opVar);
          return false;
        });
        if (isUsed) continue; // Can't remove — referenced later
      }

      const newOps = [...tf.ops.slice(0, oi), ...tf.ops.slice(oi + 1)];
      const newFuncs = [...testCase.testFuncs];
      newFuncs[fi] = { ...tf, ops: newOps };
      const candidate = { ...testCase, testFuncs: newFuncs };

      process.stdout.write(`  Remove ${tf.name} op[${oi}] (${tf.ops[oi].kind})... `);
      if (await stillFails(candidate)) {
        console.log('still fails ✓');
        testCase = candidate;
        // Update tf reference for next iteration
        reduced = true;
      } else {
        console.log('needed');
      }
    }
  }

  // Strategy 3: Remove unused imported declarations
  console.log('\nTrying to remove unused imports...');
  // Find which imports are actually used
  const usedFuncNames = new Set();
  const usedClassNames = new Set();
  for (const tf of testCase.testFuncs) {
    for (const op of tf.ops) {
      if (op.kind === 'callImport') usedFuncNames.add(op.func.name);
      if (op.kind === 'construct') usedClassNames.add(op.class.name);
    }
  }

  const prunedFuncs = testCase.env.importedFuncs.filter(f => usedFuncNames.has(f.name));
  const prunedClasses = testCase.env.importedClasses.filter(c => usedClassNames.has(c.name));
  if (prunedFuncs.length < testCase.env.importedFuncs.length ||
      prunedClasses.length < testCase.env.importedClasses.length) {
    const candidate = {
      ...testCase,
      env: { importedFuncs: prunedFuncs, importedClasses: prunedClasses },
    };
    process.stdout.write('  Prune unused imports... ');
    if (await stillFails(candidate)) {
      console.log('still fails ✓');
      testCase = candidate;
      reduced = true;
    } else {
      console.log('some are needed');
    }
  }

  // Write minimized result
  const swiftSource = emitSwift(testCase);
  const jsSource = emitJS(testCase);

  if (reduced) {
    const minDir = resolvedPath + '-min';
    fs.mkdirSync(minDir, { recursive: true });
    fs.writeFileSync(path.join(minDir, 'seed.json'), JSON.stringify({ seed }, null, 2) + '\n');
    fs.writeFileSync(path.join(minDir, 'main.swift'), swiftSource);
    fs.writeFileSync(path.join(minDir, 'harness.mjs'), jsSource);
    fs.writeFileSync(path.join(minDir, 'metadata.json'), JSON.stringify({ ...meta, minimized: true }, null, 2) + '\n');
    console.log(`\nMinimized -> ${minDir}`);
  } else {
    console.log('\nNo reductions possible.');
  }

  console.log('\n--- Minimized Swift ---');
  console.log(swiftSource);
}

// ============================================================
// "serve" command
// ============================================================

/**
 * @param {Record<string, string|boolean>} flags
 */
async function cmdServe(flags) {
  // Dynamic import to avoid loading dashboard code in CLI-only mode
  const { startServer } = await import('./web/server.mjs');

  const port = Number(flags['port'] ?? 8000);
  const iterations = Number(flags['iterations'] ?? 0);
  const startSeed = Number(flags['seed'] ?? 0);
  const maxDepth = Number(flags['max-depth'] ?? 3);
  const maxParams = Number(flags['max-params'] ?? 4);
  const maxOps = Number(flags['max-ops'] ?? 6);
  const numWorkers = Number(flags['workers'] ?? 1);
  const onFailure = typeof flags['on-failure'] === 'string' ? flags['on-failure'] : undefined;
  const timeout = Number(flags['timeout'] ?? 120) * 1000;
  const verbose = Boolean(flags['verbose']);

  const fuzzTestingDir = path.resolve(__dirname, '..');
  const jskitPath = path.resolve(fuzzTestingDir, '..');

  await startServer({
    port,
    fuzzTestingDir,
    jskitPath,
    numWorkers,
    iterations,
    startSeed,
    maxDepth,
    maxParams,
    maxOps,
    timeout,
    verbose,
    onFailure,
  });
}

// ============================================================
// Usage
// ============================================================

function printUsage() {
  console.log(`Usage:
  node src/cli.mjs run [options]            Run the fuzzer
  node src/cli.mjs reproduce <path>         Reproduce a failure
  node src/cli.mjs minimize <path>          Minimize a failure
  node src/cli.mjs serve [options]          Run with web dashboard

Run/Serve options:
  --workers N          Parallel workers (default: 1)
  --iterations N       0=unlimited (default: 0)
  --seed N             Starting seed (default: 0)
  --max-depth N        Type nesting depth (default: 3)
  --max-params N       Params per function (default: 4)
  --max-ops N          Operations per function (default: 6)
  --on-failure PATH    Hook script to run on new failures
  --timeout N          Per-iteration timeout in seconds (default: 120)
  --verbose            Show build/run output

Serve options:
  --port N             HTTP port (default: 8000)
`);
}

// ============================================================
// Main
// ============================================================

async function main() {
  const args = process.argv.slice(2);
  const { flags, positional } = parseArgs(args);

  const command = positional[0];

  if (!command || flags['help']) {
    printUsage();
    process.exit(command ? 0 : 1);
  }

  switch (command) {
    case 'run':
      await cmdRun(flags);
      break;

    case 'reproduce': {
      const failPath = positional[1];
      if (!failPath) {
        console.error('Error: reproduce requires a failure directory path');
        printUsage();
        process.exit(1);
      }
      await cmdReproduce(failPath, flags);
      break;
    }

    case 'minimize': {
      const failPath = positional[1];
      if (!failPath) {
        console.error('Error: minimize requires a failure directory path');
        printUsage();
        process.exit(1);
      }
      await cmdMinimize(failPath, flags);
      break;
    }

    case 'serve':
      await cmdServe(flags);
      break;

    default:
      console.error(`Unknown command: ${command}`);
      printUsage();
      process.exit(1);
  }
}

main().catch((err) => {
  console.error('Fatal error:', err);
  process.exit(1);
});
