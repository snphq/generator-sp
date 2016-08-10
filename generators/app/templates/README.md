## Project features

* automatic project build by [npm](https://www.npmjs.com) and [webpack](https://webpack.github.io/)
* [postcss](https://github.com/postcss/postcss) and cssnext(http://cssnext.io/) support
* [ES6](http://www.ecma-international.org/ecma-262/6.0/) support
* [jade](http://jade-lang.com/) support
* built-in proxy-server for remote backend API access and configuration for using [haproxy](http://www.haproxy.org/)
* *.js, *.css files validation
* [editorconfig](http://editorconfig.org/)
* [capistrano](http://capistranorb.com)


## First launch

You should have installed [Node.js](http://nodejs.org/) version >= 5
Check version of node by running
```bash
$ node -v
```

You should install npm packages by running command below in project root directory
```bash
$ npm i
```

You should have installed [ruby](https://www.ruby-lang.org/)
Check version of ruby by running
```bash
$ ruby -v
```

You should have installed ruby gem [bundler](https://www.ruby-lang.org/) by running
```bash
$ gem install bundler
```

You should install gems by running command below in project root directory
```bash
$ bundle
```


## Project structure

| Directory / file  | Comment |
| ------------------ | ---------- |
| `.tmp/ `| directory for temporary build files |
| `app/  `| all sources of project |
| `config/ `| deploy configuration |
| `dist/ `| project build for test server |
| `node_modules/` | node.js modules required for project |
| `prod/ `| project build for production server |
| `webpack/` | webpack configuration files |
| `.coffeelintrc` | coffee linter settings <http://www.coffeelint.org/>|
| `.editorconfig`| formatting settings <http://editorconfig.org/> |
| `.styleelintrc` | css linter settings <https://github.com/stylelint/stylelint>|
| `Capfile` | Capistrano configuration file |
| `haproxy-config.txt` | proxy-server configuration file |
| `karma.conf.js` | karma runner settings |
| `package.json` | node.js packages list |
Part of files isn't described for understanding facilitating.

`app` directory structure:

| Directory / file  | Comment |
| --------------- | ----------- |
| `files/` | files, which should be avaliable on site and be without changes |
| `fonts/` | font files |
| `html/` | html-pages templates |
| `images/` | images |
| `scripts/` | scripts |
| `└── __test__` | tests |
| `└── component` | universal components |
| `└── localization` | files with translations |
| `└── packages` | packages |
| `└── page` | pages components |
| `└── utils` | utilities |
| `└── app.js` | application file |
| `└── main.js` | entry-point file |


## Commands

There are console commands below for project development

|Command | Clarification|
|------- | ---------|
|`npm run dev` | Launch project in development mode with hot reloader.|
|`npm run test` | Run project tests once.|
|`npm run tdd` | Launch project in TDD mode. Every code change cause tests run.|
|`npm run dist` | Build project for test server in directory `dist`.|
|`npm run prod` | Build project for production server in directory `prod`.|
|`bundle exec cap (testing|production) deploy:setup`| Preparing test/production server for project deployment (runs once before first deploy)|
|`bundle exec cap (testing|production) deploy` | Deploy test/production build on test/production server.|
