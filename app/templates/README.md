# Скелет frontend проекта

## Особенности

* автоматическая сборка проекта с помощью [gulpjs](http://gulpjs.com/)
* автоматизированная установка frontend-библиотек с использование [bower](http://bower.io/)
* поддерка [libsass](http://sass-lang.com/libsass)
* поддержва [coffeescript](http://coffeescript.org/)
* шаблонизатор [jade](http://jade-lang.com/)
* встроенный proxy-сервер, для доступа к удаленному backend api и также конфиг для использования внешнего [haproxy](http://www.haproxy.org/)
* проверка валидности  используемых *.js и *.coffee файлов
* [editorconfig](http://editorconfig.org/)


## Быстрый старт

Для работы с проектом необходимо иметь установленный [node.js](http://nodejs.org/), [gulpjs](http://gulpjs.com/) и [bower](http://bower.io/).

[bower](http://bower.io/) являtтся модулем node.js поэтому его установка возможна только после того, как установлен node.js.

```bash
$ npm install bower -g
```
Для старта приложения достаточно ввести
```bash
$ gulp
```


Для упрощения настройки приложения наиболее важные опции вынесены файл `.gulpconfig.json`. Ниже приведена структура файла.

```coffeescript
module.exports =
  app: "app"
  extras:[]  #список для копирования файлов при сборке проекта
  scripts:[] #список для копирования скриптов при сборке проекта

  server:
    host: "0.0.0.0"
    port: 9000
    fallback: "index.html"
  # настройки автоматического открытия окна браузера при запуске таска
  open: 
    host: "localhost"
    port: 9001
    path: "/"

  # Use spritesmith options to configure for each sprite   https://github.com/twolfson/gulp.spritesmith#documentation
  sprites: {
    # icons:
    #   cssFormat: 'css'
  }
  
  #настройки прокси для доступа к api приложения, расположенного на другом хосте
  proxy:  
    port: 9001
    remotes:
      dist:
        #вкл/выкл
        active: true                
        #траслируемый хост
        host: "project.t.snpdev.ru" 
        port: 80
        #использование https
        https: false                
      prod:
        active: true
        host: "google.ru"
        port: 80
        https: false
    # список серверов к которым возможно подключаться через proxy
    routers:
      dist:
        "wiki/Main_Page$":
          host:"en.wikipedia.org"
          port:80
          https:false
      prod:
        "wiki/Main_Page$":
          host:"en.wikipedia.org"
          port:80
          https:false
```

В данныл файл необходимо вносить глобальные настройки проекта.

## Структура проекта

Ниже представлена структура проекта с пояснениями. Плюсом отмечены важные файлы и директории.

```
.tmp
+app - здесь расположены все исходные файлы
  bower_components - библиотеки устновленные через bower находятся здесь
  html - шаблоны генерируемых html-страниц. содержимое данной директори собирается в корень проекта
  images - изображения
  scripts - скрипты в формате coffeescript
  	main.coffee
  styles - стили
  	main.sass
  templates - родительские jade шаблоны 
  robots.txt  
+dist - в данную директорию gulp помещает собранный проект в develop mode
+production - в данную директорию gulp помещает собранный проект в production mode
node_modules - модули node.js, нужные для работы gulp
tasks
bowerrc
+.editorconfig - настройки форматирования для данного проекта
.gitattributes
.gitignore
+.gulpconfig.json - важные настройки gulp
+bower.json - конфигурационный файл bower, содержит список frontend библиотек и расширений подключенных к проекту
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
`bower install` | Установка frontend библиотек, укзанных в `bower.json`
`bower search jque` | Поиск в репозитории расширений, содержащих подстроку 'jque'
`bower install jquery` | Установка указанной библиотеки
`bower install jquery --save` | Установка указанной библиотеки и сохранения записи об этом в `bower.json`
`gulp` | Запуск gulp в режиме сервера. При изменениях в исходных файлах происходит перезагрузка страницы в браузере. Вся разработка должна происходить в данном режиме
`gulp --mode dist` | Аналогичен `gulp`, но сервер отдает файлы из директории `dist`. Данный режим важен для тестирования реализованного функцила перед выгрузкой проекта на тестовый сервер. Для внесения изменения сервер нужно перезагрузить
`gulp --mode production` | Аналогичен `gulp`, но сервер отдает файлы из директории `production`. Данный режим важен для тестирования реализованного функцила перед выгрузкой проекта на тестовый сервер. Для внесения изменения сервер нужно перезагрузить
`gulp --mode dist --build` | Сборка проекта без старта сервера
