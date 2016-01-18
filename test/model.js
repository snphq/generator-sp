'use strict';
var path = require('path');
var helpers = require('yeoman-test');
var assert = require('yeoman-assert');
var fixture = require('./_helpers').fixture;

describe('sp generator model', function () {
  before(function (done) {
    helpers.run(path.join(__dirname, '../generators/model'))
      .withArguments(['todo'])
      .on('end', done);
  });

  it('creates model', function () {
    assert.fileContent([
      ['app/scripts/model/TodoModel.js', fixture('TodoModel.js')],
    ]);
  });
});
