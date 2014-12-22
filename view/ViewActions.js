var fs = require('fs');
var path = require('path');
var util = require('util');
var _ = require('yeoman-generator/node_modules/lodash');

var ViewActions = {
  getRootPath:function(view_path){
    return 'app/scripts/view/' + view_path + "/";
  },
  getAvailableViewPath:function(){
    var viewPath  = 'app/scripts/view/';
    var folders = [];
    fs.readdirSync(viewPath).forEach(function(item){
      var itemPath = viewPath + item;
      var stat = fs.lstatSync(itemPath);
      if(stat.isDirectory()){
        folders.push(item);
      }
    });
    return folders;
  },
  validateCoffee:function(view_path, imports){
    var rootPath = ViewActions.getRootPath.call(this, view_path);
    var str = "#genetated file\n";
    str += "define (require, exports, module)->\n";
    imports['coffee'].sort();
    imports['coffee'].forEach(function(name){
      str += "  " + name + ": require './" + name + "/" + name + "'\n";
    });
    if(!imports['coffee'].length){
      str += "  {}\n";
    }
    this.write(rootPath + "main.coffee", str);
  },
  validateJade:function(view_path, imports, viewType){
    var rootPath = ViewActions.getRootPath.call(this, view_path);
    if(viewType == "layout"){
      return;
    }
    var str = "//-genetated file\n";
    imports['jade'].sort();
    imports['jade'].forEach(function(name){
      str += "script#" + name + "(type='text/template')\n";
      str += "  include " + name + "/" + name + "\n";
    });
    this.write(rootPath + "main.jade", str);
  },
  validateScss:function(view_path, imports){
    var rootPath = ViewActions.getRootPath.call(this, view_path);
    var str = "//genetated file\n";
    imports['scss'].sort();
    imports['scss'].forEach(function(name){
      str += "@import \"" + name + "/" + name + "\";\n";
    });
    this.write(rootPath + "main.scss", str);
  },
  getImports:function(view_path, _base){
    var rootPath = ViewActions.getRootPath.call(this, view_path);
    var base = typeof(_base) === 'function' ? _base() : _base;
    var mainPath = base + '/' + rootPath;
    var exts = ['coffee','scss','jade'];
    var imports = {'coffee':[],'scss':[],'jade':[]};
    if(!fs.existsSync(mainPath)){
      return imports;
    }
    fs.readdirSync(mainPath).forEach(function(item){
      var itemPath = mainPath + item;
      var stat = fs.lstatSync(itemPath);
      if(stat.isDirectory()){
        exts.forEach(function(ext){
          var filePath = itemPath + "/" + item + "." + ext;
          if(fs.existsSync(filePath)){
              imports[ext].push(item);
          }
        });
      }
    });
    return imports;
  },

  validate:function(view_path, viewType,imports){

    ViewActions.validateCoffee.call(this, view_path, imports);
    ViewActions.validateJade.call(this, view_path, imports, viewType);
    ViewActions.validateScss.call(this, view_path, imports);
  },

  _createViewFiles: function(rootPath, template_name, normalize_name){
    var exts = ['coffee','scss','jade'];
    var self = this;
    exts.forEach(function(ext){
      self.copy(
        template_name + '.' + ext,
        packagePath + normalize_name + '.' + ext
      );
    });
  },

  createView:function(view_path, normalize_name, normalize_name_list, viewType, viewTypeList, _base, template_name){
    template_name = template_name || 'view';
    var rootPath = ViewActions.getRootPath.call(this, view_path);
    this.mkdir(rootPath);

    ViewActions._createViewFiles.call(this, rootPath , template_name, normalize_name)
    if(viewType === "list"){
      ViewActions._createViewFiles.call(this, rootPath , template_name + '_list', normalize_name_list)
    }

    var imports = ViewActions.getImports.call(this, rootPath, _base);
    ViewActions.validate.call(this, rootPath, viewType, imports);
  }
};

module.exports = ViewActions;
