var path = require('path');
var helpers = require('yeoman-test');
var assert = require('yeoman-assert');
var fixture = require('./_helpers').fixture;
var viewFiles = require('./_helpers').viewFiles;

function createGenerator(args) {
  args = args.split(' ');
  return helpers.run(path.join(__dirname, '../generators/view'))
    .withArguments(args)
    .withLocalConfig({webpack: true});
}

describe('view', function () {
  it('creates page with full path', function (done) {
    createGenerator('page/sample')
    .on('end', function () {
      assert.file(viewFiles('app/scripts/page', 'Sample'));
      assert.fileContent([
        ['app/scripts/page/Sample/Sample.js', fixture('Sample/Sample.js')],
        ['app/scripts/page/Sample/Sample.css', '@b p-sample {\n}'],
        ['app/scripts/page/Sample/Sample.jade', '.p-sample'],
        ['app/scripts/page/Sample/package.json', '"main": "./Sample.js"'],
      ]);
      done();
    });
  });

  it('creates component with full path', function (done) {
    createGenerator('component/Example')
    .on('end', function () {
      assert.file(viewFiles('app/scripts/component', 'Example'));
      assert.fileContent([
        ['app/scripts/component/Example/Example.jade', '.example'],
      ]);
      done();
    });
  });

  it('creates component with short path', function (done) {
    createGenerator('demo')
    .on('end', function () {
      assert.file(viewFiles('app/scripts/component', 'Demo'));
      done();
    });
  });

  it('creates component with complex name consistently', function (done) {
    createGenerator('demoListViewSample')
    .on('end', function () {
      assert.fileContent([
        ['app/scripts/component/DemoListViewSample/DemoListViewSample.css', 'demo-list-view-sample'],
      ]);
      done();
    });
  });

  it('supports root directory shortcuts for page', function (done) {
    createGenerator('p/demo/index')
    .on('end', function () {
      assert.file(viewFiles('app/scripts/page/demo', 'Index'));
      done();
    });
  });

  it('supports root directory shortcuts for component', function (done) {
    createGenerator('c/demo/index')
    .on('end', function () {
      assert.file(viewFiles('app/scripts/component/demo', 'Index'));
      done();
    });
  });

  it('should not create view not in component or page', function (done) {
    createGenerator('guano/index')
    .on('end', function () {
      assert.noFile(viewFiles('app/scripts/guano', 'Index'));
      done();
    });
  });

  it('should set valid base class for page', function (done) {
    createGenerator('p/alfa').on('end', function () {
      assert.fileContent([
        ['app/scripts/page/Alfa/Alfa.js', /import _Base from 'page\/_Base'/],
      ]);
      done();
    });
  });

  it('should set valid base class for component in page', function (done) {
    createGenerator('p/Index/alfa').on('end', function () {
      assert.fileContent([
        ['app/scripts/page/Index/Alfa/Alfa.js', /import _Base from 'component\/_Base'/],
      ]);
      done();
    });
  });
  it('should set valid base class for component', function (done) {
    createGenerator('component/alfa').on('end', function () {
      assert.fileContent([
        ['app/scripts/component/Alfa/Alfa.js', /import _Base from 'component\/_Base'/],
      ]);
      done();
    });
  });

  it('should set valid base class for subcomponent', function (done) {
    createGenerator('component/alfa/beta').on('end', function () {
      assert.fileContent([
        ['app/scripts/component/alfa/Beta/Beta.js', /import _Base from 'component\/_Base'/],
      ]);
      done();
    });
  });

  it('should create modalView if option --modal set', function (done) {
    createGenerator('testModal')
    .withOptions({modal: true})
    .on('end', function () {
      assert.fileContent([
        ['app/scripts/component/TestModal/TestModal.js', fixture('TestModal/TestModal.js')],
      ]);
      done();
    });
  });
});
