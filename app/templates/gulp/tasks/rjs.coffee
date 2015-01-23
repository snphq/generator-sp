_ = require 'lodash'
gulp = require 'gulp'
gutil = require 'gulp-util'
libpath = require 'path'
async = require 'async'
through2 = require 'through2'
requirejs = require "requirejs"
del = require 'del'
fs = require "fs"

helpers = require '../helpers'
$ = helpers.gulpLoad [
  'if'
  'rev'
  'sourcemaps'
  'uglify'
]

PROP = require '../config'

module.exports = ->
  gulp.src PROP.path.scripts("dest")
    .pipe through2.obj ((file, enc, callback)->
      callback()
    ), ((finish)->
      _this = this
      contents = null
      amdOptions = PROP.amd.options()
      async.series [
        (cb)-> requirejs.optimize amdOptions, -> cb()
        (cb)-> del amdOptions.baseUrl, cb
        (cb)-> fs.readFile amdOptions.out, (err, data)->
          unless err
            file = new gutil.File {
              cwd: libpath.resolve "."
              base: libpath.resolve ".", PROP.path.scripts("main_base")
              path: libpath.resolve ".", PROP.path.scripts("main_path")
              contents: data
            }
            _this.push file
          cb err
        (cb)-> del PROP.path.scripts(".dest"), cb
      ], finish
    )
    .pipe $.if !PROP.isDev, $.rev.script()
    .pipe $.sourcemaps.init()
    .pipe $.if !PROP.isDev, $.uglify("main.js", {outSourceMap: true})
    .pipe $.sourcemaps.write(".")
    .pipe gulp.dest PROP.path.scripts("dest")
