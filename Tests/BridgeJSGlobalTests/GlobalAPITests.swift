import XCTest
import JavaScriptKit

@_extern(wasm, module: "BridgeJSGlobalTests", name: "runJsWorksGlobal")
@_extern(c)
func runJsWorksGlobal() -> Void

// Minimal set of @JS declarations for testing globalThis access
// These are namespaced items that should be accessible via globalThis

@JS enum GlobalNetworking {
    @JS enum API {
        @JS enum CallMethod {
            case get
            case post
            case put
            case delete
        }
        @JS class TestHTTPServer {
            @JS init() {}
            @JS func call(_ method: CallMethod) {}
        }
    }
}

@JS enum GlobalConfiguration {
    @JS enum PublicLogLevel: String {
        case debug = "debug"
        case info = "info"
        case warning = "warning"
        case error = "error"
    }

    @JS enum AvailablePort: Int {
        case http = 80
        case https = 443
        case development = 3000
    }
}

@JS(namespace: "GlobalNetworking.APIV2")
enum Internal {
    @JS enum SupportedServerMethod {
        case get
        case post
    }
    @JS class TestInternalServer {
        @JS init() {}
        @JS func call(_ method: SupportedServerMethod) {}
    }
}

@JS enum GlobalStaticPropertyNamespace {
    @JS nonisolated(unsafe) static var namespaceProperty: String = "namespace"
    @JS static let namespaceConstant: String = "constant"

    @JS enum NestedProperties {
        @JS nonisolated(unsafe) static var nestedProperty: Int = 999
        @JS static let nestedConstant: String = "nested"
        @JS nonisolated(unsafe) static var nestedDouble: Double = 1.414
    }
}

@JS enum GlobalUtils {
    @JS class PublicConverter {
        @JS init() {}

        @JS func toString(value: Int) -> String {
            return String(value)
        }
    }
}

class GlobalAPITests: XCTestCase {
    func testGlobalAccess() {
        runJsWorksGlobal()
    }
}
