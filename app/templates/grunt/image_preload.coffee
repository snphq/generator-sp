module.exports =
  image_preload:
    server:
      options:
        inlineFile:"<%= yeoman.tmpPath %>/scripts/_preloader.js"
        rev:false
      files:[
        cwd:"<%= yeoman.app %>/images"
        src:"**/*.{jpg,jpeg,gif,png}"
      ]
    dist:
      options:
        inlineFile:"<%= yeoman.dist %>/scripts/_preloader.js"
        rev:true
      files:[
        cwd:"<%= yeoman.dist %>/images"
        src:"**/*.{jpg,jpeg,gif,png}"
      ]
    production:"<%= image_preload.dist %>"
