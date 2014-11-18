through2 = require "through2"
crypto = require "crypto"

rev = (cache={}, processKey)-> through2.obj (file, enc, callback)->
  md5 = crypto.createHash("md5")
  md5.update file.contents
  key = if processKey? then processKey file else file.relative
  cache[key] = md5.digest("hex")
  @push file
  callback()

module.exports = rev
