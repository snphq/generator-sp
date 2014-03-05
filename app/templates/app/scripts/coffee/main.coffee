# Обязательно для указания относительного пути на папку bower_components
# Использование переиенной VENDOR_PATH
# При сборке проекта, происходит модификация файла
VENDOR_PATH = "../bower_components"

require.config
  paths:
    # VENDOR_PATH обязателен для использования
    jquery: "#{VENDOR_PATH}/jquery/jquery"
    backbone: "#{VENDOR_PATH}/backbone/backbone"
    underscore: "#{VENDOR_PATH}/lodash/dist/lodash"
    epoxy: "#{VENDOR_PATH}/backbone.epoxy/backbone.epoxy"
    "backbone-mixin": "#{VENDOR_PATH}/backbone-mixin/build/backbone-mixin"
    bootstrap: "#{VENDOR_PATH}/bootstrap-sass/dist/js/bootstrap"
  packages:[
    "view/layout"
    "view/widget"
    "view/modal"
    "view/page"
    "packages/social"
  ]
  shim:
    preprocess:
      exports:"PREPROCESS"
    bootstrap:
      deps:["jquery"]

require ["App", "common", "preprocess"], (App, common, preprocess) ->
  "use strict"

  KEY = preprocess.GA
  _gaq = window._gaq = window._gaq || [];
  _gaq.push ['_setAccount', KEY]
  _gaq.push ['_trackPageview']
  `
  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
  `
  common.app = new App common, _gaq
  common.app.start()
