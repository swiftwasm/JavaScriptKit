import { init } from "./.build/plugins/PackageToJS/outputs/Package/index.js";
const { exports } = await init({});

const velocity = exports.currentVelocity();

const output = document.createElement("pre");
output.innerText =
    `currentVelocity() = (${velocity.x}, ${velocity.y}, ${velocity.z})\n`
    + `magnitude = ${velocity.magnitude()}`;
document.body.appendChild(output);
