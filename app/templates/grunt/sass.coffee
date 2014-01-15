module.exports =
	sass:
    dist:
      files:[
        expand:true
        cwd: "<%= yeoman.app %>/styles/"
        src: ["{,*/}*.{scss,sass}", "!{,*/}_*.{scss,sass}"]
        dest: "<%= yeoman.tmpPath %>/styles"
        ext: ".css"
      ]
      options:
        includePaths: ["<%= yeoman.app %>/bower_components"]
        sourceComments: 'normal'
