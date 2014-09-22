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
    'sp-utils-middleware':"#{VENDOR_PATH}/sp-utils-middleware/build/Middleware"
    "sp-utils-serverclient":"#{VENDOR_PATH}/sp-utils-serverclient/build/ServerClient"
    "sp-utils-gaconstructor":"#{VENDOR_PATH}/sp-utils-gaconstructor/build/GAConstructor"
    "sp-utils-bootstrapmodal":"#{VENDOR_PATH}/sp-utils-bootstrapmodal/build/BootstrapModal"
    "sp-utils-paginatecollection":"#{VENDOR_PATH}/sp-utils-paginatecollection/build/PaginateCollection"
    #bootstrap see bootstrap.coffee file to include all deps
    'bootstrap/affix':"#{VENDOR_PATH}/bootstrap-sass-official/assets/javascripts/bootstrap/affix"
    'bootstrap/alert':"#{VENDOR_PATH}/bootstrap-sass-official/assets/javascripts/bootstrap/alert"
    'bootstrap/button':"#{VENDOR_PATH}/bootstrap-sass-official/assets/javascripts/bootstrap/button"
    'bootstrap/carousel':"#{VENDOR_PATH}/bootstrap-sass-official/assets/javascripts/bootstrap/carousel"
    'bootstrap/collapse':"#{VENDOR_PATH}/bootstrap-sass-official/assets/javascripts/bootstrap/collapse"
    'bootstrap/dropdown':"#{VENDOR_PATH}/bootstrap-sass-official/assets/javascripts/bootstrap/dropdown"
    'bootstrap/modal':"#{VENDOR_PATH}/bootstrap-sass-official/assets/javascripts/bootstrap/modal"
    'bootstrap/popover':"#{VENDOR_PATH}/bootstrap-sass-official/assets/javascripts/bootstrap/popover"
    'bootstrap/scrollspy':"#{VENDOR_PATH}/bootstrap-sass-official/assets/javascripts/bootstrap/scrollspy"
    'bootstrap/tab':"#{VENDOR_PATH}/bootstrap-sass-official/assets/javascripts/bootstrap/tab"
    'bootstrap/tooltip':"#{VENDOR_PATH}/bootstrap-sass-official/assets/javascripts/bootstrap/tooltip"
    'bootstrap/transition':"#{VENDOR_PATH}/bootstrap-sass-official/assets/javascripts/bootstrap/transition"
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
