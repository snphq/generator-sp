webpack = require 'webpack'

defaultPlugins = [
  require('postcss-import') {
    addDependencyTo: webpack
  }
  require('postcss-size')
  require('postcss-svgo')
  require('postcss-assets') {
    basePath: 'app/'
    loadPaths: ['images/']
  }
  (require 'postcss-bem') {
    style: 'suit',
    separators:
      namespace: '-'
      descendent: '--'
      modifier: '.__'
    shortcuts:
      component: 'b'
      descendent: 'e'
      modifier: 'm'
      utility: 'u'
  }
  require('postcss-cssnext')
]
config = ->
  defaults: [
    (require 'stylelint') { configFile: '.stylelintrc' }
    require('postcss-browser-reporter')
  ].concat defaultPlugins

  sass: defaultPlugins
module.exports = config
