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
