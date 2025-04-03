import Foundation

struct MakeTemporaryDirectoryError: Error {
    let error: CInt
}

internal func withTemporaryDirectory<T>(body: (URL, _ retain: inout Bool) throws -> T) throws -> T {
    // Create a temporary directory using mkdtemp
    var template = FileManager.default.temporaryDirectory.appendingPathComponent("PackageToJSTests.XXXXXX").path
    return try template.withUTF8 { template in
        let copy = UnsafeMutableBufferPointer<CChar>.allocate(capacity: template.count + 1)
        template.copyBytes(to: copy)
        copy[template.count] = 0

        guard let result = mkdtemp(copy.baseAddress!) else {
            throw MakeTemporaryDirectoryError(error: errno)
        }
        let tempDir = URL(fileURLWithPath: String(cString: result))
        var retain = false
        defer {
            if !retain {
                try? FileManager.default.removeItem(at: tempDir)
            }
        }
        return try body(tempDir, &retain)
    }
}
