module.exports = (grunt) ->
  _ = require "lodash"

  # show elapsed time at the end
  require("time-grunt") grunt

  require("jit-grunt") grunt

  # configurable paths
  yeomanConfig = require "./.gruntconfig"

  try
    localConfig = require "./.gruntconfig.local"
  catch e
    localConfig = {}

  yeomanConfig = _.extend {
    scriptlang:   "js"    #coffee
    templatelang: "swig"  #jade
    tmpPath:      ".tmp"
  }, yeomanConfig, localConfig

  global.OPTIONS = OPTIONS =
    yeoman:     do-> yeomanConfig
    TIMESTAMP: do (d=new Date) -> "#{d.getFullYear()}-#{d.getMonth()}-#{d.getDate()}-#{+(d)}"
    cssmin:       {}

    # not used since Uglify task does concat,
    # but still available if needed
    # concat: dist: {}


    #uglify2: {} // https://github.com/mishoo/UglifyJS2

    useminPrepare:
      options:
        dest: "<%= yeoman.dist %>"
        root: "<%= yeoman.app %>"

      html: "<%= yeoman.tmpPath %>/**/*.html"

    usemin:
      options:
        dirs: ["<%= yeoman.dist %>"]
        assetsDirs: "<%= yeoman.dist %>"
      html: ["<%= yeoman.dist %>/**/*.html"]
      css: ["<%= yeoman.dist %>/styles/{,*/}*.css"]
      # This task is pre-configured if you do not wish to use Usemin
      # blocks for your CSS. By default, the Usemin block from your
      # `index.html` will take care of minification, e.g.
      #
      #     <!-- build:css({.tmp,app}) styles/main.css -->
      #
      # dist: {
      #     files: {
      #         "<%= yeoman.dist %>/styles/main.css": [
      #             ".tmp/styles/{,*/}*.css",
      #             "<%= yeoman.app %>/styles/{,*/}*.css"
      #         ]
      #     }
      # }

    concurrent: do ->
      server = [
        "copy:deps"
        "sass"
        "link_templatecompiler:server"
        "copy:styles"
      ]
      dist = [
        "copy:deps"
        "sass"
        "copy:styles"
        "copy:images"
        "htmlmin"
      ]
      if yeomanConfig.scriptlang is "coffee"
        server.push "coffee:server"
        server.push "coffee:preprocess"
        dist.push "coffee:dist"
      else
        server.push "copy:js"
        dist.push "copy:js"
      {server,dist}

  TASKS_MAP = [
    "swig"
    "jade"
    "replace"
    "watch"
    "open"
    "clean"
    "jshint"
    "coffee"
    "preprocess"
    "coffeelint"
    "sass"
    "autoprefixer"
    "copy"
    "requirejs"
    "rev"
    "modernizr"
    "htmlmin"
    "compress"
    "bower"
    "connect"
    "proxy"
    "image_preload"
    "css_image"
    "rename"
  ]

  TASKS_MAP.forEach (task)->
    config = require("./grunt/#{task}")[task]
    if _.isFunction(config)
      config = config grunt,yeomanConfig
    OPTIONS[task] = config

  grunt.initConfig OPTIONS

  ##################################
  #                                #
  #         Register tasks         #
  #                                #
  ##################################

  get_preprocess_target = (targets)->
    if "dist" in targets
      "dist"
    else if "production" in targets
      "production"
    else
      "server"

  do ->
    task = if yeomanConfig.templatelang is "jade" then "jade" else "swig"
    grunt.registerTask "link_templatecompiler", (targets...)->
      mode = get_preprocess_target targets
      grunt.task.run ["#{task}:#{mode}"]

  do ->
    tasks = if yeomanConfig.scriptlang is "coffee" then ["coffeelint"] else ["jshint"]
    grunt.registerTask "link_lintscript", tasks

  grunt.registerTask "link_requirejs", [
    "replace:requirejs"
    "requirejs"
  ]

  grunt.registerTask "server", (targets...) ->
    require("load-grunt-tasks") grunt

    mode = get_preprocess_target targets
    preprocess = "preprocess:#{mode}"
    build = "build:#{mode}"

    tasks = if "dist" in targets or "production" in targets
      targets = _.without targets, ["dist","production"]
      [
        build
        "open"
        "proxy"
        "connect:dist:keepalive"
      ]
    else
      [
        "link_lintscript"
        "clean:server"
        "copy:js"
        "copy:custom"
        "css_image:dist"
        "concurrent:server"
        "image_preload:server"
        preprocess
        "autoprefixer"
        "connect:livereload"
        "proxy"
        "open"
        "watch"
      ]
    proxy_target = _.find targets, (item)->
      /^proxy-[0-9a-z]+$/.test item
    if proxy_target?
      proxy_target = proxy_target.replace "-", ":"
    else
      proxy_target = "proxy:#{yeomanConfig.proxy.default}"

    tasks[tasks.indexOf "proxy"] = proxy_target

    grunt.task.run tasks


  do ->
    n = 0
    grunt.event.on 'coffeelint:any', (status, message) ->
      grunt.config ['notify', "coffeelint#{n}"], options:
        title: "Coffeelint #{status}"
        message: message
      grunt.task.run "notify:coffeelint#{n}"
      n++

  grunt.registerTask "build", "",(targets...)->
    # load all grunt tasks

    mode = get_preprocess_target targets
    preprocess = "preprocess:#{mode}"
    image_preload = "image_preload:#{mode}"
    rename = "rename:#{mode}"
    link_templatecompiler = "link_templatecompiler:#{mode}"
    require("load-grunt-tasks") grunt
    build = [
      "link_lintscript"
      "clean:dist"
      "copy:custom"
      link_templatecompiler
      "useminPrepare"
      "css_image:dist"
      "concurrent:dist"
      "autoprefixer"
      preprocess
      "link_requirejs"
      "concat"
      "cssmin"
      "uglify"
      "modernizr:dist"
      "copy:dist"
      "rev"
      image_preload
      "usemin"
      rename
      "compress:dist"
    ]
    if yeomanConfig.archive
      build.push "compress:archive"
    grunt.task.run build

  grunt.registerTask "default", [
    "build"
  ]

  # uncomment for single task using
  #require("load-grunt-tasks") grunt
  grunt.loadTasks "tasks"

