requireChild = require '../gulp/requireChild'
config = (require './config')()
webpack = requireChild 'webpack'
ModernizrWebpackPlugin = require 'modernizr-webpack-plugin'
_ = require 'lodash'

module.exports = (opts = {})->
  opts.test ?= false
  config.devtool = 'eval'
  config.debug = true
  config.output.publicPath = 'http://localhost:8080/app/scripts/'
  config.entry.app.unshift 'webpack-dev-server/client?http://localhost:8080', 'webpack/hot/dev-server'
  config.watchOptions = timeout: 100
  config.plugins.push new webpack.HotModuleReplacementPlugin
  config.plugins.push (new ModernizrWebpackPlugin require './_modernizr') unless opts.test
  config

