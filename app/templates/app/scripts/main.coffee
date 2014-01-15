# Обязательно для указания относительного пути на папку bower_components
# Использование переиенной VENDOR_PATH
# При сборке проекта, происходит модификация файла
VENDOR_PATH = "../bower_components"

require.config
  paths:
    # VENDOR_PATH обязателен для использования
    jquery: "#{VENDOR_PATH}/jquery/jquery"
  shim:
    preprocess:
      exports:"PREPROCESS"

require ["preprocess", "app", "jquery"], (PREPROCESS, app, $) ->
  "use strict"

  # use app here
  console.log PREPROCESS
  console.log app
  console.log "Coffee: Running jQuery %s", $().jquery
