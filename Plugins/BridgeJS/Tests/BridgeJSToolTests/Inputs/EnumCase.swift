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
