LIVERELOAD_PORT = 35729
## Middleware :
# Livereload
lrSnippet = require("connect-livereload")(port: LIVERELOAD_PORT)
# Static folder mounter
mountFolder = (connect, dir) ->
  connect.static require("path").resolve(dir)
# rewrite wrong routes for sass sourcemaps
rewriteRoute = (req, res, next)->
  req.url = req.url.replace /^\/styles\/app/, ''
  next()

module.exports =
  connect: (grunt, yeomanConfig)->
    options:
      port: 9000

    # change this to '0.0.0.0' to access the server from outside
      hostname: "localhost"

    livereload:
      options:
        middleware: (connect) ->
          [
            rewriteRoute
            lrSnippet
            mountFolder(connect, yeomanConfig.tmpPath)
            mountFolder(connect, yeomanConfig.app)
          ]

    dist:
      options:
        middleware: (connect) ->
          [
            mountFolder(connect, yeomanConfig.dist)
          ]
