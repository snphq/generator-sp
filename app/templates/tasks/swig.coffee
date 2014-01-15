html = require("html")
fs = require("fs")
path = require("path")
swig = require("swig")

module.exports = (grunt)->
  grunt.registerMultiTask "swig", "Run swig", ->
    @files.forEach (filePair) =>
      try
        sw = new swig.Swig
          autoescape: true
          allowErrors: true
          encoding: "utf8"

        src = filePair.src[0]
        console.log src
        tmpl = sw.compileFile(src)

        params = grunt.util._.defaults @data.params,{livereload:false}
        data = tmpl p:params

        prettyData = html.prettyPrint(data, indent_size: 2)
        trueDest = filePair.dest.replace /_%_/ ,'/'
        grunt.file.write(trueDest, prettyData)
        grunt.log.writeln "Compile " + filePair.src[0].green + " -> ".yellow + trueDest.green
      catch err
        grunt.log.error err
