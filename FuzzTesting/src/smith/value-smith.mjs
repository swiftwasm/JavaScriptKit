// @ts-check

/**
 * @typedef {import('../types.mjs').BridgeType} BridgeType
 */

import { Random } from './random.mjs';

/** @type {number[]} */
const INT_EDGE_CASES = [0, 1, -1, 42, -42, 2147483647, -2147483648];

/** @type {number[]} */
const FLOAT_VALUES = [0, 1.5, -1.5, 3.14159, 0.5, -0.25, 100.0, 2.718281828];

/** @type {string[]} */
const STRING_VALUES = ['', 'a', 'hello', 'café', '🎉', 'foo bar', 'test', '42'];

/** @type {string[]} */
const DICT_KEYS = ['a', 'b', 'c', 'x', 'y', 'key', 'name', 'val'];

/**
 * Generates random JS value source strings for a given BridgeType.
 */
export class ValueSmith {
  /** @type {Random} */
  #rng;

  /**
   * @param {Random} rng
   */
  constructor(rng) {
    this.#rng = rng;
  }

  /**
   * Returns a JS source string for a random value of the given type.
   * @param {BridgeType} type
   * @returns {string}
   */
  randomValue(type) {
    switch (type.kind) {
      case 'int':
        return String(this.#rng.pick(INT_EDGE_CASES));

      case 'float':
      case 'double':
        return String(this.#rng.pick(FLOAT_VALUES));

      case 'string': {
        const s = this.#rng.pick(STRING_VALUES);
        return JSON.stringify(s);
      }

      case 'bool':
        return this.#rng.bool() ? 'true' : 'false';

      case 'nullable': {
        if (this.#rng.next() < 0.3) {
          return 'null';
        }
        return this.randomValue(type.wrapped);
      }

      case 'array': {
        const len = this.#rng.nextInt(0, 5);
        const elems = [];
        for (let i = 0; i < len; i++) {
          elems.push(this.randomValue(type.element));
        }
        return `[${elems.join(', ')}]`;
      }

      case 'dictionary': {
        const len = this.#rng.nextInt(0, 3);
        const usedKeys = new Set();
        const entries = [];
        for (let i = 0; i < len; i++) {
          let key;
          do {
            key = this.#rng.pick(DICT_KEYS);
          } while (usedKeys.has(key));
          usedKeys.add(key);
          entries.push(`${JSON.stringify(key)}: ${this.randomValue(type.value)}`);
        }
        return `{${entries.join(', ')}}`;
      }

      case 'jsObject':
        return '{}';

      case 'void':
        return 'undefined';

      case 'importedClass':
        // Can't generate imported classes as literals
        return 'undefined /* cannot literal importedClass */';

      default:
        return 'undefined';
    }
  }

  /**
   * Returns a JS source string for an assertion comparison.
   * @param {string} varName — the variable to assert against
   * @param {string} expectedValue — the expected value source string
   * @param {BridgeType} type
   * @returns {string}
   */
  assertionCode(varName, expectedValue, type) {
    switch (type.kind) {
      case 'array':
      case 'dictionary':
      case 'nullable':
        return `assert.deepStrictEqual(${varName}, ${expectedValue})`;

      case 'void':
        return `assert.strictEqual(${varName}, undefined)`;

      default:
        return `assert.strictEqual(${varName}, ${expectedValue})`;
    }
  }
}
