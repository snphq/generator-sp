module.exports =
  app: "app"
  dist: "dist"
  tmpPath: ".tmp"
  scriptlang:"<%= scriptType %>" #js|coffee
  templatelang:"<%= templateType %>" #swig|jade

  open:
    server:
      host: "localhost"
      path: "/index.html"

  swig:
    params:{}

  copy:[]
  copy_deps:[]

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
