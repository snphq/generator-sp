gulp = require 'gulp'
rev = require '../plugins/rev'
PROP = require '../config'

module.exports = ->
  gulp.src PROP.path.extras(), {dot: true, base: "app"}
    .pipe rev.extra()
    .pipe gulp.dest PROP.path.extras("dest")
