var fs = require('fs');
var path = require('path');
var util = require('util');
var _ = require('yeoman-generator/node_modules/lodash');

var BaseActions = {
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
    var rootPath = BaseActions.getRootPath.call(this, view_path);
    var str = "#genetated file\n";
    str += "define (require, exports, module)->\n";
    imports['coffee'].forEach(function(name){
      str += "  " + name + ": require './" + name + "/" + name + "'\n";
    });
    this.write(rootPath + "main.coffee", str);
  },
  validateJade:function(view_path, imports, viewType){
    var rootPath = BaseActions.getRootPath.call(this, view_path);
    if(viewType == "layout"){
      return;
    }
    var str = "//-genetated file\n";
    imports['jade'].forEach(function(name){
      str += "script#" + name + "(type='text/template')\n";
      str += "  include " + name + "/" + name + "\n";
    });
    this.write(rootPath + "main.jade", str);
  },
  validateScss:function(view_path, imports){
    var rootPath = BaseActions.getRootPath.call(this, view_path);
    var str = "//genetated file\n";
    imports['scss'].forEach(function(name){
      str += "@import \"" + name + "/" + name + "\";\n";
    });
    this.write(rootPath + "main.scss", str);
  },
  getImports:function(view_path, _base){
    var rootPath = BaseActions.getRootPath.call(this, view_path);
    var mainPath = _base + "/" + rootPath;
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

    BaseActions.validateCoffee.call(this, view_path, imports);
    BaseActions.validateJade.call(this, view_path, imports, viewType);
    BaseActions.validateScss.call(this, view_path, imports);
  },
  createView:function(view_path, normalize_name, normalize_name_list, viewType, viewTypeList, _base){
    var self = this;
    var rootPath = BaseActions.getRootPath.call(this, view_path);
    var packagePath = rootPath + normalize_name + "/";
    var packagePathList = rootPath + normalize_name_list + "/";

    var exts = ['coffee','scss','jade'];

    var imports = BaseActions.getImports.call(this, view_path, _base);

    this.mkdir(rootPath);

    exts.forEach(function(ext){
      self.copy(
        'view.' + ext,
        packagePath + normalize_name + '.' + ext
      );
      imports[ext].push(normalize_name);
    });

    if(self.viewTypeList){
      exts.forEach(function(ext){
        self.copy(
          'view_list.' + ext,
          packagePathList + normalize_name_list + '.' + ext
        );
        imports[ext].push(normalize_name_list);
      });
    }

    BaseActions.validate.call(this, view_path, viewType, imports);
  }
};

module.exports = BaseActions;
