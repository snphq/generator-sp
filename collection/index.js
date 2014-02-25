'use strict';
var util = require('util');
var yeoman = require('yeoman-generator');
var fs = require('fs');
var path = require('path');
var capitalize = function(name){
  return name[0].toUpperCase() + name.slice(1,name.length);
}

var CollectionGenerator = module.exports = function ModelGenerator(args, options, config) {

  // By calling `NamedBase` here, we get the argument to the subgenerator call
  // as `this.name`.
  yeoman.generators.NamedBase.apply(this, arguments);
  console.log('You called the collection subgenerator with the argument ' + this.name + '.');
};

util.inherits(CollectionGenerator, yeoman.generators.NamedBase);
CollectionGenerator.prototype.askFor = function askFor() {
  var cb = this.async();
  var prompts = [{
    name: 'modelName',
    message: "What model do you want to link with collection (without \"Model\" postfix)?",
    default: this.name
  }];
  this.prompt(prompts, function (props) {
    if (props.modelName == ''){
      props.modelName = this.name
    }
    this.model_name = capitalize(props.modelName) + "Model";
    cb();
  }.bind(this));
}

CollectionGenerator.prototype.files = function files() {
    this.normalize_name = capitalize(this.name) + "Collection"
    this.copy('collection.coffee',  'app/scripts/collection/' + this.normalize_name + '.coffee');
}
