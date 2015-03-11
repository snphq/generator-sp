gulp = require 'gulp'
PROP = require '../config'
imagepreload = require 'gulp-image-preload'
module.exports = ->
  gulp.src PROP.path.images_preload()
    .pipe imagepreload
      script: "_imagepreload.js"
      scriptPath: "_imagepreload.js"
      md5: false
      reduceRev: (filename)-> filename.replace(/([^\.]+)-([^\.]+)\.([^\.]+)/, "$1.$3");
      rev: not PROP.isDev
    .pipe gulp.dest PROP.path.scripts("dest")
