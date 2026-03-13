import JavaScriptKit

@JS public func roundTripInt8(_ v: Int8) -> Int8 { v }
@JS public func roundTripUInt8(_ v: UInt8) -> UInt8 { v }
@JS public func roundTripInt16(_ v: Int16) -> Int16 { v }
@JS public func roundTripUInt16(_ v: UInt16) -> UInt16 { v }
@JS public func roundTripInt32(_ v: Int32) -> Int32 { v }
@JS public func roundTripUInt32(_ v: UInt32) -> UInt32 { v }
@JS public func roundTripInt64(_ v: Int64) -> Int64 { v }
@JS public func roundTripUInt64(_ v: UInt64) -> UInt64 { v }

@JSFunction func roundTripInt8(_ v: Int8) throws(JSException) -> Int8
@JSFunction func roundTripUInt8(_ v: UInt8) throws(JSException) -> UInt8
@JSFunction func roundTripInt16(_ v: Int16) throws(JSException) -> Int16
@JSFunction func roundTripUInt16(_ v: UInt16) throws(JSException) -> UInt16
@JSFunction func roundTripInt32(_ v: Int32) throws(JSException) -> Int32
@JSFunction func roundTripUInt32(_ v: UInt32) throws(JSException) -> UInt32
@JSFunction func roundTripInt64(_ v: Int64) throws(JSException) -> Int64
@JSFunction func roundTripUInt64(_ v: UInt64) throws(JSException) -> UInt64
