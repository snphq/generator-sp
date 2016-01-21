var yeoman = require('yeoman-generator');

module.exports = yeoman.Base.extend({
  constructor: function () {
    yeoman.Base.apply(this, arguments);
    this.argument('path', {type: String, required: true});
    this.log('You called the test subgenerator with the argument ' + this.path + '.');
  },

  files: function () {
    if (!this.config.get('webpack')) {
      this.log('You cant use this version of generator for old. You should downgrade it to use it here');
      return;
    }
    this.name = this._getName();
    this.copy('test.js', this._getFileName());
  },

  _getName: function () {
    var pathParts = this.path.split('/');
    return pathParts[pathParts.length - 1];
  },

  _getPath: function () {
    var pathParts = this.path.split('/');
    var innerPath = pathParts.slice(0, pathParts.length - 1);
    return [
      'app/scripts',
    ].concat(
      innerPath,
      '__test__'
    ).join('/');
  },

  _getFileName: function () {
    var name = this._getName();
    var parrentPath = this._getPath();
    var localPath = name + '.js';
    return parrentPath + '/' + localPath;
  },
});
