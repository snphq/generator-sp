import _Modal from 'component/_Modal';
import './<%= componentName %>.sass';
import template from './<%= componentName %>.jade';

export default _Modal.extend({
  template,
  className: '<%= cssClassname %> modal',

  // initialize() {
  //   Reflect.apply(_Modal.prototype.initialize, this, arguments);
  //   // You code here
  // },

  // showModal() {
  //   // You code here
  //   return Reflect.apply(_Modal.prototype.showModal, this, arguments);
  // },
});
