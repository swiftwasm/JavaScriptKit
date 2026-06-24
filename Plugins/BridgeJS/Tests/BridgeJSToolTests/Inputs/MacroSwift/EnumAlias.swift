@JS(as: ColorBox.self) enum Color {
    case red, green, blue

    consuming func bridgeToJS() -> ColorBox {
        switch self {
        case .red: return ColorBox(name: "red")
        case .green: return ColorBox(name: "green")
        case .blue: return ColorBox(name: "blue")
        }
    }

    static func bridgeFromJS(_ value: consuming ColorBox) -> Color {
        switch value.name {
        case "green": return .green
        case "blue": return .blue
        default: return .red
        }
    }
}

@JS final class ColorBox {
    var name: String

    @JS init(name: String) {
        self.name = name
    }
}

@JS func roundtripColor(_ color: Color) -> Color
