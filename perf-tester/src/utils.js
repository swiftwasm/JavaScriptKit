/// run `make perf-tester` after updating this or util.js

import fs from 'fs';
import { exec } from '@actions/exec';

export const getInput = key => ({
	'build-script': 'make bootstrap benchmark_setup',
	benchmark: 'make -s run_benchmark',
	'minimum-change-threshold': 50,
	'use-check': 'no',
	'repo-token': process.env.GITHUB_TOKEN
})[key]

export async function runBenchmark() {
	let benchmarkBuffers = []
	await exec(getInput('benchmark'), [], {
		listeners: {
			stdout: data => benchmarkBuffers.push(data)
		}
	});
	const output = Buffer.concat(benchmarkBuffers).toString('utf8')
	return parse(output)
}

const firstLineRe = /^Running '(.+)' \.\.\.$/
const secondLineRe = /^done ([\d.]+) ms$/

function parse(benchmarkData) {
	const lines = benchmarkData.trim().split('\n')
	const benchmarks = Object.create(null)
	for (let i = 0; i < lines.length - 1; i += 2) {
		const [, name] = firstLineRe.exec(lines[i])
		const [, time] = secondLineRe.exec(lines[i + 1])
		benchmarks[name] = Math.round(parseFloat(time))
	}
	return benchmarks
}

/**
 * @param {{[key: string]: number}} before
 * @param {{[key: string]: number}} after
 * @return {Diff[]}
 */
export function toDiff(before, after) {
	const names = [...new Set([...Object.keys(before), ...Object.keys(after)])]
	return names.map(name => {
		const timeBefore = before[name] || 0
		const timeAfter = after[name] || 0
		const delta = timeAfter - timeBefore
		return { name, time: timeAfter, delta }
	})
}


/**
 * Check if a given file exists and can be accessed.
 * @param {string} filename
 */
export async function fileExists(filename) {
	try {
		await fs.promises.access(filename, fs.constants.F_OK);
		return true;
	} catch (e) {}
	return false;
}

/**
 * Remove any matched hash patterns from a filename string.
 * @param {string=} regex
 * @returns {(((fileName: string) => string) | undefined)}
 */
export function stripHash(regex) {
	if (regex) {
		console.log(`Striping hash from build chunks using '${regex}' pattern.`);
		return function (fileName) {
			return fileName.replace(new RegExp(regex), (str, ...hashes) => {
				hashes = hashes.slice(0, -2).filter((c) => c != null);
				if (hashes.length) {
					for (let i = 0; i < hashes.length; i++) {
						const hash = hashes[i] || '';
						str = str.replace(hash, hash.replace(/./g, '*'));
					}
					return str;
				}
				return '';
			});
		};
	}

	return undefined;
}

/**
 * @param {number} delta
 * @param {number} difference
 */
export function getDeltaText(delta, difference) {
	let deltaText = (delta > 0 ? '+' : '') + delta.toLocaleString('en-US') + 'ms';
	if (delta && Math.abs(delta) > 1) {
		deltaText += ` (${Math.abs(difference)}%)`;
	}
	return deltaText;
}

/**
 * @param {number} difference
 */
export function iconForDifference(difference) {
	let icon = '';
	if (difference >= 50) icon = '🆘';
	else if (difference >= 20) icon = '🚨';
	else if (difference >= 10) icon = '⚠️';
	else if (difference >= 5) icon = '🔍';
	else if (difference <= -50) icon = '🏆';
	else if (difference <= -20) icon = '🎉';
	else if (difference <= -10) icon = '👏';
	else if (difference <= -5) icon = '✅';
	return icon;
}

/**
 * Create a Markdown table from text rows
 * @param {string[]} rows
 */
function markdownTable(rows) {
	if (rows.length == 0) {
		return '';
	}

	// Skip all empty columns
	while (rows.every(columns => !columns[columns.length - 1])) {
		for (const columns of rows) {
			columns.pop();
		}
	}

	const [firstRow] = rows;
	const columnLength = firstRow.length;
	if (columnLength === 0) {
		return '';
	}

	return [
		// Header
		['Test name', 'Duration', 'Change', ''].slice(0, columnLength),
		// Align
		[':---', ':---:', ':---:', ':---:'].slice(0, columnLength),
		// Body
		...rows
	].map(columns => `| ${columns.join(' | ')} |`).join('\n');
}

/**
 * @typedef {Object} Diff
 * @property {string} name
 * @property {number} time
 * @property {number} delta
 */

/**
 * Create a Markdown table showing diff data
 * @param {Diff[]} tests
 * @param {object} options
 * @param {boolean} [options.showTotal]
 * @param {boolean} [options.collapseUnchanged]
 * @param {boolean} [options.omitUnchanged]
 * @param {number} [options.minimumChangeThreshold]
 */
export function diffTable(tests, { showTotal, collapseUnchanged, omitUnchanged, minimumChangeThreshold }) {
	let changedRows = [];
	let unChangedRows = [];

	let totalTime = 0;
	let totalDelta = 0;
	for (const file of tests) {
		const { name, time, delta } = file;
		totalTime += time;
		totalDelta += delta;

		const difference = ((delta / time) * 100) | 0;
		const isUnchanged = Math.abs(delta) < minimumChangeThreshold;

		if (isUnchanged && omitUnchanged) continue;

		const columns = [
			name,
			time.toLocaleString('en-US') + 'ms',
			getDeltaText(delta, difference),
			iconForDifference(difference)
		];
		if (isUnchanged && collapseUnchanged) {
			unChangedRows.push(columns);
		} else {
			changedRows.push(columns);
		}
	}

	let out = markdownTable(changedRows);

	if (unChangedRows.length !== 0) {
		const outUnchanged = markdownTable(unChangedRows);
		out += `\n\n<details><summary>ℹ️ <strong>View Unchanged</strong></summary>\n\n${outUnchanged}\n\n</details>\n\n`;
	}

	if (showTotal) {
		const totalDifference = ((totalDelta / totalTime) * 100) | 0;
		let totalDeltaText = getDeltaText(totalDelta, totalDifference);
		let totalIcon = iconForDifference(totalDifference);
		out = `**Total Time:** ${totalTime.toLocaleString('en-US')}ms\n\n${out}`;
		out = `**Time Change:** ${totalDeltaText} ${totalIcon}\n\n${out}`;
	}

	return out;
}

/**
 * Convert a string "true"/"yes"/"1" argument value to a boolean
 * @param {string} v
 */
export function toBool(v) {
	return /^(1|true|yes)$/.test(v);
}
