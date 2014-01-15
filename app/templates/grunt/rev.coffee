module.exports =
  rev:
    dist:
      files:
        src: [
          "<%= yeoman.dist %>/scripts/**/*.js"
          "<%= yeoman.dist %>/styles/{,*/}*.css"
          "<%= yeoman.dist %>/images/**/*.{png,jpg,jpeg,gif,webp}"
          "<%= yeoman.dist %>/styles/fonts/**/*.*"
        ]
