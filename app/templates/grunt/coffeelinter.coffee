module.exports =
  coffeelinter:
    options:
      force: true
      configFile: '.coffeelintrc'
      reportConsole: true
      # reporterOutput: 'coffeelinter-report.json'

    app:
      files: [
        expand: true
        cwd: "<%= yeoman.app %>/scripts"
        src: "**/*.coffee"
      ]
