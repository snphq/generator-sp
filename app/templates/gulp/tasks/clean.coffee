gulp = require 'gulp'
vinylPaths = require "vinyl-paths"
del = require "del"
PROP = require '../config'

module.exports = ->
  gulp.src PROP.path.clean(), {read: false}
    .pipe vinylPaths(del)
