webpackConfig = require('./dev')({test: true})
loaders = webpackConfig.module.loaders

replaceLoader = (list, testValue, newLoader) ->
  list = list.filter((loader) ->
    String(loader.test) != String(testValue)
  )
  list.push newLoader
  list

loaders = replaceLoader loaders, /\.coffee$/,
  test: /\.coffee$/
  include: /(__test__)\//
  loader: 'coffee'

loaders = replaceLoader loaders, /\.sass$/,
  test: /\.sass$/
  loader: 'null-loader'

webpackConfig.module.loaders = loaders

webpackConfig.module.preLoaders = replaceLoader webpackConfig.module.preLoaders, /\.coffee$/,
  test: /\.coffee$/
  exclude: /(__test__|node_modules|bower_components)\//
  loader: 'ibrik-instrumenter'

module.exports = webpackConfig
