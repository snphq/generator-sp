through2 = require "through2"
gutil = require "gulp-util"
libpath = require "path"
postcss = require "postcss"
urldata = require "urldata"
atImport = require "postcss-import"
fs = require "fs"
_ = require "lodash"
crypto = require "crypto"
sass = require "node-sass"

toHash = (contents)->
  crypto.createHash("md5").update(contents).digest("hex")[..8]

resource = (vendor_folder="vendor", external_folter="app/bower_components")-> through2.obj (file, enc, cb)->
  resource.DATA.vendor_folder = vendor_folder
  resource.DATA.external_folter = external_folter
  try
    result = postcss().use(
      atImport(
        transform: (data, filename)->
          if /\.scss$/.test filename
            data = sass.renderSync {
              file: filename
            }
          try
            result = postcss().use(
              resource.postcss_loader
            ).process(
              data, {filename, vendor_folder, external_folter}
            ).css
          catch e
            gutil.log  e
            result = data
          result
      )
    ).process(file.contents).css
  catch e
    gutil.log e
    result = ""
  file.contents = new Buffer(result)
  @push file
  cb()

resource.download = -> through2.obj (file, enc, cb)->
  resource.DATA.each (file)=>
    @push file
  cb()

analyse = (decl, vendor_folder, root, prefix)->
  urldata(decl.value).forEach (_item)->
    return if _item.indexOf(";base64,iVBORw0") > -1
    item = _item.split("?")[0].split("#")[0]

    realpath = libpath.resolve root, item
    contents = resource.DATA.getContent(realpath)
    item_hash = toHash(contents)
    item_ext = libpath.extname(item)
    item_name = libpath.basename(item,item_ext)
    virtualpath = libpath.join(
      vendor_folder, prefix,
      "#{item_name}-#{item_hash}#{item_ext}"
    )
    csspath = libpath.join "..", virtualpath
    decl.value = decl.value.replace item, csspath
    resource.DATA.push realpath, virtualpath

resource.postcss_loader = (css, {filename, vendor_folder, external_folter})->
  abs_external_folder = libpath.resolve ".", external_folter
  relative_filename = libpath.relative abs_external_folder, filename
  prefix = relative_filename.split(libpath.sep)[0]
  root = libpath.dirname(filename)
  css.eachAtRule (atRule)->
    return if atRule.name isnt "font-face"
    atRule.each (decl)->
      return if decl.prop isnt "src"
      analyse(decl, vendor_folder, root, prefix)

  css.eachDecl (decl)->
    isRecource = (
      decl.prop.indexOf("background") > -1 or
      decl.prop.indexOf("border-image") > -1
    )
    analyse(decl, vendor_folder, root, prefix) if isRecource


resource.DATA = {
  buf: []
  download: []
  contents:{}
  vendor_folder:""
  getContent: (realpath)->
    if @contents[realpath]
      @contents[realpath]
    else
      @contents[realpath] = fs.readFileSync(realpath)

  push: (realpath, virtualpath)->
    if _.find @buf, {path:virtualpath}
      return
    contents = @getContent realpath
    file = new gutil.File {
      cwd: ""
      base: ""
      path: virtualpath
      contents
    }
    @buf.push file
    @download.push file

  each: (callback)->
    @download.forEach callback
    @download = []
}


module.exports = resource
