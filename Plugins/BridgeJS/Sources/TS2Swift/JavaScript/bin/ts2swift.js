#!/usr/bin/env node
// @ts-check

/**
 * Main entry point for the ts2swift tool
 *
 * This script analyzes the TypeScript type definitions and produces macro-annotated
 * Swift declarations that can be used to generate Swift bindings.
 */

import { main } from "../src/cli.js"

main(process.argv.slice(2));
