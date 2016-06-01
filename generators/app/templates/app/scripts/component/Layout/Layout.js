import _Base from '../_Base';
import './Layout.css';

export default _Base.extend({
  regions: {
    content: '[data-view=content]',
    modal: '[data-view=modal]',
  },

  initialize() {},

  setContent(View, options, callback) {
    return this.r.content.show(View, options, () => {
      const view = this.r.content.getViewDI(View);
      if (typeof callback === 'function') {
        return callback(view);
      }
    });
  },

  getModalLayout() {
    return this.r.modal;
  },
});
