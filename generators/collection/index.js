'use strict';
var util = require('util');
var yeoman = require('yeoman-generator');

function capitalize(name) {
  return name[0].toUpperCase() + name.slice(1, name.length);
}

var CollectionGenerator = module.exports = function ModelGenerator() {
  // By calling `NamedBase` here, we get the argument to the subgenerator call
  // as `this.name`.
  yeoman.generators.NamedBase.apply(this, arguments);
  this.log('You called the collection subgenerator with the argument ' + this.name + '.');
};

util.inherits(CollectionGenerator, yeoman.generators.NamedBase);
CollectionGenerator.prototype.askFor = function askFor() {
  var cb = this.async();
  var prompts = [{
    type: 'confirm',
    name: 'model_generate',
    message: 'Whould ypu like generate model ' + this.name + 'Model',
    default: true,
  }];
  this.prompt(prompts, function (props) {
    this.model_name = capitalize(this.name) + 'Model';
    this.model_generate = props.model_generate;
    cb();
  }.bind(this));
};

CollectionGenerator.prototype.files = function files() {
  this.normalize_name = capitalize(this.name) + 'Collection';
  this.copy('collection.js', 'app/scripts/collection/' + this.normalize_name + '.js');
  if (this.model_generate) {
    this.composeWith('sp:model', {
      args: [this.name],
    });
  }
};
