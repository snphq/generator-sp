var path = require('path');
var helpers = require('yeoman-test');
var assert = require('yeoman-assert');

var customHelpers = require('./_helpers');
var inDirectory = customHelpers.inDirectory;
var viewFiles = customHelpers.viewFiles;

describe('sp generator', function () {
  it('the generator can be required without throwing', function (done) {
    this.app = require('../generators/app');
    done();
  });

  describe('run test', function () {
    var expectedContent = [
      ['package.json', /"name": "projects"/],
    ];

    var dotFiles = [
      '.editorconfig',
      '.coffeelintrc',
      '.gitignore',
      '.gitattributes',
      '.yo-rc.json',
      '.stylelintrc',
    ];

    var capFiles = [
      'Capfile',
      'Gemfile',
      'Gemfile.lock',
      'config/deploy/production.rb',
      'config/deploy/testing.rb',
      'config/deploy.rb',
    ];

    var legacyFiles = inDirectory('app/scripts/packages/social', [
      'FBApi.coffee',
      'OKApi.coffee',
      'VKApi.coffee',
      'SocialApi.coffee',
      'main.coffee',
    ]).concat(
      inDirectory('app/scripts/packages/social', [
        'FBApi.coffee',
        'OKApi.coffee',
        'VKApi.coffee',
        'SocialApi.coffee',
        'main.coffee',
      ]),
      inDirectory('app/scripts/utils', [
        'jqueryPatch.js',
        'ShareConstructor.js',
        'SWFConstructor.js',
        'ViewMixin.js',
      ])
    );

    var projectFiles = [
      'package.json',
      'haproxy-config.txt',
      'karma.conf.js',
      'run-dev.js',
      'run-build.js',
    ].concat(
      inDirectory('webpack', [
        '_aliases.js',
        '_config.js',
        '_modernizr.js',
        '_postcss.js',
        'build.js',
        'dev.js',
        'test.js',
      ])
    );

    var expected = [
      'app/scripts/__test__/test.js',
    ].concat(
      dotFiles,
      projectFiles,
      capFiles,
      inDirectory('app/scripts', [
        '_BaseView.js',
        'main.js',
        'app.js',
        'common.js',
        'Router.js',
        'preprocess.js',
        'ServerAPI.js',
      ]),
      inDirectory('app/scripts/localization', [
        'Localization.js',
        'ru.js',
      ]),
      // one cup of legacy
      legacyFiles,
      // pages
      inDirectory('app/scripts/page/_Base', ['Base.js', 'package.json']),
      viewFiles('app/scripts/page', 'Index'),
      viewFiles('app/scripts/page/Index', 'Share'),
      viewFiles('app/scripts/page', 'Error404'),
      // views
      inDirectory('app/scripts/component/_Base', ['Base.js', 'package.json']),
      viewFiles('app/scripts/component', '_Modal'),
      viewFiles('app/scripts/component', 'AuthModal'),
      viewFiles('app/scripts/component', 'Layout'),
      [
        'app/images/',
        'app/html/',
      ]
    );

    var unexpected = [
      'bower.json',
      '.bowerrc',
    ].concat(
      inDirectory('app', [
        'favicon.ico',
        'styles/',
        'images/_sprites',
      ])
    );

    var options = {
      'skip-install-message': true,
      'skip-install': true,
      'skip-welcome-message': true,
      'skip-message': true,
    };

    before(function (done) {
      helpers
        .run(path.join(__dirname, '../generators/app'))
        .withOptions(options).on('end', done);
    });

    it('creates expected files', function () {
      assert.file(expected);
      assert.fileContent(expectedContent);
    });

    it('dont creates unexpected files', function () {
      assert.noFile(unexpected);
    });

    it('sets webpack=true in config', function () {
      assert.fileContent('.yo-rc.json', /\"webpack\": true/);
    });
  });
});
