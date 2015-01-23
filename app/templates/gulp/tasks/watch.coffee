gulp = require 'gulp'
PROP = require '../config'
livereload = require 'gulp-livereload'
module.exports = ->
  livereload.listen()
  gulp.watch PROP.path.templates("watch"), ["templates"]
  gulp.watch PROP.path.styles("watch"), ["styles"]
  gulp.watch PROP.path.scripts("watch"), ["scripts"]
  gulp.watch(
    PROP.path.livereload()
  ).on "change", livereload.changed
