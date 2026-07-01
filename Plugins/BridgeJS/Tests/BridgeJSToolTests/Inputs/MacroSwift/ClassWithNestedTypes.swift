@JS class Account {
    @JS enum Role: String {
        case admin
        case guest
    }

    @JS struct Credentials {
        var token: String

        @JS init(token: String) {
            self.token = token
        }

        @JS static var maxLength: Int { 64 }

        @JS static func empty() -> Credentials {
            Credentials(token: "")
        }
    }

    @JS var name: String

    @JS var role: Role { .admin }

    @JS static var defaultRole: Role { .guest }

    @JS init(name: String) {
        self.name = name
    }

    @JS func describe() -> String {
        name
    }
}
