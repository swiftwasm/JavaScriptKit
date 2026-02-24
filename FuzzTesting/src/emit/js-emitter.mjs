// @ts-check

/**
 * @typedef {import('../types.mjs').BridgeType} BridgeType
 * @typedef {import('../types.mjs').Param} Param
 * @typedef {import('../types.mjs').ImportedFunc} ImportedFunc
 * @typedef {import('../types.mjs').ImportedClass} ImportedClass
 * @typedef {import('../types.mjs').Var} Var
 * @typedef {import('../types.mjs').Operation} Operation
 * @typedef {import('../types.mjs').TestFunc} TestFunc
 * @typedef {import('../types.mjs').TestCase} TestCase
 */

/**
 * Generate a default JS constant for a given BridgeType.
 * Used when no parameter matches the return type.
 * @param {BridgeType} type
 * @returns {*}
 */
function defaultJSValue(type) {
    switch (type.kind) {
        case "int":       return 0;
        case "float":     return 0.0;
        case "double":    return 0.0;
        case "string":    return "";
        case "bool":      return false;
        case "jsObject":  return {};
        case "void":      return undefined;
        case "nullable":  return null;
        case "array":     return [];
        case "dictionary": return {};
        case "importedClass": return {};
        default: return undefined;
    }
}

/**
 * Check if two BridgeTypes are structurally equal.
 * @param {BridgeType} a
 * @param {BridgeType} b
 * @returns {boolean}
 */
function typesEqual(a, b) {
    if (a.kind !== b.kind) return false;
    switch (a.kind) {
        case "nullable":
            return typesEqual(a.wrapped, /** @type {Extract<BridgeType, {kind:"nullable"}>} */ (b).wrapped);
        case "array":
            return typesEqual(a.element, /** @type {Extract<BridgeType, {kind:"array"}>} */ (b).element);
        case "dictionary":
            return typesEqual(a.value, /** @type {Extract<BridgeType, {kind:"dictionary"}>} */ (b).value);
        case "importedClass":
            return a.name === /** @type {Extract<BridgeType, {kind:"importedClass"}>} */ (b).name;
        default:
            return true;
    }
}

/**
 * Returns the assertion strategy for a type.
 * @param {BridgeType} type
 * @returns {"deep"|"strict"|"float"}
 */
function assertionKind(type) {
    switch (type.kind) {
        case "float":
            return "float";
        case "array":
        case "dictionary":
            return "deep";
        case "nullable":
            return assertionKind(type.wrapped);
        default:
            // importedClass + jsObject use strictEqual (reference identity is preserved)
            return "strict";
    }
}

/**
 * Format a JS value as a source literal string.
 * @param {*} val
 * @returns {string}
 */
function jsLiteral(val) {
    if (val === null) return "null";
    if (val === undefined) return "undefined";
    if (typeof val === "string") return JSON.stringify(val);
    if (typeof val === "number") return String(val);
    if (typeof val === "boolean") return String(val);
    if (Array.isArray(val)) return `[${val.map(jsLiteral).join(", ")}]`;
    if (typeof val === "object") {
        const entries = Object.entries(val);
        if (entries.length === 0) return "{}";
        return `{ ${entries.map(([k, v]) => `${JSON.stringify(k)}: ${jsLiteral(v)}`).join(", ")} }`;
    }
    return String(val);
}

/**
 * Generate the JS implementation body for an imported function.
 * Strategy: return the first param that matches the return type, else return a default.
 * @param {ImportedFunc} func
 * @returns {string}
 */
function emitImportFuncImpl(func) {
    const paramNames = func.params.map(p => p.name);
    const paramList = paramNames.join(", ");

    if (func.returnType.kind === "void") {
        return `(${paramList}) => {}`;
    }

    // If return type is string and we have multiple string params, concatenate them
    if (func.returnType.kind === "string") {
        const stringParams = func.params.filter(p => p.kind === "string" || p.type.kind === "string");
        if (stringParams.length > 1) {
            return `(${paramList}) => ${stringParams.map(p => p.name).join(" + ")}`;
        }
    }

    // If return type is numeric (int/float/double) and we have multiple numeric params, sum them
    if (func.returnType.kind === "int" || func.returnType.kind === "float" || func.returnType.kind === "double") {
        const numericParams = func.params.filter(p =>
            p.type.kind === "int" || p.type.kind === "float" || p.type.kind === "double"
        );
        if (numericParams.length > 1) {
            return `(${paramList}) => ${numericParams.map(p => p.name).join(" + ")}`;
        }
    }

    // Return first param matching return type
    for (const p of func.params) {
        if (typesEqual(p.type, func.returnType)) {
            return `(${paramList}) => ${p.name}`;
        }
    }

    // No match: return a constant
    const def = defaultJSValue(func.returnType);
    return `(${paramList}) => ${jsLiteral(def)}`;
}

/**
 * Generate the JS class implementation for an imported class.
 * Constructor stores params as _p0, _p1, etc.
 * @param {ImportedClass} cls
 * @returns {string}
 */
function emitImportClassImpl(cls) {
    const paramNames = cls.constructorParams.map(p => p.name);
    const paramList = paramNames.join(", ");
    const assigns = paramNames.map((n, i) => `this._p${i} = ${n};`).join(" ");
    return `class ${cls.name} { constructor(${paramList}) { ${assigns} } }`;
}

/**
 * Evaluate what the imported function returns for given JS argument values.
 * Must mirror the logic in emitImportFuncImpl.
 * @param {ImportedFunc} func
 * @param {*[]} argValues
 * @returns {*}
 */
function evalImportFunc(func, argValues) {
    if (func.returnType.kind === "void") return undefined;

    // String concatenation case
    if (func.returnType.kind === "string") {
        const stringIndices = func.params
            .map((p, i) => ({ p, i }))
            .filter(({ p }) => p.type.kind === "string");
        if (stringIndices.length > 1) {
            return stringIndices.map(({ i }) => argValues[i]).join("");
        }
    }

    // Numeric sum case
    if (func.returnType.kind === "int" || func.returnType.kind === "float" || func.returnType.kind === "double") {
        const numericIndices = func.params
            .map((p, i) => ({ p, i }))
            .filter(({ p }) =>
                p.type.kind === "int" || p.type.kind === "float" || p.type.kind === "double"
            );
        if (numericIndices.length > 1) {
            return numericIndices.reduce((acc, { i }) => acc + argValues[i], 0);
        }
    }

    // Identity on first matching param
    for (let i = 0; i < func.params.length; i++) {
        if (typesEqual(func.params[i].type, func.returnType)) {
            return argValues[i];
        }
    }

    return defaultJSValue(func.returnType);
}

/**
 * Evaluate what constructing an imported class yields.
 * @param {ImportedClass} cls
 * @param {*[]} argValues
 * @returns {Record<string, *>}
 */
function evalConstruct(cls, argValues) {
    /** @type {Record<string, *>} */
    const obj = {};
    for (let i = 0; i < argValues.length; i++) {
        obj[`_p${i}`] = argValues[i];
    }
    return obj;
}

/**
 * Result of tracing a test function.
 * @typedef {{ value: *, sourceExpr: string }} TraceResult
 */

/**
 * Trace through a test function's operations to compute:
 * - the expected return value (for value-type assertions)
 * - the source expression to compare against (for reference-type assertions,
 *   this is a variable name so we can assert reference identity)
 *
 * @param {TestFunc} func
 * @param {*[]} argValues - JS values for the function params
 * @param {string[]} argVarNames - emitted variable names (e.g. ["_a0", "_a1"])
 * @param {TestCase} testCase
 * @returns {TraceResult}
 */
function traceTestFunc(func, argValues, argVarNames, testCase) {
    /** @type {Map<string, *>} */
    const vars = new Map();
    /** @type {Map<string, string>} */
    const varSources = new Map();

    for (let i = 0; i < func.params.length; i++) {
        vars.set(func.params[i].name, argValues[i]);
        varSources.set(func.params[i].name, argVarNames[i]);
    }

    for (const op of func.ops) {
        switch (op.kind) {
            case "literal": {
                const val = JSON.parse(op.jsValue);
                vars.set(op.var.name, val);
                varSources.set(op.var.name, jsLiteral(val));
                break;
            }
            case "callImport": {
                const callArgs = op.args.map(a => vars.get(a.name));
                const result = evalImportFunc(op.func, callArgs);
                vars.set(op.var.name, result);
                const argSrcs = op.args.map(a => varSources.get(a.name) ?? jsLiteral(vars.get(a.name)));
                varSources.set(op.var.name, traceImportSource(op.func, argSrcs));
                break;
            }
            case "construct": {
                const ctorArgs = op.args.map(a => vars.get(a.name));
                vars.set(op.var.name, evalConstruct(op.class, ctorArgs));
                // Constructs always create a new object — no way to reference-match from outside
                const ctorSrcs = op.args.map(a => varSources.get(a.name) ?? jsLiteral(vars.get(a.name)));
                varSources.set(op.var.name, `new ${op.class.name}(${ctorSrcs.join(", ")})`);
                break;
            }
            case "return": {
                const val = vars.get(op.value.name);
                const src = varSources.get(op.value.name) ?? jsLiteral(val);
                return { value: val, sourceExpr: src };
            }
        }
    }
    return { value: undefined, sourceExpr: "undefined" };
}

/**
 * Determine what source expression an import function returns.
 * Must mirror emitImportFuncImpl / evalImportFunc.
 * @param {ImportedFunc} func
 * @param {string[]} argSources
 * @returns {string}
 */
function traceImportSource(func, argSources) {
    if (func.returnType.kind === "void") return "undefined";

    if (func.returnType.kind === "string") {
        const idx = func.params.map((p, i) => ({ p, i })).filter(({ p }) => p.type.kind === "string");
        if (idx.length > 1) return idx.map(({ i }) => argSources[i]).join(" + ");
    }

    if (func.returnType.kind === "int" || func.returnType.kind === "float" || func.returnType.kind === "double") {
        const idx = func.params.map((p, i) => ({ p, i })).filter(({ p }) =>
            p.type.kind === "int" || p.type.kind === "float" || p.type.kind === "double"
        );
        if (idx.length > 1) return idx.map(({ i }) => argSources[i]).join(" + ");
    }

    // Identity: return first param matching return type
    for (let i = 0; i < func.params.length; i++) {
        if (typesEqual(func.params[i].type, func.returnType)) return argSources[i];
    }

    return jsLiteral(defaultJSValue(func.returnType));
}

/**
 * Generate test argument source strings and runtime values for a list of params.
 * @param {Param[]} params
 * @param {DeclEnv} env
 * @returns {{ sources: string[], values: *[] }}
 */
function generateTestArgs(params, env) {
    const sources = [];
    const values = [];
    for (let i = 0; i < params.length; i++) {
        const { source, value } = generateArg(params[i].type, i, env);
        sources.push(source);
        values.push(value);
    }
    return { sources, values };
}

/**
 * Generate a deterministic test arg: both the JS source string and the runtime value.
 * @param {BridgeType} type
 * @param {number} index
 * @param {DeclEnv} env
 * @returns {{ source: string, value: * }}
 */
function generateArg(type, index, env) {
    switch (type.kind) {
        case "int":       { const v = 10 + index; return { source: String(v), value: v }; }
        case "float":     { const v = 1.5 + index; return { source: String(v), value: v }; }
        case "double":    { const v = 2.5 + index; return { source: String(v), value: v }; }
        case "string":    { const v = `s${index}`; return { source: JSON.stringify(v), value: v }; }
        case "bool":      { const v = index % 2 === 0; return { source: String(v), value: v }; }
        case "jsObject":  return { source: "{}", value: {} };
        case "void":      return { source: "undefined", value: undefined };
        case "nullable":  return generateArg(type.wrapped, index, env);
        case "array": {
            const inner = generateArg(type.element, 0, env);
            return { source: `[${inner.source}]`, value: [inner.value] };
        }
        case "dictionary": {
            const inner = generateArg(type.value, 0, env);
            const key = `k${index}`;
            return { source: `{ ${JSON.stringify(key)}: ${inner.source} }`, value: { [key]: inner.value } };
        }
        case "importedClass": {
            const cls = env.importedClasses.find(c => c.name === type.name);
            if (!cls) return { source: "{}", value: {} };
            // Construct with deterministic args
            const ctorArgs = cls.constructorParams.map((p, ci) => generateArg(p.type, ci, env));
            const ctorSources = ctorArgs.map(a => a.source).join(", ");
            const ctorValues = ctorArgs.map(a => a.value);
            return {
                source: `new ${cls.name}(${ctorSources})`,
                value: evalConstruct(cls, ctorValues),
            };
        }
        default: return { source: "null", value: null };
    }
}

/**
 * Generate the complete harness.mjs file for a test case.
 * @param {TestCase} testCase
 * @returns {string}
 */
export function emitJS(testCase) {
    const lines = [];

    lines.push(`import { instantiate } from "./instantiate.js";`);
    lines.push(`import { defaultNodeSetup } from "./platforms/node.js";`);
    lines.push(`import assert from "node:assert/strict";`);
    lines.push("");

    // Hoist class definitions so they're in scope for both getImports and assertions
    for (const cls of testCase.env.importedClasses) {
        lines.push(emitImportClassImpl(cls));
    }
    if (testCase.env.importedClasses.length > 0) lines.push("");

    // Build getImports body
    const importEntries = [];

    for (const func of testCase.env.importedFuncs) {
        importEntries.push(`            ${func.name}: ${emitImportFuncImpl(func)}`);
    }

    for (const cls of testCase.env.importedClasses) {
        importEntries.push(`            ${cls.name}: ${cls.name}`);
    }

    lines.push(`const nodeOptions = await defaultNodeSetup();`);
    lines.push(`const { exports } = await instantiate({`);
    lines.push(`    ...nodeOptions,`);
    lines.push(`    getImports() {`);
    lines.push(`        return {`);
    lines.push(importEntries.join(",\n"));
    lines.push(`        };`);
    lines.push(`    }`);
    lines.push(`});`);
    lines.push("");

    // Test assertions
    for (const tf of testCase.testFuncs) {
        const { sources: argSources, values: argValues } = generateTestArgs(tf.params, testCase.env);

        // Emit args as named variables so reference-type assertions can
        // compare against the same variable (preserving identity).
        const argVarNames = tf.params.map((_, i) => `_${tf.name}_a${i}`);
        for (let i = 0; i < tf.params.length; i++) {
            lines.push(`const ${argVarNames[i]} = ${argSources[i]};`);
        }
        const argStr = argVarNames.join(", ");

        if (tf.returnType.kind === "void") {
            lines.push(`exports.${tf.name}(${argStr});`);
            lines.push("");
            continue;
        }

        const { value: expected, sourceExpr } = traceTestFunc(tf, argValues, argVarNames, testCase);
        const kind = assertionKind(tf.returnType);

        if (kind === "float") {
            lines.push(`{ const _r = exports.${tf.name}(${argStr}); assert.ok(Math.abs(_r - ${jsLiteral(expected)}) < Math.abs(${jsLiteral(expected)} * 1e-6) + 1e-6, "float mismatch: " + _r + " vs ${jsLiteral(expected)}"); }`);
        } else if (kind === "deep") {
            lines.push(`assert.deepStrictEqual(exports.${tf.name}(${argStr}), ${sourceExpr});`);
        } else {
            // strictEqual — works for primitives and reference identity
            lines.push(`assert.strictEqual(exports.${tf.name}(${argStr}), ${sourceExpr});`);
        }
        lines.push("");
    }

    lines.push("");
    lines.push(`console.log("All assertions passed.");`);
    lines.push("");

    return lines.join("\n");
}
