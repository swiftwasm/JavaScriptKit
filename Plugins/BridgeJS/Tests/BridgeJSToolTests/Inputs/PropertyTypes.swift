@JS class PropertyHolder {
    // Primitive properties
    @JS var intValue: Int
    @JS var floatValue: Float
    @JS var doubleValue: Double
    @JS var boolValue: Bool
    @JS var stringValue: String

    // Readonly primitive properties
    @JS let readonlyInt: Int = 42
    @JS let readonlyFloat: Float = 3.14
    @JS let readonlyDouble: Double = 2.718281828
    @JS let readonlyBool: Bool = true
    @JS let readonlyString: String = "constant"

    // JSObject property
    @JS var jsObject: JSObject

    // SwiftHeapObject property (will be set later)
    @JS var sibling: PropertyHolder

    // Lazy stored property - should this be supported or generate an error?
    @JS lazy var lazyValue: String = "computed lazily"

    // Computed property with getter only (readonly)
    @JS var computedReadonly: Int {
        return intValue * 2
    }

    // Computed property with getter and setter
    @JS var computedReadWrite: String {
        get {
            return "Value: \(intValue)"
        }
        set {
            // Parse the number from "Value: X" format
            if let range = newValue.range(of: "Value: "),
                let number = Int(String(newValue[range.upperBound...]))
            {
                intValue = number
            }
        }
    }

    // Property with property observers
    @JS var observedProperty: Int {
        willSet {
            print("Will set to \(newValue)")
        }
        didSet {
            print("Did set from \(oldValue)")
        }
    }

    @JS init(
        intValue: Int,
        floatValue: Float,
        doubleValue: Double,
        boolValue: Bool,
        stringValue: String,
        jsObject: JSObject
    ) {
        self.intValue = intValue
        self.floatValue = floatValue
        self.doubleValue = doubleValue
        self.boolValue = boolValue
        self.stringValue = stringValue
        self.jsObject = jsObject
        self.sibling = self
    }

    @JS func getAllValues() -> String {
        return "int:\(intValue),float:\(floatValue),double:\(doubleValue),bool:\(boolValue),string:\(stringValue)"
    }
}

@JS func createPropertyHolder(
    intValue: Int,
    floatValue: Float,
    doubleValue: Double,
    boolValue: Bool,
    stringValue: String,
    jsObject: JSObject
) -> PropertyHolder {
    return PropertyHolder(
        intValue: intValue,
        floatValue: floatValue,
        doubleValue: doubleValue,
        boolValue: boolValue,
        stringValue: stringValue,
        jsObject: jsObject
    )
}

@JS func testPropertyHolder(holder: PropertyHolder) -> String {
    return holder.getAllValues()
}
