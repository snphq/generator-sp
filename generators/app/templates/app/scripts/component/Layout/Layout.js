import _Base from '../_Base';
import './Layout.sass';

export default _Base.extend({
  regions: {
    content: '[data-view=content]',
    modal: '[data-view=modal]',
  },

  initialize() {},

  setContent(View, callback) {
    return this.r.content.show(View, () => {
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
