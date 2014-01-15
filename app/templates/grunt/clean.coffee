module.exports =
  clean:
    dist:
      files: [
        dot: true
        src: [
          "<%= yeoman.tmpPath %>",
          "<%= yeoman.dist %>/*",
          "!<%= yeoman.dist %>/.git*"
        ]
      ]
    server: "<%= yeoman.tmpPath %>"
