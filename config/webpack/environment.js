const {environment} = require('@rails/webpacker');
const typescript =  require('./loaders/typescript');
const webpack = require('webpack');

environment.loaders.prepend('typescript', typescript);

// Webpacker 5 fix for PDFJS
let nodeModules = environment.loaders.find(loader => loader.key === 'nodeModules');
nodeModules.value.exclude = new RegExp(nodeModules.value.exclude.source + "|pdf");

const customConfig = {
  resolve: {
    fallback: {
      dgram: false,
      fs: false,
      net: false,
      tls: false,
      child_process: false
    },
    extensions: ['.css']
  }
}

environment.config.delete('node.dgram');
environment.config.delete('node.fs');
environment.config.delete('node.net');
environment.config.delete('node.tls');
environment.config.delete('node.child_process');

environment.config.merge(customConfig);

new webpack.EnvironmentPlugin(['RAILS_ENV']);

module.exports = environment;
