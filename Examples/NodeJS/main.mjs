// @ts-check

import { instantiate } from "./.build/plugins/PackageToJS/outputs/Package/instantiate.js"
import { defaultNodeSetup } from "./.build/plugins/PackageToJS/outputs/Package/platforms/node.js"

async function main() {
    // Create a default Node.js option object
    const options = await defaultNodeSetup();
    // Instantiate the Swift code, executing
    // NodeJS.main() in NodeJS.swift
    await instantiate(options);

    // Call the greet function set by NodeJS.swift
    const greet = globalThis.greet;
    console.log(greet("World"));
}

main()
