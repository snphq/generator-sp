const makeConfig = require('./_config');
const webpack = require('webpack');
const ModernizrWebpackPlugin = require('modernizr-webpack-plugin');

module.exports = opts => {
  if (!opts) {
    opts = {};
  }
  const config = makeConfig(opts);
  config.plugins = config.plugins.concat([
    new webpack.optimize.UglifyJsPlugin({
      compress: {
        /* eslint camelcase: "off" */
        dead_code: true,
        drop_debugger: true,
        unsafe: true,
        evaluate: true,
        unused: true,
      },
    }),
    new ModernizrWebpackPlugin(require('./_modernizr')),
  ]);
  return config;
};
