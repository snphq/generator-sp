gulp = require 'gulp'
PROP = require '../config'
open = require 'gulp-open'

module.exports = ->
  gulp.src PROP.path.index()
    .pipe open "", PROP.open()
