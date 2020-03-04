interface ExportedMemory {
    buffer: any
}

type ref = number;
type pointer = number;

interface GlobalVariable { }
declare const window: GlobalVariable;
declare const global: GlobalVariable;


enum JavaScriptValueKind {
    Invalid = -1,
    Boolean = 0,
    String = 1,
    Number = 2,
    Object = 3,
    Null = 4,
    Undefined = 5,
    Function = 6,
}

export class SwiftRuntime {
    private instance: WebAssembly.Instance | null;
    private _heapValues: any[]

    constructor() {
        this.instance = null;
        let _global: any;
        if (typeof window !== "undefined") {
            _global = window
        } else if (typeof global !== "undefined") {
            _global = global
        }
        this._heapValues = [
            _global,
        ]
    }

    setInsance(instance: WebAssembly.Instance) {
        this.instance = instance
    }

    importObjects() {
        const memory = () => {
            if (this.instance)
                return this.instance.exports.memory as ExportedMemory;
            throw new Error("WebAssembly instance is not set yet");
        }

        const allocValue = (value: any) => {
            // TODO
            const id = this._heapValues.length
            this._heapValues.push(value)
            return id
        }

        const textDecoder = new TextDecoder('utf-8');
        const textEncoder = new TextEncoder(); // Only support utf-8

        const readString = (ptr: pointer, len: number) => {
            const uint8Memory = new Uint8Array(memory().buffer);
            return textDecoder.decode(uint8Memory.subarray(ptr, ptr + len));
        }

        const writeString = (ptr: pointer, value: string) => {
            const bytes = textEncoder.encode(value);
            const uint8Memory = new Uint8Array(memory().buffer);
            for (const [index, byte] of bytes.entries()) {
                uint8Memory[ptr + index] = byte
            }
            uint8Memory[ptr]
        }

        const writeUint32 = (ptr: pointer, value: number) => {
            const uint8Memory = new Uint8Array(memory().buffer);
            uint8Memory[ptr + 0] = (value & 0x000000ff) >> 0
            uint8Memory[ptr + 1] = (value & 0x0000ff00) >> 8
            uint8Memory[ptr + 2] = (value & 0x00ff0000) >> 16
            uint8Memory[ptr + 3] = (value & 0xff000000) >> 24
        }

        const decodeValue = (
            kind: JavaScriptValueKind,
            payload1: number, payload2: number
        ) => {
            switch (kind) {
                case JavaScriptValueKind.Boolean: {
                    switch (payload1) {
                        case 0: return false
                        case 1: return true
                    }
                }
                case JavaScriptValueKind.Number: {
                    return payload1
                }
                case JavaScriptValueKind.String: {
                    return readString(payload1, payload2)
                }
                case JavaScriptValueKind.Object: {
                    return this._heapValues[payload1]
                }
                case JavaScriptValueKind.Null: {
                    return null
                }
                case JavaScriptValueKind.Undefined: {
                    return undefined
                }
                case JavaScriptValueKind.Function: {
                    return this._heapValues[payload1]
                }
                default:
                    throw new Error(`Type kind "${kind}" is not supported`)
            }
        }

        const encodeValue = (value: any) => {
            if (value === null) {
                return {
                    kind: JavaScriptValueKind.Null,
                    payload1: 0,
                    payload2: 0,
                }
            }
            switch (typeof value) {
                case "boolean": {
                    return {
                        kind: JavaScriptValueKind.Boolean,
                        payload1: value ? 1 : 0,
                        payload2: 0,
                    }
                }
                case "number": {
                    return {
                        kind: JavaScriptValueKind.Number,
                        payload1: value,
                        payload2: 0,
                    }
                }
                case "string": {
                    return {
                        kind: JavaScriptValueKind.String,
                        payload1: allocValue(value),
                        payload2: value.length,
                    }
                }
                case "undefined": {
                    return {
                        kind: JavaScriptValueKind.Undefined,
                        payload1: 0,
                        payload2: 0,
                    }
                }
                case "object": {
                    return {
                        kind: JavaScriptValueKind.Object,
                        payload1: allocValue(value),
                        payload2: 0,
                    }
                }
                case "function": {
                    return {
                        kind: JavaScriptValueKind.Function,
                        payload1: allocValue(value),
                        payload2: 0,
                    }
                }
                default:
                    throw new Error(`Type "${typeof value}" is not supported yet`)
            }
        }

        return {
            swjs_set_prop: (
                ref: ref, name: pointer, length: number,
                kind: JavaScriptValueKind,
                payload1: number, payload2: number
            ) => {
                const obj = this._heapValues[ref];
                Reflect.set(obj, readString(name, length), decodeValue(kind, payload1, payload2))
            },
            swjs_get_prop: (
                ref: ref, name: pointer, length: number,
                kind_ptr: pointer,
                payload1_ptr: pointer, payload2_ptr: pointer
            ) => {
                const obj = this._heapValues[ref];
                const result = Reflect.get(obj, readString(name, length));
                const { kind, payload1, payload2 } = encodeValue(result);
                writeUint32(kind_ptr, kind);
                writeUint32(payload1_ptr, payload1);
                writeUint32(payload2_ptr, payload2);
            },
            swjs_set_subscript: (
                ref: ref, index: number,
                kind: JavaScriptValueKind,
                payload1: number, payload2: number
            ) => {
                const obj = this._heapValues[ref];
                Reflect.set(obj, index, decodeValue(kind, payload1, payload2))
            },
            swjs_get_subscript: (
                ref: ref, index: number,
                kind_ptr: pointer,
                payload1_ptr: pointer, payload2_ptr: pointer
            ) => {
                const obj = this._heapValues[ref];
                const result = Reflect.get(obj, index);
                const { kind, payload1, payload2 } = encodeValue(result);
                writeUint32(kind_ptr, kind);
                writeUint32(payload1_ptr, payload1);
                writeUint32(payload2_ptr, payload2);
            },
            swjs_load_string: (ref: ref, buffer: pointer) => {
                const string = this._heapValues[ref];
                writeString(buffer, string);
            }
        }
    }
}