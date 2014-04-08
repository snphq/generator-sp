module.exports =
  autoprefixer:
    options:
      browsers: ["last 222 version", "ie >= 8",  "ff >= 17", "opera >=10"]

    dist:
      files: [
        expand: true
        cwd: "<%= yeoman.tmpPath %>/styles/"
        src: "{,*/}*.css"
        dest: "<%= yeoman.tmpPath %>/styles/"
      ]
