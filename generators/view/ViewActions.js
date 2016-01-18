var fs = require('fs');
var path = require('path');
var mkdirp = require('mkdirp');
var _ = require('yeoman-generator/node_modules/lodash');

var ViewActions = {
  getRootPath: function (view_path) {
    return path.join('app', 'scripts', 'view', view_path);
  },
  getAvailableViewPath: function () {
    var viewPath = 'app/scripts/view/';
    var folders = [];
    fs.readdirSync(viewPath).forEach(function (item) {
      var itemPath = viewPath + item;
      var stat = fs.lstatSync(itemPath);
      if (stat.isDirectory()) {
        folders.push(item);
      }
    });
    return folders;
  },
  validateCoffee: function (view_path, imports) {
    var rootPath = ViewActions.getRootPath.call(this, view_path);
    var str = '#genetated file\n';
    str += 'define (require, exports, module)->\n';
    imports.coffee.sort();
    imports.coffee.forEach(function (name) {
      str += '  ' + name + ': require \'./' + name + '/' + name + '\'\n';
    });
    if (!imports.coffee.length) {
      str += '  {}\n';
    }
    this.write(path.join(rootPath, 'main.coffee'), str);
  },
  validateJade: function (view_path, imports, viewType) {
    var rootPath = ViewActions.getRootPath.call(this, view_path);
    if (viewType === 'layout') {
      return;
    }
    var str = '//-genetated file\n';
    imports.jade.sort();
    imports.jade.forEach(function (name) {
      str += 'script#' + name + '(type=\'text/template\')\n';
      str += '  include ' + name + '/' + name + '\n';
    });
    this.write(
      path.join(rootPath, 'main.jade'), str);
  },
  validateScss: function (view_path, imports) {
    var rootPath = ViewActions.getRootPath.call(this, view_path);
    var str = '//genetated file\n';
    imports.scss.sort();
    imports.scss.forEach(function (name) {
      str += '@import "' + name + '/' + name + '";\n';
    });
    this.write(
      path.join(rootPath, 'main.scss'), str);
  },
  validateSass: function (view_path, imports) {
    var rootPath = ViewActions.getRootPath.call(this, view_path);
    var str = '//genetated file\n';
    imports.sass.sort();
    imports.sass.forEach(function (name) {
      str += '@import ' + name + '/' + name + '\n';
    });
    this.write(
      path.join(rootPath, 'main.sass'),
    str);
  },
  getImports: function (view_path, _base) {
    var rootPath = ViewActions.getRootPath.call(this, view_path);
    var base = typeof (_base) === 'function' ? _base() : _base;
    var mainPath = path.join(base, rootPath);
    var isSass = this.config.get('csspreprocessor') === 'sass';
    var exts = ['coffee', 'jade'].concat(isSass ? 'sass' : 'scss');

    var imports = _.reduce(exts, function (memo, ext) {
      memo[ext] = []; return memo;
    }, {});

    if (!fs.existsSync(mainPath)) {
      return imports;
    }
    fs.readdirSync(mainPath).forEach(function (item) {
      var itemPath = path.join(mainPath, item);
      var stat = fs.lstatSync(itemPath);
      if (stat.isDirectory()) {
        exts.forEach(function (ext) {
          var filePath = path.join(itemPath, item + '.' + ext);
          if (fs.existsSync(filePath)) {
            imports[ext].push(item);
          }
        });
      }
    });
    return imports;
  },

  validate: function (view_path, viewType, imports) {
    ViewActions.validateCoffee.call(this, view_path, imports);
    ViewActions.validateJade.call(this, view_path, imports, viewType);
    if (this.config.get('csspreprocessor') === 'sass') {
      ViewActions.validateSass.call(this, view_path, imports);
    } else {
      ViewActions.validateScss.call(this, view_path, imports);
    }
  },
  createView: function (view_path, normalize_name, normalize_name_list, viewType, viewTypeList, _base, template_name) {
    template_name = template_name || 'view';
    var self = this;
    var rootPath = ViewActions.getRootPath.call(this, view_path);
    var packagePath = path.join(rootPath, normalize_name);
    var packagePathList = path.join(rootPath, normalize_name_list);
    var isSass = this.config.get('csspreprocessor') === 'sass';
    var exts = ['coffee', 'jade'].concat(isSass ? 'sass' : 'scss');

    var imports = ViewActions.getImports.call(this, view_path, _base);

    mkdirp(rootPath);

    exts.forEach(function (ext) {
      self.copy(
        template_name + '.' + ext,
        path.join(packagePath, normalize_name + '.' + ext)
      );
      imports[ext].push(normalize_name);
    });

    if (self.viewTypeList) {
      exts.forEach(function (ext) {
        self.copy(
          template_name + '_list.' + ext,
          path.join(packagePathList, normalize_name_list + '.' + ext)
        );
        imports[ext].push(normalize_name_list);
      });
    }
    if (this.config.get('webpack') !== true) {
      ViewActions.validate.call(this, view_path, viewType, imports);
    }
  },
};

module.exports = ViewActions;
