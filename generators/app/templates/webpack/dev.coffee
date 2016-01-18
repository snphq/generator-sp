requireChild = require '../gulp/requireChild'
config = (require './config')()
webpack = requireChild 'webpack'

do ->
  config.devtool = 'eval'
  config.debug = true
  config.output.publicPath = 'http://localhost:8080/app/scripts/'
  config.entry.app.unshift 'webpack-dev-server/client?http://localhost:8080', 'webpack/hot/dev-server'
  config.watchOptions = timeout: 100
  config.plugins.push new webpack.HotModuleReplacementPlugin

module.exports = config
