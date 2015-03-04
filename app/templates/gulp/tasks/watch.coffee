gulp = require 'gulp'
browserSync = require 'browser-sync'
PROP = require '../config'
module.exports = ->
  gulp.watch PROP.path.templates("watch"), ["templates"]
  gulp.watch PROP.path.styles("watch"), ["styles"]
  gulp.watch PROP.path.scripts("watch"), ["scripts"]
  gulp.watch(
    PROP.path.livereload()
  ).on "change", browserSync.reload
