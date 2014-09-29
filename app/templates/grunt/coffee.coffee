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
      files: [
        expand: true
        cwd: "<%= yeoman.app %>/scripts"
        src: ["**/*.coffee", "!preprocess_template.coffee"]
        dest: "<%= yeoman.tmpPath %>/scripts"
        ext: ".js"
      ]

    preprocess:
      files: [
        expand: true
        cwd: "<%= yeoman.app %>/scripts"
        src: "preprocess_template.coffee"
        dest: "<%= yeoman.tmpPath %>/scripts"
        ext: ".js"
      ]
