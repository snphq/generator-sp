module.exports = 
	proxy:(grunt,yeomanConfig)->
    _ = grunt.util._
    config = {}
    _.each (yeomanConfig.proxy.remotes or {}), (remotesOpt, target)->
      config[target] = options: remote: remotesOpt
    grunt.util._.each (yeomanConfig.proxy.routers or {}), (routersOpt, target)->
      config[target] = options:{} unless config[target]?
      config[target].options.routers = routers = {}
      _.each routersOpt, (param, route)->
        routers[route] = param
        routers[route].matcher = new RegExp(route)

    config = grunt.util._.extend
      options:
        port: "<%= yeoman.proxy.port %>"
        local:
          host:"localhost"
          port: "<%= connect.options.port %>"
      , config
    config