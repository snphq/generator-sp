'use strict';
var util = require('util');
var path = require('path');
var yeoman = require('yeoman-generator');
var fs = require('fs');
var _ = require('yeoman-generator/node_modules/lodash');

var SpGenerator = module.exports = function SpGenerator(args, options, config) {
  yeoman.generators.Base.apply(this, arguments);

  this.on('end', function () {
    this.installDependencies({ skipInstall: options['skip-install'] });
  });

  this.pkg = JSON.parse(this.readFileAsString(path.join(__dirname, '../package.json')));
};

util.inherits(SpGenerator, yeoman.generators.Base);

SpGenerator.prototype.askFor = function askFor() {
  var cb = this.async();

  // have Yeoman greet the user.

  var prompts = [{
    name:"capprojectname",
    message:"Input project name for Capistrano",
    default:"sp-project"
  },{
    name: "csspreprocessor",
    type: "list",
    message: "Choose preprocessor style:",
    choices:[{
      name: "sass",
      value: "sass"
    },{
      name: "scss",
      value: "scss"
    }],
    default: "sass"
  }];

  this.prompt(prompts, function (props) {
    this.capprojectname = props.capprojectname;
    this.csspreprocessor = props.csspreprocessor;
    this.config.set(props);
    cb();
  }.bind(this));
};

SpGenerator.prototype.app = function app() {
  var self = this;
  this.mkdir('app');
  this.mkdir('app/html');
  this.mkdir('app/scripts');
  this.mkdir('app/files');

  this.mkdir('config');

  this.directory('app/images','app/images');
  //write styles
  this.directory('app/styles','app/styles');
  ["_common", "_fonts", "_mixins"].forEach(function(styleitem){
    self.fs.write(
      path.join('app','styles', styleitem + "." + self.csspreprocessor), ""
    );
  });
  this.copy(
    path.join("app","_styles","main." + this.csspreprocessor),
    path.join("app","styles","main." + this.csspreprocessor)
  );
  this.directory('app/scripts/coffee', 'app/scripts');
  this.directory("app/scripts/" + this.csspreprocessor, "app/scripts");
  this.directory('app/html/jade', 'app/html');
  this.copy("app/robots.txt","app/robots.txt");
  this.copy("app/favicon.ico","app/favicon.ico");
};
SpGenerator.prototype.cap = function cap(){
  console.log("Accept " + this.cap_project_name);
  var self = this;
  [
    'Capfile',
    'Gemfile',
    'Gemfile.lock',
  ].forEach(function(path){
    self.copy(path,path);
  });
  self.directory('config','config');
}
SpGenerator.prototype.projectfiles = function projectfiles() {
  var self = this;
  this.mkdir('gulp');
  this.directory('gulp','gulp');
  [
    'gulpfile.js',
  ].forEach(function(_p){
    self.bulkCopy(_p, _p);
  });
  //copy configs
  [
    'README.md',
    'haproxy-config.txt',
    'package.json',
    'bower.json',
  ].forEach(function(path){
    self.copy(path,path)
  });

  //copy to dot files
  [
    'gulpconfig.coffee',
    'gitattributes',
    'gitignore',
    'bowerrc',
    'editorconfig',
    'jshintrc',
    'coffeelintrc'
  ].forEach(function(path){
    self.copy(path,'.' + path)
  });



};
