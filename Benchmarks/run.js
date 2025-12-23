import { instantiate } from "./.build/plugins/PackageToJS/outputs/Package/instantiate.js"
import { defaultNodeSetup } from "./.build/plugins/PackageToJS/outputs/Package/platforms/node.js"
import fs from 'fs';
import path from 'path';
import { parseArgs } from "util";
import { APIResultValues as APIResult, ComplexResultValues as ComplexResult } from "./.build/plugins/PackageToJS/outputs/Package/bridge-js.js";

/**
 * Update progress bar on the current line
 * @param {number} current - Current progress
 * @param {number} total - Total items
 * @param {string} label - Label for the progress bar
 * @param {number} width - Width of the progress bar
 */
function updateProgress(current, total, label = '', width) {
    const percent = (current / total) * 100;
    const completed = Math.round(width * (percent / 100));
    const remaining = width - completed;
    const bar = '█'.repeat(completed) + '░'.repeat(remaining);
    process.stdout.clearLine();
    process.stdout.cursorTo(0);
    process.stdout.write(`${label} [${bar}] ${current}/${total}`);
}

/**
 * Create a name filter function from CLI argument
 * - Supports substring match (default)
 * - Supports /regex/flags syntax
 * @param {string|undefined} arg
 * @returns {(name: string) => boolean}
 */
function createNameFilter(arg) {
    if (!arg) {
        return () => true;
    }
    if (arg.startsWith('/') && arg.lastIndexOf('/') > 0) {
        const lastSlash = arg.lastIndexOf('/');
        const pattern = arg.slice(1, lastSlash);
        const flags = arg.slice(lastSlash + 1);
        try {
            const re = new RegExp(pattern, flags);
            return (name) => re.test(name);
        } catch (e) {
            console.error('Invalid regular expression for --filter:', e.message);
            process.exit(1);
        }
    }
    return (name) => name.includes(arg);
}

/**
 * Calculate coefficient of variation (relative standard deviation)
 * @param {Array<number>} values - Array of measurement values
 * @returns {number} Coefficient of variation as a percentage
 */
function calculateCV(values) {
    if (values.length < 2) return 0;

    const sum = values.reduce((a, b) => a + b, 0);
    const mean = sum / values.length;

    if (mean === 0) return 0;

    const variance = values.reduce((a, b) => a + Math.pow(b - mean, 2), 0) / values.length;
    const stdDev = Math.sqrt(variance);

    return (stdDev / mean) * 100; // Return as percentage
}

/**
 * Calculate statistics from benchmark results
 * @param {Object} results - Raw benchmark results
 * @returns {Object} Formatted results with statistics
 */
function calculateStatistics(results) {
    const formattedResults = {};
    const consoleTable = [];

    for (const [name, times] of Object.entries(results)) {
        const sum = times.reduce((a, b) => a + b, 0);
        const avg = sum / times.length;
        const min = Math.min(...times);
        const max = Math.max(...times);
        const variance = times.reduce((a, b) => a + Math.pow(b - avg, 2), 0) / times.length;
        const stdDev = Math.sqrt(variance);
        const cv = (stdDev / avg) * 100; // Coefficient of variation as percentage

        formattedResults[name] = {
            "avg_ms": parseFloat(avg.toFixed(2)),
            "min_ms": parseFloat(min.toFixed(2)),
            "max_ms": parseFloat(max.toFixed(2)),
            "stdDev_ms": parseFloat(stdDev.toFixed(2)),
            "cv_percent": parseFloat(cv.toFixed(2)),
            "samples": times.length,
            "rawTimes_ms": times.map(t => parseFloat(t.toFixed(2)))
        };

        consoleTable.push({
            Test: name,
            'Avg (ms)': avg.toFixed(2),
            'Min (ms)': min.toFixed(2),
            'Max (ms)': max.toFixed(2),
            'StdDev (ms)': stdDev.toFixed(2),
            'CV (%)': cv.toFixed(2),
            'Samples': times.length
        });
    }

    return { formattedResults, consoleTable };
}

/**
 * Load a JSON file
 * @param {string} filePath - Path to the JSON file
 * @returns {Object|null} Parsed JSON or null if file doesn't exist
 */
function loadJsonFile(filePath) {
    try {
        if (fs.existsSync(filePath)) {
            const fileContent = fs.readFileSync(filePath, 'utf8');
            return JSON.parse(fileContent);
        }
    } catch (error) {
        console.error(`Error loading JSON file ${filePath}:`, error.message);
    }
    return null;
}

/**
 * Compare current results with baseline
 * @param {Object} current - Current benchmark results
 * @param {Object} baseline - Baseline benchmark results
 * @returns {Object} Comparison results with percent change
 */
function compareWithBaseline(current, baseline) {
    const comparisonTable = [];

    // Get all unique test names from both current and baseline
    const allTests = new Set([
        ...Object.keys(current),
        ...Object.keys(baseline)
    ]);

    for (const test of allTests) {
        const currentTest = current[test];
        const baselineTest = baseline[test];

        if (!currentTest) {
            comparisonTable.push({
                Test: test,
                'Status': 'REMOVED',
                'Baseline (ms)': baselineTest.avg_ms.toFixed(2),
                'Current (ms)': 'N/A',
                'Change': 'N/A',
                'Change (%)': 'N/A'
            });
            continue;
        }

        if (!baselineTest) {
            comparisonTable.push({
                Test: test,
                'Status': 'NEW',
                'Baseline (ms)': 'N/A',
                'Current (ms)': currentTest.avg_ms.toFixed(2),
                'Change': 'N/A',
                'Change (%)': 'N/A'
            });
            continue;
        }

        const change = currentTest.avg_ms - baselineTest.avg_ms;
        const percentChange = (change / baselineTest.avg_ms) * 100;

        let status = 'NEUTRAL';
        if (percentChange < -5) status = 'FASTER';
        else if (percentChange > 5) status = 'SLOWER';

        comparisonTable.push({
            Test: test,
            'Status': status,
            'Baseline (ms)': baselineTest.avg_ms.toFixed(2),
            'Current (ms)': currentTest.avg_ms.toFixed(2),
            'Change': (0 < change ? '+' : '') + change.toFixed(2) + ' ms',
            'Change (%)': (0 < percentChange ? '+' : '') + percentChange.toFixed(2) + '%'
        });
    }

    return comparisonTable;
}

/**
 * Format and print comparison results
 * @param {Array} comparisonTable - Comparison results
 */
function printComparisonResults(comparisonTable) {
    console.log("\n==============================");
    console.log("   COMPARISON WITH BASELINE   ");
    console.log("==============================\n");

    // Color code the output if terminal supports it
    const colorize = (text, status) => {
        if (process.stdout.isTTY) {
            if (status === 'FASTER') return `\x1b[32m${text}\x1b[0m`; // Green
            if (status === 'SLOWER') return `\x1b[31m${text}\x1b[0m`; // Red
            if (status === 'NEW') return `\x1b[36m${text}\x1b[0m`;    // Cyan
            if (status === 'REMOVED') return `\x1b[33m${text}\x1b[0m`; // Yellow
        }
        return text;
    };

    // Manually format table for better control over colors
    const columnWidths = {
        Test: Math.max(4, ...comparisonTable.map(row => row.Test.length)),
        Status: 8,
        Baseline: 15,
        Current: 15,
        Change: 15,
        PercentChange: 15
    };

    // Print header
    console.log(
        'Test'.padEnd(columnWidths.Test) + ' | ' +
        'Status'.padEnd(columnWidths.Status) + ' | ' +
        'Baseline (ms)'.padEnd(columnWidths.Baseline) + ' | ' +
        'Current (ms)'.padEnd(columnWidths.Current) + ' | ' +
        'Change'.padEnd(columnWidths.Change) + ' | ' +
        'Change (%)'
    );

    console.log('-'.repeat(columnWidths.Test + columnWidths.Status + columnWidths.Baseline +
        columnWidths.Current + columnWidths.Change + columnWidths.PercentChange + 10));

    // Print rows
    for (const row of comparisonTable) {
        console.log(
            row.Test.padEnd(columnWidths.Test) + ' | ' +
            colorize(row.Status.padEnd(columnWidths.Status), row.Status) + ' | ' +
            row['Baseline (ms)'].toString().padEnd(columnWidths.Baseline) + ' | ' +
            row['Current (ms)'].toString().padEnd(columnWidths.Current) + ' | ' +
            colorize(row.Change.padEnd(columnWidths.Change), row.Status) + ' | ' +
            colorize(row['Change (%)'].padEnd(columnWidths.PercentChange), row.Status)
        );
    }
}

/**
 * Save results to JSON file
 * @param {string} filePath - Output file path
 * @param {Object} data - Data to save
 */
function saveJsonResults(filePath, data) {
    const outputDir = path.dirname(filePath);
    if (outputDir !== '.' && !fs.existsSync(outputDir)) {
        fs.mkdirSync(outputDir, { recursive: true });
    }

    fs.writeFileSync(filePath, JSON.stringify(data, null, 2));
    console.log(`\nDetailed results saved to ${filePath}`);
}

/**
 * Run a single benchmark iteration
 * @param {Object} results - Results object to store benchmark data
 * @returns {Promise<void>}
 */
async function singleRun(results, nameFilter) {
    const options = await defaultNodeSetup({})
    const benchmarkRunner = (name, body) => {
        if (nameFilter && !nameFilter(name)) {
            return;
        }
        const startTime = performance.now();
        body();
        const endTime = performance.now();
        const duration = endTime - startTime;
        if (!results[name]) {
            results[name] = []
        }
        results[name].push(duration)
    }
    const { exports } = await instantiate({
        ...options,
        getImports: () => ({
            benchmarkHelperNoop: () => { },
            benchmarkHelperNoopWithNumber: (n) => { },
            benchmarkRunner: benchmarkRunner
        })
    });
    exports.run();

    const enumRoundtrip = new exports.EnumRoundtrip();
    const iterations = 100_000;
    benchmarkRunner("EnumRoundtrip/takeEnum success", () => {
        for (let i = 0; i < iterations; i++) {
            enumRoundtrip.take({ tag: APIResult.Tag.Success, param0: "Hello, world" })
        }
    })
    benchmarkRunner("EnumRoundtrip/takeEnum failure", () => {
        for (let i = 0; i < iterations; i++) {
            enumRoundtrip.take({ tag: APIResult.Tag.Failure, param0: 42 })
        }
    })
    benchmarkRunner("EnumRoundtrip/takeEnum flag", () => {
        for (let i = 0; i < iterations; i++) {
            enumRoundtrip.take({ tag: APIResult.Tag.Flag, param0: true })
        }
    })
    benchmarkRunner("EnumRoundtrip/takeEnum rate", () => {
        for (let i = 0; i < iterations; i++) {
            enumRoundtrip.take({ tag: APIResult.Tag.Rate, param0: 0.5 })
        }
    })
    benchmarkRunner("EnumRoundtrip/takeEnum precise", () => {
        for (let i = 0; i < iterations; i++) {
            enumRoundtrip.take({ tag: APIResult.Tag.Precise, param0: 0.5 })
        }
    })
    benchmarkRunner("EnumRoundtrip/takeEnum info", () => {
        for (let i = 0; i < iterations; i++) {
            enumRoundtrip.take({ tag: APIResult.Tag.Info })
        }
    })
    benchmarkRunner("EnumRoundtrip/makeSuccess", () => {
        for (let i = 0; i < iterations; i++) {
            enumRoundtrip.makeSuccess()
        }
    })
    benchmarkRunner("EnumRoundtrip/makeFailure", () => {
        for (let i = 0; i < iterations; i++) {
            enumRoundtrip.makeFailure()
        }
    })
    benchmarkRunner("EnumRoundtrip/makeFlag", () => {
        for (let i = 0; i < iterations; i++) {
            enumRoundtrip.makeFlag()
        }
    })
    benchmarkRunner("EnumRoundtrip/makeRate", () => {
        for (let i = 0; i < iterations; i++) {
            enumRoundtrip.makeRate()
        }
    })
    benchmarkRunner("EnumRoundtrip/makePrecise", () => {
        for (let i = 0; i < iterations; i++) {
            enumRoundtrip.makePrecise()
        }
    })
    benchmarkRunner("EnumRoundtrip/makeInfo", () => {
        for (let i = 0; i < iterations; i++) {
            enumRoundtrip.makeInfo()
        }
    })

    benchmarkRunner("EnumRoundtrip/roundtrip", () => {
        for (let i = 0; i < iterations; i++) {
            enumRoundtrip.roundtrip({ tag: APIResult.Tag.Success, param0: "Hello, world" })
        }
    })

    const complexResultRoundtrip = new exports.ComplexResultRoundtrip();
    
    benchmarkRunner("ComplexResultRoundtrip/takeEnum success", () => {
        for (let i = 0; i < iterations; i++) {
            complexResultRoundtrip.take({ tag: ComplexResult.Tag.Success, param0: "Operation completed" })
        }
    })
    benchmarkRunner("ComplexResultRoundtrip/takeEnum error", () => {
        for (let i = 0; i < iterations; i++) {
            complexResultRoundtrip.take({ tag: ComplexResult.Tag.Error, param0: "Network timeout", param1: 503 })
        }
    })
    benchmarkRunner("ComplexResultRoundtrip/takeEnum location", () => {
        for (let i = 0; i < iterations; i++) {
            complexResultRoundtrip.take({ tag: ComplexResult.Tag.Location, param0: 37.7749, param1: -122.4194, param2: "San Francisco" })
        }
    })
    benchmarkRunner("ComplexResultRoundtrip/takeEnum status", () => {
        for (let i = 0; i < iterations; i++) {
            complexResultRoundtrip.take({ tag: ComplexResult.Tag.Status, param0: true, param1: 200, param2: "OK" })
        }
    })
    benchmarkRunner("ComplexResultRoundtrip/takeEnum coordinates", () => {
        for (let i = 0; i < iterations; i++) {
            complexResultRoundtrip.take({ tag: ComplexResult.Tag.Coordinates, param0: 10.5, param1: 20.3, param2: 30.7 })
        }
    })
    benchmarkRunner("ComplexResultRoundtrip/takeEnum comprehensive", () => {
        for (let i = 0; i < iterations; i++) {
            complexResultRoundtrip.take({ 
                tag: ComplexResult.Tag.Comprehensive, 
                param0: true, param1: false, param2: 42, param3: 100, 
                param4: 3.14, param5: 2.718, param6: "Hello", param7: "World", param8: "Test" 
            })
        }
    })
    benchmarkRunner("ComplexResultRoundtrip/takeEnum info", () => {
        for (let i = 0; i < iterations; i++) {
            complexResultRoundtrip.take({ tag: ComplexResult.Tag.Info })
        }
    })
    
    benchmarkRunner("ComplexResultRoundtrip/makeSuccess", () => {
        for (let i = 0; i < iterations; i++) {
            complexResultRoundtrip.makeSuccess()
        }
    })
    benchmarkRunner("ComplexResultRoundtrip/makeError", () => {
        for (let i = 0; i < iterations; i++) {
            complexResultRoundtrip.makeError()
        }
    })
    benchmarkRunner("ComplexResultRoundtrip/makeLocation", () => {
        for (let i = 0; i < iterations; i++) {
            complexResultRoundtrip.makeLocation()
        }
    })
    benchmarkRunner("ComplexResultRoundtrip/makeStatus", () => {
        for (let i = 0; i < iterations; i++) {
            complexResultRoundtrip.makeStatus()
        }
    })
    benchmarkRunner("ComplexResultRoundtrip/makeCoordinates", () => {
        for (let i = 0; i < iterations; i++) {
            complexResultRoundtrip.makeCoordinates()
        }
    })
    benchmarkRunner("ComplexResultRoundtrip/makeComprehensive", () => {
        for (let i = 0; i < iterations; i++) {
            complexResultRoundtrip.makeComprehensive()
        }
    })
    benchmarkRunner("ComplexResultRoundtrip/makeInfo", () => {
        for (let i = 0; i < iterations; i++) {
            complexResultRoundtrip.makeInfo()
        }
    })

    benchmarkRunner("ComplexResultRoundtrip/roundtrip", () => {
        for (let i = 0; i < iterations; i++) {
            complexResultRoundtrip.roundtrip({ tag: ComplexResult.Tag.Success, param0: "Hello, world" })
        }
    })

    const stringRoundtrip = new exports.StringRoundtrip();
    benchmarkRunner("StringRoundtrip/takeString", () => {
        for (let i = 0; i < iterations; i++) {
            stringRoundtrip.take("Hello, world")
        }
    })
    benchmarkRunner("StringRoundtrip/makeString", () => {
        for (let i = 0; i < iterations; i++) {
            stringRoundtrip.make()
        }
    })

    // Struct performance tests
    const structRoundtrip = new exports.StructRoundtrip();

    benchmarkRunner("StructRoundtrip/takeSimple", () => {
        for (let i = 0; i < iterations; i++) {
            structRoundtrip.takeSimple({ name: "Hello", count: 42, flag: true, rate: 0.5, precise: 3.14159 })
        }
    })
    benchmarkRunner("StructRoundtrip/makeSimple", () => {
        for (let i = 0; i < iterations; i++) {
            structRoundtrip.makeSimple()
        }
    })
    benchmarkRunner("StructRoundtrip/roundtripSimple", () => {
        for (let i = 0; i < iterations; i++) {
            structRoundtrip.roundtripSimple({ name: "Hello", count: 42, flag: true, rate: 0.5, precise: 3.14159 })
        }
    })

    benchmarkRunner("StructRoundtrip/takeAddress", () => {
        for (let i = 0; i < iterations; i++) {
            structRoundtrip.takeAddress({ street: "123 Main St", city: "San Francisco", zipCode: 94102 })
        }
    })
    benchmarkRunner("StructRoundtrip/makeAddress", () => {
        for (let i = 0; i < iterations; i++) {
            structRoundtrip.makeAddress()
        }
    })
    benchmarkRunner("StructRoundtrip/roundtripAddress", () => {
        for (let i = 0; i < iterations; i++) {
            structRoundtrip.roundtripAddress({ street: "123 Main St", city: "San Francisco", zipCode: 94102 })
        }
    })

    benchmarkRunner("StructRoundtrip/takePerson", () => {
        for (let i = 0; i < iterations; i++) {
            structRoundtrip.takePerson({
                name: "John Doe",
                age: 30,
                address: { street: "456 Oak Ave", city: "New York", zipCode: 10001 },
                email: "john@example.com"
            })
        }
    })
    benchmarkRunner("StructRoundtrip/makePerson", () => {
        for (let i = 0; i < iterations; i++) {
            structRoundtrip.makePerson()
        }
    })
    benchmarkRunner("StructRoundtrip/roundtripPerson", () => {
        for (let i = 0; i < iterations; i++) {
            structRoundtrip.roundtripPerson({
                name: "John Doe",
                age: 30,
                address: { street: "456 Oak Ave", city: "New York", zipCode: 10001 },
                email: "john@example.com"
            })
        }
    })

    benchmarkRunner("StructRoundtrip/takeComplex", () => {
        for (let i = 0; i < iterations; i++) {
            structRoundtrip.takeComplex({
                id: 12345,
                title: "Test Item",
                active: true,
                score: 98.6,
                tags: "swift,wasm,benchmark",
                metadata: "{\"version\":1}"
            })
        }
    })
    benchmarkRunner("StructRoundtrip/makeComplex", () => {
        for (let i = 0; i < iterations; i++) {
            structRoundtrip.makeComplex()
        }
    })
    benchmarkRunner("StructRoundtrip/roundtripComplex", () => {
        for (let i = 0; i < iterations; i++) {
            structRoundtrip.roundtripComplex({
                id: 12345,
                title: "Test Item",
                active: true,
                score: 98.6,
                tags: "swift,wasm,benchmark",
                metadata: "{\"version\":1}"
            })
        }
    })

    // Class vs Struct comparison tests
    const classRoundtrip = new exports.ClassRoundtrip();

    benchmarkRunner("ClassRoundtrip/takeSimpleClass", () => {
        const simple = new exports.SimpleClass("Hello", 42, true, 0.5, 3.14159)
        for (let i = 0; i < iterations; i++) {
            classRoundtrip.takeSimpleClass(simple)
        }
    })
    benchmarkRunner("ClassRoundtrip/makeSimpleClass", () => {
        for (let i = 0; i < iterations; i++) {
            classRoundtrip.makeSimpleClass()
        }
    })
    benchmarkRunner("ClassRoundtrip/roundtripSimpleClass", () => {
        const simple = new exports.SimpleClass("Hello", 42, true, 0.5, 3.14159)
        for (let i = 0; i < iterations; i++) {
            classRoundtrip.roundtripSimpleClass(simple)
        }
    })

    benchmarkRunner("ClassRoundtrip/takeAddressClass", () => {
        const address = new exports.AddressClass("123 Main St", "San Francisco", 94102)
        for (let i = 0; i < iterations; i++) {
            classRoundtrip.takeAddressClass(address)
        }
    })
    benchmarkRunner("ClassRoundtrip/makeAddressClass", () => {
        for (let i = 0; i < iterations; i++) {
            classRoundtrip.makeAddressClass()
        }
    })
    benchmarkRunner("ClassRoundtrip/roundtripAddressClass", () => {
        const address = new exports.AddressClass("123 Main St", "San Francisco", 94102)
        for (let i = 0; i < iterations; i++) {
            classRoundtrip.roundtripAddressClass(address)
        }
    })
}

/**
 * Run until the coefficient of variation of measurements is below the threshold
 * @param {Object} results - Benchmark results object
 * @param {Object} options - Adaptive sampling options
 * @returns {Promise<void>}
 */
async function runUntilStable(results, options, width, nameFilter, filterArg) {
    const {
        minRuns = 5,
        maxRuns = 50,
        targetCV = 5,
    } = options;

    let runs = 0;
    let allStable = false;

    console.log("\nAdaptive sampling enabled:");
    console.log(`- Minimum runs: ${minRuns}`);
    console.log(`- Maximum runs: ${maxRuns}`);
    console.log(`- Target CV: ${targetCV}%`);

    while (runs < maxRuns) {
        // Update progress with estimated completion
        updateProgress(runs, maxRuns, "Benchmark Progress:", width);

        await singleRun(results, nameFilter);
        runs++;

        if (runs === 1 && Object.keys(results).length === 0) {
            console.error(`\nNo benchmarks matched filter: ${filterArg}`);
            process.exit(1);
        }

        // Check if we've reached minimum runs
        if (runs < minRuns) continue;

        // Check stability of all tests after each run
        const cvs = [];
        allStable = true;

        for (const [name, times] of Object.entries(results)) {
            const cv = calculateCV(times);
            cvs.push({ name, cv });

            if (cv > targetCV) {
                allStable = false;
            }
        }

        // Display current CV values periodically
        if (runs % 3 === 0 || allStable) {
            process.stdout.write("\n");
            console.log(`After ${runs} runs, coefficient of variation (%):`)
            for (const { name, cv } of cvs) {
                const stable = cv <= targetCV;
                const status = stable ? '✓' : '…';
                const cvStr = cv.toFixed(2) + '%';
                console.log(`  ${status} ${name}: ${stable ? '\x1b[32m' : ''}${cvStr}${stable ? '\x1b[0m' : ''}`);
            }
        }

        // Check if we should stop
        if (allStable) {
            console.log("\nAll benchmarks stable! Stopping adaptive sampling.");
            break;
        }
    }

    updateProgress(maxRuns, maxRuns, "Benchmark Progress:", width);
    console.log("\n");

    if (!allStable) {
        console.log("\nWarning: Not all benchmarks reached target stability!");
        for (const [name, times] of Object.entries(results)) {
            const cv = calculateCV(times);
            if (cv > targetCV) {
                console.log(`  ! ${name}: ${cv.toFixed(2)}% > ${targetCV}%`);
            }
        }
    }
}

function showHelp() {
    console.log(`
Usage: node run.js [options]

Options:
  --runs=NUMBER         Number of benchmark runs (default: 10)
  --output=FILENAME     Save JSON results to specified file
  --baseline=FILENAME   Compare results with baseline JSON file
  --adaptive            Enable adaptive sampling (run until stable)
  --min-runs=NUMBER     Minimum runs for adaptive sampling (default: 5)
  --max-runs=NUMBER     Maximum runs for adaptive sampling (default: 50)
  --target-cv=NUMBER    Target coefficient of variation % (default: 5)
  --filter=PATTERN      Filter benchmarks by name (substring or /regex/flags)
  --help                Show this help message
`);
}

async function main() {
    const args = parseArgs({
        options: {
            runs: { type: 'string', default: '10' },
            output: { type: 'string' },
            baseline: { type: 'string' },
            help: { type: 'boolean', default: false },
            adaptive: { type: 'boolean', default: false },
            'min-runs': { type: 'string', default: '5' },
            'max-runs': { type: 'string', default: '50' },
            'target-cv': { type: 'string', default: '5' },
            filter: { type: 'string' }
        }
    });

    if (args.values.help) {
        showHelp();
        return;
    }

    const results = {};
    const width = 30;
    const filterArg = args.values.filter;
    const nameFilter = createNameFilter(filterArg);

    if (args.values.adaptive) {
        // Adaptive sampling mode
        const options = {
            minRuns: parseInt(args.values['min-runs'], 10),
            maxRuns: parseInt(args.values['max-runs'], 10),
            targetCV: parseFloat(args.values['target-cv'])
        };

        console.log("Starting benchmark with adaptive sampling...");
        if (args.values.output) {
            console.log(`Results will be saved to: ${args.values.output}`);
        }

        await runUntilStable(results, options, width, nameFilter, filterArg);
    } else {
        // Fixed number of runs mode
        const runs = parseInt(args.values.runs, 10);
        if (isNaN(runs)) {
            console.error('Invalid number of runs:', args.values.runs);
            process.exit(1);
        }

        console.log(`Starting benchmark suite with ${runs} runs per test...`);
        if (args.values.output) {
            console.log(`Results will be saved to: ${args.values.output}`);
        }

        if (args.values.baseline) {
            console.log(`Will compare with baseline: ${args.values.baseline}`);
        }

        // Show overall progress
        console.log("\nOverall Progress:");
        for (let i = 0; i < runs; i++) {
            updateProgress(i, runs, "Benchmark Runs:", width);
            await singleRun(results, nameFilter);
            if (i === 0 && Object.keys(results).length === 0) {
                process.stdout.write("\n");
                console.error(`No benchmarks matched filter: ${filterArg}`);
                process.exit(1);
            }
        }
        updateProgress(runs, runs, "Benchmark Runs:", width);
        console.log("\n");
    }

    // Calculate and display statistics
    console.log("\n==============================");
    console.log("      BENCHMARK SUMMARY      ");
    console.log("==============================\n");

    const { formattedResults, consoleTable } = calculateStatistics(results);

    // Print readable format to console
    console.table(consoleTable);

    // Compare with baseline if provided
    if (args.values.baseline) {
        const baseline = loadJsonFile(args.values.baseline);
        if (baseline) {
            const comparisonResults = compareWithBaseline(formattedResults, baseline);
            printComparisonResults(comparisonResults);
        } else {
            console.error(`Could not load baseline file: ${args.values.baseline}`);
        }
    }

    // Save JSON to file if specified
    if (args.values.output) {
        saveJsonResults(args.values.output, formattedResults);
    }
}

main().catch(err => {
    console.error('Benchmark error:', err);
    process.exit(1);
});
