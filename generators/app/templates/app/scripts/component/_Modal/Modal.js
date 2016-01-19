import BootstrapModal from 'sp-utils-bootstrapmodal';
import viewMixin from 'utils/ViewMixin';
import common from 'common';
import './Modal.sass';

const Modal = BootstrapModal.extend({
  autoremove: true,

  templateFunc() {
    return this.template || this.$el.html() || '';
  },

  layoutManager() {
    return common.app.layout.getModalLayout();
  },
});

export default viewMixin(Modal);
