import Foundation
import Testing

@testable import PackageToJS

@Suite struct TestsParserTests {
    func assertFancyFormatSnapshot(
        _ input: String,
        filePath: String = #filePath,
        function: String = #function,
        sourceLocation: SourceLocation = #_sourceLocation
    ) throws {
        var output = ""
        let parser = FancyTestsParser(write: { output += $0 })
        let lines = input.split(separator: "\n", omittingEmptySubsequences: false)

        for line in lines {
            parser.onLine(String(line))
        }
        parser.finalize()
        try assertSnapshot(
            filePath: filePath,
            function: function,
            sourceLocation: sourceLocation,
            input: Data(output.utf8),
            fileExtension: "txt"
        )
    }

    @Test func testAllPassed() throws {
        try assertFancyFormatSnapshot(
            """
            Test Suite 'All tests' started at 2025-03-16 08:10:01.946
            Test Suite '/.xctest' started at 2025-03-16 08:10:01.967
            Test Suite 'CounterTests' started at 2025-03-16 08:10:01.967
            Test Case 'CounterTests.testIncrement' started at 2025-03-16 08:10:01.967
            Test Case 'CounterTests.testIncrement' passed (0.002 seconds)
            Test Case 'CounterTests.testIncrementTwice' started at 2025-03-16 08:10:01.969
            Test Case 'CounterTests.testIncrementTwice' passed (0.001 seconds)
            Test Suite 'CounterTests' passed at 2025-03-16 08:10:01.970
                     Executed 2 tests, with 0 failures (0 unexpected) in 0.003 (0.003) seconds
            Test Suite '/.xctest' passed at 2025-03-16 08:10:01.970
                     Executed 2 tests, with 0 failures (0 unexpected) in 0.003 (0.003) seconds
            Test Suite 'All tests' passed at 2025-03-16 08:10:01.970
                     Executed 2 tests, with 0 failures (0 unexpected) in 0.003 (0.003) seconds
            """
        )
    }

    @Test func testThrowFailure() throws {
        try assertFancyFormatSnapshot(
            """
            Test Suite 'All tests' started at 2025-03-16 08:40:27.267
            Test Suite '/.xctest' started at 2025-03-16 08:40:27.287
            Test Suite 'CounterTests' started at 2025-03-16 08:40:27.287
            Test Case 'CounterTests.testThrowFailure' started at 2025-03-16 08:40:27.287
            <EXPR>:0: error: CounterTests.testThrowFailure : threw error "TestError()"
            Test Case 'CounterTests.testThrowFailure' failed (0.002 seconds)
            Test Suite 'CounterTests' failed at 2025-03-16 08:40:27.290
                     Executed 1 test, with 1 failure (1 unexpected) in 0.002 (0.002) seconds
            Test Suite '/.xctest' failed at 2025-03-16 08:40:27.290
                     Executed 1 test, with 1 failure (1 unexpected) in 0.002 (0.002) seconds
            Test Suite 'All tests' failed at 2025-03-16 08:40:27.290
                     Executed 1 test, with 1 failure (1 unexpected) in 0.002 (0.002) seconds
            """
        )
    }

    @Test func testAssertFailure() throws {
        try assertFancyFormatSnapshot(
            """
            Test Suite 'All tests' started at 2025-03-16 08:43:32.415
            Test Suite '/.xctest' started at 2025-03-16 08:43:32.465
            Test Suite 'CounterTests' started at 2025-03-16 08:43:32.465
            Test Case 'CounterTests.testAssertailure' started at 2025-03-16 08:43:32.465
            /tmp/Tests/CounterTests/CounterTests.swift:27: error: CounterTests.testAssertailure : XCTAssertEqual failed: ("1") is not equal to ("2") -
            Test Case 'CounterTests.testAssertailure' failed (0.001 seconds)
            Test Suite 'CounterTests' failed at 2025-03-16 08:43:32.467
                     Executed 1 test, with 1 failure (0 unexpected) in 0.001 (0.001) seconds
            Test Suite '/.xctest' failed at 2025-03-16 08:43:32.467
                     Executed 1 test, with 1 failure (0 unexpected) in 0.001 (0.001) seconds
            Test Suite 'All tests' failed at 2025-03-16 08:43:32.468
                     Executed 1 test, with 1 failure (0 unexpected) in 0.001 (0.001) seconds
            """
        )
    }

    @Test func testSkipped() throws {
        try assertFancyFormatSnapshot(
            """
            Test Suite 'All tests' started at 2025-03-16 09:56:50.924
            Test Suite '/.xctest' started at 2025-03-16 09:56:50.945
            Test Suite 'CounterTests' started at 2025-03-16 09:56:50.945
            Test Case 'CounterTests.testIncrement' started at 2025-03-16 09:56:50.946
            /tmp/Tests/CounterTests/CounterTests.swift:25: CounterTests.testIncrement : Test skipped - Skip it
            Test Case 'CounterTests.testIncrement' skipped (0.006 seconds)
            Test Case 'CounterTests.testIncrementTwice' started at 2025-03-16 09:56:50.953
            Test Case 'CounterTests.testIncrementTwice' passed (0.0 seconds)
            Test Suite 'CounterTests' passed at 2025-03-16 09:56:50.953
                     Executed 2 tests, with 1 test skipped and 0 failures (0 unexpected) in 0.006 (0.006) seconds
            Test Suite '/.xctest' passed at 2025-03-16 09:56:50.954
                     Executed 2 tests, with 1 test skipped and 0 failures (0 unexpected) in 0.006 (0.006) seconds
            Test Suite 'All tests' passed at 2025-03-16 09:56:50.954
                     Executed 2 tests, with 1 test skipped and 0 failures (0 unexpected) in 0.006 (0.006) seconds
            """
        )
    }

    @Test func testCrash() throws {
        try assertFancyFormatSnapshot(
            """
            Test Suite 'All tests' started at 2025-03-16 09:37:07.882
            Test Suite '/.xctest' started at 2025-03-16 09:37:07.903
            Test Suite 'CounterTests' started at 2025-03-16 09:37:07.903
            Test Case 'CounterTests.testIncrement' started at 2025-03-16 09:37:07.903
            CounterTests/CounterTests.swift:26: Fatal error: Crash
            wasm://wasm/CounterPackageTests.xctest-0ef3150a:1


            RuntimeError: unreachable
                at CounterPackageTests.xctest.$ss17_assertionFailure__4file4line5flagss5NeverOs12StaticStringV_SSAHSus6UInt32VtF (wasm://wasm/CounterPackageTests.xctest-0ef3150a:wasm-function[5087]:0x1475da)
                at CounterPackageTests.xctest.$s12CounterTestsAAC13testIncrementyyYaKFTY1_ (wasm://wasm/CounterPackageTests.xctest-0ef3150a:wasm-function[1448]:0x9a33b)
                at CounterPackageTests.xctest.swift::runJobInEstablishedExecutorContext(swift::Job*) (wasm://wasm/CounterPackageTests.xctest-0ef3150a:wasm-function[29848]:0x58cb39)
                at CounterPackageTests.xctest.swift_job_run (wasm://wasm/CounterPackageTests.xctest-0ef3150a:wasm-function[29863]:0x58d720)
                at CounterPackageTests.xctest.$sScJ16runSynchronously2onySce_tF (wasm://wasm/CounterPackageTests.xctest-0ef3150a:wasm-function[1571]:0x9fe5a)
                at CounterPackageTests.xctest.$s19JavaScriptEventLoopAAC10runAllJobsyyF (wasm://wasm/CounterPackageTests.xctest-0ef3150a:wasm-function[1675]:0xa32c4)
                at CounterPackageTests.xctest.$s19JavaScriptEventLoopAAC14insertJobQueue3jobyScJ_tFyycfU0_ (wasm://wasm/CounterPackageTests.xctest-0ef3150a:wasm-function[1674]:0xa30b7)
                at CounterPackageTests.xctest.$s19JavaScriptEventLoopAAC14insertJobQueue3jobyScJ_tFyycfU0_TA (wasm://wasm/CounterPackageTests.xctest-0ef3150a:wasm-function[1666]:0xa2c6b)
                at CounterPackageTests.xctest.$s19JavaScriptEventLoopAAC6create33_F9DB15AFB1FFBEDBFE9D13500E01F3F2LLAByFZyyyccfU0_0aB3Kit20ConvertibleToJSValue_pAE0Q0OcfU_ (wasm://wasm/CounterPackageTests.xctest-0ef3150a:wasm-function[1541]:0x9de13)
                at CounterPackageTests.xctest.$s19JavaScriptEventLoopAAC6create33_F9DB15AFB1FFBEDBFE9D13500E01F3F2LLAByFZyyyccfU0_0aB3Kit20ConvertibleToJSValue_pAE0Q0OcfU_TA (wasm://wasm/CounterPackageTests.xctest-0ef3150a:wasm-function[1540]:0x9dd8d)
            """
        )
    }
}
