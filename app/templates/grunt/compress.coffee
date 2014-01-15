module.exports =
	compress:
    dist:
      options:
        mode: 'gzip'
      files: [
        expand: true
        cwd: "<%= yeoman.dist %>"
        src: "**/*.{css,html,js}"
        dest: "<%= yeoman.dist %>"
      ]
    archive:
      options:
        archive: "arhive/dist-<%= TIMESTAMP %>.tar.gz"
      files:[
        expand: true
        cwd: "<%= yeoman.dist %>"
        src: ["**/*"]
      ]
