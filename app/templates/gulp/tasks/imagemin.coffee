gulp = require "gulp"
jpegoptim = require "imagemin-jpegoptim"
pngquant = require "imagemin-pngquant"
optipng = require "imagemin-optipng"

PROP = require "../config"

module.exports =
  'jpg': ->
    gulp.src PROP.path.images "jpg"
      .pipe jpegoptim max: 70
      .pipe gulp.dest PROP.path.images "dest"
  'png': ->
    gulp.src PROP.path.images "png"
      .pipe optipng optimizationLevel: 3
      .pipe pngquant quality: "65-80", speed: 4
      .pipe gulp.dest PROP.path.images "dest"
