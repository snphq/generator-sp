LIVERELOAD_PORT = 35729
lrSnippet = require("connect-livereload")(port: LIVERELOAD_PORT)
mountFolder = (connect, dir) ->
  connect.static require("path").resolve(dir)

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
