/*global describe, beforeEach, it*/
'use strict';
var path = require('path');
var assert = require('assert');
var helpers = require('yeoman-generator').test;
var assert = require('yeoman-generator').assert;
var _ = require('underscore');

describe('sp generator', function () {
  it('the generator can be required without throwing', function () {
    this.app = require('../app');
  });

  describe('run test', function () {
    var expectedContent = [
      ['bower.json', /"name": "projects"/],
      ['package.json', /"name": "projects"/]
    ];
    var expected = [
      '.bowerrc',
      '.editorconfig',
      '.coffeelintrc',
      '.gitignore',
      '.gitattributes',
      '.gulpconfig.coffee',
      '.yo-rc.json',
      'package.json',
      'bower.json',
      'gulpfile.js',
      'Capfile',
      'Gemfile',
      'Gemfile.lock',
      'haproxy-config.txt'
    ];

    var options = {
      'skip-install-message': true,
      'skip-install': true,
      'skip-welcome-message': true,
      'skip-message': true
    };

    var runGen;

    beforeEach(function () {
      runGen = helpers
        .run(path.join(__dirname, '../app'))
        .inDir(path.join(__dirname, '.tmp'))
        .withGenerators([[helpers.createDummyGenerator(), 'mocha:app']]);
    });

    it('creates expected files', function (done) {
      runGen.withOptions(options).on('end', function () {
        assert.file([].concat(
          expected,
          // 'app/styles/main.css',
          'app/scripts/main.coffee'
        ));
        assert.noFile([
        ]);
        assert.fileContent(expectedContent);
        done();
      });
    });
  });
});
