import Testing
import Foundation
@testable import TS2Skeleton
@testable import BridgeJSCore

@Suite struct WhichTests {

    // MARK: - Helper Functions

    private static var pathSeparator: String {
        #if os(Windows)
        return ";"
        #else
        return ":"
        #endif
    }

    // MARK: - Successful Path Resolution Tests

    @Test func whichFindsExecutableInPath() throws {
        try withTemporaryDirectory { tempDir, _ in
            let execFile = tempDir.appendingPathComponent("testexec")
            try "#!/bin/sh\necho 'test'".write(to: execFile, atomically: true, encoding: .utf8)
            try FileManager.default.setAttributes([.posixPermissions: 0o755], ofItemAtPath: execFile.path)

            let environment = ["PATH": tempDir.path]

            let result = try #require(which("testexec", environment: environment))

            #expect(result.path == execFile.path)
        }
    }

    @Test func whichReturnsFirstMatchInPath() throws {
        try withTemporaryDirectory { tempDir1, _ in
            try withTemporaryDirectory { tempDir2, _ in
                let exec1 = tempDir1.appendingPathComponent("testexec")
                let exec2 = tempDir2.appendingPathComponent("testexec")

                // Create executable files in both directories
                try "#!/bin/sh\necho 'first'".write(to: exec1, atomically: true, encoding: .utf8)
                try "#!/bin/sh\necho 'second'".write(to: exec2, atomically: true, encoding: .utf8)

                // Make files executable
                try FileManager.default.setAttributes([.posixPermissions: 0o755], ofItemAtPath: exec1.path)
                try FileManager.default.setAttributes([.posixPermissions: 0o755], ofItemAtPath: exec2.path)

                let pathEnv = "\(tempDir1.path)\(Self.pathSeparator)\(tempDir2.path)"
                let environment = ["PATH": pathEnv]

                let result = try #require(which("testexec", environment: environment))

                // Should return the first one found
                #expect(result.path == exec1.path)
            }
        }
    }

    // MARK: - Environment Variable Override Tests

    @Test func whichUsesEnvironmentVariableOverride() throws {
        try withTemporaryDirectory { tempDir, _ in
            let customExec = tempDir.appendingPathComponent("mynode")
            try "#!/bin/sh\necho 'custom node'".write(to: customExec, atomically: true, encoding: .utf8)
            try FileManager.default.setAttributes([.posixPermissions: 0o755], ofItemAtPath: customExec.path)

            let environment = [
                "PATH": "/nonexistent/path",
                "JAVASCRIPTKIT_NODE_EXEC": customExec.path,
            ]

            let result = try #require(which("node", environment: environment))

            #expect(result.path == customExec.path)
        }
    }

    @Test func whichHandlesHyphenatedExecutableNames() throws {
        try withTemporaryDirectory { tempDir, _ in
            let customExec = tempDir.appendingPathComponent("my-exec")
            try "#!/bin/sh\necho 'hyphenated'".write(to: customExec, atomically: true, encoding: .utf8)
            try FileManager.default.setAttributes([.posixPermissions: 0o755], ofItemAtPath: customExec.path)

            let environment = [
                "PATH": "/nonexistent/path",
                "JAVASCRIPTKIT_MY_EXEC_EXEC": customExec.path,
            ]

            let result = try #require(which("my-exec", environment: environment))

            #expect(result.path == customExec.path)
        }
    }

    @Test func whichPrefersEnvironmentOverridePath() throws {
        try withTemporaryDirectory { tempDir1, _ in
            try withTemporaryDirectory { tempDir2, _ in
                let pathExec = tempDir1.appendingPathComponent("testexec")
                let envExec = tempDir2.appendingPathComponent("testexec")

                try "#!/bin/sh\necho 'from path'".write(to: pathExec, atomically: true, encoding: .utf8)
                try "#!/bin/sh\necho 'from env'".write(to: envExec, atomically: true, encoding: .utf8)

                try FileManager.default.setAttributes([.posixPermissions: 0o755], ofItemAtPath: pathExec.path)
                try FileManager.default.setAttributes([.posixPermissions: 0o755], ofItemAtPath: envExec.path)

                let environment = [
                    "PATH": tempDir1.path,
                    "JAVASCRIPTKIT_TESTEXEC_EXEC": envExec.path,
                ]

                let result = try #require(which("testexec", environment: environment))

                // Should prefer environment variable over PATH
                #expect(result.path == envExec.path)
            }
        }
    }

    // MARK: - Error Handling Tests

    @Test func whichThrowsWhenExecutableNotFound() throws {
        let environment = ["PATH": "/nonexistent\(Self.pathSeparator)/also/nonexistent"]

        #expect(which("nonexistent_executable_12345", environment: environment) == nil)
    }

    @Test func whichThrowsWhenEnvironmentPathIsInvalid() throws {
        try withTemporaryDirectory { tempDir, _ in
            let nonExecFile = tempDir.appendingPathComponent("notexecutable")
            try "not executable".write(to: nonExecFile, atomically: true, encoding: .utf8)

            let environment = [
                "PATH": tempDir.path,
                "JAVASCRIPTKIT_NOTEXECUTABLE_EXEC": nonExecFile.path,
            ]

            #expect(which("notexecutable", environment: environment) == nil)
        }
    }

    @Test func whichThrowsWhenPathPointsToDirectory() throws {
        try withTemporaryDirectory { tempDir, _ in
            let environment = [
                "PATH": "/nonexistent/path",
                "JAVASCRIPTKIT_TESTEXEC_EXEC": tempDir.path,
            ]

            #expect(which("testexec", environment: environment) == nil)
        }
    }

    // MARK: - Edge Case Tests

    @Test func whichHandlesEmptyPath() throws {
        let environment = ["PATH": ""]

        #expect(which("anyexec", environment: environment) == nil)
    }

    @Test func whichHandlesMissingPathEnvironment() throws {
        let environment: [String: String] = [:]

        #expect(which("anyexec", environment: environment) == nil)
    }

    @Test func whichIgnoresNonExecutableFiles() throws {
        try withTemporaryDirectory { tempDir, _ in
            let nonExecFile = tempDir.appendingPathComponent("testfile")
            try "content".write(to: nonExecFile, atomically: true, encoding: .utf8)
            // Don't set executable permissions

            let environment = ["PATH": tempDir.path]

            #expect(which("testfile", environment: environment) == nil)
        }
    }
}
