@JS func roundTripJSValue(_ value: JSValue) -> JSValue {
    return value
}

@JS func roundTripOptionalJSValue(_ value: JSValue?) -> JSValue? {
    return value
}

@JS func roundTripJSValueArray(_ values: [JSValue]) -> [JSValue] {
    return values
}

@JS func roundTripOptionalJSValueArray(_ values: [JSValue]?) -> [JSValue]? {
    return values
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
@JSFunction func jsEchoJSValueArray(_ values: [JSValue]) throws(JSException) -> [JSValue]
