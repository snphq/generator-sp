var path = require('path');
var helpers = require('yeoman-test');
var assert = require('yeoman-assert');

function inDirectory(path, files) {
  return files.map(function (file) {
    return path + '/' + file;
  });
}

function viewFiles(path, name) {
  var extensions = [
    'js',
    'jade',
    'sass',
    'package',
  ];
  var shortName = name.replace(/^_/, '');
  return inDirectory(path, extensions.map(function (ext) {
    return name + '/' + ((ext === 'package') ? 'package.json' : (shortName + '.' + ext));
  }));
}

describe('sp generator', function () {
  it('the generator can be required without throwing', function () {
    this.app = require('../generators/app');
  });

  describe('run test', function () {
    var expectedContent = [
      ['bower.json', /"name": "projects"/],
      ['package.json', /"name": "projects"/],
    ];

    var dotFiles = [
      '.bowerrc',
      '.editorconfig',
      '.coffeelintrc',
      '.gitignore',
      '.gitattributes',
      '.gulpconfig.coffee',
      '.yo-rc.json',
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
        'jqueryPatch.coffee',
        'ShareConstructor.coffee',
        'SWFConstructor.coffee',
        'ViewMixin.js',
      ])
    );

    var projectFiles = [
      'package.json',
      'bower.json',
      'gulpfile.js',
      'haproxy-config.txt',
      'karma.conf.js',
      'gulp/requireChild.coffee',
      'gulp/tasks/.gitkeep',
    ].concat(
      inDirectory('webpack', [
        '_aliases.coffee',
        'build.coffee',
        'dev.coffee',
        'test.coffee',
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
        'ServerApi.js',
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
        'app/styles/',
        'app/html/',
      ]
    );

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
        .withGenerators([[helpers.createDummyGenerator(), 'git-init']]);
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
