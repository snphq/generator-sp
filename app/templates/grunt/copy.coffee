module.exports =
  # Put files not handled in other tasks here
  copy:
    dist:
      files: [
        expand: true
        dot: true
        cwd: "<%= yeoman.app %>"
        dest: "<%= yeoman.dist %>"
        src: [
          "*.{ico,png,txt}",
          ".htaccess",
          "images/**/*.{webp,gif}",
          "styles/fonts/**/*.*"
        ]
      ,
        expand: true
        dot: true
        cwd: "<%= yeoman.app %>/bower_components/requirejs"
        dest: "<%= yeoman.dist %>/bower_components/requirejs"
        src: "require.js"
      ,
        expand: true
        dot: true
        cwd: "<%= yeoman.tmpPath %>"
        dest: "<%= yeoman.dist %>"
        src: [
          "*.{ico,png,txt}",
          ".htaccess",
          "images/**/*.{webp,gif}",
          "styles/fonts/**/*.*"
          "files/**/*.*"
        ]
      ]

    js:
      expand: true
      dot: true
      cwd: "<%= yeoman.app %>/scripts"
      dest: "<%= yeoman.tmpPath %>/scripts"
      src: "**/*.js"

    coffee:
      expand: true
      dot: true
      cwd: "<%= yeoman.app %>/scripts"
      dest: "<%= yeoman.tmpPath %>/coffee"
      src: "**/*.coffee"

    styles:
      expand: true
      dot: true
      cwd: "<%= yeoman.app %>/styles"
      dest: "<%= yeoman.tmpPath %>/styles/"
      src: "**/*.css"

    images:
      files: [
        expand: true
        cwd: "<%= yeoman.app %>/images"
        src: "**/*.{png,jpg,jpeg}"
        dest: "<%= yeoman.dist %>/images"
      ]

    custom:
      files: "<%= yeoman.copy %>"

    deps:
      files: "<%= yeoman.copy_deps %>"
