module.exports =
  watch:
    options:
      debounceDelay: 250
      spawn: false
      livereload: true

    templates:
      files: ["<%= yeoman.app %>/{html,templates}/**/*.{html,jade}"]
      tasks: ["link_templatecompiler"]

    js:
      files: ["<%= yeoman.app %>/scripts/**/*.js"]
      tasks: ["newer:jshint", "copy:js"]

    coffee:
      options:
        livereload: false
      files: ["<%= yeoman.app %>/scripts/**/*.coffee"]
      tasks: ["newer:coffeelint","newer:coffee"]

    preprocess:
      files: ["<%= yeoman.tmpPath %>/scripts/preprocess_template.js"]
      tasks: ["preprocess:server"]

    compass:
      options:
        livereload: false
        spawn: true
      files: ["<%= yeoman.app %>/styles/{,*/}*.{scss,sass}"]
      tasks: ["sass", "autoprefixer"]

    styles:
      options:
        livereload: false
        spawn: false
      files: ["<%= yeoman.app %>/styles/{,*/}*.css"]
      tasks: ["copy:styles", "autoprefixer"]

    css:
      options:
        livereload: true
        spawn: true
      files: ["./.tmp/styles/main.css"]
      tasks: []

    livereload:
      options:
        livereload: "<%= connect.options.port %>"
        spawn: true

      files: [
        "<%= yeoman.tmpPath %>/*.html"
        "<%= yeoman.tmpPath %>/styles/{,*/}*.css"
        "{<%= yeoman.tmpPath %>,<%= yeoman.app %>}/scripts/**/*.js"
        "<%= yeoman.app %>/images/**/*.{png,jpg,jpeg,gif,webp,svg}"
      ]
