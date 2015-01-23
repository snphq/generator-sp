_ = require 'lodash'
gulp = require "gulp"
through2 = require "through2"
helpers = require "../helpers"
notifier = require "node-notifier"
libpath = require "path"

$ = helpers.gulpLoad [
  'if'
  'coffee'
  'coffeelint'
  'filter'
  'plumber'
  'cached'
  'preprocess'
  'rename'
]

PROP = require "../config"

module.exports = ->
  filter_preprocess = $.filter "preprocess_template.js"
  filter_main_js = $.filter PROP.path.scripts("name")

  linter = []
  gulp.src PROP.path.scripts()
    .pipe $.if PROP.isNotify, $.plumber {errorHandler:helpers.errorHandler}
    .pipe $.coffeelint('.coffeelintrc')
    .pipe $.if PROP.isNotify, through2.obj ((file, enc, cb)->
      c = file.coffeelint
      if c.errorCount or c.warningCount
        linter.push [c, file.relative]
      @push file
      cb()
    ),(cb)->
      notifyString = ""
      linter.forEach ([c, name])->
        notifyString += _.map(c.results, (r)->
          "#{r.level} #{name}: #{r.lineNumber} - #{r.message}"
        ).join("\n")
      if notifyString
        notifier.notify
          title:    "Coffeelint message"
          subtitle: "See console to full information"
          message:  notifyString
          sound:    "Tink"
          icon: libpath.join(__dirname, "img", "coffee-error.jpg")
      linter = []
      cb()
    .pipe $.coffeelint.reporter()

    .pipe $.coffee(bare: true)
    .pipe $.cached("scripts")

    .pipe filter_preprocess
    .pipe $.preprocess PROP.preprocess()
    .pipe $.rename basename: "preprocess"
    .pipe filter_preprocess.restore(end:true)

    .pipe $.if !PROP.isDev, filter_main_js
    .pipe $.if !PROP.isDev, PROP.amd.optionsExtract
    .pipe $.if !PROP.isDev, filter_main_js.restore(end:true)

    .pipe gulp.dest PROP.path.scripts("dest")
