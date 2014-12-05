gulp = require 'gulp'
PROP = require '../config'
helpers = require '../helpers'
$ = helpers.gulpLoad [
  'if'
  'ignore'
  'jade'
  'plumber'
]

module.exports = ->
  condition = "**/_*.jade"
  gulp.src PROP.path.templates()
    .pipe $.if PROP.isNotify, $.plumber
      errorHandler: helpers.errorHandler
    .pipe $.ignore.exclude(condition)
    .pipe $.jade PROP.jade.options()
    .pipe gulp.dest PROP.path.templates("dest")
