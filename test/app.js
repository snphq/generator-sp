var path = require('path');
var helpers = require('yeoman-generator').test;
var assert = require('yeoman-generator').assert;

describe('sp generator', function () {
  it('the generator can be required without throwing', function () {
    this.app = require('../generators/app');
  });

  describe('run test', function () {
    var expectedContent = [
      ['bower.json', /"name": "projects"/],
      ['package.json', /"name": "projects"/],
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
      'haproxy-config.txt',
      'config/deploy/production.rb',
      'config/deploy/testing.rb',
      'config/deploy.rb',
      'config/deploy.rb',
      'app/scripts/main.coffee',
      'app/scripts/app.coffee',
      'app/scripts/common.coffee',
      'app/scripts/Router.coffee',
      'app/scripts/view/page/IndexPage/IndexPage.coffee',
      'app/scripts/view/page/IndexPage/IndexPage.jade',
      'app/scripts/view/page/IndexPage/IndexPage.sass',
      'app/scripts/view/page/Error404Page/Error404Page.coffee',
      'app/scripts/view/page/Error404Page/Error404Page.jade',
      'app/scripts/view/page/Error404Page/Error404Page.sass',
      'app/images/',
      'app/styles/',
    ];

    var options = {
      'skip-install-message': true,
      'skip-install': true,
      'skip-welcome-message': true,
      'skip-message': true,
    };

    var runGen;

    beforeEach(function () {
      runGen = helpers
        .run(path.join(__dirname, '../generators/app'))
        .inDir(path.join(__dirname, '.tmp'))
        .withGenerators([[helpers.createDummyGenerator(), 'mocha:app']]);
    });

    it('creates expected files', function (done) {
      runGen.withOptions(options).on('end', function () {
        assert.file(expected);
        assert.noFile([
        ]);
        assert.fileContent(expectedContent);
        done();
      });
    });
  });
});
