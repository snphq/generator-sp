module.exports =
  jshint:
    options:
      jshintrc: ".jshintrc"
      force: true
    all: ["<%= yeoman.app %>/scripts/**/*.js", "!<%= yeoman.app %>/scripts/vendor/*"]
