//
//  CodingKey.swift
//  
//
//  Created by Alsey Coleman Miller on 5/30/20.
//

internal extension Sequence where Element == CodingKey {
    
    /// KVC path string for current coding path.
    var path: String {
        return reduce("", { $0 + "\($0.isEmpty ? "" : ".")" + $1.stringValue })
    }
}

internal extension CodingKey {
    
    static var sanitizedName: String {
        
        let rawName = String(reflecting: self)
        var elements = rawName.split(separator: ".")
        guard elements.count > 2
            else { return rawName }
        elements.removeFirst()
        // FIXME: Needs Foundation for String extensions
        //elements.removeAll { $0.contains("(unknown context") }
        return elements.reduce("", { $0 + ($0.isEmpty ? "" : ".") + $1 })
    }
}
