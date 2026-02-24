// @ts-check

import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

/**
 * Path to the Package.swift.template file.
 * Located at FuzzTesting/templates/Package.swift.template relative to this module.
 */
const TEMPLATE_PATH = path.resolve(__dirname, "..", "..", "templates", "Package.swift.template");

/**
 * Set up a worker directory with the SPM project structure.
 * Creates:
 *   workerDir/Package.swift (from template with jskitPath substituted)
 *   workerDir/Sources/FuzzTarget/ (empty source dir)
 *
 * @param {string} workerDir - Absolute path to the worker directory
 * @param {string} jskitPath - Absolute path to the JavaScriptKit package root
 */
export function setupWorkerProject(workerDir, jskitPath) {
    // Create directory structure
    const sourcesDir = path.join(workerDir, "Sources", "FuzzTarget");
    fs.mkdirSync(sourcesDir, { recursive: true });

    // Read the template and substitute the placeholder
    const template = fs.readFileSync(TEMPLATE_PATH, "utf-8");
    const packageSwift = template.replace(/\{\{JAVASCRIPTKIT_PATH\}\}/g, jskitPath);

    // Write Package.swift
    fs.writeFileSync(path.join(workerDir, "Package.swift"), packageSwift, "utf-8");
}

/**
 * Write the generated Swift source to the worker project.
 *
 * @param {string} workerDir - Absolute path to the worker directory
 * @param {string} swiftSource - The generated main.swift content
 */
export function writeTestCase(workerDir, swiftSource) {
    const targetDir = path.join(workerDir, "Sources", "FuzzTarget");
    fs.mkdirSync(targetDir, { recursive: true });
    fs.writeFileSync(path.join(targetDir, "main.swift"), swiftSource, "utf-8");
}

/**
 * Get the path where `swift package js` outputs the built package.
 *
 * @param {string} workerDir - Absolute path to the worker directory
 * @returns {string} Path to the output directory
 */
export function getOutputDir(workerDir) {
    return path.join(workerDir, ".build", "plugins", "PackageToJS", "outputs", "Package");
}
