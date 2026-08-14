@JS(namespace: "app") enum Toolbox {
    @JS class Mallet {
        @JS init() {}
    }
}

extension Toolbox {
    @JS class Hammer {
        @JS init() {}
    }
}

@JS enum Signal: String {
    case ready
}

extension Signal {
    @JS struct Meta {
        var note: String

        @JS init(note: String) {
            self.note = note
        }
    }
}
