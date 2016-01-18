'use strict';
var path = require('path');
var fs = require('fs');
var helpers = require('yeoman-generator').test;
var assert = require('yeoman-generator').assert;

function fixture(name) {
  var fixturePath = path.join(__dirname, './fixtures/', name);
  return fs.readFileSync(fixturePath, 'utf-8').trim();
}

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
