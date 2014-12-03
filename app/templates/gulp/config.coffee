gutil = require "gulp-util"
libpath = require "path"
mainbowerfiles = require "main-bower-files"
_ = require "lodash"
cfg = require "./../.gulpconfig"

server = _.defaults cfg.server, {
  host: "0.0.0.0"
  port: 9000
  fallback: "index.html"
}

open = _.defaults cfg.open, {
  host: server.host
  port: server.port
  path: "/"
}

PROP = do ->

  isDev: not (gutil.env.mode in ["dist", "prod"])
  isSrv: not gutil.env.build
  isNotify: not gutil.env.build
  isImageMin: gutil.env.imagemin

  preprocess: (prop=gutil.env.mode)->
    context = switch prop
      when "dist" then {DIST:true}
      when "prod" then {PROD:true}
      else {DEBUG:true}
    {context}

  server: server

  jade:
    mode: (prop=gutil.env.mode)->
      switch prop
        when "dist" then "dist"
        when "prod" then "production"
        else "server"

  open: ->
    url: "http://" + open.host + ":" + open.port + open.path

  path: {
    app: cfg.app or "app"
    clean: ->
      [".tmp", "dist", "prod"]
    build: (prop=gutil.env.mode)->
      switch prop
        when "dist" then "dist"
        when "prod" then "prod"
        else ".tmp"

    scripts: (prop)->
      name = "main.js"
      switch prop
        when "main_base" then libpath.join PROP.path.app, "scripts"
        when "main_path" then libpath.join PROP.path.scripts("main_base"), name
        when "dest"   then libpath.join PROP.path.build(), "scripts"
        when ".dest"  then libpath.join PROP.path.build(), ".scripts"
        when "out"    then libpath.join PROP.path.scripts(".dest"), name
        when "result" then libpath.join PROP.path.scripts("dest"), name
        when "name"   then name
        when "extras_src" then [
          libpath.join PROP.path.app, "bower_components", "modernizr", "modernizr.js"
          libpath.join PROP.path.app, "bower_components", "requirejs", "require.js"
        ].concat(cfg.scripts)
        when "extras_dest" then libpath.join PROP.path.build(), "bower_components"
        else libpath.join PROP.path.app, "scripts", "**", "*.coffee"
    templates: (prop)->
      switch prop
        when "dest" then PROP.path.build()
        when "watch" then [
          PROP.path.templates(),
          libpath.join PROP.path.app, "scripts", "**", "*.jade"
        ]
        else libpath.join PROP.path.app, "html", "**", "*.jade"
    styles: (prop)->
      switch prop
        when "dest" then libpath.join PROP.path.build(), "styles"
        when "path" then libpath.join PROP.path.app, "bower_components"
        when "watch" then [
          libpath.join PROP.path.app, "styles", "**", "*.scss"
          libpath.join PROP.path.app, "scripts", "**", "*.scss"
          libpath.join PROP.path.app, "styles", "vendor.css"
        ]
        else [
          libpath.join PROP.path.app, "styles", "main.scss"
          libpath.join PROP.path.app, "styles", "vendor.css"
        ]

    extras: (prop)->
      switch prop
        when "dest" then PROP.path.build()
        else [
          libpath.join PROP.path.app, "*.*"
        ].concat( cfg.extras)

    fonts: (prop)->
      switch prop
        when "dest" then libpath.join PROP.path.build(), "styles", "fonts"
        when "pattern" then libpath.join "**", "*.{eot,svg,ttf,woff,woff2}"
        else
          mainbowerfiles().concat [
            libpath.join PROP.path.app, "styles", "fonts", PROP.path.fonts("pattern")
          ]

    images: (prop)->
      switch prop
        when "dest" then libpath.join PROP.path.build(), "images"
        when "jpg" then libpath.join PROP.path.build(), "images", "**", "*.{jpg,jpeg}"
        when "png" then libpath.join PROP.path.build(), "images", "**", "*.png"
        else libpath.join PROP.path.app, "images", "**", "*.{gif,png,jpg,jpeg,webp}"

    index: ->
      libpath.join PROP.path.build(), "index.html"

    livereload: ->
      build = PROP.path.build()
      [
        libpath.join build, "**/*.html"
        libpath.join build, "styles", "**/*.css"
        libpath.join build, "scripts", "**/*.js"
        libpath.join PROP.path.app, "images", "**/*"
      ]
  }

module.exports = PROP
