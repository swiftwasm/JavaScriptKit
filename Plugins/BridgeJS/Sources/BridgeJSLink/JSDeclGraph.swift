#if canImport(BridgeJSUtilities)
import BridgeJSUtilities
#endif

/// A JS entity the link emits, or a name it refers to.
///
/// Symbols are the nodes of ``JSDeclGraph``: a declaration defines one, and code refers to one
/// through ``JSDeclGraph/ref(_:)``, which both spells it and records the dependency.
struct JSSymbol: Hashable, CustomStringConvertible {
    enum Kind: Hashable {
        /// A helper of the instantiator scope, e.g. `i32Stack` or `decodeString`.
        case runtime
        /// A function of the wasm import module `module`, spelled as the property of its import object.
        case wasmImport(module: String)
        /// The object holding the functions of the wasm import module `name`.
        case importModuleObject
        /// A helper registered while rendering, e.g. the container codec combinators.
        case intrinsic
        /// A named container codec, e.g. `__bjs_codec_Array_Int`.
        case codec
        /// `structHelpers.<key>`
        case structHelper
        /// `enumHelpers.<key>`
        case enumHelper
        /// A JS module the glue imports, keyed by its index in ``ImportedJSModuleRegistry``.
        case jsModule
        /// A binding imported from a JS module, spelled as the local binding name.
        case jsModuleMember(module: String)
    }

    let kind: Kind
    /// The identity of the symbol within its kind.
    let name: String
    /// The JS expression the symbol is spelled as.
    ///
    /// Symbols of the same kind and name are equal whatever their spelling, which lets a declaration
    /// that declares several JS names be referenced through any of them.
    let spelling: String

    init(kind: Kind, name: String, spelling: String? = nil) {
        self.kind = kind
        self.name = name
        self.spelling = spelling ?? name
    }

    static func == (lhs: JSSymbol, rhs: JSSymbol) -> Bool {
        lhs.kind == rhs.kind && lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(kind)
        hasher.combine(name)
    }

    /// Symbols must be spelled through ``JSDeclGraph/ref(_:)`` so that the dependency is recorded.
    var description: String {
        preconditionFailure("JSSymbol \(name) interpolated without JSDeclGraph.ref(_:)")
    }

    static func runtime(_ name: String) -> JSSymbol {
        JSSymbol(kind: .runtime, name: name)
    }

    static func wasmImport(module: String, name: String) -> JSSymbol {
        JSSymbol(kind: .wasmImport(module: module), name: name, spelling: "\(module)[\"\(name)\"]")
    }

    static func bjsImport(_ name: String) -> JSSymbol {
        wasmImport(module: "bjs", name: name)
    }

    static func importModuleObject(_ module: String) -> JSSymbol {
        JSSymbol(kind: .importModuleObject, name: module)
    }

    static func intrinsic(_ name: String) -> JSSymbol {
        JSSymbol(kind: .intrinsic, name: name)
    }

    static func codec(_ name: String) -> JSSymbol {
        JSSymbol(kind: .codec, name: name)
    }

    static func structHelper(_ key: String) -> JSSymbol {
        JSSymbol(kind: .structHelper, name: key, spelling: "\(JSSymbol.structHelpers.spelling).\(key)")
    }

    static func enumHelper(_ key: String) -> JSSymbol {
        JSSymbol(kind: .enumHelper, name: key, spelling: "\(JSSymbol.enumHelpers.spelling).\(key)")
    }
}

/// Where a part of a declaration goes in the generated JS, in output order.
enum JSSlot {
    /// `import ... from "..."` lines at the top of the file.
    case jsModuleImports
    /// `let`/`const` declarations at the top of `createInstantiator`.
    case prelude
    /// Helpers registered while rendering, ordered by name.
    case intrinsics
    /// Named container codecs, in the order of their definition.
    case namedCodecs
    /// Struct and enum helper factories.
    case helperFactories
    /// The start of `addImports`.
    case addImportsHead
    /// The intrinsic `bjs` imports.
    case bjsImports
    /// The class wrapper imports.
    case classWrappers
    /// The imports of the skeletons' import modules.
    case moduleImports
    /// The start of `setInstance`, before `instance` and `memory` are assigned.
    case setInstanceHead
    /// The rest of `setInstance`.
    case setInstance
    /// The struct and enum helper instances in `createExports`.
    case helperInstances
}

/// The declarations of the generated JS and the dependencies between them.
///
/// Every piece of JS that can be left out is a declaration: a ``JSSymbol`` with parts placed in
/// ``JSSlot``s. Declarations are rendered eagerly in a deterministic order. While a declaration
/// renders, every symbol spelled with ``ref(_:)`` becomes one of its dependencies. ``sweep()``
/// then keeps the declarations reachable from the roots, and each slot emits the parts of the kept
/// declarations in the order they were defined, so the output of a smaller set of roots is the
/// output of a larger one with whole declarations removed.
///
/// Code rendered outside of any declaration belongs to an implicit root, so what it references is
/// always kept.
final class JSDeclGraph {
    final class Declaration {
        let symbol: JSSymbol
        let isRoot: Bool
        fileprivate(set) var parts: [(slot: JSSlot, lines: [String])] = []
        fileprivate(set) var lazyParts: [(slot: JSSlot, render: (JSDeclGraph) -> [String])] = []
        fileprivate(set) var references: [JSSymbol] = []
        fileprivate var referenceSet: Set<JSSymbol> = []

        init(symbol: JSSymbol, isRoot: Bool) {
            self.symbol = symbol
            self.isRoot = isRoot
        }

        fileprivate func addReference(_ symbol: JSSymbol) {
            if referenceSet.insert(symbol).inserted {
                references.append(symbol)
            }
        }
    }

    /// The handle a declaration body renders its parts with.
    struct Builder {
        fileprivate let declaration: Declaration

        /// The spelling of the symbol being defined; spelling it records no dependency.
        var name: String { declaration.symbol.spelling }

        /// Renders a part of the declaration into `slot`.
        func part(_ slot: JSSlot, _ write: (CodeFragmentPrinter) throws -> Void) rethrows {
            let printer = CodeFragmentPrinter()
            try write(printer)
            declaration.parts.append((slot, printer.lines))
        }

        /// Adds a part of the declaration to `slot` that renders after ``JSDeclGraph/sweep()``,
        /// so that it can depend on which declarations are kept. It must not record references.
        func lazyPart(_ slot: JSSlot, _ render: @escaping (JSDeclGraph) -> [String]) {
            declaration.lazyParts.append((slot, render))
        }

        /// Records a dependency of the declaration without spelling the symbol.
        func depend(on symbol: JSSymbol) {
            declaration.addReference(symbol)
        }
    }

    private var declarations: [Declaration] = []
    private var indices: [JSSymbol: Int] = [:]
    /// The declarations being rendered, innermost last. The first is the implicit root.
    private var owners: [Declaration] = []
    private var inProgress: Set<JSSymbol> = []
    private var live: Set<JSSymbol>? = nil

    init() {
        reset()
    }

    func reset() {
        declarations.removeAll()
        indices.removeAll()
        inProgress.removeAll()
        live = nil
        let root = Declaration(symbol: JSSymbol(kind: .runtime, name: "<root>"), isRoot: true)
        owners = [root]
        declarations.append(root)
    }

    /// Defines `symbol` by running `body`, which renders its parts and records its dependencies.
    ///
    /// - Parameter isRoot: Whether the declaration is kept even if nothing references it.
    ///
    /// Declarations that `body` defines come before this one, so a declaration can use what it defines
    /// while rendering, like a codec composed of other codecs.
    func define(_ symbol: JSSymbol, isRoot: Bool = false, _ body: (Builder) throws -> Void) rethrows {
        precondition(!isDefined(symbol), "\(symbol.name) is defined twice")
        let declaration = Declaration(symbol: symbol, isRoot: isRoot)
        inProgress.insert(symbol)
        owners.append(declaration)
        defer {
            owners.removeLast()
            inProgress.remove(symbol)
            indices[symbol] = declarations.count
            declarations.append(declaration)
        }
        try body(Builder(declaration: declaration))
    }

    /// Defines `symbol` unless it is already defined, and references it.
    @discardableResult
    func defineOnce(_ symbol: JSSymbol, _ body: (Builder) throws -> Void) rethrows -> String {
        if !isDefined(symbol) {
            try define(symbol, body)
        }
        return ref(symbol)
    }

    func isDefined(_ symbol: JSSymbol) -> Bool {
        indices[symbol] != nil || inProgress.contains(symbol)
    }

    /// Returns the spelling of `symbol` and records it as a dependency of the declaration being rendered.
    func ref(_ symbol: JSSymbol) -> String {
        precondition(live == nil, "\(symbol.spelling) referenced after JSDeclGraph.sweep()")
        owners[owners.count - 1].addReference(symbol)
        return symbol.spelling
    }

    /// Keeps the declarations reachable from the roots.
    ///
    /// - Throws: If a kept declaration references a symbol nothing defines.
    /// - Parameter keepingAll: Keeps every declaration, as the output before dead code elimination.
    func sweep(keepingAll: Bool = false) throws {
        var live: Set<JSSymbol> = []
        var worklist = declarations.filter { keepingAll || $0.isRoot }
        for declaration in worklist {
            live.insert(declaration.symbol)
        }
        var undefined: Set<String> = []
        while let declaration = worklist.popLast() {
            for symbol in declaration.references {
                guard let index = indices[symbol] else {
                    undefined.insert(symbol.spelling)
                    continue
                }
                if live.insert(symbol).inserted {
                    worklist.append(declarations[index])
                }
            }
        }
        guard undefined.isEmpty else {
            throw BridgeJSLinkError(
                message: "BridgeJS internal error: undefined JS symbols \(undefined.sorted().joined(separator: ", "))"
            )
        }
        self.live = live
    }

    /// Whether the declaration of `symbol` is kept. Only valid after ``sweep()``.
    func isLive(_ symbol: JSSymbol) -> Bool {
        guard let live else { preconditionFailure("JSDeclGraph.isLive called before sweep()") }
        return live.contains(symbol)
    }

    /// The kept declarations, in the order of their definition.
    var liveDeclarations: [Declaration] {
        declarations.filter { isLive($0.symbol) }
    }

    /// The lines of the parts in `slot` of the kept declarations.
    ///
    /// - Parameter separatedByName: Orders the declarations by name and separates them by blank lines.
    func lines(for slot: JSSlot, separatedByName: Bool = false) -> [String] {
        var kept = liveDeclarations
        if separatedByName {
            kept.sort { $0.symbol.name < $1.symbol.name }
        }
        var emitted: [String] = []
        for declaration in kept {
            var lines = declaration.parts.filter { $0.slot == slot }.flatMap(\.lines)
            lines += declaration.lazyParts.filter { $0.slot == slot }.flatMap { $0.render(self) }
            guard !lines.isEmpty else { continue }
            if separatedByName, !emitted.isEmpty {
                emitted.append("")
            }
            emitted += lines
        }
        return emitted
    }
}

// MARK: - Runtime symbols

extension JSSymbol {
    static let setException = runtime("setException")
    static let decodeString = runtime("decodeString")
    static let decodeUTF8 = runtime("decodeUTF8")
    static let immortalStrings = runtime("immortalStrings")
    static let textDecoder = runtime("textDecoder")
    static let textEncoder = runtime("textEncoder")
    static let tmpRetString = runtime("tmpRetString")
    static let tmpRetBytes = runtime("tmpRetBytes")
    static let tmpRetException = runtime("tmpRetException")
    static let tmpRetOptionalBool = runtime("tmpRetOptionalBool")
    static let tmpRetOptionalInt = runtime("tmpRetOptionalInt")
    static let tmpRetOptionalFloat = runtime("tmpRetOptionalFloat")
    static let tmpRetOptionalDouble = runtime("tmpRetOptionalDouble")
    static let tmpRetOptionalHeapObject = runtime("tmpRetOptionalHeapObject")
    static let strStack = runtime("strStack")
    static let i32Stack = runtime("i32Stack")
    static let i64Stack = runtime("i64Stack")
    static let f32Stack = runtime("f32Stack")
    static let f64Stack = runtime("f64Stack")
    static let ptrStack = runtime("ptrStack")
    static let taStack = runtime("taStack")
    static let enumHelpers = runtime("enumHelpers")
    static let structHelpers = runtime("structHelpers")
    /// `const imports = options.getImports(importsContext)`
    static let importsObject = runtime("imports")
    /// `swiftClosureRegistry` and `makeClosure`
    static let swiftClosureHelpers = intrinsic("swiftClosureHelpers")
    static let makeSwiftClosure = JSSymbol(kind: .intrinsic, name: "swiftClosureHelpers", spelling: "makeClosure")
    static let typedArrayConstructors = runtime("taCtors")
    static let promiseSettlers = runtime("__bjs_promiseSettlers")
    /// The type handle registry of generic imports: `__bjs_codecByTypeId`, `__bjs_registerTypeHandles` and
    /// `__bjs_codecForTypeId`.
    static let codecByTypeId = runtime("__bjs_codecByTypeId")
    static let codecForTypeId = JSSymbol(kind: .runtime, name: "__bjs_codecByTypeId", spelling: "__bjs_codecForTypeId")
    static let registerTypeHandles = JSSymbol(
        kind: .runtime,
        name: "__bjs_codecByTypeId",
        spelling: "__bjs_registerTypeHandles"
    )
}

extension JSSymbol {
    /// The names of the runtime symbols, which variables of the glue must not shadow.
    static let reservedRuntimeNames: [String] =
        [
            setException, decodeString, decodeUTF8, immortalStrings, textDecoder, textEncoder,
            tmpRetString, tmpRetBytes, tmpRetException, tmpRetOptionalBool, tmpRetOptionalInt,
            tmpRetOptionalFloat, tmpRetOptionalDouble, tmpRetOptionalHeapObject,
            strStack, i32Stack, i64Stack, f32Stack, f64Stack, ptrStack, taStack,
            enumHelpers, structHelpers, importsObject, makeSwiftClosure, typedArrayConstructors, promiseSettlers,
            codecByTypeId, codecForTypeId, registerTypeHandles,
        ].map(\.spelling) + [
            "swiftClosureRegistry", "__bjs_primitiveCodecs", "__bjs_stringCodec", "__bjs_typeHandlesRegistered",
        ]
}

extension JSSymbol {
    static let swiftClosureRegistry = JSSymbol(
        kind: .intrinsic,
        name: "swiftClosureHelpers",
        spelling: "swiftClosureRegistry"
    )
    /// `__bjs_stringCodec` and `__bjs_primitiveCodecs`
    static let stringCodec = JSSymbol(kind: .intrinsic, name: "containerPrimitiveCodecs", spelling: "__bjs_stringCodec")
    static let primitiveCodecs = JSSymbol(
        kind: .intrinsic,
        name: "containerPrimitiveCodecs",
        spelling: "__bjs_primitiveCodecs"
    )
}
