/// The original implementation of this file is from Carton.
/// https://github.com/swiftwasm/carton/blob/1.1.3/Sources/carton-frontend-slim/TestRunners/TestsParser.swift

import Foundation
import RegexBuilder

extension String.StringInterpolation {
    /// Display `value` with the specified ANSI-escaped `color` values, then apply the reset.
    fileprivate mutating func appendInterpolation<T>(_ value: T, color: String...) {
        appendInterpolation("\(color.map { "\u{001B}\($0)" }.joined())\(value)\u{001B}[0m")
    }
}

class FancyTestsParser {
    let write: (String) -> Void

    init(write: @escaping (String) -> Void) {
        self.write = write
    }

    private enum Status {
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

    private struct Suite {
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

    private var suites = [Suite]()

    private let swiftIdentifier = #/[_\p{L}\p{Nl}][_\p{L}\p{Nl}\p{Mn}\p{Nd}\p{Pc}]*/#
    private let timestamp = #/\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{3}/#
    private lazy var suiteStarted = Regex {
        "Test Suite '"
        Capture {
            OneOrMore(CharacterClass.anyOf("'").inverted)
        }
        "' started at "
        Capture { self.timestamp }
    }
    private lazy var suiteStatus = Regex {
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
    private lazy var testCaseStarted = Regex {
        "Test Case '"
        Capture { self.swiftIdentifier }
        "."
        Capture { self.swiftIdentifier }
        "' started"
    }
    private lazy var testCaseStatus = Regex {
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

    private let testSummary =
        #/Executed \d+ (test|tests), with (?:\d+ (?:test|tests) skipped and )?\d+ (failure|failures) \((?<unexpected>\d+) unexpected\) in (?<duration>\d+\.\d+) \(\d+\.\d+\) seconds/#

    func onLine(_ line: String) {
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
                flushSingleSuite(suites[suiteIdx])
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
                write(line + "\n")
            }
        }
    }

    private func flushSingleSuite(_ suite: Suite) {
        write(suite.statusLabel + " " + suite.name + "\n")
        for testCase in suite.cases {
            write("  " + testCase.statusMark + " " + testCase.name)
            if let duration = testCase.duration {
                write(" \("(\(duration)s)", color: "[90m")")
            }
            write("\n")
        }
    }

    func finalize() {
        write("\n")

        func formatCategory(
            label: String,
            statuses: [Status]
        ) -> String {
            var passed = 0
            var skipped = 0
            var failed = 0
            var unknown = 0
            for status in statuses {
                switch status {
                case .passed: passed += 1
                case .skipped: skipped += 1
                case .failed: failed += 1
                case .unknown: unknown += 1
                }
            }
            var result = "\(label) "
            if passed > 0 {
                result += "\u{001B}[32m\(passed) passed\u{001B}[0m, "
            }
            if skipped > 0 {
                result += "\u{001B}[97m\(skipped) skipped\u{001B}[0m, "
            }
            if failed > 0 {
                result += "\u{001B}[31m\(failed) failed\u{001B}[0m, "
            }
            if unknown > 0 {
                result += "\u{001B}[31m\(unknown) unknown\u{001B}[0m, "
            }
            result += "\u{001B}[0m\(statuses.count) total\n"
            return result
        }

        let suitesWithCases = suites.filter { $0.cases.count > 0 }
        write(
            formatCategory(
                label: "Test Suites:",
                statuses: suitesWithCases.map(\.status)
            )
        )
        let allCaseStatuses = suitesWithCases.flatMap {
            $0.cases.map { $0.status }
        }
        write(
            formatCategory(
                label: "Tests:      ",
                statuses: allCaseStatuses
            )
        )

        if suites.contains(where: { $0.name == "All tests" }) {
            write("\("Ran all test suites.", color: "[90m")\n")  // gray
        }

        if suites.contains(where: { $0.status.isNegative }) {
            write("\n\("Failed test cases:", color: "[31m")\n")
            for suite in suites.filter({ $0.status.isNegative }) {
                for testCase in suite.cases.filter({ $0.status.isNegative }) {
                    write("  \(testCase.statusMark) \(suite.name).\(testCase.name)\n")
                }
            }

            write(
                "\n\("Some tests failed. Use --verbose for raw test output.", color: "[33m")\n"
            )
        }
    }
}
