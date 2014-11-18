through2 = require "through2"
crypto = require "crypto"
gutil = require "gulp-util"
libpath = require "path"

CACHE =
  image:{}
  font:{}
  js:{}
  css:{}

gulprev = (cache={}, processKey)-> through2.obj (file, enc, callback)->
  md5 = crypto.createHash("md5")
  md5.update file.contents
  key = if processKey? then processKey file else file.relative
  cache[key] = md5.digest("hex")
  @push file
  callback()

gulprev.cache = CACHE

gulprev.rev =
  src: (_url, hash)->
    urls = _url.split("#")
    url = urls[0]
    if url.indexOf("?") > -1
      url += "&"  unless url[url.length-1] in ["&","?"]
    else url += "?"
    url += "rev=" + hash
    url = [url].concat(urls[1..]).join("#")

  url: (_url, hash)->
    "url(" + @src(_url, hash) + ")"

  key: (url, callback)->
    res = url.split("?")[0].split("#")[0]
    if callback? then callback res else res

  rxImage: /^\.{0,2}\/?images\//
  rxCss: /\/?styles\//

gulprev.postcss = (css)->
  _this = gulprev.rev
  css.eachDecl (decl, data)->
    rxUrlsplit = /url\(([^\)]+)\)/g
    clean = (val)->
      val = val.replace /["']/g, ""

    if (decl.prop.indexOf("background") is 0 or decl.prop.indexOf("border-image") is 0) and decl.value.indexOf("url") >= 0
      value = decl.value.replace rxUrlsplit, (orig, $1)->
        $1 = clean $1
        url = $1.replace _this.rxImage, ""
        if(hash = CACHE.image[url]) then _this.url $1, hash
        else orig
      decl.value = value

    if decl.prop.indexOf("src") == 0 and decl.value.indexOf("url") >= 0
      value = decl.value.replace rxUrlsplit, (orig, $1)->
        $1 = clean $1
        basename = libpath.basename($1).split("?")[0].split("#")[0]
        if(hash = CACHE.font[basename])
          [_this.url($1, hash)].join("/")
        else orig
      decl.value = value

gulprev.html = ($)->
  _this = gulprev.rev
  $("img").each ->
    $el = $(this)
    src = $el.attr("src")
    key = src.replace _this.rxImage, ""
    if(hash = CACHE.image[key])
      src = _this.src(src, hash)
      $el.attr {src}
    else
      gutil.log(
        gutil.colors.red("html processing fail <img>")
        key, src
      )

  $("link").each ->
    $el = $(this)
    href = $el.attr("href")
    key = _this.key href
    switch libpath.extname(key)
      when ".css"
        key = key.replace _this.rxCss, ""
        cache = CACHE.css
      when ".ico"
        return
      else
        key = key.replace _this.rxImage, ""
        cache = CACHE.image
    if(hash = cache[key])
      href = _this.src href, hash
      $el.attr {href}
    else
      gutil.log(
        gutil.colors.red("html processing fail <link>")
        key, src
      )
  process_script = ($el, name, process)->
    _src = $el.attr name
    return unless _src
    _src = process _src if process?
    key = _this.key _src, (src)->
      if src[0] is "/" then src[1..]
      else src

    if(hash = CACHE.js[key])
      src = _this.src _src, hash
      $el.attr name, src
    else
      gutil.log(
        gutil.colors.red("html processing fail <script>")
        _src
      )

  $("script").each ->
    $el = $(this)
    process_script $el, "src"
    process_script $el, "data-main", (src)->
      src + ".js"

module.exports = gulprev
