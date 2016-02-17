# Скелет frontend проекта

## Особенности

* автоматическая сборка проекта с помощью [gulpjs](http://gulpjs.com/)
* поддерка [postcss](https://github.com/postcss/postcss)
* поддержка [ES6](http://www.ecma-international.org/ecma-262/6.0/)
* шаблонизатор [jade](http://jade-lang.com/)
* встроенный proxy-сервер, для доступа к удаленному backend api и также конфиг для использования внешнего [haproxy](http://www.haproxy.org/)
* проверка валидности  используемых *.js файлов
* [editorconfig](http://editorconfig.org/)


## Быстрый старт

Для работы с проектом необходимо иметь установленный [node.js](http://nodejs.org/), и [gulpjs](http://gulpjs.com/).

Для старта приложения достаточно ввести
```bash
$ gulp
```


Для упрощения настройки приложения наиболее важные опции вынесены файл `.gulpconfig.json`. Ниже приведена структура файла.

```coffeescript
module.exports =
  app: "app"
  extras:[]
  scripts:[]

  # browserSync settings (http://www.browsersync.io/docs/options/)
  browserSync:
    port: 9000
    open: false

  cdn:
    host: ""

  # Use spritesmith options to configure for each sprite   https://github.com/twolfson/gulp.spritesmith#documentation
  sprites: {
    # icons:
    #   cssFormat: 'css'
  }

  proxy:
    port: 9001
    remotes:
      dist:
        host: "project.snpdev.ru"
        port: 80
        https: false
      prod:
        host: "project.ru"
        port: 80
        https: false
    activeRemote: 'dist'
    pushState: true
    remoteRoutes: [
      /^\/(api|auth|admin|assets|system|rich).*$/
    ]
    localRoutes: [
      /^\/(bower_components|resources|browser\-sync|images|files|scripts|styles|favicon\.ico|robots\.txt|livereload\.js).*$/
    ]

  getDefaultTaskList: ->
    build = ["clean"]
    build.push ["images", "fonts", "extras"] unless @isDev
    build.push "sprites"
    build.push "cssimage"
    build.push "scripts.#{if @isDev then 'dev' else 'prod'}"
    build.push "templates"
    build.push "bs" if @isSrv
    build.push "proxy" if @isSrv
    build.push "watch" if @isSrv and @isDev
    build.push ["imagemin.png"] if @isImageMin
    build.push "revision" unless @isDev
    build.push "git-version" unless @isDev
    build.push "compress" unless @isDev
    build
```

В данный файл необходимо вносить глобальные настройки проекта.

## Структура проекта

Ниже представлена структура проекта с пояснениями. Плюсом отмечены важные файлы и директории.

```
.tmp
+app - здесь расположены все исходные файлы
  html - шаблоны генерируемых html-страниц. содержимое данной директори собирается в корень проекта
  images - изображения
  scripts - скрипты в формате ES6
  	main.js
  styles - стили
  templates - родительские jade шаблоны
  robots.txt  
+dist - в данную директорию gulp помещает собранный проект в develop mode
+production - в данную директорию gulp помещает собранный проект в production mode
node_modules - модули node.js, нужные для работы gulp
+.editorconfig - настройки форматирования для данного проекта
.gitattributes
.gitignore
+.gulpconfig.json - важные настройки gulp
+gulpfile.js - конфигурация gulp.
+gulp - в данной директории хранятся файлы для конфигурации gulp
+package.json - список расширений node.js
README.md - ;)
```

## Быстрая справка

Здесь приведены команы консоли для работы с проектом


Команда | Пояснение
------- | ---------
`npm install` | Установка всех расширений node.js, необходимых для работы gulp.  Обычно выполняется при инициализации проекта единожды
`npm install jquery --save` | Установка указанной библиотеки и сохранения записи об этом в `package.json`
`gulp` | Запуск gulp в режиме сервера. При изменениях в исходных файлах происходит перезагрузка страницы в браузере. Вся разработка должна происходить в данном режиме
`gulp --mode dist` | Аналогичен `gulp`, но сервер отдает файлы из директории `dist`. Данный режим важен для тестирования реализованного функцила перед выгрузкой проекта на тестовый сервер. Для внесения изменения сервер нужно перезагрузить
`gulp --mode production` | Аналогичен `gulp`, но сервер отдает файлы из директории `production`. Данный режим важен для тестирования реализованного функцила перед выгрузкой проекта на тестовый сервер. Для внесения изменения сервер нужно перезагрузить
`gulp --mode dist --build` | Сборка проекта без старта сервера
