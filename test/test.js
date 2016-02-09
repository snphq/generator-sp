'use strict';
var path = require('path');
var helpers = require('yeoman-test');
var assert = require('yeoman-assert');
var fixture = require('./_helpers').fixture;

function createGenerator(args) {
  var splitedArgs = args.split(' ');
  return helpers.run(path.join(__dirname, '../generators/test'))
    .withArguments(splitedArgs)
    .withLocalConfig({webpack: true});
}

describe('test', function () {
  it('creates test in root directory', function (done) {
    createGenerator('todo').on('end', function () {
      assert.fileContent([
        ['app/scripts/__test__/todo.js', fixture('test.js')],
      ]);
      done();
    });
  });

  it('creates test in any other directory', function (done) {
    createGenerator('model/NewModel').on('end', function () {
      assert.file([
        'app/scripts/model/__test__/NewModel.js',
      ]);
      done();
    });
  });
});
