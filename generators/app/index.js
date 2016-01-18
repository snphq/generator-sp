var util = require('util');
var yeoman = require('yeoman-generator');
var mkdirp = require('mkdirp');

var SpGenerator = module.exports = function SpGenerator() {
  yeoman.generators.Base.apply(this, arguments);
};

util.inherits(SpGenerator, yeoman.generators.Base);

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
    'bower.json',
  ].forEach(function (path) {
    self.copy(path, path);
  });

  // copy to dot files
  this.directory('dotfiles', this.destinationRoot());
  // this.directory('webpack', 'webpack');
};

SpGenerator.prototype.install = function install() {
  this.installDependencies({skipInstall: this.options['skip-install']});
  this.on('end', function () {
    this.spawnCommand('gulp', ['git-init']);
  });
};
