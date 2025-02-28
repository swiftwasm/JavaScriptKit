import Foundation

/// A minimal build system
///
/// This build system is a traditional mtime-based incremental build system.
struct MiniMake {
    /// Attributes of a task
    enum TaskAttribute: String, Codable {
        /// Task is phony, meaning it must be built even if its inputs are up to date
        case phony
        /// Don't print anything when building this task
        case silent
    }

    /// Information about a task enough to capture build
    /// graph changes
    struct TaskInfo: Codable {
        /// Input tasks not yet built
        let wants: [TaskKey]
        /// Set of files that must be built before this task
        let inputs: [String]
        /// Output task name
        let output: String
        /// Attributes of the task
        let attributes: [TaskAttribute]
        /// Salt for the task, used to differentiate between otherwise identical tasks
        var salt: Data?
    }

    /// A task to build
    struct Task {
        let info: TaskInfo
        /// Input tasks not yet built
        let wants: Set<TaskKey>
        /// Attributes of the task
        let attributes: Set<TaskAttribute>
        /// Display name of the task
        let displayName: String
        /// Key of the task
        let key: TaskKey
        /// Build operation
        let build: (Task) throws -> Void
        /// Whether the task is done
        var isDone: Bool

        var inputs: [String] { self.info.inputs }
        var output: String { self.info.output }
    }

    /// A task key
    struct TaskKey: Codable, Hashable, Comparable, CustomStringConvertible {
        let id: String
        var description: String { self.id }

        fileprivate init(id: String) {
            self.id = id
        }

        static func < (lhs: TaskKey, rhs: TaskKey) -> Bool { lhs.id < rhs.id }
    }

    /// All tasks in the build system
    private var tasks: [TaskKey: Task]
    /// Whether to explain why tasks are built
    private var shouldExplain: Bool
    /// Current working directory at the time the build started
    private let buildCwd: String
    /// Prints progress of the build
    private var printProgress: ProgressPrinter.PrintProgress

    init(
        explain: Bool = false,
        printProgress: @escaping ProgressPrinter.PrintProgress
    ) {
        self.tasks = [:]
        self.shouldExplain = explain
        self.buildCwd = FileManager.default.currentDirectoryPath
        self.printProgress = printProgress
    }

    /// Adds a task to the build system
    mutating func addTask(
        inputFiles: [String] = [], inputTasks: [TaskKey] = [], output: String,
        attributes: [TaskAttribute] = [], salt: (any Encodable)? = nil,
        build: @escaping (Task) throws -> Void
    ) -> TaskKey {
        let displayName =
            output.hasPrefix(self.buildCwd)
            ? String(output.dropFirst(self.buildCwd.count + 1)) : output
        let taskKey = TaskKey(id: output)
        let saltData = try! salt.map {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .sortedKeys
            return try encoder.encode($0)
        }
        let info = TaskInfo(
            wants: inputTasks, inputs: inputFiles, output: output, attributes: attributes,
            salt: saltData
        )
        self.tasks[taskKey] = Task(
            info: info, wants: Set(inputTasks), attributes: Set(attributes),
            displayName: displayName, key: taskKey, build: build, isDone: false)
        return taskKey
    }

    /// Computes a stable fingerprint of the build graph
    ///
    /// This fingerprint must be stable across builds and must change
    /// if the build graph changes in any way.
    func computeFingerprint(root: TaskKey) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let tasks = self.tasks.sorted { $0.key < $1.key }.map { $0.value.info }
        return try encoder.encode(tasks)
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
        typealias PrintProgress = (_ subject: Task, _ total: Int, _ built: Int, _ message: String) -> Void

        /// Total number of tasks to build
        let total: Int
        /// Number of tasks built so far
        var built: Int
        /// Prints progress of the build
        var printProgress: PrintProgress

        init(total: Int, printProgress: @escaping PrintProgress) {
            self.total = total
            self.built = 0
            self.printProgress = printProgress
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
            self.printProgress(task, self.total, self.built, message())
            self.built += 1
        }
    }

    /// Computes the total number of tasks to build used for progress display
    private func computeTotalTasksForDisplay(task: Task) -> Int {
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

    /// Cleans all outputs of all tasks
    func cleanEverything() {
        for task in self.tasks.values {
            try? FileManager.default.removeItem(atPath: task.output)
        }
    }

    /// Starts building
    func build(output: TaskKey) throws {
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
            let outputMtime = try? outputURL.resourceValues(forKeys: [.contentModificationDateKey])
                .contentModificationDate
            return task.inputs.contains { input in
                let inputURL = URL(fileURLWithPath: input)
                // Ignore directory modification times
                var isDirectory: ObjCBool = false
                let fileExists = FileManager.default.fileExists(
                    atPath: input, isDirectory: &isDirectory)
                if fileExists && isDirectory.boolValue {
                    return false
                }

                let inputMtime = try? inputURL.resourceValues(forKeys: [.contentModificationDateKey]
                ).contentModificationDate
                let shouldBuild =
                    outputMtime == nil || inputMtime == nil || outputMtime! < inputMtime!
                if shouldBuild {
                    explain(
                        "Task \(task.output) should be re-built because \(input) is newer: \(outputMtime?.timeIntervalSince1970 ?? 0) < \(inputMtime?.timeIntervalSince1970 ?? 0)"
                    )
                }
                return shouldBuild
            }
        }
        var progressPrinter = ProgressPrinter(
            total: self.computeTotalTasksForDisplay(task: self.tasks[output]!),
            printProgress: self.printProgress
        )
        // Make a copy of the tasks so we can mutate the state
        var tasks = self.tasks

        func runTask(taskKey: TaskKey) throws {
            guard var task = tasks[taskKey] else {
                violated("Task \(taskKey) not found")
                return
            }
            guard !task.isDone else { return }

            // Build dependencies first
            for want in task.wants.sorted() {
                try runTask(taskKey: want)
            }

            if shouldBuild(task: task) {
                progressPrinter.started(task)
                try task.build(task)
            } else {
                progressPrinter.skipped(task)
            }
            task.isDone = true
            tasks[taskKey] = task
        }
        try runTask(taskKey: output)
    }
}
