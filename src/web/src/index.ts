interface ExportedMemory {
    buffer: any
}

type ref = number;
type pointer = number;

export class SwiftRuntime {
    private instance: WebAssembly.Instance | null;
    private _heapValues: any[]

    constructor() {
        this.instance = null;
        this._heapValues = [
            window,
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
        const textDecoder = new TextDecoder('utf-8');

        const readString = (ptr: pointer, len: number) => {
            const uint8Memory = new Uint8Array(memory().buffer);
            return textDecoder.decode(uint8Memory.subarray(ptr, ptr + len));
        }

        const readStringUntilNull = (ptr: pointer) => {
            const uint8Memory = new Uint8Array(memory().buffer);
            return textDecoder.decode(uint8Memory.slice(ptr));
        }

        const writeUint32 = (ptr: pointer, value: number) => {
            const uint8Memory = new Uint8Array(memory().buffer);
            uint8Memory[ptr + 0] = value & 0x000000ff
            uint8Memory[ptr + 1] = value & 0x0000ff00
            uint8Memory[ptr + 2] = value & 0x00ff0000
            uint8Memory[ptr + 3] = value & 0xff000000
        }

        const decodeValue = (kind: number, payload: number) => {
            switch (kind) {
                case 0: {
                    switch (payload) {
                        case 0: return false
                        case 1: return true
                    }
                }
                case 1: {
                    return readStringUntilNull(payload)
                }
            }
        }

        const encodeValue = (value: any) => {
            switch (typeof value) {
                case "boolean":
                    return {
                        kind: 0,
                        payload: value ? 1 : 0,
                    }
                default:
                    throw new Error(`Type "${typeof value}" is not supported yet`)
            }
        }

        return {
            swjs_set_js_value: (ref: ref, name: number, length: number, kind: number, payload: number) => {
                const obj = this._heapValues[ref];
                console.log(`obj = ${obj}, name = ${name}, length = ${length}, kind = ${kind}, value = ${payload}`)
                console.log(`name is decoded as "${readString(name, length)}"`)
                Reflect.set(obj, readString(name, length), decodeValue(kind, payload))
            },
            swjs_get_js_value: (ref: ref, name: number, length: number, kind_ptr: pointer, payload_ptr: pointer) => {
                const obj = this._heapValues[ref];
                const result = Reflect.get(obj, readString(name, length));
                const { kind, payload } = encodeValue(result);
                writeUint32(kind_ptr, kind);
                writeUint32(payload_ptr, payload);
            }
        }
    }
}