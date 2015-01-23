through2 = require "through2"
crypto = require "crypto"
gutil = require "gulp-util"
libpath = require "path"
postcss = require "postcss"
urldata = require "urldata"
_ = require "lodash"

CACHE = {}

toHash = (contents)->
  crypto.createHash("md5").update(contents).digest("hex")[..8]

toRevPath = (path, hash)->
  ext = libpath.extname path
  name = libpath.basename path, ext
  dir = libpath.dirname path
  revname = name + "-" + hash + ext
  libpath.join dir, revname

toRevFile = (file)->
  hash = toHash(file.contents)
  CACHE[file.path] = file
  file.hash = hash
  file.orig_path = file.path
  file.path = toRevPath file.orig_path, hash
  file

toReplace = (orig, _new, source=orig)->
  quest = orig.indexOf("?")
  hash = orig.indexOf("#")
  split = if quest > hash then hash else quest

  if split > -1 then repl = orig.split(split)[0]
  else repl = orig
  res = source.replace repl, _new
  res

gulprev = (cache={}, processKey)-> through2.obj (file, enc, callback)->
  md5 = crypto.createHash("md5")
  md5.update file.contents
  key = if processKey? then processKey file else file.relative
  cache[key] = md5.digest("hex")
  @push file
  callback()

gulprev.cache = CACHE

gulprev.image = -> through2.obj (file, enc, callback)->
  @push toRevFile file
  callback()

gulprev.font = -> through2.obj (file, enc, callback)->
  @push toRevFile file
  callback()

gulprev.script = -> through2.obj (file, enc, callback)->
  @push toRevFile file
  callback()

gulprev.extra = -> through2.obj (file, enc, callback)->
  CACHE[file.path] = file
  file.orig_path = file.path
  @push file
  callback()

gulprev.css = (root=".")-> through2.obj (file, enc, callback)->
  filedir = libpath.dirname file.path
  postcss_processor = (css)-> css.eachDecl (decl, data)->
    is_prop = decl.prop.indexOf("background") is 0 or
        decl.prop.indexOf("border-image") is 0 or
        decl.prop.indexOf("src") is 0
    return unless is_prop and decl.value.indexOf("url") >= 0
    urls = urldata decl.value
    rev_urls = _.map urls, (_url)->
      return if /^http/.test _url
      return if _url.indexOf(";base64,") > -1
      if _url.indexOf("./") is 0
        url = _url
      else if _url.indexOf("/") is 0
        url = "..#{_url}"
      else
        url = "./#{_url}"
      url = url.split("#")[0].split("?")[0]
      #abs path
      absurl = libpath.resolve filedir, url

      ext = libpath.extname(absurl).toLowerCase()
      #relative path
      relurl = libpath.relative root, absurl

      _file = CACHE[absurl]

      unless _file
        gutil.log("gulprev.css can't find #{absurl}")
        return
      return if absurl is _file.path
      libpath.relative root, _file.path

    value = decl.value
    for i in [0..rev_urls.length-1]
      if r_url = rev_urls[i]
        value = toReplace urls[i], rev_urls[i], value
    decl.value = value

  css_result = postcss(postcss_processor)
    .process(file.contents.toString()).css

  file.contents = new Buffer(css_result)
  @push file
  callback()

gulprev.cssrev = -> through2.obj (file, enc, callback)->
  file = toRevFile file
  @push file
  callback()

gulprev.jade_parser = (resource=".", output=".")->
  P = require("jade").Parser
  parseExpr = P::parseExpr
  processAttr = (attr)->
    val = attr.val.replace /[\'\"]/g, ""
    if val[0] is "/" then val = val[1..]
    absurl = libpath.resolve resource, val
    absurl = absurl.split("#")[0].split("?")[0]
    _file = CACHE[absurl]
    unless _file
      gutil.log("gulprev.jade_parser can't find #{absurl}")
      return attr
    relurl = libpath.relative output, _file.path
    attr.val = toReplace val, relurl, attr.val
    attr

  P::parseExpr = ->
    res = parseExpr.apply this, arguments

    rxResource = /\.(jpg|jpeg|png|gif|webp|svg|ico|js|css|woff|oef|ttf|bmp)/
    switch res.name
      when "img" then res.attrs.forEach (attr)->
        return unless attr.name is "src"
        processAttr attr

      when "link" then res.attrs.forEach (attr)->
        return unless attr.name is "href"
        processAttr attr

      when "script" then res.attrs.forEach (attr)->
        if attr.name is "src"
          processAttr attr
        else if attr.name is "data-main"
          attr.val = attr.val.replace /^(\'|\")(.+)(\'|\")/, "$1$2.js$3"
          attr = processAttr attr
          attr.val = attr.val.replace /\.js$/, ""
      when "meta" then res.attrs.forEach (attr)->
        if attr.name is "content"
          if rxResource.test attr.val.toLowerCase()
            processAttr attr

    res
  P

module.exports = gulprev
