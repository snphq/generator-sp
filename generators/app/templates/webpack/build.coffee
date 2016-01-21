requireChild = require '../gulp/requireChild'
config = (require './config')()
webpack = requireChild 'webpack'
ModernizrWebpackPlugin = require 'modernizr-webpack-plugin'
PROP = require 'snp-gulp-tasks/lib/config'

module.exports = ->
  config.output.path = PROP.path.scripts('dest')
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
