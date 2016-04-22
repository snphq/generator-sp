# Change Log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
- Change .stylelintrc from JSON to YAML
- Add html-webpack-plugin in package.json
- Change loader for images - url-loader
- Add path 'files' to webpack aliases config

## [2.1.0] - 2016-02-25
- Remove all gulp dependencies
- Remove snp-gulp-task styles dependency.
- Remove folder app/styles.
- Remove font-awesome.
- Migrate to cssnext PostCSS, add plugins:
    - postcss-assets,
    - postcss-bem,
    - postcss-browser-reporter,
    - postcss-cssnext,
    - postcss-import,
    - postcss-size,
    - postcss-svgo,
    - stylelint.
- Migrate from coffee script to ES6 in webpack configs.

## [2.0.3] - 2016-02-01
- Update phantomjs
- Change autoprefixer-loader package to postcss-loader.
- Fix pushState bug.
- Update generator-git-init and use `commit` option to create initial commit on app create

## [2.0.2] - 2016-01-28
- Add generator-git-init into npm local dependencies.
- Add common.js exporting method in es6 modules

## [2.0.1] - 2016-01-22
- Remove extra_js from default tasks list
- Fix dotfiles copying(.gitignore wasnt copied)
- Add compression on build for generated project
- Add `--modal` option in view generator
- Add test generator.
- Remove bower dependencies.
- Add npm packages: bootstrap, font-awesome, reset.css, sp-utils-paginatecollection, imports-loader.
- Add test for check unexpected files (bower.json, .bowerrc, favicon.ico, bootstrap file).
- Change dependencies installation (remove bower).

## [2.0.0] - 2016-01-20
 - Add webpack configuration
 - Add tests in generated project(karma, mocha, chai, sinon)
 - Add precommit hooks for tests and linter(xo) in generated project
 - Add precommit hooks for tests and linter(xo) in this project
 - Remove validate generator as unneeded
 - Add tests for all generators
 - Change view generator logic. Now we can create views not only in root directory.
 - Add deperecation check for old projects
 - Update dependencies and fix deperecation warnings.
 - Add webpack-modernizr. It can be tuned for project needs in `/webpack/_modernizr.coffee`. Disabled by default.

## Ananchy - 2014-01-15-2016-01-18

Unfortunately, there were no changelog before 2016-01-18. Nowbody can reconstruct log of all changes and its reasons authentically. Despite all thanks to project contributors:
 - @lexich
 - @maximkoretskiy
 - @RomanovRoman
 - @donbobka
 - @i-suhar
