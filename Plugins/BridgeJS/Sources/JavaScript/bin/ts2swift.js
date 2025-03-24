#!/usr/bin/env node

/**
 * Main entry point for the ts2swift tool
 * 
 * This script generates Swift type bindings from TypeScript declaration files.
 * It analyzes the TypeScript type definitions and produces a structured JSON output
 * with detailed type information that can be used to generate Swift bindings.
 * 
 * Usage:
 *   ts2swift <d.ts file> [-o output.json]
 * 
 * @fileoverview Entry point script that imports from the modular structure
 */

import { main } from "../src/cli.js"

main();
