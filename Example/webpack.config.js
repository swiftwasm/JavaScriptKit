const path = require('path');
const outputPath = path.resolve(__dirname, 'dist');

module.exports = {
  entry: './src/index.js',
  mode: 'development',
  output: {
    filename: 'main.js',
    path: outputPath,
  },
  devServer: {
    inline: true,
    watchContentBase: true,
    contentBase: [
      path.join(__dirname, 'public'),
      path.join(__dirname, 'dist'),
    ],
  },
};
