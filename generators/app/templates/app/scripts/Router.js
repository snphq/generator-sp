import Backbone from 'backbone';
import Middleware from 'sp-utils-middleware';
import common from './common';

import IndexPage from 'page/Index';
import Error404Page from 'page/Error404';

function showPage(View, options = {}, callback) {
  return common.app.layout.setContent(View, options, callback);
}

class MiddlewareRouter extends Middleware {
  auth(async) {
    return async.resolve('auth');
  }
}

const middleware = new MiddlewareRouter();

const Router = Backbone.Router.extend({

  routes:
    {'': 'index',
    '404': 'error404',
    '*default': 'defaultRouter',
    },

  index: middleware.wrap(() =>
    showPage(IndexPage)
  ),

  error404: middleware.wrap(() =>
    showPage(Error404Page)
  ),

  defaultRouter() {
    return this.navigate('404', {trigger: true, replace: true});
  },
});

export default Router;
