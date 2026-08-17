@JS class Archive {
    @JS init() {}
}

extension Archive {
    @JS struct Record {
        var label: String

        @JS init(label: String) {
            self.label = label
        }
    }
}
