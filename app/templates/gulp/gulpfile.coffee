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
  resource: require "./plugins/resource"
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
    pretty: PROP.isDev
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

gulp.task "scripts", ["imagepreload"], ->
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
  filter_vendor = $.filter "vendor.css"
  filter_main = $.filter "main.css"

  mqpacker = require "css-mqpacker"
  csswring = require "csswring"
  autoprefixer = require "autoprefixer-core"
  ORDER = []
  gulp.src PROP.path.styles()
    .pipe $.if PROP.isNotify, $.plumber {errorHandler}
    .pipe $.sass includePaths: [PROP.path.styles("path")]
    .pipe filter_vendor
    .pipe $.resource("resources")
    .pipe filter_vendor.restore(end:true)
    .pipe $.sourcemaps.init()
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


gulp.task "extras", ->
  gulp.src PROP.path.extras(), {dot: true}
    .pipe $.rev.extra()
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
      script: "_imagepreload.js"
      scriptPath: "_imagepreload.js"
      md5: false
    .pipe gulp.dest PROP.path.scripts("dest")


gulp.task "png", ->
  pngquant = require "imagemin-pngquant"
  optipng = require "imagemin-optipng"
  gulp.src PROP.path.images "png"
    .pipe optipng optimizationLevel: 3
    .pipe pngquant quality: "65-80", speed: 4
    .pipe gulp.dest PROP.path.images "dest"


gulp.task "jpg", ->
  jpegoptim = require "imagemin-jpegoptim"
  gulp.src PROP.path.images "jpg"
    .pipe jpegoptim max: 70
    .pipe gulp.dest PROP.path.images "dest"


gulp.task "imagemin", ["png","jpg"]

gulp.task "compress", ->
  gulp.src libpath.join PROP.path.build(), "**", "*.{html,js,css}"
    .pipe $.zopfli()
    .pipe gulp.dest PROP.path.build()

gulp.task "watch", ->
  $.livereload.listen()
  gulp.watch PROP.path.templates("watch"), ["templates"]
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

gulp.task "proxy", ->
  http = require 'http'
  httpProxy = require 'http-proxy'

  proxy = new httpProxy.createProxyServer()
  options = PROP.proxy || {} # @options()
  if "function" == typeof options.remotes
    options.remotes = options.remotes()
  if "function" == typeof options.routers
    options.routers = options.routers()
  _.each options.routers, (param, route)->
    options.routers[route].matcher = new RegExp(route)
  options.local =
    host: "localhost"
    port: PROP.server.port
#  PROP.server.port = options.port
  server = http.createServer (req, res)=>
    routers = options.routers || {}
    destination = null
    for matcher, dest of routers
      if dest.matcher.test(req.url)
        destination = dest
        break

    if destination != null
        opts =
          changeOrigin: true
        opts.target = "http" + (if destination.https then "s" else "") +
          "://" + destination.host + ":" + destination.port
        proxy.web req, res, opts
    else
      reqOptions = {
        hostname: options.local.host
        port: options.local.port
        path: req.url
        method: 'HEAD'
      }
      checkRequest = http.request reqOptions, (checkResponce) =>
        proxyOptions = {changeOrigin: true}
        if checkResponce.statusCode == 404 and options.remotes.active
          settingsSource = options.remotes
        else
          settingsSource = options.local

        proxyOptions.target = "http" + (if settingsSource.https then "s" else "") +
          "://" + settingsSource.host + ":" + settingsSource.port
        proxy.web req, res, proxyOptions

      checkRequest.on 'socket', (socket)->
        socket.setTimeout 100
        socket.on 'timeout', ->
          checkRequest.abort()
      checkRequest.end()

      checkRequest.on 'error', (error, code)->
        console.log arguments[0]['code']
        console.log "#{error.code} #{error}"
  server.listen(PROP.proxy.port);

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
  build.push "server" if PROP.isSrv
  build.push "watch" if PROP.isSrv and PROP.isDev
  build.push "proxy" if PROP.isSrv
  build.push "open" if PROP.isSrv
  build.push "compress" unless PROP.isDev
  build.push "imagemin" if PROP.isImageMin
  build


gulp.task "debug", ->
  gutil.log gutil.colors.cyan JSON.stringify(DEFAULT_TASK, null, 4)

gulp.task "default", $.gulpsync.sync DEFAULT_TASK
