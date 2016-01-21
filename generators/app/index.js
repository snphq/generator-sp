var util = require('util');
var yeoman = require('yeoman-generator');
var mkdirp = require('mkdirp');

var SpGenerator = module.exports = function SpGenerator() {
  yeoman.Base.apply(this, arguments);
  this.composeWith('git-init');
};

util.inherits(SpGenerator, yeoman.Base);

SpGenerator.prototype.askFor = function askFor() {
  var cb = this.async();

  // have Yeoman greet the user.

  var prompts = [{
    name: 'capprojectname',
    message: 'Input project name for Capistrano',
    default: 'sp-project',
  }];

  this.prompt(prompts, function (props) {
    this.capprojectname = props.capprojectname;
    this.config.set(props);
    this.config.set({webpack: true});
    cb();
  }.bind(this));
};

SpGenerator.prototype.app = function app() {
  this.directory('app', 'app');
};

SpGenerator.prototype.cap = function cap() {
  this.log('Accept ' + this.cap_project_name);
  var self = this;
  [
    'Capfile',
    'Gemfile',
    'Gemfile.lock',
  ].forEach(function (path) {
    self.copy(path, path);
  });
  self.directory('webpack', 'webpack');
  self.directory('gulp', 'gulp');
  self.directory('config', 'config');
};

SpGenerator.prototype.projectfiles = function projectfiles() {
  var self = this;
  mkdirp('gulp');
  this.directory('gulp', 'gulp');
  // copy configs
  [
    'gulpfile.js',
    'README.md',
    'haproxy-config.txt',
    'karma.conf.js',
    'package.json',
  ].forEach(function (path) {
    self.copy(path, path);
  });

  // copy to dot files
  this.fs.copy(
    this.templatePath('dotfiles/.*'),
    this.destinationRoot()
  );
  // this.directory('webpack', 'webpack');
};

SpGenerator.prototype.install = function install() {
  this.npmInstall([], {skipInstall: this.options['skip-install']});
};
