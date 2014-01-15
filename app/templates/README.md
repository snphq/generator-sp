# Скелет frontend проекта

## Особенности

* автоматическая сборка проекта с помощью [grunt](http://gruntjs.com/)
* автоматизированная установка frontend-библиотек с использование [bower](http://bower.io/)
* поддерка [sass](http://sass-lang.com/)
* поддержва [coffeescript](http://coffeescript.org/)
* шаблонизатор [swig](http://paularmstrong.github.io/swig/)
* встроенный proxy-сервер, для доступа к удаленному backend api
* проверка валидности  используемых *.js и *.coffee файлов
* [editorconfig](http://editorconfig.org/)


## Быстрый старт

Для работы с проектом необходимо иметь установленный [node.js](http://nodejs.org/), grunt.js и bower.

grunt.js и bower являются модулями node.js поэтому их установка возможна только после того, как установлен node.js.

```bash
$ sudo npm install grunt-cli -g
$ sudo npm install bower -g
```

```bash
$ git clone ssh://git@git.snpdev.ru:42204/s-p-frontend-skel.git <название проекта>
$ cd <название проекта>
$ rm -rf .git
$ npm install && bower install
$ grunt server
```

Для упрощения настройки приложения наиболее важные опции вынесены файл `.gruntconfig.json`. Ниже приведена структура файла.

```javascript
{
  "open": { // настройки автоматического открытия окна браузера при запуске таска `grunt server` 
    "server": {
      "host": "localhost",
      "path": ""
    }
  },
  "copy":[ // список для копирования файлов при сборке проекта в стандратной нотации grunt
    {
      "expand": true,
      "dot": true,
      "cwd": "<%= yeoman.app %>/scripts",
      "dest": ".tmp/coffee",
      "src": "{,*/}*.coffee"
    }
  ],
  "proxy": { // настройки прокси для доступа к api приложения, расположенного на другом хосте
    "port": 9001,
    "alternative": {
      "active": false, // вкл/выкл
      "host": "saltpepper.ru",  //траслируемый хост
      "port": 80,
      "https": false //использование https
    }
    "remotes":{ //список серверов к которым возможно подключаться через proxy
      "test": {
        "active": true, // вкл/выкл
        "host": "yandex.ru", //траслируемый хост
        "port": 80,
        "https": false //использование https
      },
      "production":{
        "active": true,
        "host": "google.ru",
        "port": 80,
        "https": false
      }
    }
  }
}
```

В данныл файл необходимо вносить глобальные настройки проекта. В случае, если у разработчика есть необходисть переопределить некоторые настройки индивидуально, следует создать файл `.gruntconfig.local.json` и задать требующиеся настройки в нем. Данный файл не отслеживается git.

## Структура проекта

Ниже представлена структура проекта с пояснениями. Плюсом отмечены важные файлы и директории.

```
.tmp
+app - здесь расположены все исходные файлы
  bower_components - библиотеки устновленные через bower находятся здесь
  html - шаблоны генерируемых html-страниц. содержимое данной директори собирается в корень проекта
  images - изображения
  scripts - скрипты в формате javascript и coffeescript
  	app.js
  	main.coffee
  styles - стили
  	reset.css
  	main.scss
  templates - родительские шаблоны html.В отличие от шаблонов из директории html, из этих не генерируются файлы
  .htaccess
  robots.txt  
+dist - в данную директорию grunt помещает собранный проект
node_modules - модули node.js, нужные для работы grunt
tasks
bowerrc
+.editorconfig - настройки форматирования для данного проекта
.gitattributes
.gitignore
+.gruntconfig.json - важные настройки grunt
.jshintrc
+bower.json - конфигурационный файл bower, содержит список frontend библиотек и расширений подключенных к проекту
+Gruntfile.coffee - конфигурация grunt. Для решения стандартных задач нет необходимости менять этот файл
+package.json - список расширений node.js
README.md - ;)
```

## Быстрая справка

Здесь приведены команы консоли для работы с проектом


Команда | Пояснение
------- | ---------
`npm install` | Установка всех расширений node.js, необходимых для работы grunt.  Обычно выполняется при инициализации проекта единожды
`bower install` | Установка frontend библиотек, укзанных в `bower.json`
`bower search jque` | Поиск в репозитории расширений, содержащих подстроку 'jque'
`bower install jquery` | Установка указанной библиотеки
`bower install jquery --save` | Установка указанной библиотеки и сохранения записи об этом в `bower.json`
`grunt server` | Запуск grunt в режиме сервера. При изменениях в исходных файлах происходит перезагрузка страницы в браузере. Вся разработка должна происходить в данном режиме
`grunt server:dist` | Аналогичен `grunt server`, но сервер отдает файлы из директории `dist`. Данный режим важен для тестирования реализованного функцила перед выгрузкой проекта на тестовый сервер.
`grunt` | Сборка проекта

К таскам `grunt server` и `grunt server:dist` есть возможность добавить подзадачу `:proxy-<название удаленного сервера>`. Например:

```bash
$ grunt server:proxy-test
```


