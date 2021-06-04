process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const webpackConfig = require('./base')
webpackConfig.devServer = {
  host: 'localhost',
  port: 8080
}

module.exports = webpackConfig;
