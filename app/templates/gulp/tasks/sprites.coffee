gulp = require 'gulp'
libpath = require 'path'
fs = require 'fs'
_ = require 'lodash'
Merge = require 'merge-stream'
$ =
  concat: require 'gulp-concat'
  sprites: require 'gulp.spritesmith'

helpers = require '../helpers'
PROP = require '../config'

getSprites = ->
  rootDir = PROP.path.sprites 'path'
  spritesDirsMap = {}
  for dir in fs.readdirSync rootDir
    path = libpath.join rootDir, dir
    continue unless (fs.lstatSync path).isDirectory()
    path = "#{path}/*"
    spritesDirsMap[dir] = {
      name: dir
      path
      settings: PROP.sprites.get dir
    }
  spritesDirsMap

module.exports = (cb)->
  mergedCss = Merge()
  streams = {}
  sprites = getSprites()
  mergedCss.add helpers.emptyStream "file.scss"
  for name, opts of sprites
    stream = gulp.src(opts.path).pipe $.sprites opts.settings
    stream.img.pipe gulp.dest PROP.path.sprites "dest_images"
    mergedCss.add stream.css
    if opts.settings.cssFormat is 'json' and opts.settings.destCSS
      stream.css.pipe gulp.dest opts.settings.destCSS
    else
      mergedCss.add stream.css
  mergedCss
    .pipe $.concat ('_sprites.scss')
    .pipe gulp.dest PROP.path.sprites "dest_styles"

