// Обязательно для указания относительного пути на папку bower_components
// Использование переиенной VENDOR_PATH
// При сборке проекта, происходит модификация файла

// Если планируется использовать javascript в проекте нужно удалить все *.coffee файлы в каталоге  app/scripts/

var VENDOR_PATH;
VENDOR_PATH = '../bower_components';

require.config({
    paths: {
        jquery: VENDOR_PATH + '/jquery/jquery' // VENDOR_PATH обязателен для использования
    },
    shim: {
      preprocess: {
        exports: 'PREPROCESS'
      }
    }
});

require(['app', 'jquery', 'preprocess'], function (app, $, PREPROCESS) {
    'use strict';
    // use app here

    console.log(PREPROCESS);
    console.log(app);
    console.log('JS: Running jQuery %s', $().jquery);
});
