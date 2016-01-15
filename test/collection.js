/*global describe, beforeEach, it*/
'use strict';
var path = require('path');
var assert = require('assert');
var helpers = require('yeoman-generator').test;
var assert = require('yeoman-generator').assert;



describe('sp generator collection', function(){

  before(function(done){
    helpers.run(path.join( __dirname, '../collection'))
      .withGenerators([path.join( __dirname, '../model')])
      .withArguments(['people'])
      .withPrompts({ model_generate: true })
      .on('end', done);
  });

  before(function(done){
    helpers.run(path.join( __dirname, '../collection'))
      .withArguments(['news'])
      .withPrompts({ model_generate: false })
      .on('end', done);
  });

  it('creates only collection', function(){
    assert.file([
      'app/scripts/collection/NewsCollection.coffee',
    ]);
    assert.noFile([
      'app/scripts/model/NewsModel.coffee',
    ]);
  })

});
