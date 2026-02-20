import XCTest
import JavaScriptKit

@JSClass struct JSClassWithArrayMembers {
    @JSGetter var numbers: [Int]
    @JSGetter var labels: [String]
    @JSSetter func setNumbers(_ value: [Int]) throws(JSException)
    @JSSetter func setLabels(_ value: [String]) throws(JSException)
    @JSFunction init(_ numbers: [Int], _ labels: [String]) throws(JSException)
    @JSFunction func concatNumbers(_ values: [Int]) throws(JSException) -> [Int]
    @JSFunction func concatLabels(_ values: [String]) throws(JSException) -> [String]
    @JSFunction func firstLabel(_ values: [String]) throws(JSException) -> String
}

@JSClass struct JSClassSupportImports {
    @JSFunction static func makeJSClassWithArrayMembers(
        _ numbers: [Int],
        _ labels: [String]
    ) throws(JSException) -> JSClassWithArrayMembers
}

final class JSClassSupportTests: XCTestCase {
    func testJSClassArrayMembers() throws {
        let numbers = [1, 2, 3]
        let labels = ["alpha", "beta"]
        let host = try JSClassSupportImports.makeJSClassWithArrayMembers(numbers, labels)

        XCTAssertEqual(try host.numbers, numbers)
        XCTAssertEqual(try host.labels, labels)

        try host.setNumbers([10, 20])
        try host.setLabels(["gamma"])
        XCTAssertEqual(try host.numbers, [10, 20])
        XCTAssertEqual(try host.labels, ["gamma"])

        XCTAssertEqual(try host.concatNumbers([30, 40]), [10, 20, 30, 40])
        XCTAssertEqual(try host.concatLabels(["delta", "epsilon"]), ["gamma", "delta", "epsilon"])
        XCTAssertEqual(try host.firstLabel([]), "gamma")
        XCTAssertEqual(try host.firstLabel(["zeta"]), "zeta")
    }
}
