gulp = require 'gulp'
libpath = require 'path'
through2 = require 'through2'
helpers = require '../helpers'

$ = helpers.gulpLoad [
  'if'
  'rev'
  'sourcemaps'
  'uglify'
]
PROP = require '../config'

module.exports = ->
  gulp.src PROP.path.scripts("extras_src")
    .pipe through2.obj (file, enc, callback)->
      file.base = libpath.resolve file.base, "../"
      @push file
      callback()
    .pipe $.if !PROP.isDev, $.rev.script()
    .pipe $.sourcemaps.init {loadMaps: true}
    .pipe $.if !PROP.isDev, $.uglify()
    .pipe $.sourcemaps.write(".")
    .pipe gulp.dest PROP.path.scripts("extras_dest")
