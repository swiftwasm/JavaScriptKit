# Exporting Swift Static Properties to JS

Learn how to export Swift static and class properties as JavaScript static properties using BridgeJS.

## Overview

> Tip: You can quickly preview what interfaces will be exposed on the Swift/TypeScript sides using the [BridgeJS Playground](https://swiftwasm.org/JavaScriptKit/PlayBridgeJS/).

BridgeJS supports exporting Swift `static var`, `static let`, and `class var` properties to JavaScript static properties. Both stored and computed properties are supported.

## Class Static Properties

Classes can export both stored and computed static properties:

```swift
@JS class Configuration {
    @JS init() {}
    
    @JS static let version = "1.0.0"
    @JS static var debugMode = false
    @JS class var defaultTimeout = 30
    
    @JS static var timestamp: Double {
        get { return Date().timeIntervalSince1970 }
        set { /* custom setter logic */ }
    }
    
    @JS static var buildNumber: Int {
        return 12345
    }
}
```

JavaScript usage:

```javascript
console.log(Configuration.version);      // "1.0.0"
console.log(Configuration.debugMode);    // false
console.log(Configuration.timestamp);    // current timestamp

Configuration.debugMode = true;
Configuration.timestamp = Date.now() / 1000;
```

Generated TypeScript definitions:

```typescript
export type Exports = {
    Configuration: {
        new(): Configuration;
        readonly version: string;
        debugMode: boolean;
        defaultTimeout: number;
        timestamp: number;
        readonly buildNumber: number;
    }
}

export interface Configuration extends SwiftHeapObject {
    // instance methods here
}
```

## Enum Static Properties

Enums can contain static properties that are exported alongside enum cases:

```swift
@JS enum NetworkStatus {
    case connected
    case disconnected
    case connecting
    
    @JS static var retryCount = 3
    @JS static let maxRetries = 10
}
```

Generated JavaScript:

```javascript
export const NetworkStatus = {
    Connected: 0,
    Disconnected: 1,
    Connecting: 2
};

// Properties added via Object.defineProperty
Object.defineProperty(NetworkStatus, 'retryCount', {
    get: function() { return wasmCall('bjs_NetworkStatus_static_retryCount_get'); },
    set: function(value) { wasmCall('bjs_NetworkStatus_static_retryCount_set', value); }
});

Object.defineProperty(NetworkStatus, 'maxRetries', {
    get: function() { return wasmCall('bjs_NetworkStatus_static_maxRetries_get'); }
});
```

JavaScript usage:

```javascript
console.log(NetworkStatus.retryCount);  // 3
console.log(NetworkStatus.maxRetries);  // 10
NetworkStatus.retryCount = 5;
```

Generated TypeScript definitions:

```typescript
export const NetworkStatus: {
    readonly Connected: 0;
    readonly Disconnected: 1;
    readonly Connecting: 2;
    retryCount: number;
    readonly maxRetries: number;
};
export type NetworkStatus = typeof NetworkStatus[keyof typeof NetworkStatus];
```

## Namespace Enum Static Properties

Namespace enums organize related static properties and are assigned to `globalThis`:

```swift
@JS enum Config {
    @JS enum API {
        @JS static var baseURL = "https://api.example.com"
        @JS static let version = "v1"
    }
}
```

Generated JavaScript:

```javascript
if (typeof globalThis.Config === 'undefined') {
    globalThis.Config = {};
}
if (typeof globalThis.Config.API === 'undefined') {
    globalThis.Config.API = {};
}

Object.defineProperty(globalThis.Config.API, 'baseURL', {
    get: function() { return wasmCall('bjs_Config_API_baseURL_get'); },
    set: function(value) { wasmCall('bjs_Config_API_baseURL_set', value); }
});

Object.defineProperty(globalThis.Config.API, 'version', {
    get: function() { return wasmCall('bjs_Config_API_version_get'); }
});
```

JavaScript usage:

```javascript
console.log(Config.API.baseURL);  // "https://api.example.com"
console.log(Config.API.version);  // "v1"

Config.API.baseURL = "https://staging.api.example.com";
```

Generated TypeScript definitions:

```typescript
declare global {
    namespace Config {
        namespace API {
            baseURL: string;
            readonly version: string;
        }
    }
}
```

## Supported Features

| Swift Static Property Feature | Status |
|:------------------------------|:-------|
| Class `static let` | ✅ |
| Class `static var` | ✅ |
| Class `class var` | ✅ |
| Enum static properties | ✅ |
| Namespace enum static properties | ✅ |
| Computed properties (get/set) | ✅ |
| Read-only computed properties | ✅ |
| All property types (primitives, objects, optionals) | ✅ |
| Property observers (`willSet`/`didSet`) | ❌ |
| Generic static properties | ❌ |
| Protocol static property requirements | ❌ |