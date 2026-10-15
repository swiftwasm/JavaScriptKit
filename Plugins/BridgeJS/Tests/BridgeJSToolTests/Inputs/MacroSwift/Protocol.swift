import JavaScriptKit

@JS enum Direction {
    case north
    case south
    case east
    case west
}

@JS enum ExampleEnum: String {
    case test = "test"
    case test2 = "test2"
}

@JS enum Result {
    case success(String)
    case failure(Int)
}

@JS enum Priority: Int {
    case low = -1
    case medium = 0
    case high = 1
}

@JS class Helper {
    @JS var value: Int

    @JS init(value: Int) {
        self.value = value
    }

    @JS func increment() {
        value += 1
    }
}

@JS protocol MyViewControllerDelegate {
    var eventCount: Int { get set }
    var delegateName: String { get }
    var optionalName: String? { get set }
    var optionalRawEnum: ExampleEnum? { get set }
    var rawStringEnum: ExampleEnum { get set }
    var result: Result { get set }
    var optionalResult: Result? { get set }
    var direction: Direction { get set }
    var directionOptional: Direction? { get set }
    var priority: Priority { get set }
    var priorityOptional: Priority? { get set }
    func onSomethingHappened()
    func onValueChanged(_ value: String)
    func onCountUpdated(count: Int) -> Bool
    func onLabelUpdated(_ prefix: String, _ suffix: String)
    func isCountEven() -> Bool
    func onHelperUpdated(_ helper: Helper)
    func createHelper() -> Helper
    func onOptionalHelperUpdated(_ helper: Helper?)
    func createOptionalHelper() -> Helper?
    func createEnum() -> ExampleEnum
    func handleResult(_ result: Result)
    func getResult() -> Result
    func validate(_ value: Int) throws(JSException) -> Int
    func loadLabel(_ key: String) async throws(JSException) -> String
    func reset() async throws(JSException)
    func fetchCount() async -> Int
}

@JS class MyViewController {
    @JS
    var delegate: MyViewControllerDelegate

    @JS
    var secondDelegate: (any MyViewControllerDelegate)?

    @JS init(delegate: any MyViewControllerDelegate) {
        self.delegate = delegate
    }

    @JS func triggerEvent() {
        delegate.onSomethingHappened()
    }

    @JS func updateValue(_ value: String) {
        delegate.onValueChanged(value)
    }

    @JS func updateCount(_ count: Int) -> Bool {
        return delegate.onCountUpdated(count: count)
    }

    @JS func updateLabel(_ prefix: String, _ suffix: String) {
        delegate.onLabelUpdated(prefix, suffix)
    }

    @JS func checkEvenCount() -> Bool {
        return delegate.isCountEven()
    }

    @JS func sendHelper(_ helper: Helper) {
        delegate.onHelperUpdated(helper)
    }

    @JS func validateValue(_ value: Int) throws(JSException) -> Int {
        return try delegate.validate(value)
    }

    @JS func loadLabel(_ key: String) async throws(JSException) -> String {
        return try await delegate.loadLabel(key)
    }
}

// Protocol array support
@JS class DelegateManager {
    @JS
    var delegates: [MyViewControllerDelegate]

    @JS
    var delegatesByName: [String: any MyViewControllerDelegate]

    @JS init(delegates: [MyViewControllerDelegate]) {
        self.delegates = delegates
        self.delegatesByName = [:]
    }

    @JS func notifyAll() {
        for delegate in delegates {
            delegate.onSomethingHappened()
        }
    }
}

@JS func processDelegates(_ delegates: [any MyViewControllerDelegate]) -> [any MyViewControllerDelegate]

@JS func processDelegatesByName(
    _ delegates: [String: MyViewControllerDelegate]
) -> [String: MyViewControllerDelegate]
