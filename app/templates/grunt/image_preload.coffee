module.exports =
  image_preload:
    server:
      options:
        #inlineFile:"<%= yeoman.tmpPath %>/scripts/_preloader.js"
        rev:false
      files:[
        cwd:"<%= yeoman.app %>/images"
        src:"**/*.{jpg,jpeg,gif,png}"
      ]
      process:
        files:[
          cwd:"<%= yeoman.tmpPath %>"
          src:["index.html","pokolenie_m/index.html"]
          dest:"<%= yeoman.tmpPath %>"
        ]
    dist:
      options:
        #inlineFile:"<%= yeoman.dist %>/scripts/_preloader.js"
        rev:true
      files:[
        cwd:"<%= yeoman.dist %>/images"
        src:"**/*.{jpg,jpeg,gif,png}"
      ]
      process:
        files:[
          cwd:"<%= yeoman.dist %>"
          src:["index.html","pokolenie_m/index.html"]
          dest:"<%= yeoman.dist %>"
        ]
    production:"<%= image_preload.dist %>"
