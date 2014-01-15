module.exports =
	jade:
    dist:
      options:
        pretty:true
        data:-> {}
        filters:{}
      files:[
        expand:true
        src: ["**/*.jade", "!**/_*.jade" ]
        cwd: "app/html"
        dest: "<%= yeoman.tmpPath %>"
        ext: ".html"
      ]
