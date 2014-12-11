gulp = require "gulp"
gutil = require "gulp-util"
gulpsync = require("gulp-sync")(gulp)
_ = require "lodash"

PROP = require "./config"

gulp.task "clean", require './tasks/clean'
gulp.task "templates", require './tasks/templates'
gulp.task "scripts", ["imagepreload"], require './tasks/scripts'
gulp.task "rjs", ["scripts"],  require './tasks/rjs'
gulp.task "fonts", require './tasks/fonts'
gulp.task "images", require './tasks/images'
gulp.task "cssimage", require './tasks/cssimage'
gulp.task "styles", ["cssimage"], require './tasks/styles'
gulp.task "extras", require './tasks/extras'
gulp.task "extras:js", require './tasks/extras-js'
gulp.task "imagepreload", require './tasks/imagepreload'
gulp.task "imagemin.png", (require './tasks/imagemin').png
gulp.task "imagemin.jpg", (require './tasks/imagemin').jpg
gulp.task "imagemin", ['imagemin.png', 'imagemin.jpg']
gulp.task "sprites", require './tasks/sprites'
gulp.task "compress", require './tasks/compress'
gulp.task "watch",  require './tasks/watch'
gulp.task "server", require './tasks/server'
gulp.task "proxy", require './tasks/proxy'
gulp.task "open", require './tasks/open'

DEFAULT_TASK = do ->
  build = ["clean"]
  build.push ["images", "fonts", "extras"] unless PROP.isDev
  build.push "sprites"
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

gulp.task "default", gulpsync.sync DEFAULT_TASK
