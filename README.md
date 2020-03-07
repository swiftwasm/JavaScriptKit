# JavaScriptKit

![Run unit tests](https://github.com/kateinoigakukun/JavaScriptKit/workflows/Run%20unit%20tests/badge.svg?branch=master)

Swift framework to interact with JavaScript through WebAssembly.

## Usage

This JavaScript code

```javascript
const alert = window.alert
const document = window.document

const divElement = document.createElement("div")
divElement.innerText = "Hello, world"
const body = document.body
body.appendChild(divElement)

alert("JavaScript is running on browser!")
```

Can be written in Swift using JavaScriptKit

```swift
import JavaScriptKit

let alert = JSObjectRef.global.alert.function!
let document = JSObjectRef.global.document.object!

let divElement = document.createElement!("div").object!
divElement.innerText = "Hello, world"
let body = document.body.object!
_ = body.appendChild!(divElement)

alert("Swift is running on browser!")
```


Please see [Example](https://github.com/kateinoigakukun/JavaScriptKit/tree/master/Example) directory for more information
