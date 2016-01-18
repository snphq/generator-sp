import Backbone from 'backbone';
import Router from './Router';
import ServerApi from './ServerAPI';
// import preprocess from './preprocess';
import cookies from 'cookies';
// require 'utils/jqueryPatch'  # uncomment if You need touch-click support
// import GAConstructor from 'sp-utils-gaconstructor';
// UserModel = require 'model/UserModel'
// social = require 'packages/social'
import Layout from 'component/Layout';
import common from 'common';

const sblocksComponents = [
  // simple-blocks implementation
  // https://github.com/lexich/simple-blocks
];

$(document).ajaxSend((event, jqxhr, settings) => {
  if (settings.type !== 'GET') {
    return jqxhr.setRequestHeader('X-CSRF-Token', cookies.get('CSRF-Token'));
  }
});

export default class Application {
    constructor(common) {
      common.router = new Router();
      common.api = new ServerApi();
      this.$document = $(document);

      // Init UserModel
      // common.user = new UserModel();

       // Init google analitics
      // common.ga = new GAConstructor(preprocess.GA, Backbone, true);

      // common.sapi = new social.SocialApi({
      //   vk: new social.VKApi(preprocess.social.vk.appID),
      //   fb: new social.FBApi(preprocess.social.fb.appID),
      //   ok: new social.OKApi(preprocess.social.ok.appID, preprocess.social.ok.appKey)
      // });

      this.initPushstateLinks();
    }
//
    start() {
      for (let i = 0, sblock; i < sblocksComponents.length; i++) {
        sblock = sblocksComponents[i];
        common.sblocks.add(sblock);
      }
      common.sblocks.init($('body'));
      const layout = new Layout({el: '#layout'});
      layout.showCurrent();
      this.layout = layout;
      return Backbone.history.start(({
        pushState: Modernizr.history,
      }));
    }

    initPushstateLinks() {
      const selector = 'a:not([data-link]):not([href^="javascript:"])';
      this.$document.on('click', selector, function (evt) {
        $('.dropdown.open').removeClass('open');
        if (Boolean($(this).parents('.pluso-box').length)) {
          return;
        }
        const href = $(this).attr('href') || '';
        const protocol = `${this.protocol}//`;
        if (href.slice(0, protocol.length) !== protocol) {
          evt.preventDefault();
          common.router.navigate(href, true);
        }
      });
    }
}
