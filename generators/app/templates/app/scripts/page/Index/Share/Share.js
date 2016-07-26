import _Base from 'component/_Base';
import template from './Share.jade';
import './Share.css';
import './Share-patch-two.sass';

export default _Base.extend({

  template,

  className: 'share',

  ui: {
    share: '[ data-js="share"]',
  },

  events: {
    'click @ui.share': 'onShareClick',
  },

  onShareClick() {
    return;
  },
});
