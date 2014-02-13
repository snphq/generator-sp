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
    cb();
  }.bind(this));
}

ViewGenerator.prototype.files = function files() {
  this.copy('view.coffee',  'app/scripts/view/' + this.view_path + "/" + this.normalize_name + '.coffee');
  var jade_folder = 'app/html/' + this.view_path + "/";
  var index_jade = jade_folder + "__" + this.view_path + ".jade";
  this.copy('view.jade',  jade_folder + "_" + this.normalize_name + '.jade');
  (function(self){
    var data = "";
    try{
      data = self.dest.read(index_jade);
    }catch(e){}
    data += "\nscript#" + self.normalize_name + "(type=\"text/template\")\n  include _" + self.normalize_name + "\n";
    self.write(index_jade,data);
  })(this);

  var scss_folder = 'app/styles/' + this.view_path + "/";
  var index_scss = scss_folder + "__" + this.view_path + ".scss";
  this.copy('view.scss', scss_folder + "_" + this.normalize_name + '.scss');
  (function(self){
    var data = "";
    var indexPath = path.join(__dirname,index_scss);
    try{
      data = self.dest.read(index_scss);
    }catch(e){}
    data += "\n@import \"" + self.normalize_name + "\";\n";
    self.write(index_scss,data);
  })(this);
};
