'use strict';
var path = require('path');
var helpers = require('yeoman-generator').test;
var assert = require('yeoman-generator').assert;

function createGenerator() {
  return helpers.run(path.join(__dirname, '../generators/collection'))
    .withGenerators([path.join(__dirname, '../generators/model')]);
}

describe('sp generator collection', function () {
  it('creates collection and model if required', function (done) {
    createGenerator()
      .withArguments(['people'])
      .withPrompts({model_generate: true})
      .on('end', function () {
        assert.file([
          'app/scripts/collection/PeopleCollection.coffee',
          'app/scripts/model/PeopleModel.js',
        ]);
        done();
      });
  });

  it('creates only collection', function (done) {
    createGenerator()
      .withArguments(['news'])
      .withPrompts({model_generate: false})
      .on('end', function () {
        assert.file(['app/scripts/collection/NewsCollection.coffee']);
        assert.noFile(['app/scripts/model/NewsModel.js']);
        done();
      });
  });
});
