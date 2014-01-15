module.exports =
  requirejs:
    dist:
    # Options: https://github.com/jrburke/r.js/blob/master/build/example.build.js
      options:
      # `name` and `out` is set by grunt-usemin
        name: "main"
        baseUrl: "<%= yeoman.tmpPath %>/scripts"
        mainConfigFile: "<%= yeoman.tmpPath %>/scripts/main.js",
        out: "<%= yeoman.dist %>/scripts/main.js"
      # optimize: "none"

      # TODO: Figure out how to make sourcemaps work with grunt-usemin
      # https://github.com/yeoman/grunt-usemin/issues/30
      #generateSourceMaps: true,
      # required to support SourceMaps
      # http://requirejs.org/docs/errors.html#sourcemapcomments
        preserveLicenseComments: false
        useStrict: true
        wrap: true
