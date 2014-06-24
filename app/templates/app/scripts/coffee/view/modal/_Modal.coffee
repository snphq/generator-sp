define (require, exports, module)->
  BootstrapModal = require 'sp-utils-bootstrapmodal'

  Modal = BootstrapModal.extend
    autoremove: true
