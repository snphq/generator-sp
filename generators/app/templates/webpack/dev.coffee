webpack = require 'webpack'
ModernizrWebpackPlugin = require 'modernizr-webpack-plugin'
_ = require 'lodash'
path = require 'path'
makeConfig = require './_config'

ALLOWED_MODES = {
  DEBUG: true
  DIST: true
  PROD: true
}

BUILD_MODE = process.env.MODE or 'DEBUG'

unless ALLOWED_MODES[BUILD_MODE]
  console.log "Build mode has wrong value. MODE=#{BUILD_MODE}"
  process.abort()

config = makeConfig {
  BUILD_MODE
  IS_DEV: true
}

config.output = {
  path: path.join(__dirname, '../app/'),
  filename: 'frassets/[name].bundle.js',
  chunkFilename: 'frassets/[id].bundle.js',
}

module.exports = (opts = {})->
  opts.test ?= false
  config.devtool = 'eval'
  config.debug = true
  config.output.publicPath = 'http://localhost:9000/'
  config.entry.app.unshift 'webpack-dev-server/client?http://localhost:9000', 'webpack/hot/dev-server'
  config.watchOptions = timeout: 100
  config.plugins.push new webpack.HotModuleReplacementPlugin
  config.plugins.push (new ModernizrWebpackPlugin require './_modernizr') unless opts.test
  config

