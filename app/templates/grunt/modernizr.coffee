module.exports =
  modernizr:
    devFile: "<%= yeoman.app %>/bower_components/modernizr/modernizr.js"
    outputFile: "<%= yeoman.dist %>/bower_components/modernizr/modernizr.js"
    files: ["<%= yeoman.dist %>/scripts/**/*.js", "<%= yeoman.dist %>/styles/{,*/}*.css", "!<%= yeoman.dist %>/scripts/vendor/*"]
    uglify: true
