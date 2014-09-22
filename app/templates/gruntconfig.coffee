module.exports =
  app: "app"
  dist: "dist"
  tmpPath: ".tmp"
  scriptlang:"<%= scriptType %>" #js|coffee
  templatelang:"<%= templateType %>" #swig|jade

  open:
    server:
      host: "localhost:9001"
      path: "/"

  swig:
    params:{}

  copy:[
  #  expand: true
  #  cwd: "<%= yeoman.app %>/bower_components/owl-carousel/owl-carousel/"
  #  src: "owl.carousel.css"
  #  dest: "<%= yeoman.app %>/styles/vendor/owlcarousel/"
  #  rename: (dest, filename, orig)->
  #    dest + filename.replace( /([^\/]+)\.css$/, "_$1.scss")
  #,
  #  expand: true
  #  cwd: "<%= yeoman.app %>/bower_components/owl-carousel/owl-carousel/"
  #  src: ["grabbing.png", "AjaxLoader.gif"]
  #  dest: "<%= yeoman.app %>/images/vendor/owlcarousel/"
  ]
  copy_deps:[]
    #options:
    #  process: (content, srcpath)->
    #    #if /pen\.css$/.test srcpath
    #    #  content.replace "font/fontello", "font/fontello"
    #    #else
    #    content
    #files: []

  sprite:
    all:
      # не занимать путь `sprites`, туда генерируются спрайты
      path: "sprites"
      format: "png"
      # шаблон для генерации стилей, по умолчанию используется другой шаблон, генерирующий миксины
      template: "grunt/spritetemplates/class.scss.mustache"

  proxy:
    port: 9001
    default:"test"
    remotes:
      test:
        active: true
        host: "yandex.ru"
        port: 80
        https: false
      production:
        active: true
        host: "google.ru"
        port: 80
        https: false
    routers:
      test:
        "wiki/Main_Page$":
          host:"en.wikipedia.org"
          port:80
          https:false
      production:
        "wiki/Main_Page$":
          host:"en.wikipedia.org"
          port:80
          https:false
