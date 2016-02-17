path = require 'path'

module.exports = config = {
  # All avaliable settings here:
  # https://github.com/Modernizr/Modernizr/blob/master/lib/config-all.json
  filename: 'frassets/modernizr.[hash].js',
  classPrefix: 'mzr-',
  options: [
    'setClasses',
  ],
  minify:
    output:
      comments: false
      beautify: false
  # 'feature-detects': [
    # 'audio',
    # 'css/animations',
    # 'history',
  # ]
}
