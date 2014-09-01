module.exports =
   coffeelint:
      options:
        force: true
        configFile: '.coffeelintrc'
      app:
        files: [
            expand: true
            cwd: "<%= yeoman.app %>/scripts"
            src: "**/*.coffee"
          ]
