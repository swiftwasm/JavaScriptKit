/**
 * TypeScript type processing functionality
 * @module processor
 */

// @ts-check
import ts from 'typescript';

/** @typedef {import('./index.d.ts').Parameter} Parameter */

/**
 * @typedef {{
 *   print: (level: "warning" | "error", message: string, node?: ts.Node) => void,
 * }} DiagnosticEngine
 */

/**
 * TypeScript type processor class
 */
export class TypeProcessor {
    /**
     * Create a TypeScript program from a d.ts file
     * @param {string[]} filePaths - Paths to the d.ts file
     * @param {ts.CompilerOptions} options - Compiler options
     * @returns {ts.Program} TypeScript program object
     */
    static createProgram(filePaths, options) {
        const host = ts.createCompilerHost(options);
        return ts.createProgram(filePaths, {
            ...options,
            noCheck: true,
            skipLibCheck: true,
        }, host);
    }

    /**
     * @param {ts.TypeChecker} checker - TypeScript type checker
     * @param {DiagnosticEngine} diagnosticEngine - Diagnostic engine
     */
    constructor(checker, diagnosticEngine, options = {
        defaultImportFromGlobal: false,
    }) {
        this.checker = checker;
        this.diagnosticEngine = diagnosticEngine;
        this.options = options;

        /** @type {Map<ts.Type, string>} */
        this.processedTypes = new Map();
        /** @type {Map<ts.Type, ts.Node>} Seen position by type */
        this.seenTypes = new Map();
        /** @type {string[]} Collected Swift code lines */
        this.swiftLines = [];
        /** @type {Set<string>} */
        this.emittedEnumNames = new Set();
        /** @type {Set<string>} */
        this.emittedStructuredTypeNames = new Set();
        /** @type {Set<string>} */
        this.emittedStringLiteralUnionNames = new Set();
        /** @type {Set<string>} */
        this.emittedStringLiteralUnionNames = new Set();

        /** @type {Set<string>} */
        this.visitedDeclarationKeys = new Set();

        /** @type {Map<string, string>} */
        this.swiftTypeNameByJSTypeName = new Map();

        /** @type {boolean} */
        this.defaultImportFromGlobal = options.defaultImportFromGlobal ?? false;
    }

    /**
     * Escape a string for a Swift string literal inside macro arguments.
     * @param {string} value
     * @returns {string}
     * @private
     */
    escapeForSwiftStringLiteral(value) {
        return value.replaceAll("\\", "\\\\").replaceAll("\"", "\\\\\"");
    }

    /**
     * Render a `jsName:` macro argument if the JS name differs from the default.
     * @param {string} jsName
     * @param {string} defaultName
     * @returns {string | null}
     * @private
     */
    renderOptionalJSNameArg(jsName, defaultName) {
        if (jsName === defaultName) return null;
        return `jsName: "${this.escapeForSwiftStringLiteral(jsName)}"`;
    }

    /**
     * Render a macro annotation with optional labeled arguments.
     * @param {string} macroName
     * @param {string[]} args
     * @returns {string}
     * @private
     */
    renderMacroAnnotation(macroName, args) {
        if (!args.length) return `@${macroName}`;
        return `@${macroName}(${args.join(", ")})`;
    }

    /**
     * Convert a TypeScript type name to a valid Swift type identifier.
     * @param {string} jsTypeName
     * @returns {string}
     * @private
     */
    swiftTypeName(jsTypeName) {
        const cached = this.swiftTypeNameByJSTypeName.get(jsTypeName);
        if (cached) return cached;
        const swiftName = isValidSwiftDeclName(jsTypeName) ? jsTypeName : makeValidSwiftIdentifier(jsTypeName, { emptyFallback: "_" });
        this.swiftTypeNameByJSTypeName.set(jsTypeName, swiftName);
        return swiftName;
    }

    /**
     * Render a Swift type identifier from a TypeScript type name.
     * @param {string} jsTypeName
     * @returns {string}
     * @private
     */
    renderTypeIdentifier(jsTypeName) {
        return this.renderIdentifier(this.swiftTypeName(jsTypeName));
    }

    /**
     * Process type declarations from a TypeScript program and render Swift code
     * @param {ts.Program} program - TypeScript program
     * @param {string} inputFilePath - Path to the input file
     * @returns {{ content: string, hasAny: boolean }} Rendered Swift code
     */
    processTypeDeclarations(program, inputFilePath) {
        const sourceFiles = program.getSourceFiles().filter(
            sf => !sf.isDeclarationFile || sf.fileName === inputFilePath
        );

        for (const sourceFile of sourceFiles) {
            if (sourceFile.fileName.includes('node_modules/typescript/lib')) continue;

            Error.stackTraceLimit = 100;

            try {
                sourceFile.forEachChild(node => {
                    this.visitNode(node);

                    for (const [type, node] of this.seenTypes) {
                        this.seenTypes.delete(type);
                        const stringLiteralUnion = this.getStringLiteralUnionLiterals(type);
                        if (stringLiteralUnion && stringLiteralUnion.length > 0) {
                            this.emitStringLiteralUnion(type, node);
                            continue;
                        }
                        if (this.isEnumType(type)) {
                            this.visitEnumType(type, node);
                            continue;
                        }
                        const members = type.getProperties();
                        if (members) {
                            this.visitStructuredType(type, node, members);
                        }
                    }
                });
            } catch (/** @type {unknown} */ error) {
                if (error instanceof Error) {
                    this.diagnosticEngine.print("error", `Error processing ${sourceFile.fileName}: ${error.message}`);
                } else {
                    this.diagnosticEngine.print("error", `Error processing ${sourceFile.fileName}: ${String(error)}`);
                }
            }
        }

        const content = this.swiftLines.join("\n").trimEnd() + "\n";
        const hasAny = content.trim().length > 0;
        return { content, hasAny };
    }


    /**
     * Visit a node and process it
     * @param {ts.Node} node - The node to visit
     */
    visitNode(node) {
        if (ts.isFunctionDeclaration(node)) {
            this.visitFunctionDeclaration(node);
        } else if (ts.isClassDeclaration(node)) {
            this.visitClassDecl(node);
        } else if (ts.isVariableStatement(node)) {
            this.visitVariableStatement(node);
        } else if (ts.isEnumDeclaration(node)) {
            this.visitEnumDeclaration(node);
        } else if (ts.isExportDeclaration(node)) {
            this.visitExportDeclaration(node);
        }
    }

    /**
     * Visit an export declaration and process re-exports like:
     * - export { Thing } from "./module";
     * - export { Thing as Alias } from "./module";
     * - export * from "./module";
     * @param {ts.ExportDeclaration} node
     */
    visitExportDeclaration(node) {
        if (!node.moduleSpecifier) return;

        const moduleSymbol = this.checker.getSymbolAtLocation(node.moduleSpecifier);
        if (!moduleSymbol) {
            this.diagnosticEngine.print("warning", "Failed to resolve module for export declaration", node);
            return;
        }

        /** @type {ts.Symbol[]} */
        let targetSymbols = [];

        if (!node.exportClause) {
            // export * from "..."
            targetSymbols = this.checker.getExportsOfModule(moduleSymbol);
        } else if (ts.isNamedExports(node.exportClause)) {
            const moduleExports = this.checker.getExportsOfModule(moduleSymbol);
            for (const element of node.exportClause.elements) {
                const originalName = element.propertyName?.text ?? element.name.text;

                const match = moduleExports.find(s => s.name === originalName);
                if (match) {
                    targetSymbols.push(match);
                    continue;
                }

                // Fallback for unusual bindings/resolution failures.
                const fallback = this.checker.getSymbolAtLocation(element.propertyName ?? element.name);
                if (fallback) {
                    targetSymbols.push(fallback);
                    continue;
                }

                this.diagnosticEngine.print("warning", `Failed to resolve re-exported symbol '${originalName}'`, node);
            }
        } else {
            // export * as ns from "..." is not currently supported by BridgeJS imports.
            return;
        }

        for (const symbol of targetSymbols) {
            const declarations = symbol.getDeclarations() ?? [];
            for (const declaration of declarations) {
                // Avoid duplicate emission when the same declaration is reached via multiple re-exports.
                const sourceFile = declaration.getSourceFile();
                const key = `${sourceFile.fileName}:${declaration.pos}:${declaration.end}`;
                if (this.visitedDeclarationKeys.has(key)) continue;
                this.visitedDeclarationKeys.add(key);

                this.visitNode(declaration);
            }
        }
    }

    /**
     * Visit an exported variable statement and render Swift global getter(s).
     * Supports simple `export const foo: T` / `export let foo: T` declarations.
     *
     * @param {ts.VariableStatement} node
     * @private
     */
    visitVariableStatement(node) {
        const isExported = node.modifiers?.some(m => m.kind === ts.SyntaxKind.ExportKeyword) ?? false;
        if (!isExported) return;

        const fromArg = this.renderDefaultJSImportFromArgument();

        for (const decl of node.declarationList.declarations) {
            if (!ts.isIdentifier(decl.name)) continue;

            const jsName = decl.name.text;
            const swiftName = this.swiftTypeName(jsName);
            const swiftVarName = this.renderIdentifier(swiftName);

            const type = this.checker.getTypeAtLocation(decl);
            const swiftType = this.visitType(type, decl);

            /** @type {string[]} */
            const args = [];
            const jsNameArg = this.renderOptionalJSNameArg(jsName, swiftName);
            if (jsNameArg) args.push(jsNameArg);
            if (fromArg) args.push(fromArg);
            const annotation = this.renderMacroAnnotation("JSGetter", args);

            this.emitDocComment(decl, { indent: "" });
            this.swiftLines.push(`${annotation} var ${swiftVarName}: ${swiftType}`);
            this.swiftLines.push("");
        }
    }

    /**
     * @param {ts.Type} type
     * @returns {boolean}
     * @private
     */
    isEnumType(type) {
        const symbol = type.getSymbol() ?? type.aliasSymbol;
        if (!symbol) return false;
        return (symbol.flags & ts.SymbolFlags.Enum) !== 0;
    }

    dedupeSwiftEnumCaseNames(items) {
        const seen = new Map();
        return items.map(item => {
            const count = seen.get(item.name) ?? 0;
            seen.set(item.name, count + 1);
            if (count === 0) return item;
            return { ...item, name: `${item.name}_${count + 1}` };
        });
    }

    /**
     * Extract string literal values if the type is a union containing only string literals.
     * Returns null when any member is not a string literal.
     * @param {ts.Type} type
     * @returns {string[] | null}
     * @private
     */
    getStringLiteralUnionLiterals(type) {
        if ((type.flags & ts.TypeFlags.Union) === 0) return null;
        /** @type {ts.UnionType} */
        // @ts-ignore
        const unionType = type;
        /** @type {string[]} */
        const literals = [];
        const seen = new Set();
        for (const member of unionType.types) {
            if ((member.flags & ts.TypeFlags.StringLiteral) === 0) {
                return null;
            }
            // @ts-ignore value exists for string literal types
            const value = String(member.value);
            if (seen.has(value)) continue;
            seen.add(value);
            literals.push(value);
        }
        return literals;
    }

    /**
     * @param {ts.Type} type
     * @param {ts.Node} diagnosticNode
     * @private
     */
    emitStringLiteralUnion(type, diagnosticNode) {
        const typeName = this.deriveTypeName(type);
        if (!typeName) return;
        if (this.emittedStringLiteralUnionNames.has(typeName)) return;
        this.emittedStringLiteralUnionNames.add(typeName);

        const literals = this.getStringLiteralUnionLiterals(type);
        if (!literals || literals.length === 0) return;

        const swiftEnumName = this.renderTypeIdentifier(typeName);
        /** @type {{ name: string, raw: string }[]} */
        const members = literals.map(raw => ({ name: makeValidSwiftIdentifier(String(raw), { emptyFallback: "_case" }), raw: String(raw) }));
        const deduped = this.dedupeSwiftEnumCaseNames(members);

        this.emitDocComment(diagnosticNode, { indent: "" });
        this.swiftLines.push(`enum ${swiftEnumName}: String {`);
        for (const { name, raw } of deduped) {
            this.swiftLines.push(`    case ${this.renderIdentifier(name)} = "${raw.replaceAll("\"", "\\\"")}"`);
        }
        this.swiftLines.push("}");
        this.swiftLines.push(`extension ${swiftEnumName}: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {}`);
        this.swiftLines.push("");
    }

    /**
     * @param {ts.EnumDeclaration} node
     * @private
     */
    visitEnumDeclaration(node) {
        const name = node.name?.text;
        if (!name) return;
        this.emitEnumFromDeclaration(name, node, node);
    }

    /**
     * @param {ts.Type} type
     * @param {ts.Node} node
     * @private
     */
    visitEnumType(type, node) {
        const symbol = type.getSymbol() ?? type.aliasSymbol;
        const name = symbol?.name;
        if (!name) return;
        const decl = symbol?.getDeclarations()?.find(d => ts.isEnumDeclaration(d));
        if (!decl || !ts.isEnumDeclaration(decl)) {
            this.diagnosticEngine.print("warning", `Enum declaration not found for type: ${name}`, node);
            return;
        }
        this.emitEnumFromDeclaration(name, decl, node);
    }

    /**
     * @param {string} enumName
     * @param {ts.EnumDeclaration} decl
     * @param {ts.Node} diagnosticNode
     * @private
     */
    emitEnumFromDeclaration(enumName, decl, diagnosticNode) {
        if (this.emittedEnumNames.has(enumName)) return;
        this.emittedEnumNames.add(enumName);

        const members = decl.members ?? [];
        this.emitDocComment(decl, { indent: "" });
        if (members.length === 0) {
            this.diagnosticEngine.print("warning", `Empty enum is not supported: ${enumName}`, diagnosticNode);
            this.swiftLines.push(`typealias ${this.renderIdentifier(enumName)} = String`);
            this.swiftLines.push("");
            return;
        }

        /** @type {{ name: string, raw: string }[]} */
        const stringMembers = [];
        /** @type {{ name: string, raw: number }[]} */
        const intMembers = [];
        let canBeStringEnum = true;
        let canBeIntEnum = true;
        let nextAutoValue = 0;

        for (const member of members) {
            const rawMemberName = member.name.getText();
            const unquotedName = rawMemberName.replace(/^["']|["']$/g, "");
            const swiftCaseNameBase = makeValidSwiftIdentifier(unquotedName, { emptyFallback: "_case" });

            if (member.initializer && ts.isStringLiteral(member.initializer)) {
                stringMembers.push({ name: swiftCaseNameBase, raw: member.initializer.text });
                canBeIntEnum = false;
                continue;
            }

            if (member.initializer && ts.isNumericLiteral(member.initializer)) {
                const rawValue = Number(member.initializer.text);
                if (!Number.isInteger(rawValue)) {
                    canBeIntEnum = false;
                } else {
                    intMembers.push({ name: swiftCaseNameBase, raw: rawValue });
                    nextAutoValue = rawValue + 1;
                    canBeStringEnum = false;
                    continue;
                }
            }

            if (!member.initializer) {
                intMembers.push({ name: swiftCaseNameBase, raw: nextAutoValue });
                nextAutoValue += 1;
                canBeStringEnum = false;
                continue;
            }

            canBeStringEnum = false;
            canBeIntEnum = false;
        }
        const swiftEnumName = this.renderTypeIdentifier(enumName);
        const dedupeNames = (/** @type {{ name: string, raw: string | number }[]} */ items) => {
            const seen = new Map();
            return items.map(item => {
                const count = seen.get(item.name) ?? 0;
                seen.set(item.name, count + 1);
                if (count === 0) return item;
                return { ...item, name: `${item.name}_${count + 1}` };
            });
        };

        if (canBeStringEnum && stringMembers.length > 0) {
            this.swiftLines.push(`enum ${swiftEnumName}: String {`);
            for (const { name, raw } of dedupeNames(stringMembers)) {
                if (typeof raw !== "string") {
                    this.diagnosticEngine.print("warning", `Invalid string literal: ${raw}`, diagnosticNode);
                    continue;
                }
                this.swiftLines.push(`    case ${this.renderIdentifier(name)} = "${raw.replaceAll("\"", "\\\\\"")}"`);
            }
            this.swiftLines.push("}");
            this.swiftLines.push(`extension ${swiftEnumName}: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {}`);
            this.swiftLines.push("");
            return;
        }

        if (canBeIntEnum && intMembers.length > 0) {
            this.swiftLines.push(`enum ${swiftEnumName}: Int {`);
            for (const { name, raw } of dedupeNames(intMembers)) {
                this.swiftLines.push(`    case ${this.renderIdentifier(name)} = ${raw}`);
            }
            this.swiftLines.push("}");
            this.swiftLines.push(`extension ${swiftEnumName}: _BridgedSwiftEnumNoPayload, _BridgedSwiftRawValueEnum {}`);
            this.swiftLines.push("");
            return;
        }

        this.diagnosticEngine.print(
            "warning",
            `Unsupported enum (only string or int enums are supported): ${enumName}`,
            diagnosticNode
        );
        this.swiftLines.push(`typealias ${swiftEnumName} = String`);
        this.swiftLines.push("");
    }

    /**
     * Visit a function declaration and render Swift code
     * @param {ts.FunctionDeclaration} node - The function node
     * @private
     */
    visitFunctionDeclaration(node) {
        if (!node.name) return;
        const jsName = node.name.text;
        const swiftName = this.swiftTypeName(jsName);
        const fromArg = this.renderDefaultJSImportFromArgument();
        /** @type {string[]} */
        const args = [];
        const jsNameArg = this.renderOptionalJSNameArg(jsName, swiftName);
        if (jsNameArg) args.push(jsNameArg);
        if (fromArg) args.push(fromArg);
        const annotation = this.renderMacroAnnotation("JSFunction", args);

        const signature = this.checker.getSignatureFromDeclaration(node);
        if (!signature) return;

        const parameters = signature.getParameters();
        const parameterNameMap = this.buildParameterNameMap(parameters);
        const params = this.renderParameters(parameters, node);
        const returnType = this.visitType(signature.getReturnType(), node);
        const effects = this.renderEffects({ isAsync: false });
        const swiftFuncName = this.renderIdentifier(swiftName);

        this.emitDocComment(node, { parameterNameMap });
        this.swiftLines.push(`${annotation} func ${swiftFuncName}(${params}) ${effects} -> ${returnType}`);
        this.swiftLines.push("");
    }

    /**
     * Convert a JSDoc comment node content to plain text.
     * @param {string | ts.NodeArray<ts.JSDocComment> | undefined} comment
     * @returns {string}
     * @private
     */
    renderJSDocText(comment) {
        if (!comment) return "";
        if (typeof comment === "string") return comment;
        let result = "";
        for (const part of comment) {
            if (typeof part === "string") {
                result += part;
                continue;
            }
            // JSDocText/JSDocLink both have a `text` field
            // https://github.com/microsoft/TypeScript/blob/main/src/compiler/types.ts
            // @ts-ignore
            if (typeof part.text === "string") {
                // @ts-ignore
                result += part.text;
                continue;
            }
            if (typeof part.getText === "function") {
                result += part.getText();
            }
        }
        return result;
    }

    /**
     * Split documentation text into lines suitable for DocC rendering.
     * @param {string} text
     * @returns {string[]}
     * @private
     */
    splitDocumentationText(text) {
        if (!text) return [];
        return text.split(/\r?\n/).map(line => line.trimEnd());
    }

    /**
     * @param {string[]} lines
     * @returns {boolean}
     * @private
     */
    hasMeaningfulLine(lines) {
        return lines.some(line => line.trim().length > 0);
    }

    /**
     * Render Swift doc comments from a node's JSDoc, including parameter/return tags.
     * @param {ts.Node} node
     * @param {{ indent?: string, parameterNameMap?: Map<string, string> }} options
     * @private
     */
    emitDocComment(node, options = {}) {
        const indent = options.indent ?? "";
        const parameterNameMap = options.parameterNameMap ?? new Map();

        /** @type {string[]} */
        const descriptionLines = [];
        for (const doc of ts.getJSDocCommentsAndTags(node)) {
            if (!ts.isJSDoc(doc)) continue;
            const text = this.renderJSDocText(doc.comment);
            if (text) {
                descriptionLines.push(...this.splitDocumentationText(text));
            }
        }

        /** @type {Array<{ name: string, lines: string[] }>} */
        const parameterDocs = [];
        const supportsParameters = (
            ts.isFunctionLike(node) ||
            ts.isMethodSignature(node) ||
            ts.isCallSignatureDeclaration(node) ||
            ts.isConstructSignatureDeclaration(node)
        );
        /** @type {ts.JSDocReturnTag | undefined} */
        let returnTag = undefined;
        if (supportsParameters) {
            for (const tag of ts.getJSDocTags(node)) {
                if (ts.isJSDocParameterTag(tag)) {
                    const tsName = tag.name.getText();
                    const name = parameterNameMap.get(tsName) ?? this.renderIdentifier(tsName);
                    const text = this.renderJSDocText(tag.comment);
                    const lines = this.splitDocumentationText(text);
                    parameterDocs.push({ name, lines });
                } else if (!returnTag && ts.isJSDocReturnTag(tag)) {
                    returnTag = tag;
                }
            }
        }

        const returnLines = returnTag ? this.splitDocumentationText(this.renderJSDocText(returnTag.comment)) : [];
        const hasDescription = this.hasMeaningfulLine(descriptionLines);
        const hasParameters = parameterDocs.length > 0;
        const hasReturns = returnTag !== undefined;

        if (!hasDescription && !hasParameters && !hasReturns) {
            return;
        }

        /** @type {string[]} */
        const docLines = [];
        if (hasDescription) {
            docLines.push(...descriptionLines);
        }

        if (hasDescription && (hasParameters || hasReturns)) {
            docLines.push("");
        }

        if (hasParameters) {
            docLines.push("- Parameters:");
            for (const param of parameterDocs) {
                const hasParamDescription = this.hasMeaningfulLine(param.lines);
                const [firstParamLine, ...restParamLines] = param.lines;
                if (hasParamDescription) {
                    docLines.push(`  - ${param.name}: ${firstParamLine}`);
                    for (const line of restParamLines) {
                        docLines.push(`    ${line}`);
                    }
                } else {
                    docLines.push(`  - ${param.name}:`);
                }
            }
        }

        if (hasReturns) {
            const hasReturnDescription = this.hasMeaningfulLine(returnLines);
            const [firstReturnLine, ...restReturnLines] = returnLines;
            if (hasReturnDescription) {
                docLines.push(`- Returns: ${firstReturnLine}`);
                for (const line of restReturnLines) {
                    docLines.push(`  ${line}`);
                }
            } else {
                docLines.push("- Returns:");
            }
        }

        const prefix = `${indent}///`;
        for (const line of docLines) {
            if (line.length === 0) {
                this.swiftLines.push(prefix);
            } else {
                this.swiftLines.push(`${prefix} ${line}`);
            }
        }
    }

    /**
     * Build a map from TypeScript parameter names to rendered Swift identifiers.
     * @param {ts.Symbol[]} parameters
     * @returns {Map<string, string>}
     * @private
     */
    buildParameterNameMap(parameters) {
        const map = new Map();
        for (const parameter of parameters) {
            map.set(parameter.name, this.renderIdentifier(parameter.name));
        }
        return map;
    }

    /** @returns {string} */
    renderDefaultJSImportFromArgument() {
        if (this.defaultImportFromGlobal) return "from: .global";
        return "";
    }

    /**
     * Visit a property declaration and extract metadata
     * @param {ts.PropertyDeclaration | ts.PropertySignature} node
     * @returns {{ jsName: string, swiftName: string, type: string, isReadonly: boolean } | null}
     */
    visitPropertyDecl(node) {
        if (!node.name) return null;
        /** @type {string | null} */
        let jsName = null;
        if (ts.isIdentifier(node.name)) {
            jsName = node.name.text;
        } else if (ts.isStringLiteral(node.name) || ts.isNumericLiteral(node.name)) {
            jsName = node.name.text;
        } else {
            // Computed property names like `[Symbol.iterator]` are not supported yet.
            return null;
        }

        const swiftName = isValidSwiftDeclName(jsName) ? jsName : makeValidSwiftIdentifier(jsName, { emptyFallback: "_" });

        const type = this.checker.getTypeAtLocation(node)
        const swiftType = this.visitType(type, node);
        const isReadonly = node.modifiers?.some(m => m.kind === ts.SyntaxKind.ReadonlyKeyword) ?? false;
        return { jsName, swiftName, type: swiftType, isReadonly };
    }

    /**
     * @param {ts.Symbol} symbol
     * @param {ts.Node} node
     * @returns {Parameter}
     */
    visitSignatureParameter(symbol, node) {
        const type = this.checker.getTypeOfSymbolAtLocation(symbol, node);
        const swiftType = this.visitType(type, node);
        return { name: symbol.name, type: swiftType };
    }

    /**
     * Visit a class declaration and render Swift code
     * @param {ts.ClassDeclaration} node
     * @private
     */
    visitClassDecl(node) {
        if (!node.name) return;

        const jsName = node.name.text;
        if (this.emittedStructuredTypeNames.has(jsName)) return;
        this.emittedStructuredTypeNames.add(jsName);

        const swiftName = this.swiftTypeName(jsName);
        const fromArg = this.renderDefaultJSImportFromArgument();
        /** @type {string[]} */
        const args = [];
        const jsNameArg = this.renderOptionalJSNameArg(jsName, swiftName);
        if (jsNameArg) args.push(jsNameArg);
        if (fromArg) args.push(fromArg);
        const annotation = this.renderMacroAnnotation("JSClass", args);
        const className = this.renderIdentifier(swiftName);
        this.emitDocComment(node, { indent: "" });
        this.swiftLines.push(`${annotation} struct ${className} {`);

        // Process members in declaration order
        for (const member of node.members) {
            if (ts.isPropertyDeclaration(member)) {
                this.renderProperty(member);
            } else if (ts.isMethodDeclaration(member)) {
                this.renderMethod(member);
            } else if (ts.isConstructorDeclaration(member)) {
                this.renderConstructor(member);
            }
        }

        this.swiftLines.push("}");
        this.swiftLines.push("");
    }

    /**
     * @param {ts.SymbolFlags} flags
     * @returns {string[]}
     */
    debugSymbolFlags(flags) {
        const result = [];
        for (const key in ts.SymbolFlags) {
            const val = (ts.SymbolFlags)[key];
            if (typeof val === "number" && (flags & val) !== 0) {
                result.push(key);
            }
        }
        return result;
    }

    /**
     * @param {ts.TypeFlags} flags
     * @returns {string[]}
     */
    debugTypeFlags(flags) {
        const result = [];
        for (const key in ts.TypeFlags) {
            const val = (ts.TypeFlags)[key];
            if (typeof val === "number" && (flags & val) !== 0) {
                result.push(key);
            }
        }
        return result;
    }

    /**
     * Visit a structured type (interface) and render Swift code
     * @param {ts.Type} type
     * @param {ts.Node} diagnosticNode
     * @param {ts.Symbol[]} members
     * @private
     */
    visitStructuredType(type, diagnosticNode, members) {
        const symbol = type.aliasSymbol ?? type.getSymbol();
        const name = type.aliasSymbol?.name ?? symbol?.name ?? this.checker.typeToString(type);
        if (!name) return;
        if (this.emittedStructuredTypeNames.has(name)) return;
        this.emittedStructuredTypeNames.add(name);

        const swiftName = this.swiftTypeName(name);
        /** @type {string[]} */
        const args = [];
        const jsNameArg = this.renderOptionalJSNameArg(name, swiftName);
        if (jsNameArg) args.push(jsNameArg);
        const annotation = this.renderMacroAnnotation("JSClass", args);
        const typeName = this.renderIdentifier(swiftName);
        const docNode = type.aliasSymbol?.getDeclarations()?.[0] ?? symbol?.getDeclarations()?.[0] ?? diagnosticNode;
        if (docNode) {
            this.emitDocComment(docNode, { indent: "" });
        }
        this.swiftLines.push(`${annotation} struct ${typeName} {`);

        // Collect all declarations with their positions to preserve order
        /** @type {Array<{ decl: ts.Node, symbol: ts.Symbol, position: number }>} */
        const allDecls = [];

        const typeMembers = members ?? type.getProperties() ?? [];
        for (const memberSymbol of typeMembers) {
            for (const decl of memberSymbol.getDeclarations() ?? []) {
                const sourceFile = decl.getSourceFile();
                const pos = sourceFile ? decl.getStart() : 0;
                allDecls.push({ decl, symbol: memberSymbol, position: pos });
            }
        }

        // Sort by position to preserve declaration order
        allDecls.sort((a, b) => a.position - b.position);

        // Process declarations in order
        for (const { decl, symbol } of allDecls) {
            if (symbol.flags & ts.SymbolFlags.Property) {
                if (ts.isPropertyDeclaration(decl) || ts.isPropertySignature(decl)) {
                    this.renderProperty(decl);
                } else if (ts.isMethodSignature(decl)) {
                    this.renderMethodSignature(decl);
                }
            } else if (symbol.flags & ts.SymbolFlags.Method) {
                if (ts.isMethodSignature(decl)) {
                    this.renderMethodSignature(decl);
                }
            } else if (symbol.flags & ts.SymbolFlags.Constructor) {
                if (ts.isConstructorDeclaration(decl)) {
                    this.renderConstructor(decl);
                }
            }
        }

        this.swiftLines.push("}");
        this.swiftLines.push("");
    }

    /**
     * Convert TypeScript type to Swift type string
     * @param {ts.Type} type - TypeScript type
     * @param {ts.Node} node - Node
     * @returns {string} Swift type string
     * @private
     */
    visitType(type, node) {
        const typeArguments = this.getTypeArguments(type);
        if (this.checker.isArrayType(type)) {
            const typeArgs = this.checker.getTypeArguments(/** @type {ts.TypeReference} */ (type));
            if (typeArgs && typeArgs.length > 0) {
                const elementType = this.visitType(typeArgs[0], node);
                return `[${elementType}]`;
            }
            return "[JSObject]";
        }

        const recordType = this.convertRecordType(type, typeArguments, node);
        if (recordType) {
            return recordType;
        }

        // Treat A<B> and A<C> as the same type
        if (isTypeReference(type)) {
            type = type.target;
        }
        const maybeProcessed = this.processedTypes.get(type);
        if (maybeProcessed) {
            return maybeProcessed;
        }
        /**
         * @param {ts.Type} type
         * @returns {string}
         */
        const convert = (type) => {
            const originalType = type;
            // Handle nullable/undefined unions (e.g. T | null, T | undefined)
            const isUnionType = (type.flags & ts.TypeFlags.Union) !== 0;
            if (isUnionType) {
                /** @type {ts.UnionType} */
                // @ts-ignore
                const unionType = type;
                const unionTypes = unionType.types;
                const hasNull = unionTypes.some(t => (t.flags & ts.TypeFlags.Null) !== 0);
                const hasUndefined = unionTypes.some(t => (t.flags & ts.TypeFlags.Undefined) !== 0);
                const nonNullableTypes = unionTypes.filter(
                    t => (t.flags & ts.TypeFlags.Null) === 0 && (t.flags & ts.TypeFlags.Undefined) === 0
                );
                if (nonNullableTypes.length === 1 && (hasNull || hasUndefined)) {
                    const wrapped = this.visitType(nonNullableTypes[0], node);
                    if (hasNull && hasUndefined) {
                        return "JSObject";
                    }
                    if (hasNull) {
                        return `Optional<${wrapped}>`;
                    }
                    return `JSUndefinedOr<${wrapped}>`;
                }

                const stringLiteralUnion = this.getStringLiteralUnionLiterals(type);
                if (stringLiteralUnion && stringLiteralUnion.length > 0) {
                    const typeName = this.deriveTypeName(originalType) ?? this.deriveTypeName(type);
                    if (typeName) {
                        this.seenTypes.set(originalType, node);
                        return this.renderTypeIdentifier(typeName);
                    }
                }
            }

            /** @type {Record<string, string>} */
            const typeMap = {
                "number": "Double",
                "string": "String",
                "boolean": "Bool",
                "void": "Void",
                "any": "JSValue",
                "unknown": "JSValue",
                "null": "Void",
                "undefined": "Void",
                "bigint": "Int",
                "object": "JSObject",
                "symbol": "JSObject",
                "never": "Void",
                "Promise": "JSPromise",
            };
            const symbol = type.getSymbol() ?? type.aliasSymbol;
            const typeString = symbol?.name ?? this.checker.typeToString(type);
            if (typeMap[typeString]) {
                return typeMap[typeString];
            }
            if (symbol && (symbol.flags & ts.SymbolFlags.Enum) !== 0) {
                const typeName = symbol.name;
                this.seenTypes.set(type, node);
                return this.renderTypeIdentifier(typeName);
            }

            const stringLiteralUnion = this.getStringLiteralUnionLiterals(type);
            if (stringLiteralUnion && stringLiteralUnion.length > 0) {
                this.seenTypes.set(type, node);
                return this.renderTypeIdentifier(this.deriveTypeName(type) ?? this.checker.typeToString(type));
            }

            if (this.checker.isTupleType(type) || type.getCallSignatures().length > 0) {
                return "JSObject";
            }
            // "a" | "b" -> string
            if (this.checker.isTypeAssignableTo(type, this.checker.getStringType())) {
                return "String";
            }
            if (type.isTypeParameter()) {
                return "JSObject";
            }

            const typeName = this.deriveTypeName(type);
            if (!typeName) {
                this.diagnosticEngine.print("warning", `Unknown non-nominal type: ${typeString}`, node);
                return "JSObject";
            }
            this.seenTypes.set(type, node);
            return this.renderTypeIdentifier(typeName);
        }
        const swiftType = convert(type);
        this.processedTypes.set(type, swiftType);
        return swiftType;
    }

    /**
     * Convert a `Record<string, T>` TypeScript type into a Swift dictionary type.
     * Falls back to `JSObject` when keys are not string-compatible or type arguments are missing.
     * @param {ts.Type} type
     * @param {readonly ts.Type[]} typeArguments
     * @param {ts.Node} node
     * @returns {string | null}
     * @private
     */
    convertRecordType(type, typeArguments, node) {
        const symbol = type.aliasSymbol ?? type.getSymbol();
        if (!symbol || symbol.name !== "Record") {
            return null;
        }
        if (typeArguments.length !== 2) {
            this.diagnosticEngine.print("warning", "Record expects two type arguments", node);
            return "JSObject";
        }
        const [keyType, valueType] = typeArguments;
        const stringType = this.checker.getStringType();
        if (!this.checker.isTypeAssignableTo(keyType, stringType)) {
            this.diagnosticEngine.print(
                "warning",
                `Record key type must be assignable to string: ${this.checker.typeToString(keyType)}`,
                node
            );
            return "JSObject";
        }

        const valueSwiftType = this.visitType(valueType, node);
        return `[String: ${valueSwiftType}]`;
    }

    /**
     * Retrieve type arguments for a given type, including type alias instantiations.
     * @param {ts.Type} type
     * @returns {readonly ts.Type[]}
     * @private
     */
    getTypeArguments(type) {
        if (isTypeReference(type)) {
            return this.checker.getTypeArguments(type);
        }
        // Non-TypeReference alias instantiations store type arguments separately.
        // @ts-ignore: `aliasTypeArguments` is intentionally accessed for alias instantiations.
        return type.aliasTypeArguments ?? [];
    }

    /**
     * Derive the type name from a type
     * @param {ts.Type} type - TypeScript type
     * @returns {string | undefined} Type name
     * @private
     */
    deriveTypeName(type) {
        const aliasSymbol = type.aliasSymbol;
        if (aliasSymbol) {
            return aliasSymbol.name;
        }
        const typeSymbol = type.getSymbol();
        if (typeSymbol) {
            return typeSymbol.name;
        }
        return undefined;
    }

    /**
     * Render a property declaration
     * @param {ts.PropertyDeclaration | ts.PropertySignature} node
     * @private
     */
    renderProperty(node) {
        const property = this.visitPropertyDecl(node);
        if (!property) return;

        const type = property.type;
        const swiftName = this.renderIdentifier(property.swiftName);
        const needsJSGetterName = property.jsName !== property.swiftName;
        // Note: `from: .global` is only meaningful for top-level imports and constructors.
        // Instance member access always comes from the JS object itself.
        const fromArg = "";
        /** @type {string[]} */
        const getterArgs = [];
        if (needsJSGetterName) getterArgs.push(`jsName: "${this.escapeForSwiftStringLiteral(property.jsName)}"`);
        if (fromArg) getterArgs.push(fromArg);
        const getterAnnotation = this.renderMacroAnnotation("JSGetter", getterArgs);

        // Always render getter
        this.emitDocComment(node, { indent: "    " });
        this.swiftLines.push(`    ${getterAnnotation} var ${swiftName}: ${type}`);

        // Render setter if not readonly
        if (!property.isReadonly) {
            const capitalizedSwiftName = property.swiftName.charAt(0).toUpperCase() + property.swiftName.slice(1);
            const derivedPropertyName = property.swiftName.charAt(0).toLowerCase() + property.swiftName.slice(1);
            const needsJSNameField = property.jsName !== derivedPropertyName;
            const setterName = `set${capitalizedSwiftName}`;
            /** @type {string[]} */
            const setterArgs = [];
            if (needsJSNameField) setterArgs.push(`jsName: "${this.escapeForSwiftStringLiteral(property.jsName)}"`);
            if (fromArg) setterArgs.push(fromArg);
            const annotation = this.renderMacroAnnotation("JSSetter", setterArgs);
            this.swiftLines.push(`    ${annotation} func ${this.renderIdentifier(setterName)}(_ value: ${type}) ${this.renderEffects({ isAsync: false })}`);
        }
    }

    /**
     * Render a method declaration
     * @param {ts.MethodDeclaration | ts.MethodSignature} node
     * @private
     */
    renderMethod(node) {
        if (!node.name) return;
        /** @type {string | null} */
        let jsName = null;
        if (ts.isIdentifier(node.name)) {
            jsName = node.name.text;
        } else if (ts.isStringLiteral(node.name) || ts.isNumericLiteral(node.name)) {
            jsName = node.name.text;
        } else {
            // Computed property names like `[Symbol.iterator]` are not supported yet.
            return;
        }

        const swiftName = this.swiftTypeName(jsName);
        const needsJSNameField = jsName !== swiftName;
        // Note: `from: .global` is only meaningful for top-level imports and constructors.
        // Instance member calls always come from the JS object itself.
        const fromArg = "";
        /** @type {string[]} */
        const args = [];
        if (needsJSNameField) args.push(`jsName: "${this.escapeForSwiftStringLiteral(jsName)}"`);
        if (fromArg) args.push(fromArg);
        const annotation = this.renderMacroAnnotation("JSFunction", args);

        const signature = this.checker.getSignatureFromDeclaration(node);
        if (!signature) return;

        const parameters = signature.getParameters();
        const parameterNameMap = this.buildParameterNameMap(parameters);
        const params = this.renderParameters(parameters, node);
        const returnType = this.visitType(signature.getReturnType(), node);
        const effects = this.renderEffects({ isAsync: false });
        const swiftMethodName = this.renderIdentifier(swiftName);
        const isStatic = node.modifiers?.some(
            (modifier) => modifier.kind === ts.SyntaxKind.StaticKeyword
        ) ?? false;
        const staticKeyword = isStatic ? "static " : "";

        this.emitDocComment(node, { indent: "    ", parameterNameMap });
        this.swiftLines.push(`    ${annotation} ${staticKeyword}func ${swiftMethodName}(${params}) ${effects} -> ${returnType}`);
    }

    /**
     * Render a method signature (from interface)
     * @param {ts.MethodSignature} node
     * @private
     */
    renderMethodSignature(node) {
        this.renderMethod(node);
    }

    /**
     * Render a constructor declaration
     * @param {ts.ConstructorDeclaration} node
     * @private
     */
    renderConstructor(node) {
        const signature = this.checker.getSignatureFromDeclaration(node);
        if (!signature) return;

        const parameters = signature.getParameters();
        const parameterNameMap = this.buildParameterNameMap(parameters);
        const params = this.renderParameters(parameters, node);
        const effects = this.renderEffects({ isAsync: false });
        this.emitDocComment(node, { indent: "    ", parameterNameMap });
        this.swiftLines.push(`    @JSFunction init(${params}) ${effects}`);
    }

    /**
     * Render function parameters
     * @param {ts.Symbol[]} parameters
     * @param {ts.Node} node
     * @returns {string}
     * @private
     */
    renderParameters(parameters, node) {
        const params = [];
        for (const p of parameters) {
            const param = this.visitSignatureParameter(p, node);
            const paramName = this.renderIdentifier(p.name);
            const type = param.type;
            params.push(`_ ${paramName}: ${type}`);
        }
        return params.join(", ");
    }

    /**
     * Render effects (async/throws)
     * @param {{ isAsync: boolean }} effects
     * @returns {string}
     * @private
     */
    renderEffects(effects) {
        const parts = [];
        if (effects?.isAsync) {
            parts.push("async");
        }
        parts.push("throws(JSException)");
        return parts.join(" ");
    }

    /**
     * Render identifier with backticks if needed
     * @param {string} name
     * @returns {string}
     * @private
     */
    renderIdentifier(name) {
        if (!name) return name;
        if (!isValidSwiftDeclName(name) || isSwiftKeyword(name)) {
            return `\`${name}\``;
        }
        return name;
    }
}


const SWIFT_KEYWORDS = new Set([
    "associatedtype", "class", "deinit", "enum", "extension", "fileprivate",
    "func", "import", "init", "inout", "internal", "let", "open", "operator",
    "private", "protocol", "public", "static", "struct", "subscript", "typealias",
    "var", "break", "case", "continue", "default", "defer", "do", "else",
    "fallthrough", "for", "guard", "if", "in", "repeat", "return", "switch",
    "where", "while", "as", "Any", "catch", "false", "is", "nil", "rethrows",
    "super", "self", "Self", "throw", "throws", "true", "try",
    "prefix", "postfix", "infix"  // Contextual keywords for operator declarations
]);

/**
 * @param {string} name
 * @returns {boolean}
 */
function isSwiftKeyword(name) {
    return SWIFT_KEYWORDS.has(name);
}

/**
 * @param {ts.Type} type
 * @returns {type is ts.ObjectType}
 */
function isObjectType(type) {
    // @ts-ignore
    return typeof type.objectFlags === "number";
}

/**
 *
 * @param {ts.Type} type
 * @returns {type is ts.TypeReference}
 */
function isTypeReference(type) {
    return (
        isObjectType(type) &&
        (type.objectFlags & ts.ObjectFlags.Reference) !== 0
    );
}

/**
 * Check if a declaration name is valid for Swift generation
 * @param {string} name - Declaration name to check
 * @returns {boolean} True if the name is valid for Swift
 * @private
 */
export function isValidSwiftDeclName(name) {
    // https://docs.swift.org/swift-book/documentation/the-swift-programming-language/lexicalstructure/
    const swiftIdentifierRegex = /^[_\p{ID_Start}][\p{ID_Continue}\u{200C}\u{200D}]*$/u;
    return swiftIdentifierRegex.test(name);
}

/**
 * Convert an arbitrary string into a valid Swift identifier.
 * @param {string} name
 * @param {{ emptyFallback?: string }} options
 * @returns {string}
 */
function makeValidSwiftIdentifier(name, options = {}) {
    const emptyFallback = options.emptyFallback ?? "_";
    let result = "";
    for (const ch of name) {
        const isIdentifierChar = /^[_\p{ID_Continue}\u{200C}\u{200D}]$/u.test(ch);
        result += isIdentifierChar ? ch : "_";
    }
    if (!result) result = emptyFallback;
    if (!/^[_\p{ID_Start}]$/u.test(result[0])) {
        result = "_" + result;
    }
    if (!isValidSwiftDeclName(result)) {
        result = result.replace(/[^_\p{ID_Continue}\u{200C}\u{200D}]/gu, "_");
        if (!result) result = emptyFallback;
        if (!/^[_\p{ID_Start}]$/u.test(result[0])) {
            result = "_" + result;
        }
    }
    if (isSwiftKeyword(result)) {
        result = result + "_";
    }
    return result;
}
