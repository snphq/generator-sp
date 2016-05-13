import _Page from '../_Base';
import AuthModal from 'component/AuthModal';
import Share from './Share';
import template from './Index.jade';
import './Index.css';
import 'fonts/Muller/muller.css';

export default _Page.extend({

  template,

  className: 'p-index',

  regions: {
    share: {
      el: '[data-view=share]',
      view: Share,
    },
  },

  ui: {
    auth: '[data-js="auth"]',
  },

  events: {
    'click @ui.auth': 'onClick',
  },

  onClick() {
    return (new AuthModal()).showModal();
  },
});
