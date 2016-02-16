
var fs = require('fs');
var path = require('path');

function inDirectory(path, files) {
  return files.map(function (file) {
    return path + '/' + file;
  });
}

function viewFiles(path, name) {
  var extensions = [
    'js',
    'jade',
    'css',
    'package',
  ];
  var shortName = name.replace(/^_/, '');
  return inDirectory(path, extensions.map(function (ext) {
    return name + '/' + ((ext === 'package') ? 'package.json' : (shortName + '.' + ext));
  }));
}

module.exports = {
  fixture: function (name) {
    var fixturePath = path.join(__dirname, './fixtures/', name);
    return fs.readFileSync(fixturePath, 'utf-8').trim();
  },
  inDirectory: inDirectory,
  viewFiles: viewFiles,
};
