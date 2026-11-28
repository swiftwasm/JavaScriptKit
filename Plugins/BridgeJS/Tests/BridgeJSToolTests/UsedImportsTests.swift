import Foundation
import SwiftParser
import Testing
@testable import BridgeJSLink
@testable import BridgeJSCore
@testable import BridgeJSSkeleton

@Suite struct UsedImportsTests {
    private func makeLink(input: String) throws -> BridgeJSLink {
        let url = BridgeJSLinkTests.inputsDirectory.appendingPathComponent(input)
        let sourceFile = Parser.parse(source: try String(contentsOf: url, encoding: .utf8))
        let swiftAPI = SwiftToSkeleton(
            progress: .silent,
            moduleName: "TestModule",
            exposeToGlobal: false,
            externalModuleIndex: .empty,
            javaScriptModuleExists: { BridgeJSLinkTests.existingModulePaths[input, default: []].contains($0) }
        )
        swiftAPI.addSourceFile(sourceFile, inputFilePath: input)
        return BridgeJSLink(skeletons: [try swiftAPI.finalize()])
    }

    /// The `module["name"] = ...` and `importObject["module"]["name"] = ...` assignments in the
    /// generated JS, keyed by module.
    private func assignedImports(_ js: String) throws -> [String: Set<String>] {
        let regex = try NSRegularExpression(
            pattern: #"^\s*(?:importObject\["(\w+)"\]|(\w+))\["(\w+)"\] = "#,
            options: .anchorsMatchLines
        )
        let matches = regex.matches(in: js, range: NSRange(js.startIndex..., in: js))
        return matches.reduce(into: [:]) { result, match in
            let moduleRange = match.range(at: 1).location != NSNotFound ? match.range(at: 1) : match.range(at: 2)
            let module = String(js[Range(moduleRange, in: js)!])
            guard module != "importObject" else { return }
            let name = String(js[Range(match.range(at: 3), in: js)!])
            result[module, default: []].insert(name)
        }
    }

    /// The `bjs` imports the generated JS calls itself as `bjs["name"](...)`.
    private func referencedBJSImports(_ js: String) throws -> Set<String> {
        let regex = try NSRegularExpression(pattern: #"bjs\["(\w+)"\]\("#)
        let matches = regex.matches(in: js, range: NSRange(js.startIndex..., in: js))
        return Set(matches.map { String(js[Range($0.range(at: 1), in: js)!]) })
    }

    /// The `__bjs_*` helpers the generated JS uses but doesn't declare.
    private func undeclaredHelpers(_ js: String) throws -> Set<String> {
        func names(_ pattern: String) throws -> Set<String> {
            let regex = try NSRegularExpression(pattern: pattern)
            let matches = regex.matches(in: js, range: NSRange(js.startIndex..., in: js))
            return Set(matches.map { String(js[Range($0.range(at: 1), in: js)!]) })
        }
        let declared = try names(#"(?:\b(?:const|let|var|function|class|import)\s+|\bas\s+)(__bjs_\w+)"#)
        return try names(#"\b(__bjs_\w+)"#).subtracting(declared)
    }

    @Test(arguments: BridgeJSLinkTests.collectInputs(extension: ".swift"))
    func filteringKeepsGlueConsistent(input: String) throws {
        let link = try makeLink(input: input)
        let unfiltered = try link.link().outputJs
        let all = try assignedImports(unfiltered)

        #expect(try link.link(usedImports: all).outputJs == unfiltered)

        // Every bjs import and helper the remaining glue references must stay defined, whether module
        // imports or closure imports are what references it, also when its other users are dropped
        let moduleImports = all.filter { $0.key != "bjs" }
        var closureImports = moduleImports
        closureImports["bjs"] = all["bjs", default: []].filter {
            $0.hasPrefix("make_swift_closure_") || $0.hasPrefix("invoke_js_callback_")
        }
        let eachImportAlone: [[String: Set<String>]] = all.flatMap { module, names in names.map { [module: [$0]] } }
        for used in [moduleImports, closureImports, [:]] + eachImportAlone {
            let js = try link.link(usedImports: used).outputJs
            let defined = try assignedImports(js)["bjs", default: []]
            #expect(try referencedBJSImports(js).isSubset(of: defined))
            #expect(try undeclaredHelpers(js).isEmpty)
        }
    }

    @Test
    func emitsOnlyUsedImports() throws {
        let link = try makeLink(input: "JSClass.swift")
        let unfiltered = try link.link()
        let all = try assignedImports(unfiltered.outputJs)
        let moduleImports = try #require(all["TestModule"]).sorted()
        let bjsImports = try #require(all["bjs"]).sorted()
        try #require(moduleImports.count >= 2 && bjsImports.count >= 2)

        let used: [String: Set<String>] = ["TestModule": [moduleImports[0]], "bjs": [bjsImports[0]]]
        let output = try link.link(usedImports: used)
        #expect(try assignedImports(output.outputJs) == used)
        #expect(output.outputDts == unfiltered.outputDts)
    }

    @Test
    func emptyUsedImportsDropsAllGlue() throws {
        let link = try makeLink(input: "SwiftClosure.swift")
        #expect(try assignedImports(link.link(usedImports: [:]).outputJs).isEmpty)
    }

    @Test
    func closureHelpersFollowUsedImports() throws {
        let link = try makeLink(input: "SwiftClosure.swift")
        let all = try assignedImports(link.link().outputJs)
        let make = try #require(all["bjs"]?.filter { $0.hasPrefix("make_swift_closure_") }.min())
        let invoke = try #require(all["bjs"]?.filter { $0.hasPrefix("invoke_js_callback_") }.min())

        let invokeOnly = try link.link(usedImports: ["bjs": [invoke]]).outputJs
        #expect(try assignedImports(invokeOnly) == ["bjs": [invoke]])
        #expect(!invokeOnly.contains(JSGlueVariableScope.reservedSwiftClosureRegistry))

        let makeOnly = try link.link(usedImports: ["bjs": [make]]).outputJs
        #expect(try assignedImports(makeOnly) == ["bjs": [make]])
        #expect(makeOnly.contains(JSGlueVariableScope.reservedSwiftClosureRegistry))
    }
}
