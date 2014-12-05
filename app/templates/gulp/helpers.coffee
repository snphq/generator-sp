notify = require "gulp-notify"
module.exports =
  gulpLoad: (libs)->
    wrap = {}
    for l in libs
      try
        wrap[l] = require "gulp-#{l}"
      catch
        wrap[l] = require "./plugins/#{l}"
    wrap
  errorHandler: (err)->
    notify.onError(
      title:    "Gulp"
      subtitle: "Failure!"
      message:  "Error: <%= error.message %>"
      sound:    "Beep"
    )(err)
    @emit "end"
