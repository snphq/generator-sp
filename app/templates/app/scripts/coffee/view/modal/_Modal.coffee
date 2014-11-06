define (require, exports, module)->
  BootstrapModal = require 'sp-utils-bootstrapmodal'
  common = require "common"
  Modal = BootstrapModal.extend
    autoremove: true
    layoutManager: ->
      common.app.modal
