module.exports =
	preprocess:

    server:
      files:[
        src:"<%= yeoman.tmpPath %>/scripts/preprocess_template.js"
        dest:"<%= yeoman.tmpPath %>/scripts/preprocess.js"
      ]
      options:
        context:
          DEBUG:true

    dist:
      files:"<%= preprocess.server.files %>"
      options:
        context:
          DIST:true

    prodaction:
      files:"<%= preprocess.server.files %>"
      options:
        context:
          PROD:true
