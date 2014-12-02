through2 = require "through2"
gutil = require "gulp-util"
libpath = require "path"
postcss = require "postcss"
urldata = require "urldata"
atImport = require "postcss-import"
fs = require "fs"
_ = require "lodash"
crypto = require "crypto"

toHash = (contents)->
  crypto.createHash("md5").update(contents).digest("hex")[..8]

resource = (vendor_folder="vendor")-> through2.obj (file, enc, cb)->
  resource.DATA = {
    buf: {}
    vendor_folder
  }
  result = postcss().use(
    atImport(
      transform: (data, filename)->
        result = postcss().use(
          resource.postcss_loader
        ).process(
          data, {filename, vendor_folder}
        ).css
        result
    )
  ).process(file.contents).css
  file.contents = new Buffer(result)
  @push file
  cb()

resource.download = -> through2.obj (file, enc, cb)->
  buf = resource.DATA.buf
  resource.DATA.buf = {}
  for virtualpath, contents of buf
    @push new gutil.File {
      cwd: ""
      base: ""
      path: virtualpath
      contents
    }
  cb()

analyse = (decl, vendor_folder, root, prefix)->
  urldata(decl.value).forEach (_item)->
    return if _item.indexOf(";base64,iVBORw0") > -1
    item = _item.split("?")[0].split("#")[0]

    realpath = libpath.resolve root, item
    contents = fs.readFileSync(realpath)

    item_hash = toHash(contents)
    item_ext = libpath.extname(item)
    item_name = libpath.basename(item,item_ext)
    item_folder = libpath.dirname(item)
    virtualpath = libpath.join(
      vendor_folder, prefix, item_folder,
      "#{item_name}-#{item_hash}#{item_ext}"
    )
    csspath = libpath.join "..", virtualpath
    decl.value = decl.value.replace item, csspath
    resource.DATA.buf[virtualpath] = contents


resource.postcss_loader = (css, {filename, vendor_folder})->
  prefix = libpath.basename(filename)
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
  buf:{}
  vendor_folder:""
}


module.exports = resource
