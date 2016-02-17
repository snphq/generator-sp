require('coffee-script/register');
const webpack = require('webpack');
const WebpackDevServer = require('webpack-dev-server');
const webpackConfig = require('./webpack/dev')();

new WebpackDevServer((webpack(webpackConfig)), {
  publicPath: webpackConfig.output.publicPath,
  filename: 'bundle.js',
  inline: true,
  hot: true,
  stats: {
    colors: true,
  },
})
.listen(9000, '127.0.0.1', err => {
  if (err) {
    throw new Error('webpack-dev-server', err);
  }
});
