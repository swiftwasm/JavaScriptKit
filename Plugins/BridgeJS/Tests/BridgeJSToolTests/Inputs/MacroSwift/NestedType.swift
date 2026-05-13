@JS class User {
    @JS func getName() -> String {
        return "test"
    }

    @JS struct Stats {
        var health: Int
        var score: Double
    }
}

@JS class Player {
    @JS func getTag() -> String {
        return "player"
    }

    @JS struct Stats {
        var level: Int
        var rating: String
    }
}
