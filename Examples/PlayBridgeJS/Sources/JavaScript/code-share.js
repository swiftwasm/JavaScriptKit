// @ts-check

export class CodeCompression {
    /**
     * Compresses a string using gzip compression and returns base64-encoded result.
     * @param {string} text - The text to compress
     * @returns {Promise<string>} Base64-encoded compressed string
     */
    static async compress(text) {
        const textEncoder = new TextEncoder();
        const stream = new CompressionStream('gzip');
        const writer = stream.writable.getWriter();
        const reader = stream.readable.getReader();

        // Start compression
        const writePromise = writer.write(textEncoder.encode(text)).then(() => writer.close());

        // Read compressed chunks
        const chunks = [];
        let readResult;
        do {
            readResult = await reader.read();
            if (readResult.value) {
                chunks.push(readResult.value);
            }
        } while (!readResult.done);

        await writePromise;

        // Combine all chunks into single Uint8Array
        const totalLength = chunks.reduce((sum, chunk) => sum + chunk.length, 0);
        const compressed = new Uint8Array(totalLength);
        let offset = 0;
        for (const chunk of chunks) {
            compressed.set(chunk, offset);
            offset += chunk.length;
        }

        // Convert to base64 for URL safety
        return this.uint8ArrayToBase64(compressed);
    }

    /**
     * Decompresses a base64-encoded gzip string back to original text.
     * @param {string} compressedBase64 - Base64-encoded compressed string
     * @returns {Promise<string>} Original decompressed text
     */
    static async decompress(compressedBase64) {
        const compressed = this.base64ToUint8Array(compressedBase64);
        const stream = new DecompressionStream('gzip');
        const writer = stream.writable.getWriter();
        const reader = stream.readable.getReader();

        // Start decompression
        const writePromise = writer.write(compressed).then(() => writer.close());

        // Read decompressed chunks
        const chunks = [];
        let readResult;
        do {
            readResult = await reader.read();
            if (readResult.value) {
                chunks.push(readResult.value);
            }
        } while (!readResult.done);

        await writePromise;

        // Combine chunks and decode
        const totalLength = chunks.reduce((sum, chunk) => sum + chunk.length, 0);
        const decompressed = new Uint8Array(totalLength);
        let offset = 0;
        for (const chunk of chunks) {
            decompressed.set(chunk, offset);
            offset += chunk.length;
        }

        const textDecoder = new TextDecoder();
        return textDecoder.decode(decompressed);
    }

    /**
     * Converts Uint8Array to base64 string.
     * @param {Uint8Array} uint8Array - Array to convert
     * @returns {string} Base64 string
     */
    static uint8ArrayToBase64(uint8Array) {
        let binary = '';
        for (let i = 0; i < uint8Array.byteLength; i++) {
            binary += String.fromCharCode(uint8Array[i]);
        }
        return btoa(binary);
    }

    /**
     * Converts base64 string to Uint8Array.
     * @param {string} base64 - Base64 string to convert
     * @returns {Uint8Array} Converted array
     */
    static base64ToUint8Array(base64) {
        const binary = atob(base64);
        const bytes = new Uint8Array(binary.length);
        for (let i = 0; i < binary.length; i++) {
            bytes[i] = binary.charCodeAt(i);
        }
        return bytes;
    }
}

/**
 * URL parameter manager for sharing code.
 * Handles compression, URL generation, and parameter extraction with encoding type versioning.
 */
export class CodeShareManager {
    /** @type {string} */
    static CURRENT_ENCODING = 'gzip-b64';

    /**
     * Available encoding types for future extensibility.
     * @type {Object<string, {compress: function, decompress: function}>}
     */
    static ENCODERS = {
        'gzip-b64': {
            compress: CodeCompression.compress.bind(CodeCompression),
            decompress: CodeCompression.decompress.bind(CodeCompression)
        }
    };

    /**
     * Generates a shareable URL with compressed code and encoding type.
     * @param {Object} code - Code object containing swift and dts properties
     * @param {string} code.swift - Swift code
     * @param {string} code.dts - TypeScript definition code
     * @returns {Promise<string>} Shareable URL
     */
    static async generateShareUrl(code) {
        const codeData = JSON.stringify(code);
        const encoder = this.ENCODERS[this.CURRENT_ENCODING];

        if (!encoder) {
            throw new Error(`Unsupported encoding type: ${this.CURRENT_ENCODING}`);
        }

        const compressed = await encoder.compress(codeData);

        const url = new URL(window.location.href);
        url.searchParams.set('code', compressed);
        url.searchParams.set('enc', this.CURRENT_ENCODING);

        return url.toString();
    }

    /**
     * Extracts code from URL parameters with encoding type detection.
     * @param {string} [url] - URL to extract from (defaults to current URL)
     * @returns {Promise<Object|null>} Code object or null if no code found
     */
    static async extractCodeFromUrl(url) {
        const urlObj = new URL(url || window.location.href);
        const compressedCode = urlObj.searchParams.get('code');
        const encodingType = urlObj.searchParams.get('enc') || this.CURRENT_ENCODING;

        if (!compressedCode) {
            return null;
        }

        const encoder = this.ENCODERS[encodingType];
        if (!encoder) {
            console.error(`Unsupported encoding type: ${encodingType}`);
            throw new Error(`Unsupported encoding type: ${encodingType}. Supported types: ${Object.keys(this.ENCODERS).join(', ')}`);
        }

        try {
            const decompressed = await encoder.decompress(compressedCode);
            return JSON.parse(decompressed);
        } catch (error) {
            console.error('Failed to extract code from URL:', error);
            throw new Error(`Failed to decode shared code (encoding: ${encodingType}): ${error.message}`);
        }
    }

    /**
     * Checks if current URL contains shared code.
     * @returns {boolean} True if URL contains code parameter
     */
    static hasSharedCode() {
        return new URL(window.location.href).searchParams.has('code');
    }
}