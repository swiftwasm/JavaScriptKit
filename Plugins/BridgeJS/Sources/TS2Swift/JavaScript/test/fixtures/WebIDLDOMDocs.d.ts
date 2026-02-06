/**
 * Minimal stubs to mirror lib.dom.d.ts documentation converted from WebIDL.
 */

interface Node {
    /** [MDN Reference](https://developer.mozilla.org/docs/Web/API/Node/textContent) */
    textContent: string | null;
    /**
     * Returns a copy of node. If deep is true, the copy also includes the node's descendants.
     *
     * [MDN Reference](https://developer.mozilla.org/docs/Web/API/Node/cloneNode)
     */
    cloneNode(subtree?: boolean): Node;
}

interface Element extends Node {}
type HTMLElement = Element;
type SVGElement = Element;
type MathMLElement = Element;
type DocumentFragment = Node;

interface ElementCreationOptions {
    is?: string;
}

/**
 * A simple Document subset with WebIDL-derived comments.
 */
interface Document {
    /**
     * Creates an instance of the element for the specified tag.
     * @param tagName The name of an element.
     *
     * [MDN Reference](https://developer.mozilla.org/docs/Web/API/Document/createElement)
     */
    createElement(tagName: string, options?: ElementCreationOptions): HTMLElement;

    /**
     * Returns an element with namespace namespace. Its namespace prefix will be everything before ":" (U+003E) in qualifiedName or null. Its local name will be everything after ":" (U+003E) in qualifiedName or qualifiedName.
     *
     * If localName does not match the Name production an "InvalidCharacterError" DOMException will be thrown.
     *
     * If one of the following conditions is true a "NamespaceError" DOMException will be thrown:
     *
     * localName does not match the QName production.
     * Namespace prefix is not null and namespace is the empty string.
     * Namespace prefix is "xml" and namespace is not the XML namespace.
     * qualifiedName or namespace prefix is "xmlns" and namespace is not the XMLNS namespace.
     * namespace is the XMLNS namespace and neither qualifiedName nor namespace prefix is "xmlns".
     *
     * When supplied, options's is can be used to create a customized built-in element.
     *
     * [MDN Reference](https://developer.mozilla.org/docs/Web/API/Document/createElementNS)
     */
    createElementNS(namespaceURI: string | null, qualifiedName: string, options?: string | ElementCreationOptions): Element;

    /**
     * Creates a TreeWalker object.
     * @param root The root element or node to start traversing on.
     * @param whatToShow The type of nodes or elements to appear in the node list
     * @param filter A custom NodeFilter function to use. For more information, see filter. Use null for no filter.
     * @returns The created TreeWalker.
     *
     * [MDN Reference](https://developer.mozilla.org/docs/Web/API/Document/createTreeWalker)
     */
    createTreeWalker(root: Node, whatToShow?: number, filter?: (node: Node) => number | null): TreeWalker;
}

interface TreeWalker {
    /** [MDN Reference](https://developer.mozilla.org/docs/Web/API/TreeWalker/currentNode) */
    currentNode: Node;
    /**
     * Moves the currentNode to the next visible node in the document order.
     *
     * [MDN Reference](https://developer.mozilla.org/docs/Web/API/TreeWalker/nextNode)
     */
    nextNode(): Node | null;
}

/** [MDN Reference](https://developer.mozilla.org/docs/Web/API/Document) */
export const document: Document;
