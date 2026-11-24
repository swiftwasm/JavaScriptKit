// @ts-check

/**
 * @returns {import('../../../.build/plugins/PackageToJS/outputs/PackageTests/bridge-js.d.ts').Imports["SpanParameterImports"]}
 */
export function getImports(importsContext) {
    return {
        jsSum: (bytes) => bytes.reduce((sum, byte) => sum + byte, 0),
        jsLength: (bytes) => bytes.length,
        jsByteOffset: (bytes) => bytes.byteOffset,
        jsViewKind: (bytes) => {
            const buffer = importsContext.getInstance().exports.memory.buffer;
            if (bytes.buffer === buffer) return "view";
            if (buffer instanceof SharedArrayBuffer && !(bytes.buffer instanceof SharedArrayBuffer)) return "copy";
            return "unexpected";
        },
        jsFill: (bytes, value) => {
            bytes.fill(value);
        },
        jsFillThenThrow: (bytes, message) => {
            bytes.fill(1);
            throw new Error(message);
        },
        jsCopy: (source, destination) => {
            destination.set(source);
            return source.length;
        },
        jsFillWithLengthAndEcho: (bytes, value) => {
            bytes.fill(bytes.length);
            return value;
        },
    };
}

export class SpanHeaderStore {
    /** @param {Uint8Array} header */
    constructor(header) {
        this.header = header.slice();
    }
    /** @param {Uint8Array} bytes */
    sum(bytes) {
        return bytes.reduce((sum, byte) => sum + byte, 0);
    }
    /** @param {Uint8Array} bytes */
    readHeader(bytes) {
        bytes.set(this.header);
        return this.header.length;
    }
}
