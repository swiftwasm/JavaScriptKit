#!/usr/bin/env node
// @ts-check

/**
 * Main entry point for the ts2skeleton tool
 *
 * This script analyzes the TypeScript type definitions and produces a structured
 * JSON output with skeleton information that can be used to generate Swift
 * bindings.
 */

import { main } from "../src/cli.js"

main(process.argv.slice(2));
