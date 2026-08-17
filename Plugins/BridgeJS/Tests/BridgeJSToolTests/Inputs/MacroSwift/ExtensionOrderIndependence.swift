@JS class Depot {
    @JS init() {}
}

extension Depot.Crate {
    @JS func describeCrate() -> String {
        "Crate: " + label
    }
}

extension Depot {
    @JS struct Crate {
        var label: String

        @JS init(label: String) {
            self.label = label
        }
    }
}
