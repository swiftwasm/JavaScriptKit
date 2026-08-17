import JavaScriptKit

@JS class Library {
    @JS var name: String

    @JS init(name: String) {
        self.name = name
    }

    @JS func describe() -> String {
        name
    }
}

extension Library {
    typealias Title = String

    @JS enum Genre: String {
        case fiction
        case reference
    }

    @JS struct Shelf {
        var label: String

        @JS init(label: String) {
            self.label = label
        }

        @JS static var capacity: Int { 32 }
    }

    @JS func rename(_ title: Title) -> Title {
        title
    }

    @JS func shelf(label: String) -> Shelf {
        Shelf(label: label)
    }
}

extension Library.Shelf {
    @JS struct Divider {
        var slot: Int

        @JS init(slot: Int) {
            self.slot = slot
        }
    }

    @JS func describeShelf() -> String {
        "Shelf: " + label
    }
}

@JS enum Message {
    case update(Update)
    case delete
}

extension Message {
    @JS enum Update {
        case flip
        case rotate
    }
}

@JS func roundTripMessage(_ message: Message) -> Message {
    message
}
