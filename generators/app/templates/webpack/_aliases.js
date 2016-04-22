const path = require('path');

module.exports = {
  'images': path.join(__dirname, '../app/images'),
  'files': path.join(__dirname, '../app/files'),
  'utils': path.join(__dirname, '../app/scripts/utils'),
  'common': path.join(__dirname, '../app/scripts/common'),
  'model': path.join(__dirname, '../app/scripts/model'),
  'collection': path.join(__dirname, '../app/scripts/collection'),
  'view': path.join(__dirname, '../app/scripts/view'),
  'component': path.join(__dirname, '../app/scripts/component'),
  'page': path.join(__dirname, '../app/scripts/page'),
  'backbone-mixin': 'backbone-mixin/build/backbone-mixin',
  // 'jquery': path.join(__dirname, 'node_modules/jquery/dist/jquery'),
  'epoxy': 'backbone.epoxy',
  'underscore': 'lodash',
  'bootstrap': path.join(__dirname, '../node_modules/bootstrap/dist/js/bootstrap'),
  'simple-blocks': 'simple-blocks/dist/simpleblocks',
};
