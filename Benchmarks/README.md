# JavaScriptKit Benchmarks

This directory contains performance benchmarks for JavaScriptKit.

## Building Benchmarks

```bash
swift package --swift-sdk $SWIFT_SDK_ID js -c release
```

## Running Benchmarks

```bash
# Run with default settings
node run.js

# Save results to a JSON file
node run.js --output=results.json

# Run in adaptive mode until results stabilize
node run.js --adaptive --output=stable-results.json

# Compare with previous results
node run.js --baseline=previous-results.json

# Filter benchmarks by name
node run.js --filter=Call
node run.js --filter=/^Property access\//
```

## Identity Mode Benchmarks

The benchmark suite includes identity-mode variants (`@JS(identityMode: true)`) of the core classes to measure pointer identity caching. Both variants are in the same build and run as regular benchmarks alongside everything else.

```bash
# Run only identity benchmarks
node --expose-gc run.js --filter=Identity

# Run only pointer-mode identity benchmarks
node --expose-gc run.js --filter=Identity/pointer

# Run only non-identity baseline
node --expose-gc run.js --filter=Identity/none
```

### Identity Scenarios

| Scenario | What it measures |
|----------|-----------------|
| `passBothWaysRoundtrip` | Same object crossing boundary repeatedly (cache hit path) |
| `getPoolRepeated_100` | Bulk return of 100 cached objects (model collection pattern) |
| `churnObjects` | Create, roundtrip, release cycle (FinalizationRegistry cleanup pressure) |
| `swiftConsumesSameObject` | JS passes same object to Swift repeatedly |
| `swiftCreatesObject` | Fresh object creation overhead (cache miss path) |
