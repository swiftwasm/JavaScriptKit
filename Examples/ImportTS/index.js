import { init } from "./.build/plugins/PackageToJS/outputs/Package/index.js";
const { exports } = await init({
    getImports() {
        return {
            consoleLog: (message) => {
                console.log(message);
            },
            getDocument: () => {
                return document;
            },
        }
    }
});

exports.run()
