path = require 'path'
PROP = require 'snp-gulp-tasks/lib/config'

config = {
  # All avaliable settings here:
  # https://github.com/Modernizr/Modernizr/blob/master/lib/config-all.json
  filename: 'modernizr.bundle.js',
  classPrefix: 'mzr-',
  options: [
    'setClasses',
  ],
  # 'feature-detects': [
    # 'audio',
    # 'css/animations',
    # 'history',
  # ]
}
if not PROP.isDev
  config.minify = {
    output: {
      comments: false
      beautify: false
    }
  }
module.exports = config
