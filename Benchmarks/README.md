# JavaScriptKit Benchmarks

This directory contains performance benchmarks for JavaScriptKit.

## Building Benchmarks

Before running the benchmarks, you need to build the test suite:

```bash
swift package --swift-sdk $SWIFT_SDK_ID js -c release
```

## Running Benchmarks

```bash
# Run with default settings
node run.js

# Save results to a JSON file
node run.js --output=results.json

# Specify number of iterations
node run.js --runs=20

# Run in adaptive mode until results stabilize
node run.js --adaptive --output=stable-results.json

# Run benchmarks and compare with previous results
node run.js --baseline=previous-results.json

# Run only a subset of benchmarks
# Substring match
node run.js --filter=Call
# Regex (with flags)
node run.js --filter=/^Property access\//
node run.js --filter=/string/i
```
