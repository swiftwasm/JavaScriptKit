import JavaScriptKit

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
    func onSomethingHappened()
    func onValueChanged(_ value: String)
    func onCountUpdated(count: Int) -> Bool
    func onLabelUpdated(_ prefix: String, _ suffix: String)
    func isCountEven() -> Bool
    func onHelperUpdated(_ helper: Helper)
    func createHelper() -> Helper
    func onOptionalHelperUpdated(_ helper: Helper?)
    func createOptionalHelper() -> Helper?
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
