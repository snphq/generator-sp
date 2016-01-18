import _Modal from '../_Modal';
import './AuthModal.sass';
import template from './AuthModal.jade';

export default class AuthModal extends _Modal {
  template = template;
  className = 'auth-modal modal';

  ui = {
    ok: '[data-ok]',
  };

  events = {
    'click @ui.ok': 'onClickAuth',
  };

  onClickAuth() {
    return this.ok('User auth');
  }
}
