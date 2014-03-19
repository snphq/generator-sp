define (require, exports, module)->
  BootstrapModal = require './BootstrapModal/_BootstrapModal'

  Modal = BootstrapModal.extend
    autoremove: true
    initialize:(options)->
      @autoremove = options?.autoremove or @autoremove
      @on "onClose",=> setTimeout (=>
        @remove() if @autoremove
      ),10
