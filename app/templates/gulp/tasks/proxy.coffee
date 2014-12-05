http = require 'http'
httpProxy = require 'http-proxy'
PROP = require '../config'
_ = require "lodash"
module.exports = ->
  proxy = new httpProxy.createProxyServer()
  options = PROP.proxy || {} # @options()
  if "function" == typeof options.remotes
    options.remotes = options.remotes()
  if "function" == typeof options.routers
    options.routers = options.routers()
  _.each options.routers, (param, route)->
    options.routers[route].matcher = new RegExp(route)
  options.local =
    host: "localhost"
    port: PROP.server.port
#  PROP.server.port = options.port
  server = http.createServer (req, res)=>
    routers = options.routers || {}
    destination = null
    for matcher, dest of routers
      if dest.matcher.test(req.url)
        destination = dest
        break

    if destination != null
        opts =
          changeOrigin: true
        opts.target = "http" + (if destination.https then "s" else "") +
          "://" + destination.host + ":" + destination.port
        proxy.web req, res, opts
    else
      reqOptions = {
        hostname: options.local.host
        port: options.local.port
        path: req.url
        method: 'HEAD'
      }
      checkRequest = http.request reqOptions, (checkResponce) =>
        proxyOptions = {changeOrigin: true}
        if checkResponce.statusCode == 404 and options.remotes.active
          settingsSource = options.remotes
        else
          settingsSource = options.local

        proxyOptions.target = "http" + (if settingsSource.https then "s" else "") +
          "://" + settingsSource.host + ":" + settingsSource.port
        proxy.web req, res, proxyOptions

      checkRequest.on 'socket', (socket)->
        socket.setTimeout 100
        socket.on 'timeout', ->
          checkRequest.abort()
      checkRequest.end()

      checkRequest.on 'error', (error, code)->
        console.log arguments[0]['code']
        console.log "#{error.code} #{error}"
  server.listen(PROP.proxy.port);
