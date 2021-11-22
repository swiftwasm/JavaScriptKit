const path = require("path");
const outputPath = path.resolve(__dirname, "dist");

module.exports = {
    entry: "./src/index.js",
    mode: "development",
    output: {
        filename: "main.js",
        path: outputPath,
    },
    devServer: {
        static: [
            {
                directory: path.join(__dirname, "public"),
                watch: true,
            },
            {
                directory: path.join(__dirname, "dist"),
                watch: true,
            },
        ],
    },
};
