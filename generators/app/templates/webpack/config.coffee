requireChild = require '../gulp/requireChild'

webpack = requireChild('webpack')
path = require 'path'
ExtractTextPlugin = require 'extract-text-webpack-plugin'
PROP = require 'snp-gulp-tasks/lib/config'
ENV = if PROP and PROP.preprocess then Object.keys(PROP.preprocess()) else 'DEBUG'

# TODO: do all thigs without gulp

doConfig = ->
  context: path.resolve 'app'
  entry: app: [ './scripts/main.js' ]
  resolve:
    extensions: [
      ''
      '.js'
      '.coffee'
    ]
    modulesDirectoriess: ['node_modules']

    alias: require './_aliases'

  resolveLoader: modulesDirectories: ['node_modules']

  output:
    path: path.join(__dirname, '/app/scripts/')
    filename: '[name].bundle.js'
    chunkFilename: '[id].bundle.js'

  module:
    preLoaders: [
      test: /\.coffee$/
      loader: 'coffeelint'
    ,
      test: /\.jsx?$/
      loader: 'xo'
      exclude: /(node_modules|bower_components)/
    ]
    loaders: [
      test: /\.coffee$/
      loader: 'coffee'
    ,
      test: /\.jsx?$/
      exclude: /(node_modules|bower_components)/
      loader: 'babel'
      query:
        presets: [
          'react'
          'es2015'
          'stage-0'
        ],
        plugins: [
          'add-module-exports'
        ]
    ,
      test: /\.jade$/
      loader: 'jade'
    ,
      test: /\.sass$/
      loader: ExtractTextPlugin.extract('style', 'css!postcss!sass')
    ,
      test: /\.css$/
      loader: ExtractTextPlugin.extract('style', 'css')
    ,
      test: /\.svg$/
      loader: 'file?limit=4096'
    ,
      test: /\.png$/
      loader: 'file?limit=10000'
    ,
      test: /\.jpe?g$/
      loader: 'file?limit=10000'
    ,
      test: /\/bootstrap\/dist\/js\/bootstrap\.js/
      loader: 'imports?jQuery=jquery'
    ]
    noParse: [
      /jquery\/dist\/jquery\.js/
      /^backbone\/backbone\.js/
    ]
  postcss: [
    (require 'autoprefixer') { browsers: ['last 2 versions'] }
  ]
  plugins: [
    new (webpack.DefinePlugin)(BUILD_MODE: JSON.stringify(ENV))
    new (webpack.ContextReplacementPlugin)(/node_modules\/moment\//, /ru/)
    new (webpack.ProvidePlugin)(
      $: 'jquery'
      jQuery: 'jquery'
      _: 'underscore')
    new ExtractTextPlugin('../styles/app.css',
      allChunks: true
      disable: PROP.isDev)
  ]

  coffeelint: configFile: '.coffeelintrc'

  sassLoader:
    indentedSyntax: true
    includePaths: [ path.resolve(__dirname, 'app/styles') ]

  xo: esnext: true


module.exports = doConfig
