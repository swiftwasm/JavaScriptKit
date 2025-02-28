import Foundation
import Testing

@testable import PackageToJS

@Suite struct MiniMakeTests {
    // Test basic task management functionality
    @Test func basicTaskManagement() throws {
        try withTemporaryDirectory { tempDir in
            var make = MiniMake(printProgress: { _, _, _, _ in })
            let outputPath = tempDir.appendingPathComponent("output.txt").path

            let task = make.addTask(output: outputPath) { task in
                try "Hello".write(toFile: task.output, atomically: true, encoding: .utf8)
            }

            try make.build(output: task)
            let content = try String(contentsOfFile: outputPath, encoding: .utf8)
            #expect(content == "Hello")
        }
    }

    // Test that task dependencies are handled correctly
    @Test func taskDependencies() throws {
        try withTemporaryDirectory { tempDir in
            var make = MiniMake(printProgress: { _, _, _, _ in })
            let input = tempDir.appendingPathComponent("input.txt").path
            let intermediate = tempDir.appendingPathComponent("intermediate.txt").path
            let output = tempDir.appendingPathComponent("output.txt").path

            try "Input".write(toFile: input, atomically: true, encoding: .utf8)

            let intermediateTask = make.addTask(inputFiles: [input], output: intermediate) { task in
                let content = try String(contentsOfFile: task.inputs[0], encoding: .utf8)
                try (content + " processed").write(
                    toFile: task.output, atomically: true, encoding: .utf8)
            }

            let finalTask = make.addTask(
                inputFiles: [intermediate], inputTasks: [intermediateTask], output: output
            ) { task in
                let content = try String(contentsOfFile: task.inputs[0], encoding: .utf8)
                try (content + " final").write(
                    toFile: task.output, atomically: true, encoding: .utf8)
            }

            try make.build(output: finalTask)
            let content = try String(contentsOfFile: output, encoding: .utf8)
            #expect(content == "Input processed final")
        }
    }

    // Test that phony tasks are always rebuilt
    @Test func phonyTask() throws {
        try withTemporaryDirectory { tempDir in
            var make = MiniMake(printProgress: { _, _, _, _ in })
            let outputPath = tempDir.appendingPathComponent("phony.txt").path
            try "Hello".write(toFile: outputPath, atomically: true, encoding: .utf8)
            var buildCount = 0

            let task = make.addTask(output: outputPath, attributes: [.phony]) { task in
                buildCount += 1
                try String(buildCount).write(toFile: task.output, atomically: true, encoding: .utf8)
            }

            try make.build(output: task)
            try make.build(output: task)

            #expect(buildCount == 2, "Phony task should always rebuild")
        }
    }

    // Test that the same build graph produces stable fingerprints
    @Test func fingerprintStability() throws {
        var make1 = MiniMake(printProgress: { _, _, _, _ in })
        var make2 = MiniMake(printProgress: { _, _, _, _ in })

        let output1 = "output1.txt"

        let task1 = make1.addTask(output: output1) { _ in }
        let task2 = make2.addTask(output: output1) { _ in }

        let fingerprint1 = try make1.computeFingerprint(root: task1)
        let fingerprint2 = try make2.computeFingerprint(root: task2)

        #expect(fingerprint1 == fingerprint2, "Same build graph should have same fingerprint")
    }

    // Test that rebuilds are controlled by timestamps
    @Test func timestampBasedRebuild() throws {
        try withTemporaryDirectory { tempDir in
            var make = MiniMake(printProgress: { _, _, _, _ in })
            let input = tempDir.appendingPathComponent("input.txt").path
            let output = tempDir.appendingPathComponent("output.txt").path
            var buildCount = 0

            try "Initial".write(toFile: input, atomically: true, encoding: .utf8)

            let task = make.addTask(inputFiles: [input], output: output) { task in
                buildCount += 1
                let content = try String(contentsOfFile: task.inputs[0], encoding: .utf8)
                try content.write(toFile: task.output, atomically: true, encoding: .utf8)
            }

            // First build
            try make.build(output: task)
            #expect(buildCount == 1, "First build should occur")

            // Second build without changes
            try make.build(output: task)
            #expect(buildCount == 1, "No rebuild should occur if input is not modified")

            // Modify input and rebuild
            try "Modified".write(toFile: input, atomically: true, encoding: .utf8)
            try make.build(output: task)
            #expect(buildCount == 2, "Should rebuild when input is modified")
        }
    }

    // Test that silent tasks execute without output
    @Test func silentTask() throws {
        try withTemporaryDirectory { tempDir in
            var messages: [(String, Int, Int, String)] = []
            var make = MiniMake(
                printProgress: { task, total, built, message in
                    messages.append((URL(fileURLWithPath: task.output).lastPathComponent, total, built, message))
                }
            )
            let silentOutputPath = tempDir.appendingPathComponent("silent.txt").path
            let silentTask = make.addTask(output: silentOutputPath, attributes: [.silent]) { task in
                try "Silent".write(toFile: task.output, atomically: true, encoding: .utf8)
            }
            let finalOutputPath = tempDir.appendingPathComponent("output.txt").path
            let task = make.addTask(
                inputTasks: [silentTask], output: finalOutputPath
            ) { task in
                try "Hello".write(toFile: task.output, atomically: true, encoding: .utf8)
            }

            try make.build(output: task)
            #expect(FileManager.default.fileExists(atPath: silentOutputPath), "Silent task should still create output file")
            #expect(FileManager.default.fileExists(atPath: finalOutputPath), "Final task should create output file")
            try #require(messages.count == 1, "Should print progress for the final task")
            #expect(messages[0] == ("output.txt", 1, 0, "\u{1B}[32mbuilding\u{1B}[0m"))
        }
    }

    // Test that error cases are handled appropriately
    @Test func errorWhileBuilding() throws {
        struct BuildError: Error {}
        try withTemporaryDirectory { tempDir in
            var make = MiniMake(printProgress: { _, _, _, _ in })
            let output = tempDir.appendingPathComponent("error.txt").path

            let task = make.addTask(output: output) { task in
                throw BuildError()
            }

            #expect(throws: BuildError.self) {
                try make.build(output: task)
            }
        }
    }

    // Test that cleanup functionality works correctly
    @Test func cleanup() throws {
        try withTemporaryDirectory { tempDir in
            var make = MiniMake(printProgress: { _, _, _, _ in })
            let outputs = [
                tempDir.appendingPathComponent("clean1.txt").path,
                tempDir.appendingPathComponent("clean2.txt").path,
            ]

            // Create tasks and build them
            let tasks = outputs.map { output in
                make.addTask(output: output) { task in
                    try "Content".write(toFile: task.output, atomically: true, encoding: .utf8)
                }
            }

            for task in tasks {
                try make.build(output: task)
            }

            // Verify files exist
            for output in outputs {
                #expect(
                    FileManager.default.fileExists(atPath: output),
                    "Output file should exist before cleanup")
            }

            // Clean everything
            make.cleanEverything()

            // Verify files are removed
            for output in outputs {
                #expect(
                    !FileManager.default.fileExists(atPath: output),
                    "Output file should not exist after cleanup")
            }
        }
    }
}
