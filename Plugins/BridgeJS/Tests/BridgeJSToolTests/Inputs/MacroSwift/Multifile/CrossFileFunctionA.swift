@JS class FunctionA {
    @JS init() {}

    // Method that takes a cross-file type as parameter
    @JS func processB(b: FunctionB) -> String {
        return "Processed \(b.value)"
    }

    // Method that returns a cross-file type
    @JS func createB(value: String) -> FunctionB {
        return FunctionB(value: value)
    }
}

// Standalone function that uses cross-file types
@JS func standaloneFunction(b: FunctionB) -> FunctionB {
    return b
}
