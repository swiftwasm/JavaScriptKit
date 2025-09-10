@JS enum Direction {
    case north
    case south
    case east
    case west
}

@JS enum Status {
    case loading
    case success
    case error
}

@JS func setDirection(_ direction: Direction)
@JS func getDirection() -> Direction
@JS func processDirection(_ input: Direction) -> Status
@JS func roundTripOptionalDirection(_ input: Direction?) -> Direction?

@JS(enumStyle: .tsEnum) enum TSDirection {
    case north
    case south
    case east
    case west
}

@JS func setTSDirection(_ direction: TSDirection)
@JS func getTSDirection() -> TSDirection
@JS func roundTripOptionalTSDirection(_ input: TSDirection?) -> TSDirection?

@JS public enum PublicStatus {
    case success
}
