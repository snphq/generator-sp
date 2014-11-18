'use strict';
var util = require('util');
var path = require('path');
var yeoman = require('yeoman-generator');
var fs = require('fs');


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
  console.log(this.yeoman);

  var prompts = [{
    name:'capprojectname',
    message:'Input project name for Capistrano',
    default:"sp-project"
  }];

  this.prompt(prompts, function (props) {
    this.capprojectname = props.capprojectname;
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
  this.directory('app/styles','app/styles');
  this.directory('app/scripts/coffee', 'app/scripts');
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
    'gruntconfig.coffee',
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
