gulp = require 'gulp'
zopfli = require 'gulp-zopfli'
PROP = require '../config'
libpath = require 'path'

module.exports = ->
  gulp.src libpath.join PROP.path.build(), "**", "*.{html,js,css}"
    .pipe zopfli()
    .pipe gulp.dest PROP.path.build()
