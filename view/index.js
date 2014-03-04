'use strict';
var util = require('util');
var yeoman = require('yeoman-generator');
var fs = require('fs');
var path = require('path');
var capitalize = function(name){
  return name[0].toUpperCase() + name.slice(1,name.length);
}

var ViewGenerator = module.exports = function ViewGenerator(args, options, config) {

  // By calling `NamedBase` here, we get the argument to the subgenerator call
  // as `this.name`.
  yeoman.generators.NamedBase.apply(this, arguments);
  console.log('You called the view subgenerator with the argument ' + this.normalize_name + '.');

};

util.inherits(ViewGenerator, yeoman.generators.NamedBase);
ViewGenerator.prototype.askFor = function askFor() {
  var cb = this.async();
  var prompts = [{
    type: 'list',
    name: 'viewType',
    message: 'Select viewType',
    choices:[
      { 'name':'widget', value:'widget' },
      { 'name':'layout', value:'layout' },
      { 'name':'modal', value:'modal' },
      { 'name':'page', value:'page' },
    ],
    default: 'widget'
  }];
  this.prompt(prompts, function (props) {
    this.viewType = props.viewType;
    this.css_classname = (this.name + "_" + this.viewType).toLowerCase();
    this.normalize_name = capitalize(this.name) + capitalize(this.viewType);
    this.view_path = this.viewType;
    this.coffee_base = "_" + capitalize(this.viewType);
    cb();
  }.bind(this));
}

ViewGenerator.prototype.files = function files() {
  var self = this;
  var rootPath = 'app/scripts/view/' + self.view_path + "/";
  var packagePath = rootPath + self.normalize_name + "/";
  var mainPath = self.dest._base + "/" + rootPath;

  var exts = ['coffee','scss','jade'];
  var imports = {'coffee':[],'scss':[],'jade':[]}

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

  exts.forEach(function(ext){
    self.copy(
      'view.' + ext,
      packagePath + self.normalize_name + '.' + ext
    );
    imports[ext].push(self.normalize_name);
  });

  (function(imports){

    var str = "#genetated file\n";
    str += "define (require, exports, module)->\n";
    imports['coffee'].forEach(function(name){
      str += "  " + name + ": require './" + name + "/" + name + "'\n";
    });
    self.write(rootPath + "main.coffee", str);

  })(imports);

  (function(imports){
    if(self.viewType == "layout"){
      return;
    }
    var str = "//-genetated file\n";
    imports['jade'].forEach(function(name){
      str += "script#" + name + "(type='text/template')\n";
      str += "  include " + name + "/" + name + "\n";
    });
    self.write(rootPath + "main.jade", str);

  })(imports);

  (function(imports){

    var str = "//genetated file\n";
    imports['scss'].forEach(function(name){
      str += "@import \"" + name + "/" + name + "\";\n";
    });
    self.write(rootPath + "main.scss", str);

  })(imports);


};
