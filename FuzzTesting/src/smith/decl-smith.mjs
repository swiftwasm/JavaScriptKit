// @ts-check

/**
 * @typedef {import('../types.mjs').DeclEnv} DeclEnv
 * @typedef {import('../types.mjs').ImportedClass} ImportedClass
 * @typedef {import('../types.mjs').ImportedFunc} ImportedFunc
 * @typedef {import('../types.mjs').Param} Param
 * @typedef {import('../types.mjs').BridgeType} BridgeType
 */

import { Random } from './random.mjs';
import { TypeSmith } from './type-smith.mjs';

/** @type {string[]} */
const PARAM_NAMES = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];

/**
 * Generates a DeclEnv with random imported classes and free functions.
 */
export class DeclSmith {
  /** @type {Random} */
  #rng;
  /** @type {TypeSmith} */
  #typeSmith;
  /** @type {number} */
  #maxClasses;
  /** @type {number} */
  #maxFuncs;
  /** @type {number} */
  #maxParams;

  /**
   * @param {Random} rng
   * @param {TypeSmith} typeSmith
   * @param {{ maxClasses?: number, maxFuncs?: number, maxParams?: number }} [options]
   */
  constructor(rng, typeSmith, options = {}) {
    this.#rng = rng;
    this.#typeSmith = typeSmith;
    this.#maxClasses = options.maxClasses ?? 2;
    this.#maxFuncs = options.maxFuncs ?? 4;
    this.#maxParams = options.maxParams ?? 4;
  }

  /**
   * Generate a complete DeclEnv.
   * @returns {DeclEnv}
   */
  generate() {
    const importedClasses = this.#generateClasses();
    const classNames = importedClasses.map((c) => c.name);
    const importedFuncs = this.#generateFuncs(classNames);
    return { importedFuncs, importedClasses };
  }

  /**
   * @returns {ImportedClass[]}
   */
  #generateClasses() {
    const count = this.#rng.nextInt(0, this.#maxClasses);
    /** @type {ImportedClass[]} */
    const classes = [];
    for (let i = 0; i < count; i++) {
      const name = `FuzzObj${i}`;
      const paramCount = this.#rng.nextInt(1, 3);
      const params = this.#makeParams(paramCount, []);
      classes.push({ name, constructorParams: params });
    }
    return classes;
  }

  /**
   * @param {string[]} availableClasses
   * @returns {ImportedFunc[]}
   */
  #generateFuncs(availableClasses) {
    const count = this.#rng.nextInt(1, this.#maxFuncs);
    /** @type {ImportedFunc[]} */
    const funcs = [];
    for (let i = 0; i < count; i++) {
      const name = `jsFuzz${i}`;
      const paramCount = this.#rng.nextInt(0, this.#maxParams);
      const params = this.#makeParams(paramCount, availableClasses);
      const returnType = this.#typeSmith.randomReturnType(0, availableClasses);
      funcs.push({ name, params, returnType });
    }
    return funcs;
  }

  /**
   * Generate a list of Param objects.
   * @param {number} count
   * @param {string[]} availableClasses
   * @returns {Param[]}
   */
  #makeParams(count, availableClasses) {
    /** @type {Param[]} */
    const params = [];
    for (let i = 0; i < count; i++) {
      const name = PARAM_NAMES[i] ?? `p${i}`;
      const type = this.#typeSmith.randomParamType(0, availableClasses);
      // 30% chance of a label that differs from the parameter name
      const label = this.#rng.next() < 0.3 ? `_` : null;
      params.push({ label, name, type });
    }
    return params;
  }
}
