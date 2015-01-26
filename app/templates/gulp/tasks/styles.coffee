gulp = require 'gulp'
through2 = require 'through2'

helpers = require "../helpers"
$ = helpers.gulpLoad [
  'if'
  'filter'
  'plumber'
  'sass'
  'rev'
  'resource'
  'sourcemaps'
  'postcss'
  'concat'
  'cached'
]

PROP = require "../config"

module.exports = ->
  filter_vendor = $.filter "vendor.css"
  filter_main = $.filter "main.css"
  filter_scss = $.filter "*.sass"
  mqpacker = require "css-mqpacker"
  csswring = require "csswring"
  autoprefixer = require "autoprefixer-core"
  postcssUrl = require "postcss-url"
  ORDER = []
  postprocessors = [
    autoprefixer browsers:[
      "last 222 version"
      "ie >= 8"
      "ff >= 17"
      "opera >=10"
    ]
  ]
  unless PROP.isDev
    postprocessors = postprocessors.concat [
      mqpacker
      csswring
      postcssUrl({
        url: "inline"
        maxSize: 12
        #basePath: "app/styles"
      })
    ]

  gulp.src PROP.path.styles()
    .pipe $.if PROP.isNotify, $.plumber {errorHandler: helpers.errorHandler}
    .pipe filter_scss
    .pipe $.sass includePaths: [PROP.path.styles("path")]
    .pipe filter_scss.restore()
    .pipe filter_vendor
    .pipe $.cached("resources")
    .pipe $.resource("resources")
    .pipe filter_vendor.restore end:true
    .pipe $.sourcemaps.init()
    .pipe $.postcss postprocessors
    .pipe through2.obj ((file, enc, cb)->
      ORDER.push file
      cb()
    ), (cb)->
      mainFile = null
      ORDER.forEach (file)=>
        if /main\.css$/.test file.path then mainFile = file
        else @push file
      @push mainFile if mainFile?
      cb()

    .pipe filter_main
    .pipe $.if !PROP.isDev, $.rev.css PROP.path.styles("dest")
    .pipe filter_main.restore(end:true)
    .pipe $.concat("main.css")
    .pipe $.if !PROP.isDev, $.rev.cssrev()
    .pipe $.sourcemaps.write(".")
    .pipe gulp.dest PROP.path.styles("dest")
    .pipe $.resource.download()
    .pipe gulp.dest PROP.path.build()
