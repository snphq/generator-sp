'use strict';
var util = require('util');
var path = require('path');
var yeoman = require('yeoman-generator');


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
    type: 'list',
    name: 'scriptType',
    message: 'Select using script language',
    choices:[
      { 'name':'Coffeescript', value:'coffee' },
      { 'name':'Javascript', value:'js' },
    ],
    default: 'js'
  },{
    type: 'list',
    name: 'templateType',
    message: 'Select using template engine',
    choices:[
      { 'name':'Jade', value:'jade' },
      { 'name':'Swig', value:'swig' },
    ],
    default: 'swig'
  }];

  this.prompt(prompts, function (props) {
    this.scriptType = props.scriptType;
    this.templateType = props.templateType;
    cb();
  }.bind(this));
};

SpGenerator.prototype.app = function app() {
  var self = this;
  this.mkdir('app');
  this.mkdir('app/html');
  this.mkdir('app/scripts');

  this.directory('app/images','app/images');
  this.directory('app/styles','app/styles');


  ['app','main','preprocess_template','test'].forEach(function(path){
    var apath = "app/scripts/" + path + "." + self.scriptType;
    self.copy(apath, apath);
  });

  ['_base', 'index'].forEach(function(path){
    var ext = ".html";
    if(self.templateType === "jade"){
      ext = '.jade';
    }

    var apath = "app/html/" + path + ext;
    self.copy(apath, apath);
  });

};

SpGenerator.prototype.projectfiles = function projectfiles() {
  var self = this;
  this.directory('tasks','tasks');
  this.mkdir('grunt', 'grunt');
  [
    'autoprefixer.coffee',
    'connect.coffee',
    'newer.coffee',
    'rev.coffee',
    'bower.coffee',
    'copy.coffee',
    'open.coffee',
    'sass.coffee',
    'clean.coffee',
    'htmlmin.coffee',
    'preprocess.coffee',
    'swig.coffee',
    'coffee.coffee',
    'jade.coffee',
    'proxy.coffee',
    'watch.coffee',
    'coffeelint.coffee',
    'jshint.coffee',
    'replace.coffee',
    'compress.coffee',
    'modernizr.coffee',
    'requirejs.coffee'
  ].forEach(function(item){
    var data = self.read('grunt/' + item );
    self.write('grunt/' + item, data);
  });

  (function(data){
    self.write('Gruntfile.coffee',data)
  })(self.read('Gruntfile.coffee'));



  [
    'README.md',
    'package.json',
    'bower.json'
  ].forEach(function(path){
    self.copy(path,path)
  });

  [
    'gruntconfig.coffee',
    'gitattributes',
    'gitignore',
    'bowerrc',
    'editorconfig',
    'jshintrc'
  ].forEach(function(path){
    self.copy(path,'.' + path)
  });



};
