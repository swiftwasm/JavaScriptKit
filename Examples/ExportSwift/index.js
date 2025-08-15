import { init } from "./.build/plugins/PackageToJS/outputs/Package/index.js";
const { exports } = await init({});

const Greeter = exports.Greeter;
const greeter = Greeter.init("World");
const circle = exports.renderCircleSVG(100);

// Display the results
const textOutput = document.createElement("div");
textOutput.innerText = greeter.greet()
document.body.appendChild(textOutput);
const circleOutput = document.createElement("div");
circleOutput.innerHTML = circle;
document.body.appendChild(circleOutput);
