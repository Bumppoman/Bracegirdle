const {environment} = require('@rails/webpacker');
const typescript =  require('./loaders/typescript');
const webpack = require('webpack');

environment.loaders.prepend('typescript', typescript);

/*environment.loaders.append("bootstrap.native", {
  test: /bootstrap\.native/,
  use: {
    loader: "bootstrap.native-loader",
    options: {
      only: ["alert", "button", "dropdown", "modal", "tab", "tooltip"],
      bsVersion: 4
    }
  }
});*/

environment.plugins.append('Provide', new webpack.ProvidePlugin({
    BSN: 'bootstrap.native'
}));

module.exports = environment;
