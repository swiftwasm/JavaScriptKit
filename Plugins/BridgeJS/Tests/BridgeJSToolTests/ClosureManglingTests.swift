import Testing

@testable import BridgeJSSkeleton

@Suite struct ClosureManglingTests {
    private func sig(async a: Bool, throws t: Bool) -> ClosureSignature {
        ClosureSignature(
            parameters: [.integer(.int)],
            returnType: .integer(.int),
            moduleName: "M",
            isAsync: a,
            isThrows: t
        )
    }

    @Test func effectsDisambiguateMangle() {
        let plain = sig(async: false, throws: false).mangleName
        let thr = sig(async: false, throws: true).mangleName
        let asy = sig(async: true, throws: false).mangleName
        let both = sig(async: true, throws: true).mangleName
        #expect(Set([plain, thr, asy, both]).count == 4)
        #expect(thr.contains("K"))
        #expect(asy.contains("Ya"))
        if let ya = both.range(of: "Ya"), let k = both.range(of: "K") {
            #expect(ya.lowerBound < k.lowerBound)
        } else {
            Issue.record("expected both Ya and K in async-throws mangle")
        }
    }
}
