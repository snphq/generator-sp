var yeoman = require('yeoman-generator');
var capitalize = function (name) {
  return name[0].toUpperCase() + name.slice(1, name.length);
};

module.exports = yeoman.Base.extend({
  constructor: function () {
    yeoman.Base.apply(this, arguments);
    this.argument('name', {type: String, required: true});
    this.log('You called the model subgenerator with the argument ' + this.name + '.');
  },

  files: function () {
    if (!this.config.get('webpack')) {
      this.log('You cant use this version of generator for old. You should downgrade it to use it here');
      return;
    }
    this.normalize_name = capitalize(this.name) + 'Model';
    this.copy('model.js', 'app/scripts/model/' + this.normalize_name + '.js');
  },
});
