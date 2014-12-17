gulp = require 'gulp'
PROP = require '../config'
helpers = require '../helpers'
$ = helpers.gulpLoad [
  "svg-sprites"
  "flatten"
]
libpath = require "path"

module.exports = ->
  gulp.src PROP.path.svg()
    .pipe $["svg-sprites"] {
      mode: "symbols"
      preview: false
    }
    .pipe $.flatten()
    .pipe gulp.dest PROP.path.svg("dest")
