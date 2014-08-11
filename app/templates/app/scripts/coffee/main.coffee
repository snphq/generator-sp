# Обязательно для указания относительного пути на папку bower_components
# Использование переиенной VENDOR_PATH
# При сборке проекта, происходит модификация файла
VENDOR_PATH = "../bower_components"

require.config
  paths:
    # VENDOR_PATH обязателен для использования
    jquery: "#{VENDOR_PATH}/jquery/dist/jquery"
    backbone: "#{VENDOR_PATH}/backbone/backbone"
    underscore: "#{VENDOR_PATH}/lodash/dist/lodash"
    epoxy: "#{VENDOR_PATH}/backbone.epoxy/backbone.epoxy"
    "backbone-mixin": "#{VENDOR_PATH}/backbone-mixin/build/backbone-mixin"
    bootstrap: "#{VENDOR_PATH}/bootstrap-sass/dist/js/bootstrap"
    'sp-utils-middleware':"#{VENDOR_PATH}/sp-utils-middleware/build/Middleware"
    "sp-utils-serverclient":"#{VENDOR_PATH}/sp-utils-serverclient/build/ServerClient"
    "sp-utils-gaconstructor":"#{VENDOR_PATH}/sp-utils-gaconstructor/build/GAConstructor"
    "sp-utils-bootstrapmodal":"#{VENDOR_PATH}/sp-utils-bootstrapmodal/build/BootstrapModal"
  packages:[
    "view/layout"
    "view/widget"
    "view/modal"
    "view/page"
    "view/list"
    "packages/social"
  ]
  shim:
    preprocess:
      exports:"PREPROCESS"
    bootstrap:
      deps:["jquery"]

require ["App", "common"], (App, common) ->
  common.app = new App common
  common.app.start()
