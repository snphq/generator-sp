gulp = require 'gulp'
helpers = require '../helpers'
$ = helpers.gulpLoad [
  'if'
  'filter'
  'rev'
  'flatten'
]
PROP = require '../config'

module.exports = ->
  gulp.src PROP.path.fonts()
    .pipe $.filter PROP.path.fonts("pattern")
    .pipe $.if !PROP.isDev, $.rev.font()
    .pipe $.flatten()
    .pipe gulp.dest PROP.path.fonts("dest")
