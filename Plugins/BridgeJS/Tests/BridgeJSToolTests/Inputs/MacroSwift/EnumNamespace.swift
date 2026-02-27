// Empty enums to act as namespace wrappers for nested elements

@JS enum Utils {
    @JS class Converter {
        @JS var precision: Int

        @JS init() {
            self.precision = 2
        }

        @JS func toString(value: Int) -> String {
            return String(value)
        }
    }
}

@JS enum Networking {
    @JS enum API {
        @JS enum Method {
            case get
            case post
            case put
            case delete
        }
        // Invalid to declare @JS(namespace) here as it would be conflicting with nesting
        @JS class HTTPServer {
            @JS init() {}
            @JS func call(_ method: Method) {}
        }
    }
}

@JS enum Configuration {
    @JS enum LogLevel: String {
        case debug = "debug"
        case info = "info"
        case warning = "warning"
        case error = "error"
    }

    @JS enum Port: Int {
        case http = 80
        case https = 443
        case development = 3000
    }
}

@JS(namespace: "Networking.APIV2")
enum Internal {
    @JS enum SupportedMethod {
        case get
        case post
    }
    @JS class TestServer {
        @JS init() {}
        @JS func call(_ method: SupportedMethod) {}
    }
}

@JS(namespace: "Services.Graph")
enum GraphOperations {
    @JS static func createGraph(rootId: Int) -> Int {
        return rootId * 10
    }

    @JS static func nodeCount(graphId: Int) -> Int {
        return graphId
    }

    @JS static func validate(graphId: Int) throws(JSException) -> Bool {
        return graphId > 0
    }
}
