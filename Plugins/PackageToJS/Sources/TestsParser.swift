/// The original implementation of this file is from Carton.
/// https://github.com/swiftwasm/carton/blob/1.1.3/Sources/carton-frontend-slim/TestRunners/TestsParser.swift

import Foundation
import RegexBuilder

protocol InteractiveWriter {
    func write(_ string: String)
}

protocol TestsParser {
    /// Parse the output of a test process, format it, then output in the `InteractiveWriter`.
    func onLine(_ line: String, _ terminal: InteractiveWriter)
    func finalize(_ terminal: InteractiveWriter)
}

extension String.StringInterpolation {
    /// Display `value` with the specified ANSI-escaped `color` values, then apply the reset.
    fileprivate mutating func appendInterpolation<T>(_ value: T, color: String...) {
        appendInterpolation("\(color.map { "\u{001B}\($0)" }.joined())\(value)\u{001B}[0m")
    }
}

class FancyTestsParser: TestsParser {
    init() {}

    enum Status: Equatable {
        case passed, failed, skipped
        case unknown(String.SubSequence?)

        var isNegative: Bool {
            switch self {
            case .failed, .unknown(nil): return true
            default: return false
            }
        }

        init(rawValue: String.SubSequence) {
            switch rawValue {
            case "passed": self = .passed
            case "failed": self = .failed
            case "skipped": self = .skipped
            default: self = .unknown(rawValue)
            }
        }
    }

    struct Suite {
        let name: String.SubSequence
        var status: Status = .unknown(nil)

        var statusLabel: String {
            switch status {
            case .passed: return "\(" PASSED ", color: "[1m", "[97m", "[42m")"
            case .failed: return "\(" FAILED ", color: "[1m", "[97m", "[101m")"
            case .skipped: return "\(" SKIPPED ", color: "[1m", "[97m", "[97m")"
            case .unknown(let status):
                return "\(" \(status ?? "UNKNOWN") ", color: "[1m", "[97m", "[101m")"
            }
        }

        var cases: [Case]

        struct Case {
            let name: String.SubSequence
            var statusMark: String {
                switch status {
                case .passed: return "\("\u{2714}", color: "[92m")"
                case .failed: return "\("\u{2718}", color: "[91m")"
                case .skipped: return "\("\u{279C}", color: "[97m")"
                case .unknown: return "\("?", color: "[97m")"
                }
            }
            var status: Status = .unknown(nil)
            var duration: String.SubSequence?
        }
    }

    var suites = [Suite]()

    let swiftIdentifier = #/[_\p{L}\p{Nl}][_\p{L}\p{Nl}\p{Mn}\p{Nd}\p{Pc}]*/#
    let timestamp = #/\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{3}/#
    lazy var suiteStarted = Regex {
        "Test Suite '"
        Capture {
            OneOrMore(CharacterClass.anyOf("'").inverted)
        }
        "' started at "
        Capture { self.timestamp }
    }
    lazy var suiteStatus = Regex {
        "Test Suite '"
        Capture { OneOrMore(CharacterClass.anyOf("'").inverted) }
        "' "
        Capture {
            ChoiceOf {
                "failed"
                "passed"
            }
        }
        " at "
        Capture { self.timestamp }
    }
    lazy var testCaseStarted = Regex {
        "Test Case '"
        Capture { self.swiftIdentifier }
        "."
        Capture { self.swiftIdentifier }
        "' started"
    }
    lazy var testCaseStatus = Regex {
        "Test Case '"
        Capture { self.swiftIdentifier }
        "."
        Capture { self.swiftIdentifier }
        "' "
        Capture {
            ChoiceOf {
                "failed"
                "passed"
                "skipped"
            }
        }
        " ("
        Capture {
            OneOrMore(.digit)
            "."
            OneOrMore(.digit)
        }
        " seconds)"
    }

    let testSummary =
        #/Executed \d+ (test|tests), with (?:\d+ (?:test|tests) skipped and )?\d+ (failure|failures) \((?<unexpected>\d+) unexpected\) in (?<duration>\d+\.\d+) \(\d+\.\d+\) seconds/#

    func onLine(_ line: String, _ terminal: InteractiveWriter) {
        if let match = line.firstMatch(
            of: suiteStarted
        ) {
            let (_, suite, _) = match.output
            suites.append(.init(name: suite, cases: []))
        } else if let match = line.firstMatch(
            of: suiteStatus
        ) {
            let (_, suite, status, _) = match.output
            if let suiteIdx = suites.firstIndex(where: { $0.name == suite }) {
                suites[suiteIdx].status = Status(rawValue: status)
                flushSingleSuite(suites[suiteIdx], terminal)
            }
        } else if let match = line.firstMatch(
            of: testCaseStarted
        ) {
            let (_, suite, testCase) = match.output
            if let suiteIdx = suites.firstIndex(where: { $0.name == suite }) {
                suites[suiteIdx].cases.append(
                    .init(name: testCase, duration: nil)
                )
            }
        } else if let match = line.firstMatch(
            of: testCaseStatus
        ) {
            let (_, suite, testCase, status, duration) = match.output
            if let suiteIdx = suites.firstIndex(where: { $0.name == suite }) {
                if let caseIdx = suites[suiteIdx].cases.firstIndex(where: {
                    $0.name == testCase
                }) {
                    suites[suiteIdx].cases[caseIdx].status = Status(rawValue: status)
                    suites[suiteIdx].cases[caseIdx].duration = duration
                }
            }
        } else if line.firstMatch(of: testSummary) != nil {
            // do nothing
        } else {
            if !line.isEmpty {
                terminal.write(line + "\n")
            }
        }
    }

    func finalize(_ terminal: InteractiveWriter) {
        terminal.write("\n")
        flushSummary(of: suites, terminal)
    }

    private func flushSingleSuite(_ suite: Suite, _ terminal: InteractiveWriter) {
        terminal.write(suite.statusLabel)
        terminal.write(" \(suite.name)\n")
        for testCase in suite.cases {
            terminal.write("  \(testCase.statusMark) ")
            if let duration = testCase.duration {
                terminal
                    .write(
                        "\(testCase.name) \("(\(Int(Double(duration)! * 1000))ms)", color: "[90m")\n"
                    )  // gray
            }
        }
    }

    private func flushSummary(of suites: [Suite], _ terminal: InteractiveWriter) {
        let suitesWithCases = suites.filter { $0.cases.count > 0 }

        terminal.write("Test Suites: ")
        let suitesPassed = suitesWithCases.filter { $0.status == .passed }.count
        if suitesPassed > 0 {
            terminal.write("\("\(suitesPassed) passed", color: "[32m"), ")
        }
        let suitesSkipped = suitesWithCases.filter { $0.status == .skipped }.count
        if suitesSkipped > 0 {
            terminal.write("\("\(suitesSkipped) skipped", color: "[97m"), ")
        }
        let suitesFailed = suitesWithCases.filter { $0.status == .failed }.count
        if suitesFailed > 0 {
            terminal.write("\("\(suitesFailed) failed", color: "[31m"), ")
        }
        let suitesUnknown = suitesWithCases.filter { $0.status == .unknown(nil) }.count
        if suitesUnknown > 0 {
            terminal.write("\("\(suitesUnknown) unknown", color: "[31m"), ")
        }
        terminal.write("\(suitesWithCases.count) total\n")

        terminal.write("Tests:       ")
        let allTests = suitesWithCases.map(\.cases).reduce([], +)
        let testsPassed = allTests.filter { $0.status == .passed }.count
        if testsPassed > 0 {
            terminal.write("\("\(testsPassed) passed", color: "[32m"), ")
        }
        let testsSkipped = allTests.filter { $0.status == .skipped }.count
        if testsSkipped > 0 {
            terminal.write("\("\(testsSkipped) skipped", color: "[97m"), ")
        }
        let testsFailed = allTests.filter { $0.status == .failed }.count
        if testsFailed > 0 {
            terminal.write("\("\(testsFailed) failed", color: "[31m"), ")
        }
        let testsUnknown = allTests.filter { $0.status == .unknown(nil) }.count
        if testsUnknown > 0 {
            terminal.write("\("\(testsUnknown) unknown", color: "[31m"), ")
        }
        terminal.write("\(allTests.count) total\n")

        if suites.contains(where: { $0.name == "All tests" }) {
            terminal.write("\("Ran all test suites.", color: "[90m")\n")  // gray
        }

        if suites.contains(where: { $0.status.isNegative }) {
            print(suites.filter({ $0.status.isNegative }))
            terminal.write("\n\("Failed test cases:", color: "[31m")\n")
            for suite in suites.filter({ $0.status.isNegative }) {
                for testCase in suite.cases.filter({ $0.status.isNegative }) {
                    terminal.write("  \(testCase.statusMark) \(suite.name).\(testCase.name)\n")
                }
            }

            terminal.write(
                "\n\("Some tests failed. Use --verbose for raw test output.", color: "[33m")\n"
            )
        }
    }
}
