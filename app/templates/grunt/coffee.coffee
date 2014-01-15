module.exports =
  coffee:
    dist:
      files: [
        expand: true
        cwd: "<%= yeoman.app %>/scripts"
        src: "**/*.coffee"
        dest: "<%= yeoman.tmpPath %>/scripts"
        ext: ".js"
      ]
    server:
      options:
        sourceMap: false
      files: "<%= coffee.dist.files %>"
