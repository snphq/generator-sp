
var fs = require('fs');
var path = require('path');

module.exports = {
  fixture: function (name) {
    var fixturePath = path.join(__dirname, './fixtures/', name);
    return fs.readFileSync(fixturePath, 'utf-8').trim();
  },
};
