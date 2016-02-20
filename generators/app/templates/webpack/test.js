'use strict';

const webpackConfig = require('./dev')({test: true});
let loaders = webpackConfig.module.loaders;

const replaceLoader = (list, testValue, newLoader) => {
  list = list.filter(loader => {
    return String(loader.test) !== String(testValue);
  });
  list.push(newLoader);
  return list;
};

loaders = replaceLoader(loaders, /\.coffee$/, {
  test: /\.coffee$/,
  include: /(__test__)\//,
  loader: 'coffee',
});

loaders = replaceLoader(loaders, /\.sass$/, {
  test: /\.sass$/,
  loader: 'null-loader',
});

webpackConfig.module.loaders = loaders;

webpackConfig.module.preLoaders = replaceLoader(webpackConfig.module.preLoaders, /\.coffee$/, {
  test: /\.coffee$/,
  exclude: /(__test__|node_modules|bower_components)\//,
  loader: 'ibrik-instrumenter',
});

module.exports = webpackConfig;
