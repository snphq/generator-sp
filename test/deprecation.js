'use strict';
var path = require('path');
var helpers = require('yeoman-test');
var assert = require('yeoman-assert');

describe('deprecation', function () {
  it('doesn`t create model in old projects', function (done) {
    var generator = helpers.run(path.join(__dirname, '../generators/model'))
    .withArguments(['todo'])
    .withLocalConfig({});
    generator.on('end', function () {
      assert.noFile([
        'app/scripts/model/TodoModel.js',
      ]);
      done();
    });
  });

  it('doesn`t create collection in old projects', function (done) {
    var generator = helpers.run(path.join(__dirname, '../generators/collection'))
    .withArguments(['todo'])
    .withLocalConfig({});
    generator.on('end', function () {
      assert.noFile([
        'app/scripts/collection/TodoCollection.js',
      ]);
      done();
    });
  });

  it('doesn`t create view in old projects', function (done) {
    var generator = helpers.run(path.join(__dirname, '../generators/view'))
    .withArguments(['todo'])
    .withLocalConfig({});
    generator.on('end', function () {
      assert.noFile([
        'app/scripts/component/Todo/Todo.js',
      ]);
      done();
    });
  });
});
