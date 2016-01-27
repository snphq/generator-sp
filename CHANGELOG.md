# Change Log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
- Add generator-git-init into npm local dependencies.

## [1.0.1] - 2016-01-22
- Remove extra_js from default tasks list
- Fix dotfiles copying(.gitignore wasnt copied)
- Add compression on build for generated project
- Add `--modal` option in view generator
- Add test generator.
- Remove bower dependencies.
- Add npm packages: bootstrap, font-awesome, reset.css, sp-utils-paginatecollection, imports-loader.
- Add test for check unexpected files (bower.json, .bowerrc, favicon.ico, bootstrap file).
- Change dependencies installation (remove bower).

## [1.0.0] - 2016-01-20
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
