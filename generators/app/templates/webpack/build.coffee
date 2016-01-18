requireChild = require '../gulp/requireChild'
config = (require './config')()
webpack = requireChild 'webpack'
PROP = require 'snp-gulp-tasks/lib/config'

do ->
  config.output.path = PROP.path.scripts('dest')
  config.plugins.concat [
    new webpack.optimize.UglifyJsPlugin
  ]

module.exports = config
