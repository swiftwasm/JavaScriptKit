// @ts-check

/**
 * @typedef {import('../types.mjs').BridgeType} BridgeType
 */

import { Random } from './random.mjs';

/** @type {BridgeType[]} */
const LEAF_TYPES = [
  { kind: 'int' },
  { kind: 'float' },
  { kind: 'double' },
  { kind: 'string' },
  { kind: 'bool' },
];

/**
 * Generates random BridgeType objects with depth-limited recursion.
 */
export class TypeSmith {
  /** @type {Random} */
  #rng;
  /** @type {number} */
  #maxDepth;

  /**
   * @param {Random} rng
   * @param {{ maxDepth?: number }} [options]
   */
  constructor(rng, options = {}) {
    this.#rng = rng;
    this.#maxDepth = options.maxDepth ?? 3;
  }

  /**
   * Generate a random type (depth-limited recursive).
   * @param {number} [depth]
   * @param {{ insideNullable?: boolean }} [constraints]
   * @returns {BridgeType}
   */
  randomType(depth = 0, constraints = {}) {
    /** @type {BridgeType[]} */
    const candidates = [...LEAF_TYPES, { kind: 'jsObject' }];

    if (depth < this.#maxDepth) {
      // Add wrapper type placeholders — we'll generate the inner type lazily
      /** @type {string[]} */
      const wrapperKinds = ['array', 'dictionary'];
      // Prevent nested optionals (not supported by BridgeJS)
      if (!constraints.insideNullable) wrapperKinds.push('nullable');
      const chosen = this.#rng.pick([...candidates.map(() => 'leaf'), ...wrapperKinds]);
      if (chosen === 'nullable') {
        return { kind: 'nullable', wrapped: this.randomType(depth + 1, { insideNullable: true }) };
      }
      if (chosen === 'array') {
        return { kind: 'array', element: this.randomType(depth + 1) };
      }
      if (chosen === 'dictionary') {
        return { kind: 'dictionary', value: this.randomType(depth + 1) };
      }
    }

    return this.#rng.pick(candidates);
  }

  /**
   * Generate a random type suitable for function parameters.
   * No void; importedClass only if availableClasses is non-empty.
   * @param {number} [depth]
   * @param {string[]} [availableClasses]
   * @param {{ insideNullable?: boolean }} [constraints]
   * @returns {BridgeType}
   */
  randomParamType(depth = 0, availableClasses = [], constraints = {}) {
    /** @type {BridgeType[]} */
    const candidates = [...LEAF_TYPES, { kind: 'jsObject' }];

    if (availableClasses.length > 0) {
      candidates.push({ kind: 'importedClass', name: this.#rng.pick(availableClasses) });
    }

    if (depth < this.#maxDepth) {
      /** @type {string[]} */
      const wrapperKinds = ['array', 'dictionary'];
      // Prevent nested optionals (not supported by BridgeJS)
      if (!constraints.insideNullable) wrapperKinds.push('nullable');
      const allChoices = [...candidates.map(() => 'leaf'), ...wrapperKinds];
      const chosen = this.#rng.pick(allChoices);
      if (chosen === 'nullable') {
        return { kind: 'nullable', wrapped: this.randomParamType(depth + 1, availableClasses, { insideNullable: true }) };
      }
      if (chosen === 'array') {
        return { kind: 'array', element: this.randomParamType(depth + 1, availableClasses) };
      }
      if (chosen === 'dictionary') {
        return { kind: 'dictionary', value: this.randomParamType(depth + 1, availableClasses) };
      }
    }

    return this.#rng.pick(candidates);
  }

  /**
   * Generate a random type suitable for function return types.
   * Includes void as a possibility.
   * @param {number} [depth]
   * @param {string[]} [availableClasses]
   * @returns {BridgeType}
   */
  randomReturnType(depth = 0, availableClasses = []) {
    // 20% chance of void
    if (this.#rng.next() < 0.2) {
      return { kind: 'void' };
    }
    return this.randomParamType(depth, availableClasses);
  }
}
