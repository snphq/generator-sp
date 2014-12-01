gulp = require "gulp"
gutil = require "gulp-util"
_ = require "lodash"
libpath = require "path"
through2 = require "through2"
fs = require "fs"
del = require "del"
vinylPaths = require "vinyl-paths"
requirejs = require "requirejs"
async = require "async"
notifier = require "node-notifier"

$ =
  coffee: require "gulp-coffee"
  jade: require "gulp-jade"
  ignore: require "gulp-ignore"
  sass: require "gulp-sass"
  sourcemaps: require "gulp-sourcemaps"
  postcss: require "gulp-postcss"
  watch: require "gulp-watch"
  gulpsync: require("gulp-sync")(gulp)
  preprocess: require "gulp-preprocess"
  rename: require "gulp-rename"
  open: require "gulp-open"
  imagepreload: require "gulp-image-preload"
  cached: require "gulp-cached"
  livereload: require "gulp-livereload"
  filter: require "gulp-filter"
  if: require "gulp-if"
  concat: require "gulp-concat"
  flatten: require "gulp-flatten"
  uglify: require "gulp-uglify"
  zopfli: require("gulp-zopfli")
  cssimage: require "gulp-css-image"
  notify: require "gulp-notify"
  plumber: require "gulp-plumber"
  rev: require "./plugins/rev"
  coffeelint: require "gulp-coffeelint"

PROP = require "./config"

errorHandler = (err)->
  $.notify.onError(
    title:    "Gulp"
    subtitle: "Failure!"
    message:  "Error: <%= error.message %>"
    sound:    "Beep"
  )(err)
  @emit "end"


gulp.task "clean", ->
  gulp.src PROP.path.clean(), {read: false}
    .pipe vinylPaths(del)

gulp.task "templates", ->
  condition = "**/_*.jade"

  jade_options =
    basedir: PROP.path.app
    pretty:true
    data: jade_mode: PROP.jade.mode()
    filters:{}

  unless PROP.isDev
    jade_options.parser = $.rev.jade_parser(
      PROP.path.app
      PROP.path.build()
    )

  gulp.src PROP.path.templates()
    .pipe $.if PROP.isNotify, $.plumber {errorHandler}
    .pipe $.ignore.exclude(condition)
    .pipe $.jade jade_options
    .pipe gulp.dest PROP.path.templates("dest")


amd_options =
  name: "main"
  baseUrl: PROP.path.scripts("dest")
  out: PROP.path.scripts("out")
  preserveLicenseComments: false
  useStrict: true
  wrap: true

gulp.task "scripts", ->
  filter_preprocess = $.filter "preprocess_template.js"
  filter_main_js = $.filter PROP.path.scripts("name")

  extractAmdOptions = through2.obj (file, enc, callback)->
    rjs_content = """
      var output;
      var requirejs = require = function(){}
      require.config = function (options) { output = options; }
      var define = function () {};
      #{file.contents.toString(enc)}
      return output;
    """
    try
      amd_options = _.merge amd_options, Function(rjs_content)()
      amd_options.paths = _.reduce amd_options.paths, ((memo, v, k)->
        memo[k] = v.replace /^\.\.\/bower_components\//, "../../app/bower_components/"
        memo
      ), {}
      @push file
      callback()
    catch e
      callback e

  linter = []
  gulp.src PROP.path.scripts()
    .pipe $.if PROP.isNotify, $.plumber {errorHandler}
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
    .pipe $.if !PROP.isDev, extractAmdOptions
    .pipe $.if !PROP.isDev, filter_main_js.restore(end:true)

    .pipe gulp.dest PROP.path.scripts("dest")

gulp.task "rjs", ["scripts"], ->
  gulp.src PROP.path.scripts("dest")
    .pipe through2.obj ((file, enc, callback)->
      callback()
    ), ((finish)->
      _this = this
      contents = null
      async.series [
        (cb)-> requirejs.optimize amd_options, -> cb()
        (cb)-> del amd_options.baseUrl, cb
        (cb)-> fs.readFile amd_options.out, (err, data)->
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


gulp.task "fonts", ->
  gulp.src PROP.path.fonts()
    .pipe $.filter PROP.path.fonts("pattern")
    .pipe $.if !PROP.isDev, $.rev.font()
    .pipe $.flatten()
    .pipe gulp.dest PROP.path.fonts("dest")

gulp.task "images", ->
  gulp.src PROP.path.images()
    .pipe $.if !PROP.isDev, $.rev.image()
    .pipe gulp.dest PROP.path.images("dest")


gulp.task "cssimage", ->
  folder = libpath.join PROP.path.app, "styles"
  gulp.src PROP.path.images()
    .pipe $.cssimage {
      css: true
      scss: true
      prefix:"img_"
      root:"../images"
      name: "_img.scss"
    }
    .pipe gulp.dest libpath.join folder, "vendor"

gulp.task "styles", ["cssimage"], ->
  mqpacker = require "css-mqpacker"
  csswring = require "csswring"
  autoprefixer = require "autoprefixer-core"
  gulp.src PROP.path.styles()
    .pipe $.if PROP.isNotify, $.plumber {errorHandler}
    .pipe $.sass includePaths: [PROP.path.styles("path")]
    .pipe $.sourcemaps.init()
    .pipe $.if !PROP.isDev, $.rev.css PROP.path.styles("dest")
    .pipe $.postcss [
      autoprefixer browsers:[
        "last 222 version"
        "ie >= 8"
        "ff >= 17"
        "opera >=10"
      ]
      mqpacker
      csswring
    ]
    .pipe $.sourcemaps.write(".")
    .pipe gulp.dest PROP.path.styles("dest")

gulp.task "extras", ->
  gulp.src PROP.path.extras(), {dot: true}
    .pipe gulp.dest PROP.path.extras("dest")


gulp.task "extras:js", ->
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

gulp.task "imagepreload", ->
  gulp.src PROP.path.images()
    .pipe $.imagepreload
      inline: PROP.path.index()
    .pipe $.ignore.include(/\.(html|js)$/) #filter js and html only
    .pipe gulp.dest PROP.path.build()

gulp.task "compress", ->
  gulp.src libpath.join PROP.path.build(), "**", "*.{html,js,css}"
    .pipe $.zopfli()
    .pipe gulp.dest PROP.path.build()

gulp.task "watch", ->
  $.livereload.listen()
  gulp.watch PROP.path.templates("watch"), ["templates", "imagepreload"]
  gulp.watch PROP.path.styles("watch"), ["styles"]
  gulp.watch PROP.path.scripts("watch"), ["scripts"]
  gulp.watch PROP.path.livereload()
    .on "change", $.livereload.changed

gulp.task "server", ->
  serveStatic = require "serve-static"
  serveIndex = require "serve-index"
  livereload = require "connect-livereload"
  connect = require "connect"
  http = require "http"
  app = connect()
  if PROP.isDev
    app.use livereload port: 35729
  app.use serveStatic PROP.path.build()
  if PROP.isDev
    app.use serveStatic PROP.path.app
    app.use '/bower_components', serveStatic "bower_components"
    app.use '/images', serveStatic "images"
  app.use serveIndex PROP.path.build()

  http.createServer(app)
    .listen PROP.server.port
    .on "listening", ->
      gutil.log gutil.colors.green "Started connect web server on http://localhost:#{PROP.server.port}"


gulp.task "open", ->
  gulp.src PROP.path.index()
    .pipe $.open "", PROP.open()


DEFAULT_TASK = do ->
  build = ["clean"]
  build.push ["images", "fonts", "extras"] unless PROP.isDev
  build.push "styles"
  build.push if PROP.isDev then "scripts" else "rjs"
  build.push "extras:js" unless PROP.isDev
  build.push "templates"
  build.push "imagepreload"
  build.push "server" if PROP.isSrv
  build.push "watch" if PROP.isSrv and PROP.isDev
  build.push "open" if PROP.isSrv
  build.push "compress" unless PROP.isDev
  build


gulp.task "debug", ->
  gutil.log gutil.colors.cyan JSON.stringify(DEFAULT_TASK, null, 4)

gulp.task "default", $.gulpsync.sync DEFAULT_TASK
