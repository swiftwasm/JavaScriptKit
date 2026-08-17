@JS enum Workshop {
    @JS class Bench {
        @JS init() {}
    }
}

@JS func makeBench() -> Workshop.Bench {
    Workshop.Bench()
}

@JS func refitBench(_ bench: Workshop.Bench, _ transform: (Workshop.Bench) -> Workshop.Bench) -> Workshop.Bench {
    transform(bench)
}
