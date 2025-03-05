import Foundation

/// A simple build system
struct MiniMake {
    /// Attributes of a task
    enum TaskAttribute {
        /// Task is phony, meaning it must be built even if its inputs are up to date
        case phony
        /// Don't print anything when building this task
        case silent
    }
    /// A task to build
    struct Task {
        /// Key of the task
        let key: TaskKey
        /// Display name of the task
        let displayName: String
        /// Input tasks not yet built
        var wants: Set<TaskKey>
        /// Set of files that must be built before this task
        let inputs: [String]
        /// Output task name
        let output: String
        /// Attributes of the task
        let attributes: Set<TaskAttribute>
        /// Build operation
        let build: (Task) throws -> Void
        /// Whether the task is done
        var isDone: Bool
    }

    /// A task key
    struct TaskKey: Hashable, Comparable, CustomStringConvertible {
        let id: String
        var description: String { self.id }

        fileprivate init(id: String) {
            self.id = id
        }

        static func < (lhs: TaskKey, rhs: TaskKey) -> Bool { lhs.id < rhs.id }
    }

    private var tasks: [TaskKey: Task]
    private var shouldExplain: Bool
    /// Current working directory at the time the build started
    private let buildCwd: String

    init(explain: Bool = false) {
        self.tasks = [:]
        self.shouldExplain = explain
        self.buildCwd = FileManager.default.currentDirectoryPath
    }

    mutating func addTask(inputFiles: [String] = [], inputTasks: [TaskKey] = [], output: String, attributes: Set<TaskAttribute> = [], build: @escaping (Task) throws -> Void) -> TaskKey {
        let displayName = output.hasPrefix(self.buildCwd) ? String(output.dropFirst(self.buildCwd.count + 1)) : output
        let taskKey = TaskKey(id: output)
        self.tasks[taskKey] = Task(key: taskKey, displayName: displayName, wants: Set(inputTasks), inputs: inputFiles, output: output, attributes: attributes, build: build, isDone: false)
        return taskKey
    }

    private func explain(_ message: @autoclosure () -> String) {
        if self.shouldExplain {
            print(message())
        }
    }

    private func violated(_ message: @autoclosure () -> String) {
        print(message())
    }

    /// Prints progress of the build
    struct ProgressPrinter {
        /// Total number of tasks to build
        let total: Int
        /// Number of tasks built so far
        var built: Int

        init(total: Int) {
            self.total = total
            self.built = 0
        }

        private static var green: String { "\u{001B}[32m" }
        private static var yellow: String { "\u{001B}[33m" }
        private static var reset: String { "\u{001B}[0m" }

        mutating func started(_ task: Task) {
            self.print(task, "\(Self.green)building\(Self.reset)")
        }

        mutating func skipped(_ task: Task) {
            self.print(task, "\(Self.yellow)skipped\(Self.reset)")
        }

        private mutating func print(_ task: Task, _ message: @autoclosure () -> String) {
            guard !task.attributes.contains(.silent) else { return }
            Swift.print("[\(self.built + 1)/\(self.total)] \(task.displayName): \(message())")
            self.built += 1
        }
    }

    private func computeTotalTasks(task: Task) -> Int {
        var visited = Set<TaskKey>()
        func visit(task: Task) -> Int {
            guard !visited.contains(task.key) else { return 0 }
            visited.insert(task.key)
            var total = task.attributes.contains(.silent) ? 0 : 1
            for want in task.wants {
                total += visit(task: self.tasks[want]!)
            }
            return total
        }
        return visit(task: task)
    }

    mutating func build(output: TaskKey) throws {
        /// Returns true if any of the task's inputs have a modification date later than the task's output
        func shouldBuild(task: Task) -> Bool {
            if task.attributes.contains(.phony) {
                return true
            }
            let outputURL = URL(fileURLWithPath: task.output)
            if !FileManager.default.fileExists(atPath: task.output) {
                explain("Task \(task.output) should be built because it doesn't exist")
                return true
            }
            let outputMtime = try? outputURL.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate
            return task.inputs.contains { input in
                let inputURL = URL(fileURLWithPath: input)
                // Ignore directory modification times
                var isDirectory: ObjCBool = false
                let fileExists = FileManager.default.fileExists(atPath: input, isDirectory: &isDirectory)
                if fileExists && isDirectory.boolValue {
                    return false
                }

                let inputMtime = try? inputURL.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate
                let shouldBuild = outputMtime == nil || inputMtime == nil || outputMtime! < inputMtime!
                if shouldBuild {
                    explain("Task \(task.output) should be re-built because \(input) is newer: \(outputMtime?.timeIntervalSince1970 ?? 0) < \(inputMtime?.timeIntervalSince1970 ?? 0)")
                }
                return shouldBuild
            }
        }
        var progressPrinter = ProgressPrinter(total: self.computeTotalTasks(task: self.tasks[output]!))

        func runTask(taskKey: TaskKey) throws {
            guard var task = self.tasks[taskKey] else {
                violated("Task \(taskKey) not found")
                return
            }
            guard !task.isDone else { return }

            // Build dependencies first
            for want in task.wants {
                try runTask(taskKey: want)
            }

            if shouldBuild(task: task) {
                progressPrinter.started(task)
                try task.build(task)
            } else {
                progressPrinter.skipped(task)
            }
            task.isDone = true
            self.tasks[taskKey] = task
        }
        try runTask(taskKey: output)
    }
}
