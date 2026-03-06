extension Greeter {
    @JS func greetFormally() -> String {
        return "Good day, " + self.name + "."
    }
}
