gulp = require 'gulp'
libpath = require 'path'
cssimage = require 'gulp-css-image'

module.exports = ->
  folder = libpath.join PROP.path.app, "styles"
  gulp.src PROP.path.images()
    .pipe cssimage {
      css: false
      scss: true
      prefix:"img_"
      root:"../images"
      name: "_img.scss"
    }
    .pipe gulp.dest libpath.join folder, "vendor"
