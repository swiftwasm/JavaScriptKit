@JS enum Theme: String {
    case light = "light"
    case dark = "dark"
    case auto = "auto"
}

@JS(enumStyle: .tsEnum) enum TSTheme: String {
    case light = "light"
    case dark = "dark"
    case auto = "auto"
}

@JS enum FeatureFlag: Bool {
    case enabled = true
    case disabled = false
}

@JS enum HttpStatus: Int {
    case ok = 200
    case notFound = 404
    case serverError = 500
}

@JS(enumStyle: .tsEnum) enum TSHttpStatus: Int {
    case ok = 200
    case notFound = 404
    case serverError = 500
}

@JS enum Priority: Int32 {
    case lowest = 1
    case low = 2
    case medium = 3
    case high = 4
    case highest = 5
}

@JS enum FileSize: Int64 {
    case tiny = 1024
    case small = 10240
    case medium = 102400
    case large = 1048576
}

@JS enum UserId: UInt {
    case guest = 0
    case user = 1000
    case admin = 9999
}

@JS enum TokenId: UInt32 {
    case invalid = 0
    case session = 12345
    case refresh = 67890
}

@JS enum SessionId: UInt64 {
    case none = 0
    case active = 9876543210
    case expired = 1234567890
}

@JS enum Precision: Float {
    case rough = 0.1
    case normal = 0.01
    case fine = 0.001
}

@JS enum Ratio: Double {
    case quarter = 0.25
    case half = 0.5
    case golden = 1.618
    case pi = 3.14159
}

@JS func setTheme(_ theme: Theme)
@JS func getTheme() -> Theme

@JS func setTSTheme(_ theme: TSTheme)
@JS func getTSTheme() -> TSTheme

@JS func setFeatureFlag(_ flag: FeatureFlag)
@JS func getFeatureFlag() -> FeatureFlag

@JS func setHttpStatus(_ status: HttpStatus)
@JS func getHttpStatus() -> HttpStatus

@JS func setTSHttpStatus(_ status: TSHttpStatus)
@JS func getTSHttpStatus() -> TSHttpStatus

@JS func setPriority(_ priority: Priority)
@JS func getPriority() -> Priority

@JS func setFileSize(_ size: FileSize)
@JS func getFileSize() -> FileSize

@JS func setUserId(_ id: UserId)
@JS func getUserId() -> UserId

@JS func setTokenId(_ token: TokenId)
@JS func getTokenId() -> TokenId

@JS func setSessionId(_ session: SessionId)
@JS func getSessionId() -> SessionId

@JS func setPrecision(_ precision: Precision)
@JS func getPrecision() -> Precision

@JS func setRatio(_ ratio: Ratio)
@JS func getRatio() -> Ratio

@JS func setFeatureFlag(_ featureFlag: FeatureFlag)
@JS func getFeatureFlag() -> FeatureFlag

@JS func processTheme(_ theme: Theme) -> HttpStatus
@JS func convertPriority(_ status: HttpStatus) -> Priority
@JS func validateSession(_ session: SessionId) -> Theme
