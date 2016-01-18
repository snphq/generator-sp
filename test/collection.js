/*global describe, beforeEach, it*/
'use strict';
var path = require('path');
var assert = require('assert');
var helpers = require('yeoman-generator').test;
var assert = require('yeoman-generator').assert;

describe('sp generator collection', function(){

  it('creates collection and model if required', function(done){
    helpers.run(path.join( __dirname, '../generators/collection'))
      .withGenerators([path.join( __dirname, '../generators/model')])
      .withArguments(['people'])
      .withPrompts({ model_generate: true })
      .on('end', function () {
        assert.file([
          'app/scripts/collection/PeopleCollection.coffee',
          'app/scripts/model/PeopleModel.coffee',
        ]);
        done();
      });
  })

  it('creates only collection', function(done){
    helpers.run(path.join( __dirname, '../generators/collection'))
      .withGenerators([path.join( __dirname, '../generators/model')])
      .withArguments(['news'])
      .withPrompts({ model_generate: false })
      .on('end', function(){
        assert.file(['app/scripts/collection/NewsCollection.coffee']);
        assert.noFile(['app/scripts/model/NewsModel.coffee']);
        done();
      });
  });

});
