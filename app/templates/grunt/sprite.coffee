config = sprite:{}

addTask = (name, format, path, template)->
  config.sprite["tsk_#{name}"] =
    src: ["<%= yeoman.app %>/images/#{path}/*.*"]
    destImg: "<%= yeoman.app %>/images/sprites/#{name}.#{format}"
    imgPath: "/images/_sprites/#{name}.#{format}"
    destCSS: "<%= yeoman.app %>/styles/sprites/_#{name}.scss"
    algorithm: 'binary-tree'
    padding: 2
    engine: 'gm'
    cssVarMap: (sprite)->
      sprite.name = "#{name}-" + sprite.name;
      sprite
  if template
    config.sprite["tsk_#{name}"].cssTemplate = template

for key, value of OPTIONS.yeoman.sprite
  addTask key, value.format, value.path, value?.template

module.exports = config
