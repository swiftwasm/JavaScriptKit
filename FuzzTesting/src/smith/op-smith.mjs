// @ts-check

/**
 * @typedef {import('../types.mjs').BridgeType} BridgeType
 * @typedef {import('../types.mjs').DeclEnv} DeclEnv
 * @typedef {import('../types.mjs').ImportedFunc} ImportedFunc
 * @typedef {import('../types.mjs').ImportedClass} ImportedClass
 * @typedef {import('../types.mjs').Param} Param
 * @typedef {import('../types.mjs').Var} Var
 * @typedef {import('../types.mjs').Operation} Operation
 * @typedef {import('../types.mjs').TestFunc} TestFunc
 */

import { Random } from './random.mjs';
import { TypeSmith } from './type-smith.mjs';
import { ValueSmith } from './value-smith.mjs';

/**
 * Deep-equal comparison for BridgeType objects.
 * @param {BridgeType} a
 * @param {BridgeType} b
 * @returns {boolean}
 */
function typesEqual(a, b) {
  if (a.kind !== b.kind) return false;
  switch (a.kind) {
    case 'nullable':
      return /** @type {any} */ (b).wrapped != null && typesEqual(a.wrapped, /** @type {any} */ (b).wrapped);
    case 'array':
      return /** @type {any} */ (b).element != null && typesEqual(a.element, /** @type {any} */ (b).element);
    case 'dictionary':
      return /** @type {any} */ (b).value != null && typesEqual(a.value, /** @type {any} */ (b).value);
    case 'importedClass':
      return /** @type {any} */ (b).name === a.name;
    default:
      return true; // leaf kinds match by kind alone
  }
}

/**
 * Find all vars in scope that match a given type.
 * @param {Var[]} scope
 * @param {BridgeType} type
 * @returns {Var[]}
 */
function findVarsByType(scope, type) {
  return scope.filter((v) => typesEqual(v.type, type));
}

/** @type {BridgeType[]} */
const LITERAL_LEAF_TYPES = [
  { kind: 'int' },
  { kind: 'float' },
  { kind: 'double' },
  { kind: 'string' },
  { kind: 'bool' },
];

/**
 * Check if a type can be represented as a Swift literal.
 * @param {BridgeType} type
 * @returns {boolean}
 */
function canLiteral(type) {
  switch (type.kind) {
    case 'int': case 'float': case 'double': case 'string': case 'bool':
      return true;
    case 'nullable':
      return canLiteral(type.wrapped);
    case 'array':
      return canLiteral(type.element);
    case 'dictionary':
      return canLiteral(type.value);
    default:
      return false;
  }
}

/**
 * Operation sequence generator. Builds a TestFunc with typed variables
 * and operations that compose using the current scope.
 */
export class OpSmith {
  /** @type {Random} */
  #rng;
  /** @type {number} */
  #maxOps;
  /** @type {number} */
  #maxParams;

  /**
   * @param {Random} rng
   * @param {{ maxOps?: number, maxParams?: number }} [options]
   */
  constructor(rng, options = {}) {
    this.#rng = rng;
    this.#maxOps = options.maxOps ?? 8;
    this.#maxParams = options.maxParams ?? 4;
  }

  /**
   * Generate a complete test function.
   * @param {string} name — function name (e.g. "testFunc0")
   * @param {DeclEnv} env — available declarations
   * @returns {TestFunc}
   */
  generateFunc(name, env) {
    const typeSmith = new TypeSmith(this.#rng, { maxDepth: 2 });
    const valueSmith = new ValueSmith(this.#rng);
    const classNames = env.importedClasses.map((c) => c.name);

    // 1. Generate function params — these are the initial vars in scope
    const paramCount = this.#rng.nextInt(0, this.#maxParams);
    /** @type {Param[]} */
    const params = [];
    /** @type {Var[]} */
    const scope = [];
    let varIdx = 0;

    const paramLabels = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
    for (let i = 0; i < paramCount; i++) {
      const type = typeSmith.randomParamType(0, classNames);
      const paramName = paramLabels[i] ?? `p${i}`;
      params.push({ label: null, name: paramName, type });
      // Use param name directly as the scope variable name
      scope.push({ name: paramName, type });
    }

    // 2. Pick a target return type
    const returnType = typeSmith.randomReturnType(0, classNames);

    // 3. Generate operations
    const opCount = this.#rng.nextInt(0, this.#maxOps);
    /** @type {Operation[]} */
    const ops = [];

    for (let i = 0; i < opCount; i++) {
      const op = this.#pickOperation(scope, env, typeSmith, valueSmith, classNames, varIdx);
      if (op) {
        ops.push(op.operation);
        scope.push(op.newVar);
        varIdx = op.nextVarIdx;
      }
    }

    // 4. Final return: find a var matching the return type, or generate a literal
    const returnOp = this.#makeReturn(scope, returnType, valueSmith, varIdx, ops);
    ops.push(returnOp);

    // Fix up return type to match what we're actually returning
    const actualReturnType = returnOp.value.type;
    return { name, params, returnType: actualReturnType, ops };
  }

  /**
   * Pick a valid operation given current scope.
   * @param {Var[]} scope
   * @param {DeclEnv} env
   * @param {TypeSmith} typeSmith
   * @param {ValueSmith} valueSmith
   * @param {string[]} classNames
   * @param {number} varIdx
   * @returns {{ operation: Operation, newVar: Var, nextVarIdx: number } | null}
   */
  #pickOperation(scope, env, typeSmith, valueSmith, classNames, varIdx) {
    /** @type {string[]} */
    const candidates = ['literal']; // literal is always valid

    // Check which callImport candidates are satisfiable
    const satisfiableFuncs = env.importedFuncs.filter((f) =>
      f.params.every((p) => findVarsByType(scope, p.type).length > 0)
    );
    if (satisfiableFuncs.length > 0) {
      candidates.push('callImport');
    }

    // Check which construct candidates are satisfiable
    const satisfiableClasses = env.importedClasses.filter((c) =>
      c.constructorParams.every((p) => findVarsByType(scope, p.type).length > 0)
    );
    if (satisfiableClasses.length > 0) {
      candidates.push('construct');
    }

    const choice = this.#rng.pick(candidates);
    const newVarName = `v${varIdx}`;

    switch (choice) {
      case 'literal': {
        const type = this.#rng.pick(LITERAL_LEAF_TYPES);
        const jsValue = valueSmith.randomValue(type);
        /** @type {Var} */
        const newVar = { name: newVarName, type };
        return {
          operation: { kind: 'literal', var: newVar, jsValue },
          newVar,
          nextVarIdx: varIdx + 1,
        };
      }

      case 'callImport': {
        const func = this.#rng.pick(satisfiableFuncs);
        const args = func.params.map((p) => {
          const matches = findVarsByType(scope, p.type);
          return this.#rng.pick(matches);
        });
        const resultType = func.returnType;
        /** @type {Var} */
        const newVar = { name: newVarName, type: resultType };
        return {
          operation: { kind: 'callImport', var: newVar, func, args },
          newVar,
          nextVarIdx: varIdx + 1,
        };
      }

      case 'construct': {
        const cls = this.#rng.pick(satisfiableClasses);
        const args = cls.constructorParams.map((p) => {
          const matches = findVarsByType(scope, p.type);
          return this.#rng.pick(matches);
        });
        /** @type {BridgeType} */
        const resultType = { kind: 'importedClass', name: cls.name };
        /** @type {Var} */
        const newVar = { name: newVarName, type: resultType };
        return {
          operation: { kind: 'construct', var: newVar, class: cls, args },
          newVar,
          nextVarIdx: varIdx + 1,
        };
      }

      default:
        return null;
    }
  }

  /**
   * Create the final return operation.
   * @param {Var[]} scope
   * @param {BridgeType} returnType
   * @param {ValueSmith} valueSmith
   * @param {number} varIdx
   * @param {Operation[]} ops — mutated: may push a literal op
   * @returns {Operation}
   */
  #makeReturn(scope, returnType, valueSmith, varIdx, ops) {
    // For void, return a dummy var
    if (returnType.kind === 'void') {
      /** @type {Var} */
      const dummyVar = { name: '_void', type: { kind: 'void' } };
      return { kind: 'return', value: dummyVar };
    }

    // Try to find an existing var of matching type
    const matches = findVarsByType(scope, returnType);
    if (matches.length > 0) {
      return { kind: 'return', value: this.#rng.pick(matches) };
    }

    // No matching var — generate a literal if the type allows it
    if (canLiteral(returnType)) {
      const newVarName = `v${varIdx}`;
      const jsValue = valueSmith.randomValue(returnType);
      /** @type {Var} */
      const newVar = { name: newVarName, type: returnType };
      ops.push({ kind: 'literal', var: newVar, jsValue });
      return { kind: 'return', value: newVar };
    }

    // Fallback: pick any var from scope (type mismatch but avoids invalid code)
    // This can happen when no var of the right type exists and we can't make a literal.
    // Change the return type to match what we have.
    if (scope.length > 0) {
      const fallback = this.#rng.pick(scope);
      // We'll fix the function's return type to match
      return { kind: 'return', value: fallback };
    }

    // Last resort: return a simple literal and change the return type
    const newVarName = `v${varIdx}`;
    const fallbackType = this.#rng.pick(LITERAL_LEAF_TYPES);
    const jsValue = valueSmith.randomValue(fallbackType);
    /** @type {Var} */
    const newVar = { name: newVarName, type: fallbackType };
    ops.push({ kind: 'literal', var: newVar, jsValue });
    return { kind: 'return', value: newVar };
  }
}
