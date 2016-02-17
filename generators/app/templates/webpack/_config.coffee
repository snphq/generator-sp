webpack = require 'webpack'
path = require 'path'
ExtractTextPlugin = require 'extract-text-webpack-plugin'
HtmlWebpackPlugin = require 'html-webpack-plugin'

# TODO: do all thigs without gulp

doConfig = (opts = {})->
  BUILD_MODE = opts.BUILD_MODE
  IS_DEV = !!opts.IS_DEV
  context: path.resolve 'app'
  entry: app: [ 'babel-polyfill', './scripts/main.js' ]
  resolve:
    extensions: [
      ''
      '.js'
      '.coffee'
    ]
    modulesDirectoriess: ['node_modules']

    alias: require './_aliases'

  resolveLoader: modulesDirectories: ['node_modules']

  # output is definded in build an dev configs

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
      loader: ExtractTextPlugin.extract('style', 'css!postcss?pack=sass!sass')
    ,
      test: /\.css$/
      loader: ExtractTextPlugin.extract('style', 'css!postcss')
    ,
      test: /\.svg$/
      loader: 'file?name=frassets/[name].[hash:6].[ext]&limit=4096'
    ,
      test: /\.png$/
      loader: 'file?name=frassets/[name].[hash:6].[ext]&limit=4096'
    ,
      test: /\.jpe?g$/
      loader: 'file?name=frassets/[name].[hash:6].[ext]&limit=4096'
    ,
    # custom file types
      test: /\.(pdf|zip)$/
      loader: 'file?name=files/[name].[hash:6].[ext]'
    ,
      test: /\/bootstrap\/dist\/js\/bootstrap\.js/
      loader: 'imports?jQuery=jquery'
    ]
    noParse: [
      /jquery\/dist\/jquery\.js/
      /^backbone\/backbone\.js/
    ]
  postcss: (require './_postcss')
  plugins: [
    new (webpack.DefinePlugin)(BUILD_MODE: JSON.stringify(BUILD_MODE))
    new (webpack.ContextReplacementPlugin)(/node_modules\/moment\//, /ru/)
    new (webpack.ProvidePlugin)(
      $: 'jquery'
      jQuery: 'jquery'
      _: 'underscore')
    new (HtmlWebpackPlugin)({
        filename: 'index.html'
        template: 'html/index.jade'
      }),
    new (HtmlWebpackPlugin)({
        filename: 'auth_fail.html'
        template: 'html/auth_fail.jade'
        inject: false
      }),
    new (HtmlWebpackPlugin)({
        filename: 'auth_success.html'
        template: 'html/auth_success.jade'
        inject: false
      }),
    new ExtractTextPlugin('frassets/app.[contenthash].css',
      allChunks: true
      disable: IS_DEV)
  ]

  coffeelint: configFile: '.coffeelintrc'

  sassLoader:
    indentedSyntax: true
    includePaths: [ path.resolve(__dirname, 'app/styles') ]

  xo: esnext: true


module.exports = doConfig
