import Foundation
import Testing

@testable import BridgeJSLink
@testable import BridgeJSSkeleton

/// Covers module-origin behavior that the single-Swift-module snapshot tests cannot reach:
/// how references from *several* Swift modules are deduplicated, ordered, and named.
@Suite struct ImportedJSModuleRegistryTests {
    private func skeleton(
        moduleName: String,
        functions: [ImportedFunctionSkeleton] = [],
        types: [ImportedTypeSkeleton] = []
    ) -> BridgeJSSkeleton {
        BridgeJSSkeleton(
            moduleName: moduleName,
            imported: ImportedModuleSkeleton(
                children: [ImportedFileSkeleton(functions: functions, types: types)]
            )
        )
    }

    private func function(
        _ name: String,
        jsName: String? = nil,
        from: JSImportFrom
    ) -> ImportedFunctionSkeleton {
        ImportedFunctionSkeleton(
            name: name,
            jsName: jsName,
            from: from,
            parameters: [],
            returnType: .void
        )
    }

    private func importLines(_ skeletons: [BridgeJSSkeleton]) throws -> [String] {
        var link = BridgeJSLink(sharedMemory: false)
        let encoder = JSONEncoder()
        for skeleton in skeletons {
            _ = try link.addSkeletonFile(data: try encoder.encode(skeleton))
        }
        let js = try link.link().outputJs
        return js.split(separator: "\n").map(String.init).filter { $0.hasPrefix("import ") }
    }

    /// A bare specifier names the same module regardless of which Swift module mentions it,
    /// so two Swift modules must share one import and one binding.
    @Test func bareSpecifierIsSharedAcrossSwiftModules() throws {
        let lines = try importLines([
            skeleton(moduleName: "Alpha", functions: [function("a", jsName: "basename", from: .module("node:path"))]),
            skeleton(moduleName: "Beta", functions: [function("b", jsName: "dirname", from: .module("node:path"))]),
        ])
        #expect(lines.count == 1)
        #expect(lines[0].contains("from \"node:path\""))
        #expect(lines[0].contains("basename as "))
        #expect(lines[0].contains("dirname as "))
    }

    /// A local path is only meaningful relative to its Swift target, so the same path in two
    /// Swift modules must stay two separate copies with two separate imports.
    @Test func localPathIsNotSharedAcrossSwiftModules() throws {
        let lines = try importLines([
            skeleton(moduleName: "Alpha", functions: [function("a", from: .module("/utils.mjs"))]),
            skeleton(moduleName: "Beta", functions: [function("b", from: .module("/utils.mjs"))]),
        ])
        #expect(lines.count == 2)
        #expect(lines.contains { $0.contains("bridge-js-modules/Alpha/utils.mjs") })
        #expect(lines.contains { $0.contains("bridge-js-modules/Beta/utils.mjs") })
    }

    /// A named import is a hard link-time requirement, so a class whose module export is
    /// never looked up must not produce one. A wrapper-only `@JSClass` has no constructor
    /// and no static methods, so nothing references the module's export of that name and
    /// the module need not export it at all; requiring it would fail the whole module load.
    @Test func wrapperOnlyClassDoesNotRequireANamedExport() throws {
        let lines = try importLines([
            skeleton(
                moduleName: "Alpha",
                types: [
                    ImportedTypeSkeleton(
                        name: "Wrapper",
                        from: .module("some-pkg"),
                        methods: [
                            ImportedFunctionSkeleton(name: "read", parameters: [], returnType: .void)
                        ]
                    )
                ]
            )
        ])
        #expect(lines.count == 1)
        #expect(lines[0].hasPrefix("import * as "))
        #expect(!lines[0].contains("Wrapper as "))
    }

    /// A class with a constructor does have its export looked up, so it keeps a named import.
    @Test func classWithConstructorUsesANamedImport() throws {
        let lines = try importLines([
            skeleton(
                moduleName: "Alpha",
                types: [
                    ImportedTypeSkeleton(
                        name: "Wrapper",
                        from: .module("some-pkg"),
                        constructor: ImportedConstructorSkeleton(parameters: [])
                    )
                ]
            )
        ])
        #expect(lines == [#"import { Wrapper as __bjs_import_0_Wrapper } from "some-pkg";"#])
    }

    /// A class with only static methods also looks its export up.
    @Test func classWithOnlyStaticMethodsUsesANamedImport() throws {
        let lines = try importLines([
            skeleton(
                moduleName: "Alpha",
                types: [
                    ImportedTypeSkeleton(
                        name: "Wrapper",
                        from: .module("some-pkg"),
                        staticMethods: [
                            ImportedFunctionSkeleton(name: "create", parameters: [], returnType: .void)
                        ]
                    )
                ]
            )
        ])
        #expect(lines == [#"import { Wrapper as __bjs_import_0_Wrapper } from "some-pkg";"#])
    }

    /// Local references are emitted before bare ones, each group sorted, so that the numbered
    /// aliases in generated JavaScript are stable across runs.
    @Test func referencesAreOrderedDeterministically() throws {
        let lines = try importLines([
            skeleton(
                moduleName: "Alpha",
                functions: [
                    function("z", jsName: "zeta", from: .module("zzz-package")),
                    function("a", jsName: "alpha", from: .module("aaa-package")),
                    function("l", from: .module("/local.mjs")),
                ]
            )
        ])
        #expect(lines.count == 3)
        #expect(lines[0].contains("/local.mjs"))
        #expect(lines[1].contains("aaa-package"))
        #expect(lines[2].contains("zzz-package"))
    }

    /// A class and a free function on the same specifier share one import line.
    @Test func classAndFunctionOnSameSpecifierShareOneImport() throws {
        let lines = try importLines([
            skeleton(
                moduleName: "Alpha",
                functions: [function("a", jsName: "helper", from: .module("pkg"))],
                types: [
                    ImportedTypeSkeleton(
                        name: "Widget",
                        from: .module("pkg"),
                        constructor: ImportedConstructorSkeleton(parameters: [])
                    )
                ]
            )
        ])
        #expect(lines.count == 1)
        #expect(lines[0].contains("helper as "))
        #expect(lines[0].contains("Widget as "))
    }

    /// One non-identifier export name degrades its own origin to a namespace import without
    /// affecting any other origin in the same program.
    @Test func namespaceFallbackIsScopedToOneOrigin() throws {
        let lines = try importLines([
            skeleton(
                moduleName: "Alpha",
                functions: [
                    function("a", jsName: "kebab-case", from: .module("weird-package")),
                    function("b", jsName: "join", from: .module("node:path")),
                ]
            )
        ])
        let weird = try #require(lines.first { $0.contains("weird-package") })
        let node = try #require(lines.first { $0.contains("node:path") })
        #expect(weird.hasPrefix("import * as "))
        #expect(node.hasPrefix("import { join as "))
    }

    /// Because a bare specifier is shared across Swift modules, its member names form a union.
    /// A non-identifier name contributed by one Swift module therefore degrades the shared
    /// import for the other module too. That is intended — one specifier means one import
    /// statement — but it is worth pinning so the behavior is not changed by accident.
    @Test func nonIdentifierNameInOneSwiftModuleDegradesTheSharedImport() throws {
        let lines = try importLines([
            skeleton(moduleName: "Alpha", functions: [function("a", jsName: "join", from: .module("node:path"))]),
            skeleton(moduleName: "Beta", functions: [function("b", jsName: "odd-name", from: .module("node:path"))]),
        ])
        #expect(lines.count == 1)
        #expect(lines[0].hasPrefix("import * as "))
    }

    /// A reserved word is a legal ECMAScript export name, and `default` is how the default
    /// export is spelled, so both must survive as named imports.
    @Test(arguments: ["default", "class", "import"])
    func reservedWordExportNamesUseNamedImports(memberName: String) throws {
        let lines = try importLines([
            skeleton(moduleName: "Alpha", functions: [function("a", jsName: memberName, from: .module("pkg"))])
        ])
        #expect(lines.count == 1)
        #expect(lines[0].hasPrefix("import { \(memberName) as "))
    }

    /// A specifier is embedded in a JavaScript string literal, so quotes and backslashes in it
    /// must be escaped rather than terminating the literal.
    @Test func specifierIsEscapedInTheImportLine() throws {
        let lines = try importLines([
            skeleton(moduleName: "Alpha", functions: [function("a", jsName: "x", from: .module("pk\"g\\y"))])
        ])
        #expect(lines.count == 1)
        #expect(lines[0].hasSuffix(#"from "pk\"g\\y";"#))
    }
}
