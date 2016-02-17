makeConfig = require './_config'
webpack = require 'webpack'
ModernizrWebpackPlugin = require 'modernizr-webpack-plugin'

module.exports = (opts = {})->
  config = makeConfig(opts)
  config.plugins = config.plugins.concat [
    new webpack.optimize.UglifyJsPlugin
      compress:
        dead_code: true
        drop_debugger: true
        unsafe: true
        evaluate: true
        unused: true
    new ModernizrWebpackPlugin(require './_modernizr')
  ]
  config
