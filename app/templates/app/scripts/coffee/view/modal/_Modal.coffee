define (require, exports, module)->
  BootstrapModal = require 'sp-utils-bootstrapmodal'
  ViewMixin = require 'utils/ViewMixin'
  common = require 'common'
  Modal = BootstrapModal.extend
    autoremove: true
    layoutManager: ->
      common.app.modal

  ViewMixin Modal
