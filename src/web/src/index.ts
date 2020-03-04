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
    Array = 4,
    Null = 5,
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

        const readStringUntilNull = (ptr: pointer) => {
            const uint8Memory = new Uint8Array(memory().buffer);
            return textDecoder.decode(uint8Memory.slice(ptr));
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
            uint8Memory[ptr + 0] = value & 0x000000ff
            uint8Memory[ptr + 1] = value & 0x0000ff00
            uint8Memory[ptr + 2] = value & 0x00ff0000
            uint8Memory[ptr + 3] = value & 0xff000000
        }

        const decodeValue = (kind: JavaScriptValueKind, payload: number) => {
            switch (kind) {
                case JavaScriptValueKind.Boolean: {
                    switch (payload) {
                        case 0: return false
                        case 1: return true
                    }
                }
                case JavaScriptValueKind.String: {
                    return readStringUntilNull(payload)
                }
                case JavaScriptValueKind.Object: {
                }
                default:
                    throw new Error(`Type kind "${kind}" is not supported`)
            }
        }

        const encodeValue = (value: any) => {
            switch (typeof value) {
                case "boolean":
                    return {
                        kind: 0,
                        payload: value ? 1 : 0,
                    }
                case "string": {
                    return {
                        kind: JavaScriptValueKind.String,
                        payload: allocValue(value),
                    }
                }
                default:
                    throw new Error(`Type "${typeof value}" is not supported yet`)
            }
        }

        return {
            swjs_set_js_value: (ref: ref, name: pointer, length: number, kind: JavaScriptValueKind, payload: number) => {
                const obj = this._heapValues[ref];
                Reflect.set(obj, readString(name, length), decodeValue(kind, payload))
            },
            swjs_get_js_value: (ref: ref, name: pointer, length: number, kind_ptr: pointer, payload_ptr: pointer) => {
                const obj = this._heapValues[ref];
                const result = Reflect.get(obj, readString(name, length));
                const { kind, payload } = encodeValue(result);
                writeUint32(kind_ptr, kind);
                writeUint32(payload_ptr, payload);
            },
            swjs_load_string: (ref: ref, buffer: pointer) => {
                const string = this._heapValues[ref];
                writeString(buffer, string);
            }
        }
    }
}