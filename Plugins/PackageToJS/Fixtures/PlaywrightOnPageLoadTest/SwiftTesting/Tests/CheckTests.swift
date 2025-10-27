import Testing
import JavaScriptKit
import JavaScriptEventLoop

@Test func expectToBeTrue() async throws {
    let expectToBeTrue = try #require(JSObject.global.expectToBeTrue.function)

    // expectToBeTrue returns a Promise, so we need to await it
    let promiseObject = try #require(expectToBeTrue.callAsFunction().object)
    let promise = try #require(JSPromise(promiseObject))

    let resultValue = try await promise.value
    #expect(resultValue.boolean == true)
}

@Test func getTitleOfPage() async throws {
    let getTitle = try #require(JSObject.global.getTitle.function)

    // getTitle returns a Promise, so we need to await it
    let promiseObject = try #require(getTitle.callAsFunction().object)
    let promise = try #require(JSPromise(promiseObject))

    let resultValue = try await promise.value
    #expect(resultValue.string == "")
}
