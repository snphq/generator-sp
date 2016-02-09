import _Modal from 'component/_Modal';
import './TestModal.sass';
import template from './TestModal.jade';

export default _Modal.extend({
  template,
  className: 'test-modal modal',

  // initialize() {
  //   Reflect.apply(_Modal.prototype.initialize, this, arguments);
  //   // You code here
  // },

  // showModal() {
  //   // You code here
  //   return Reflect.apply(_Modal.prototype.showModal, this, arguments);
  // },
});
