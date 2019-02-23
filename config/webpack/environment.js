const {environment} = require('@rails/webpacker');
const coffee = require('./loaders/coffee')
const datatables = require('./loaders/datatables')

const webpack = require('webpack');
environment.plugins.append('Provide', new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: ['popper.js', 'default']
}));

environment.loaders.append('coffee', coffee);
environment.loaders.append('datatables', datatables)

module.exports = environment;