http = require('http')
httpProxy = require('http-proxy')


module.exports = (grunt)->
  grunt.registerMultiTask "proxy", "Run proxy", ->
    proxy = new httpProxy.RoutingProxy()
    options = @options()
    console.log options
    server = http.createServer (req, res)=>
      routers = options.routers or {}
      destination = null
      for matcher, dest of routers
        if dest.matcher.test(req.url)
          destination = dest
          break

      if destination != null
          opts =
            changeOrigin: true
            host: destination.host,
            port: destination.port
          if destination.https is true
            opts.target = https:true
          console.log opts
          proxy.proxyRequest req, res, opts
      else
        reqOptions = {
          hostname: options.local.host
          port: options.local.port
          path: req.url
          method: 'HEAD'
        }
        checkRequest = http.request reqOptions, (checkResponce ) =>
          proxyOptions = {changeOrigin: true}
          if checkResponce.statusCode == 404 and options.remote.active
            settingsSource = options.remote
          else
            settingsSource = options.local

          proxyOptions.host = settingsSource.host
          proxyOptions.port = settingsSource.port
          if settingsSource?.https
            proxyOptions.target = {https: true}
          proxy.proxyRequest req, res, proxyOptions

        checkRequest.on 'socket', (socket)->
          socket.setTimeout 100
          socket.on 'timeout', ->
            checkRequest.abort()
        checkRequest.end()

        checkRequest.on 'error', (error, code)->
          console.log arguments[0]['code']
          console.log "#{error.code} #{error}"
    server.listen(options.port);
