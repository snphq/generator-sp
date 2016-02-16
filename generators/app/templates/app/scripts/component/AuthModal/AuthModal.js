import _Modal from '../_Modal';
import './AuthModal.css';
import template from './AuthModal.jade';

export default _Modal.extend({
  template,
  className: 'auth-modal modal',

  ui: {
    ok: '[data-ok]',
  },

  events: {
    'click @ui.ok': 'onClickAuth',
  },

  onClickAuth() {
    return this.ok('User auth');
  },
});
