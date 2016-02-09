'use strict';
var yeoman = require('yeoman-generator');

function capitalize(name) {
  return name[0].toUpperCase() + name.slice(1, name.length);
}

module.exports = yeoman.Base.extend({
  constructor: function () {
    yeoman.Base.apply(this, arguments);
    this.argument('name', {type: String, required: true});
    this.log('You called the collection subgenerator with the argument ' + this.name + '.');
  },

  askFor: function () {
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
  },

  files: function () {
    if (!this.config.get('webpack')) {
      this.log('You cant use this version of generator for old. You should downgrade it to use it here');
      return;
    }
    this.normalize_name = capitalize(this.name) + 'Collection';
    this.copy('collection.js', 'app/scripts/collection/' + this.normalize_name + '.js');
    if (this.model_generate) {
      this.composeWith('sp:model', {
        args: [this.name],
      });
    }
  },
});
