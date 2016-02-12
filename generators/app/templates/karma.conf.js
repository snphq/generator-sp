/* eslint no-var: 0 */
/* eslint babel/object-shorthand: 0 */

// Karma configuration
require('coffee-script/register');
var webpackConfig = require('./webpack/test.coffee');
const ibrik = require('ibrik');
delete webpackConfig.entry;

module.exports = function (config) {
  config.set({

    plugins: [
      // fraworks
      'karma-mocha',
      'karma-chai',
      'karma-sinon-chai',
      'karma-phantomjs-shim',

      // environment
      'karma-webpack',

      // launchers
      'karma-chrome-launcher',
      'karma-phantomjs-launcher',

      // reporters
      'karma-notify-reporter',
      'karma-nyan-reporter',
      'karma-coverage',
    ],

    basePath: '',

    frameworks: ['mocha', 'chai', 'sinon-chai', 'phantomjs-shim'],

    // list of files / patterns to load in the browser
    files: [
      'node_modules/babel-polyfill/dist/polyfill.js',
      {pattern: 'app/scripts/**/__test__/*.js'},
      {pattern: 'app/scripts/**/*.js', included: false},
    ],

    exclude: [
      'app/scripts/main.js',
    ],

    preprocessors: {
      '**/__test__/*.js': ['webpack'],
    },

    client: {
      mocha: {
        reporter: 'html',
      },
    },

    reporters: ['notify', 'nyan'],
    // reporters: ['notify', 'nyan', 'coverage'],

    coverageReporter: {
      instrumenters: {ibrik: ibrik},
      type: 'text',
      includeAllSources: true,
      instrumenter: {
        '**/*.coffee': 'ibrik',
      },
    },

    notifyReporter: {
      reportEachFailure: true,
      reportSuccess: false,
    },

    webpack: webpackConfig,

    webpackMiddleware: {
      stats: {
        colors: true,
      },
    },

    port: 9876,

    colors: true,

    // possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
    logLevel: config.LOG_ERROR,

    // enable / disable watching file and executing tests whenever any file changes
    autoWatch: true,

    browsers: ['PhantomJS'],

    singleRun: false,
  });
};
