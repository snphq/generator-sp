module.exports =
	swig:
    dist:
      options:
        templateDir: "<%= yeoman.app %>/templates"
      root: "app"
      livereload: true
      params: "<%= yeoman.swig.params %>"
      files: [
        expand: true
        src: ["**/*.html", "!**/_*.html"]
        cwd: "app/html"
        dest: "<%= yeoman.tmpPath %>"
        options:
          bare: true
      ]
