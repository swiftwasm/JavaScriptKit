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
 * Map a BridgeType to its Swift type string.
 * @param {BridgeType} type
 * @returns {string}
 */
function swiftType(type) {
    switch (type.kind) {
        case "int":       return "Int";
        case "float":     return "Float";
        case "double":    return "Double";
        case "string":    return "String";
        case "bool":      return "Bool";
        case "jsObject":  return "JSObject";
        case "void":      return "Void";
        case "nullable":  return `${swiftType(type.wrapped)}?`;
        case "array":     return `[${swiftType(type.element)}]`;
        case "dictionary": return `[String: ${swiftType(type.value)}]`;
        case "importedClass": return type.name;
        default:
            throw new Error(`Unknown BridgeType kind: ${/** @type {any} */ (type).kind}`);
    }
}

/**
 * Emit a Swift literal for a given value and BridgeType.
 * @param {string} jsValue - JSON-encoded value string from the operation
 * @param {BridgeType} type
 * @returns {string}
 */
function swiftLiteral(jsValue, type) {
    const val = JSON.parse(jsValue);
    switch (type.kind) {
        case "int":
            return String(Math.trunc(Number(val)));
        case "float":
        case "double":
            return String(Number(val));
        case "string":
            return swiftStringLiteral(String(val));
        case "bool":
            return val ? "true" : "false";
        case "nullable":
            if (val === null || val === undefined) return "nil";
            return swiftLiteral(JSON.stringify(val), type.wrapped);
        case "array":
            if (!Array.isArray(val)) return "[]";
            return `[${val.map(e => swiftLiteral(JSON.stringify(e), type.element)).join(", ")}]`;
        case "dictionary": {
            if (val === null || typeof val !== "object") return "[:]";
            const entries = Object.entries(val);
            if (entries.length === 0) return "[:]";
            return `[${entries.map(([k, v]) => `${swiftStringLiteral(k)}: ${swiftLiteral(JSON.stringify(v), type.value)}`).join(", ")}]`;
        }
        case "void":
            return "()";
        default:
            // jsObject, importedClass — should never be generated as literals
            throw new Error(`Cannot generate Swift literal for type: ${type.kind}`);
    }
}

/**
 * Escape a string for Swift string literal.
 * @param {string} s
 * @returns {string}
 */
function swiftStringLiteral(s) {
    const escaped = s
        .replace(/\\/g, "\\\\")
        .replace(/"/g, '\\"')
        .replace(/\n/g, "\\n")
        .replace(/\r/g, "\\r")
        .replace(/\t/g, "\\t");
    return `"${escaped}"`;
}

/**
 * Emit parameter list for imported function declarations (all _ labels).
 * @param {Param[]} params
 * @returns {string}
 */
function emitImportParams(params) {
    return params.map(p => `_ ${p.name}: ${swiftType(p.type)}`).join(", ");
}

/**
 * Emit parameter list for exported function declarations (named labels).
 * @param {Param[]} params
 * @returns {string}
 */
function emitExportParams(params) {
    return params.map(p => `${p.name}: ${swiftType(p.type)}`).join(", ");
}

/**
 * Emit an imported free function declaration.
 * @param {ImportedFunc} func
 * @returns {string}
 */
function emitImportedFunc(func) {
    const params = emitImportParams(func.params);
    const ret = swiftType(func.returnType);
    return `@JSFunction func ${func.name}(${params}) throws(JSException) -> ${ret}`;
}

/**
 * Emit an imported class declaration.
 * @param {ImportedClass} cls
 * @returns {string}
 */
function emitImportedClass(cls) {
    const params = emitImportParams(cls.constructorParams);
    const lines = [
        `@JSClass struct ${cls.name} {`,
        `    @JSFunction init(${params}) throws(JSException)`,
        `}`,
    ];
    return lines.join("\n");
}

/**
 * Emit a single operation within a test function body.
 * @param {Operation} op
 * @returns {string}
 */
function emitOperation(op) {
    switch (op.kind) {
        case "literal": {
            const typeName = swiftType(op.var.type);
            const value = swiftLiteral(op.jsValue, op.var.type);
            return `    let ${op.var.name}: ${typeName} = ${value}`;
        }
        case "callImport": {
            const args = op.args.map(a => a.name).join(", ");
            return `    let ${op.var.name} = try! ${op.func.name}(${args})`;
        }
        case "construct": {
            const args = op.args.map(a => a.name).join(", ");
            return `    let ${op.var.name} = try! ${op.class.name}(${args})`;
        }
        case "return":
            if (op.value.type.kind === "void") return `    return`;
            return `    return ${op.value.name}`;
        default:
            throw new Error(`Unknown operation kind: ${/** @type {any} */ (op).kind}`);
    }
}

/**
 * Emit a single exported test function.
 * @param {TestFunc} func
 * @returns {string}
 */
function emitTestFunc(func) {
    const params = emitExportParams(func.params);
    const ret = swiftType(func.returnType);
    const header = `@JS func ${func.name}(${params}) -> ${ret} {`;
    const body = func.ops.map(op => emitOperation(op)).join("\n");
    return `${header}\n${body}\n}`;
}

/**
 * Generate the complete main.swift file for a test case.
 * @param {TestCase} testCase
 * @returns {string}
 */
export function emitSwift(testCase) {
    const lines = [];

    // Header
    lines.push("import JavaScriptKit");
    lines.push("");

    // Import declarations: classes first
    for (const cls of testCase.env.importedClasses) {
        lines.push(emitImportedClass(cls));
        lines.push("");
    }

    // Import declarations: free functions
    for (const func of testCase.env.importedFuncs) {
        lines.push(emitImportedFunc(func));
        lines.push("");
    }

    // Exported test functions
    for (const tf of testCase.testFuncs) {
        lines.push(emitTestFunc(tf));
        lines.push("");
    }

    return lines.join("\n");
}
