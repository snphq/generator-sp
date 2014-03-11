'use strict';
var util = require('util');
var yeoman = require('yeoman-generator');
var BaseActions = require("./../view/BaseActions")

var ValidateGenerator = module.exports = function ValidateGenerator(args, options, config) {
  yeoman.generators.Base.apply(this, arguments);
};

util.inherits(ValidateGenerator, yeoman.generators.Base);

ValidateGenerator.prototype.askFor = function askFor() {
  var cb = this.async();
  var choicesViews = [{name:"all",value:"_all"}];
  var views = BaseActions.getAvailableViewPath.call(this);
  views.forEach(function(item){
    choicesViews.push({
      name:item, value:item
    });
  });
  var prompts = [{
    type: 'list',
    name: 'view_path',
    message: 'Select folder for validate',
    choices:choicesViews,
    default: '_all'
  }];
  this.prompt(prompts, function (props) {
    this.view_path = props.view_path;
    this.views = views;
    cb();
  }.bind(this));
}

ValidateGenerator.prototype.validate = function validate() {
  var _base = this.dest._base;
  var self = this;
  var views = null;
  if(this.view_path == "_all"){
    views = this.views;
  } else {
    views = [this.view_path];
  }
  views.forEach(function(view_path){
    var imports = BaseActions.getImports.call(self, view_path,_base);
    BaseActions.validate.call(self, view_path, view_path, imports);
  });
};
