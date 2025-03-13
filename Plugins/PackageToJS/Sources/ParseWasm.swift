/// Represents the type of value in WebAssembly
enum ValueType: String, Codable {
    case i32
    case i64
    case f32
    case f64
    case funcref
    case externref
    case v128
}

/// Represents a function type in WebAssembly
struct FunctionType: Codable {
    let parameters: [ValueType]
    let results: [ValueType]
}

/// Represents a table type in WebAssembly
struct TableType: Codable {
    let element: ElementType
    let minimum: UInt32
    let maximum: UInt32?
    
    enum ElementType: String, Codable {
        case funcref
        case externref
    }
}

/// Represents a memory type in WebAssembly
struct MemoryType: Codable {
    let minimum: UInt32
    let maximum: UInt32?
    let shared: Bool
    let index: IndexType
    
    enum IndexType: String, Codable {
        case i32
        case i64
    }
}

/// Represents a global type in WebAssembly
struct GlobalType: Codable {
    let value: ValueType
    let mutable: Bool
}

/// Represents an import entry in WebAssembly
struct ImportEntry: Codable {
    let module: String
    let name: String
    let kind: ImportKind
    
    enum ImportKind: Codable {
        case function(type: FunctionType)
        case table(type: TableType)
        case memory(type: MemoryType)
        case global(type: GlobalType)
    }
}

/// Parse state for WebAssembly parsing
private class ParseState {
    private let moduleBytes: [UInt8]
    private var offset: Int
    
    init(moduleBytes: [UInt8]) {
        self.moduleBytes = moduleBytes
        self.offset = 0
    }
    
    func hasMoreBytes() -> Bool {
        return offset < moduleBytes.count
    }
    
    func readByte() throws -> UInt8 {
        guard offset < moduleBytes.count else {
            throw ParseError.unexpectedEndOfData
        }
        let byte = moduleBytes[offset]
        offset += 1
        return byte
    }
    
    func skipBytes(_ count: Int) throws {
        guard offset + count <= moduleBytes.count else {
            throw ParseError.unexpectedEndOfData
        }
        offset += count
    }

    /// Read an unsigned LEB128 integer
    func readUnsignedLEB128() throws -> UInt32 {
        var result: UInt32 = 0
        var shift: UInt32 = 0
        var byte: UInt8
        
        repeat {
            byte = try readByte()
            result |= UInt32(byte & 0x7F) << shift
            shift += 7
            if shift > 32 {
                throw ParseError.integerOverflow
            }
        } while (byte & 0x80) != 0
        
        return result
    }
    
    func readName() throws -> String {
        let nameLength = try readUnsignedLEB128()
        guard offset + Int(nameLength) <= moduleBytes.count else {
            throw ParseError.unexpectedEndOfData
        }
        
        let nameBytes = moduleBytes[offset..<(offset + Int(nameLength))]
        guard let name = String(bytes: nameBytes, encoding: .utf8) else {
            throw ParseError.invalidUTF8
        }
        
        offset += Int(nameLength)
        return name
    }
    
    func assertBytes(_ expected: [UInt8]) throws {
        let baseOffset = offset
        let expectedLength = expected.count
        
        guard baseOffset + expectedLength <= moduleBytes.count else {
            throw ParseError.unexpectedEndOfData
        }
        
        for i in 0..<expectedLength {
            if moduleBytes[baseOffset + i] != expected[i] {
                throw ParseError.invalidMagicNumber
            }
        }
        
        offset += expectedLength
    }
}

enum ParseError: Error {
    case invalidBufferSource
    case unexpectedEndOfData
    case invalidMagicNumber
    case invalidVersion
    case unknownImportDescriptorType(UInt8)
    case unknownTableElementType(UInt8)
    case unknownValueType(UInt8)
    case invalidFunctionTypeForm(UInt8)
    case integerOverflow
    case invalidUTF8
}

/// Parse a WebAssembly module bytes and return the imports entries.
/// - Parameter moduleBytes: The WebAssembly module bytes
/// - Returns: Array of import entries
/// - Throws: ParseError if the module bytes are invalid
func parseImports(moduleBytes: [UInt8]) throws -> [ImportEntry] {
    let parseState = ParseState(moduleBytes: moduleBytes)
    try parseMagicNumber(parseState)
    try parseVersion(parseState)
    
    var types: [FunctionType] = []
    var imports: [ImportEntry] = []
    
    while parseState.hasMoreBytes() {
        let sectionId = try parseState.readByte()
        let sectionSize = try parseState.readUnsignedLEB128()
        
        switch sectionId {
        case 1: // Type section
            let typeCount = try parseState.readUnsignedLEB128()
            for _ in 0..<typeCount {
                types.append(try parseFunctionType(parseState))
            }
            
        case 2: // Import section
            let importCount = try parseState.readUnsignedLEB128()
            for _ in 0..<importCount {
                let module = try parseState.readName()
                let name = try parseState.readName()
                let type = try parseState.readByte()
                
                switch type {
                case 0x00: // Function
                    let index = try parseState.readUnsignedLEB128()
                    guard index < UInt32(types.count) else {
                        throw ParseError.unexpectedEndOfData
                    }
                    imports.append(ImportEntry(module: module, name: name, kind: .function(type: types[Int(index)])))
                    
                case 0x01: // Table
                    let tableType = try parseTableType(parseState)
                    imports.append(ImportEntry(module: module, name: name, kind: .table(type: tableType)))
                    
                case 0x02: // Memory
                    let limits = try parseLimits(parseState)
                    imports.append(ImportEntry(module: module, name: name, kind: .memory(type: limits)))
                    
                case 0x03: // Global
                    let globalType = try parseGlobalType(parseState)
                    imports.append(ImportEntry(module: module, name: name, kind: .global(type: globalType)))
                    
                default:
                    throw ParseError.unknownImportDescriptorType(type)
                }
            }
            // Skip the rest of the module
            return imports
            
        default: // Other sections
            try parseState.skipBytes(Int(sectionSize))
        }
    }
    
    return []
}

private func parseMagicNumber(_ parseState: ParseState) throws {
    let expected: [UInt8] = [0x00, 0x61, 0x73, 0x6D]
    try parseState.assertBytes(expected)
}

private func parseVersion(_ parseState: ParseState) throws {
    let expected: [UInt8] = [0x01, 0x00, 0x00, 0x00]
    try parseState.assertBytes(expected)
}

private func parseTableType(_ parseState: ParseState) throws -> TableType {
    let elementType = try parseState.readByte()
    
    let element: TableType.ElementType
    switch elementType {
    case 0x70:
        element = .funcref
    case 0x6F:
        element = .externref
    default:
        throw ParseError.unknownTableElementType(elementType)
    }
    
    let limits = try parseLimits(parseState)
    return TableType(element: element, minimum: limits.minimum, maximum: limits.maximum)
}

private func parseLimits(_ parseState: ParseState) throws -> MemoryType {
    let flags = try parseState.readByte()
    let minimum = try parseState.readUnsignedLEB128()
    let hasMaximum = (flags & 1) != 0
    let shared = (flags & 2) != 0
    let isMemory64 = (flags & 4) != 0
    let index: MemoryType.IndexType = isMemory64 ? .i64 : .i32
    
    if hasMaximum {
        let maximum = try parseState.readUnsignedLEB128()
        return MemoryType(minimum: minimum, maximum: maximum, shared: shared, index: index)
    } else {
        return MemoryType(minimum: minimum, maximum: nil, shared: shared, index: index)
    }
}

private func parseGlobalType(_ parseState: ParseState) throws -> GlobalType {
    let value = try parseValueType(parseState)
    let mutable = try parseState.readByte() == 1
    return GlobalType(value: value, mutable: mutable)
}

private func parseValueType(_ parseState: ParseState) throws -> ValueType {
    let type = try parseState.readByte()
    switch type {
    case 0x7F:
        return .i32
    case 0x7E:
        return .i64
    case 0x7D:
        return .f32
    case 0x7C:
        return .f64
    case 0x70:
        return .funcref
    case 0x6F:
        return .externref
    case 0x7B:
        return .v128
    default:
        throw ParseError.unknownValueType(type)
    }
}

private func parseFunctionType(_ parseState: ParseState) throws -> FunctionType {
    let form = try parseState.readByte()
    if form != 0x60 {
        throw ParseError.invalidFunctionTypeForm(form)
    }
    
    var parameters: [ValueType] = []
    let parameterCount = try parseState.readUnsignedLEB128()
    for _ in 0..<parameterCount {
        parameters.append(try parseValueType(parseState))
    }
    
    var results: [ValueType] = []
    let resultCount = try parseState.readUnsignedLEB128()
    for _ in 0..<resultCount {
        results.append(try parseValueType(parseState))
    }
    
    return FunctionType(parameters: parameters, results: results)
}
