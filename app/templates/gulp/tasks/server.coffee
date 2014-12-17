gutil = require 'gulp-util'
serveStatic = require "serve-static"
serveIndex = require "serve-index"
livereload = require "connect-livereload"
connect = require "connect"
http = require "http"

PROP = require "../config"

module.exports = ->
  app = connect()
  if PROP.isDev
    app.use livereload port: 35729
  app.use serveStatic PROP.path.build()
  if PROP.isDev
    app.use serveStatic PROP.path.app
    app.use '/bower_components', serveStatic "bower_components"
    app.use '/images', serveStatic "images"
  app.use serveIndex PROP.path.build()

  server = http.createServer(app)
  server.listen(PROP.server.port)
  server.on "listening", ->
      gutil.log gutil.colors.green "Started connect web server on http://localhost:#{PROP.server.port}"
  null
