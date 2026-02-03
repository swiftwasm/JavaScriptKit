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
    var eventCount: Int { get throws(JSException) }
    var delegateName: String { get throws(JSException) }
    var optionalName: String? { get throws(JSException) }
    var optionalRawEnum: ExampleEnum? { get throws(JSException) }
    var rawStringEnum: ExampleEnum { get throws(JSException) }
    var result: Result { get throws(JSException) }
    var optionalResult: Result? { get throws(JSException) }
    var direction: Direction { get throws(JSException) }
    var directionOptional: Direction? { get throws(JSException) }
    var priority: Priority { get throws(JSException) }
    var priorityOptional: Priority? { get throws(JSException) }
    func setEventCount(_ value: Int) throws(JSException)
    func setOptionalName(_ value: String?) throws(JSException)
    func setOptionalRawEnum(_ value: ExampleEnum?) throws(JSException)
    func setRawStringEnum(_ value: ExampleEnum) throws(JSException)
    func setResult(_ value: Result) throws(JSException)
    func setOptionalResult(_ value: Result?) throws(JSException)
    func setDirection(_ value: Direction) throws(JSException)
    func setDirectionOptional(_ value: Direction?) throws(JSException)
    func setPriority(_ value: Priority) throws(JSException)
    func setPriorityOptional(_ value: Priority?) throws(JSException)
    func onSomethingHappened() throws(JSException)
    func onValueChanged(_ value: String) throws(JSException)
    func onCountUpdated(count: Int) throws(JSException) -> Bool
    func onLabelUpdated(_ prefix: String, _ suffix: String) throws(JSException)
    func isCountEven() throws(JSException) -> Bool
    func onHelperUpdated(_ helper: Helper) throws(JSException)
    func createHelper() throws(JSException) -> Helper
    func onOptionalHelperUpdated(_ helper: Helper?) throws(JSException)
    func createOptionalHelper() throws(JSException) -> Helper?
    func createEnum() throws(JSException) -> ExampleEnum
    func handleResult(_ result: Result) throws(JSException)
    func getResult() throws(JSException) -> Result
}

@JS class MyViewController {
    @JS
    var delegate: MyViewControllerDelegate

    @JS
    var secondDelegate: MyViewControllerDelegate?

    @JS init(delegate: MyViewControllerDelegate) {
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
}

// Protocol array support
@JS class DelegateManager {
    @JS
    var delegates: [MyViewControllerDelegate]

    @JS init(delegates: [MyViewControllerDelegate]) {
        self.delegates = delegates
    }

    @JS func notifyAll() {
        for delegate in delegates {
            delegate.onSomethingHappened()
        }
    }
}

@JS func processDelegates(_ delegates: [MyViewControllerDelegate]) -> [MyViewControllerDelegate]
