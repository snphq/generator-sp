gulp = require "gulp"
browserSync = require "browser-sync"
PROP = require "../config"

baseDir = [PROP.path.build()]
baseDir.push PROP.path.app if PROP.isDev

module.exports = ->
  browserSync {
    port: PROP.server.port
    open: true
    server: {
      baseDir
      index: "index.html"
      routes: {
        "/bower_components": "bower_components"
        "/images": "images"
      }
    }
  }
