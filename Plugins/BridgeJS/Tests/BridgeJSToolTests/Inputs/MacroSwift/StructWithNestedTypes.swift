@JS struct Shape {
    @JS enum Kind: String {
        case circle
        case square
    }

    var label: String

    @JS init(label: String) {
        self.label = label
    }
}

@JS struct Widget {
    @JS enum Variant: String {
        case button
        case slider
    }

    @JS struct Layout {
        @JS enum Alignment: String {
            case leading
            case trailing
        }

        var padding: Int
    }

    @JS struct Bounds {
        var width: Int
        var height: Int

        @JS init(width: Int, height: Int) {
            self.width = width
            self.height = height
        }

        @JS static var dimensions: Int {
            2
        }

        @JS static func zero() -> Bounds {
            Bounds(width: 0, height: 0)
        }
    }

    var name: String

    @JS init(name: String) {
        self.name = name
    }
}
