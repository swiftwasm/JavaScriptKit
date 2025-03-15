import Foundation
import Testing

@testable import PackageToJS

@Suite struct MiniMakeTests {
    // Test basic task management functionality
    @Test func basicTaskManagement() throws {
        try withTemporaryDirectory { tempDir, _ in
            var make = MiniMake(printProgress: { _, _ in })
            let outDir = BuildPath(prefix: "OUTPUT")

            let task = make.addTask(output: outDir.appending(path: "output.txt")) {
                try "Hello".write(toFile: $1.resolve(path: $0.output).path, atomically: true, encoding: .utf8)
            }

            try make.build(output: task, scope: MiniMake.VariableScope(variables: [
                "OUTPUT": tempDir.path,
            ]))
            let content = try String(contentsOfFile: tempDir.appendingPathComponent("output.txt").path, encoding: .utf8)
            #expect(content == "Hello")
        }
    }

    // Test that task dependencies are handled correctly
    @Test func taskDependencies() throws {
        try withTemporaryDirectory { tempDir, _ in
            var make = MiniMake(printProgress: { _, _ in })
            let prefix = BuildPath(prefix: "PREFIX")
            let scope = MiniMake.VariableScope(variables: [
                "PREFIX": tempDir.path,
            ])
            let input = prefix.appending(path: "input.txt")
            let intermediate = prefix.appending(path: "intermediate.txt")
            let output = prefix.appending(path: "output.txt")

            try "Input".write(toFile: scope.resolve(path: input).path, atomically: true, encoding: .utf8)

            let intermediateTask = make.addTask(inputFiles: [input], output: intermediate) { task, outputURL in
                let content = try String(contentsOfFile: scope.resolve(path: task.inputs[0]).path, encoding: .utf8)
                try (content + " processed").write(
                    toFile: scope.resolve(path: task.output).path, atomically: true, encoding: .utf8)
            }

            let finalTask = make.addTask(
                inputFiles: [intermediate], inputTasks: [intermediateTask], output: output
            ) { task, scope in
                let content = try String(contentsOfFile: scope.resolve(path: task.inputs[0]).path, encoding: .utf8)
                try (content + " final").write(
                    toFile: scope.resolve(path: task.output).path, atomically: true, encoding: .utf8)
            }

            try make.build(output: finalTask, scope: scope)
            let content = try String(contentsOfFile: scope.resolve(path: output).path, encoding: .utf8)
            #expect(content == "Input processed final")
        }
    }

    // Test that phony tasks are always rebuilt
    @Test func phonyTask() throws {
        try withTemporaryDirectory { tempDir, _ in
            var make = MiniMake(printProgress: { _, _ in })
            let phonyName = "phony.txt"
            let outputPath = BuildPath(prefix: "OUTPUT").appending(path: phonyName)
            try "Hello".write(toFile: tempDir.appendingPathComponent(phonyName).path, atomically: true, encoding: .utf8)
            var buildCount = 0

            let task = make.addTask(output: outputPath, attributes: [.phony]) { task, scope in
                buildCount += 1
                try String(buildCount).write(toFile: scope.resolve(path: task.output).path, atomically: true, encoding: .utf8)
            }

            let scope = MiniMake.VariableScope(variables: [
                "OUTPUT": tempDir.path,
            ])
            try make.build(output: task, scope: scope)
            try make.build(output: task, scope: scope)

            #expect(buildCount == 2, "Phony task should always rebuild")
        }
    }

    // Test that the same build graph produces stable fingerprints
    @Test func fingerprintStability() throws {
        var make1 = MiniMake(printProgress: { _, _ in })
        var make2 = MiniMake(printProgress: { _, _ in })

        let output1 = BuildPath(prefix: "OUTPUT")

        let task1 = make1.addTask(output: output1) { _, _ in }
        let task2 = make2.addTask(output: output1) { _, _ in }

        let fingerprint1 = try make1.computeFingerprint(root: task1)
        let fingerprint2 = try make2.computeFingerprint(root: task2)

        #expect(fingerprint1 == fingerprint2, "Same build graph should have same fingerprint")
    }

    // Test that rebuilds are controlled by timestamps
    @Test func timestampBasedRebuild() throws {
        try withTemporaryDirectory { tempDir, _ in
            var make = MiniMake(printProgress: { _, _ in })
            let prefix = BuildPath(prefix: "PREFIX")
            let scope = MiniMake.VariableScope(variables: [
                "PREFIX": tempDir.path,
            ])
            let input = prefix.appending(path: "input.txt")
            let output = prefix.appending(path: "output.txt")
            var buildCount = 0

            try "Initial".write(toFile: scope.resolve(path: input).path, atomically: true, encoding: .utf8)

            let task = make.addTask(inputFiles: [input], output: output) { task, scope in
                buildCount += 1
                let content = try String(contentsOfFile: scope.resolve(path: task.inputs[0]).path, encoding: .utf8)
                try content.write(toFile: scope.resolve(path: task.output).path, atomically: true, encoding: .utf8)
            }

            // First build
            try make.build(output: task, scope: scope)
            #expect(buildCount == 1, "First build should occur")

            // Second build without changes
            try make.build(output: task, scope: scope)
            #expect(buildCount == 1, "No rebuild should occur if input is not modified")

            // Modify input and rebuild
            try "Modified".write(toFile: scope.resolve(path: input).path, atomically: true, encoding: .utf8)
            try make.build(output: task, scope: scope)
            #expect(buildCount == 2, "Should rebuild when input is modified")
        }
    }

    // Test that silent tasks execute without output
    @Test func silentTask() throws {
        try withTemporaryDirectory { tempDir, _ in
            var messages: [(String, Int, Int, String)] = []
            var make = MiniMake(
                printProgress: { ctx, message in
                    messages.append((ctx.subject.output.description, ctx.total, ctx.built, message))
                }
            )
            let prefix = BuildPath(prefix: "PREFIX")
            let scope = MiniMake.VariableScope(variables: [
                "PREFIX": tempDir.path,
            ])
            let silentOutputPath = prefix.appending(path: "silent.txt")
            let silentTask = make.addTask(output: silentOutputPath, attributes: [.silent]) { task, scope in
                try "Silent".write(toFile: scope.resolve(path: task.output).path, atomically: true, encoding: .utf8)
            }
            let finalOutputPath = prefix.appending(path: "output.txt")
            let task = make.addTask(
                inputTasks: [silentTask], output: finalOutputPath
            ) { task, scope in
                try "Hello".write(toFile: scope.resolve(path: task.output).path, atomically: true, encoding: .utf8)
            }

            try make.build(output: task, scope: scope)
            #expect(FileManager.default.fileExists(atPath: scope.resolve(path: silentOutputPath).path), "Silent task should still create output file")
            #expect(FileManager.default.fileExists(atPath: scope.resolve(path: finalOutputPath).path), "Final task should create output file")
            try #require(messages.count == 1, "Should print progress for the final task")
            #expect(messages[0] == ("$PREFIX/output.txt", 1, 0, "\u{1B}[32mbuilding\u{1B}[0m"))
        }
    }

    // Test that error cases are handled appropriately
    @Test func errorWhileBuilding() throws {
        struct BuildError: Error {}
        try withTemporaryDirectory { tempDir, _ in
            var make = MiniMake(printProgress: { _, _ in })
            let prefix = BuildPath(prefix: "PREFIX")
            let scope = MiniMake.VariableScope(variables: [
                "PREFIX": tempDir.path,
            ])
            let output = prefix.appending(path: "error.txt")

            let task = make.addTask(output: output) { task, scope in
                throw BuildError()
            }

            #expect(throws: BuildError.self) {
                try make.build(output: task, scope: scope)
            }
        }
    }

    // Test that cleanup functionality works correctly
    @Test func cleanup() throws {
        try withTemporaryDirectory { tempDir, _ in
            var make = MiniMake(printProgress: { _, _ in })
            let prefix = BuildPath(prefix: "PREFIX")
            let scope = MiniMake.VariableScope(variables: [
                "PREFIX": tempDir.path,
            ])
            let outputs = [
                prefix.appending(path: "clean1.txt"),
                prefix.appending(path: "clean2.txt"),
            ]

            // Create tasks and build them
            let tasks = outputs.map { output in
                make.addTask(output: output) { task, scope in
                    try "Content".write(toFile: scope.resolve(path: task.output).path, atomically: true, encoding: .utf8)
                }
            }

            for task in tasks {
                try make.build(output: task, scope: scope)
            }

            // Verify files exist
            for output in outputs {
                #expect(
                    FileManager.default.fileExists(atPath: scope.resolve(path: output).path),
                    "Output file should exist before cleanup")
            }

            // Clean everything
            make.cleanEverything(scope: scope)

            // Verify files are removed
            for output in outputs {
                #expect(
                    !FileManager.default.fileExists(atPath: scope.resolve(path: output).path),
                    "Output file should not exist after cleanup")
            }
        }
    }
}
