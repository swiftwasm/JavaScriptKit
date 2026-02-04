@JS func roundTripJSValue(_ value: JSValue) -> JSValue {
    return value
}

@JS func roundTripOptionalJSValue(_ value: JSValue?) -> JSValue? {
    return value
}

@JS class JSValueHolder {
    @JS var value: JSValue
    @JS var optionalValue: JSValue?

    @JS init(value: JSValue, optionalValue: JSValue?) {
        self.value = value
        self.optionalValue = optionalValue
    }

    @JS func update(value: JSValue, optionalValue: JSValue?) {
        self.value = value
        self.optionalValue = optionalValue
    }

    @JS func echo(value: JSValue) -> JSValue {
        return value
    }

    @JS func echoOptional(_ value: JSValue?) -> JSValue? {
        return value
    }
}

@JSFunction func jsEchoJSValue(_ value: JSValue) throws(JSException) -> JSValue
