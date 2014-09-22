module.exports =
  jade:
    server:
      options:
        pretty:true
        data:-> {
          jade_mode: "server"
        }
        filters:{}
        basedir:"app"
      files:[
        expand:true
        src: ["**/*.jade", "!**/_*.jade" ]
        cwd: "app/html"
        dest: "<%= yeoman.tmpPath %>"
        ext: ".html"
      ]

    dist:
      options:
        pretty:true
        data:-> {
          jade_mode: "dist"
        }
        filters:{}
        basedir:"app"
      files: "<%= jade.server.files %>"

    production:
      options:
        pretty:true
        data:-> {
          jade_mode: "production"
        }
        filters:{}
        basedir:"app"
      files: "<%= jade.server.files %>"
