'use strict';
var yeoman = require('yeoman-generator');
var _ = require('lodash');

module.exports = yeoman.Base.extend({
  constructor: function () {
    yeoman.Base.apply(this, arguments);
    this.argument('path', {type: String, required: true});
    this.log('You called the view subgenerator with the argument ' + this.normalize_name + '.');
  },

  _setTemplatesData: function () {
    this.cssClassname = this._getCssClassName();
    this.componentName = this._getComponentName();
    this.baseClassPath = this._getBaseClassPath();
  },

  files: function () {
    if (!this.config.get('webpack')) {
      this.log('You cant use this version of generator for old. You should downgrade it to use it here');
      return;
    }
    if (!this._isDirectoryValid()) {
      this.log('You can`t create files not in component or page');
      return;
    }
    this._setTemplatesData();
    this.copy('view.js', this._getFileName('js'));
    this.copy('view.sass', this._getFileName('sass'));
    this.copy('view.jade', this._getFileName('jade'));
    this.copy('package.json', this._getPackageFileName());
  },

  _getPath: function () {
    var pathParts = this.path.split('/');
    var innerPath = pathParts.slice(1, pathParts.length - 1);
    return [
      'app/scripts',
      this._getRootParent(),
    ].concat(innerPath).join('/');
  },

  _getRootParent: function () {
    var shortcuts = {
      p: 'page',
      c: 'component',
    };
    var pathParts = this.path.split('/');
    if (pathParts.length === 1) {
      return 'component';
    }
    var rootParent = pathParts[0];
    if (shortcuts[rootParent]) {
      rootParent = shortcuts[rootParent];
    }
    return rootParent;
  },

  _getFileName: function (ext) {
    var name = this._getComponentName();
    var parrentPath = this._getPath();
    var localPath = name + '/' + name + '.' + ext;
    return parrentPath + '/' + localPath;
  },

  _getPackageFileName: function () {
    return this._getPath() + '/' + this._getComponentName() + '/package.json';
  },

  _getCssClassName: function () {
    var className = _.kebabCase(
      this._getComponentName()
    );
    if (this._getRootParent() === 'page') {
      className = 'p-' + className;
    }
    return className;
  },

  _getComponentName: function () {
    var pathParts = this.path.split('/');
    var name = pathParts[pathParts.length - 1];
    return _.upperFirst(
      _.camelCase(name)
    );
  },

  _getBaseClassPath: function () {
    if (this._isRootComponent()) {
      return this._getRootParent() + '/_Base';
    }
    return 'component/_Base';
  },

  _isDirectoryValid: function () {
    var rootDir = this._getRootParent();
    return rootDir === 'component' || rootDir === 'page';
  },

  _isRootComponent: function () {
    var pathParts = this.path.split('/');
    return pathParts.length <= 2;
  },
});
