define (require, exports, module)->
  _Modal = require '../_Modal'
  common = require 'common'

  AuthModal = _Modal.extend
    template: '#AuthModal'
    className: 'auth_modal'
    ui:
      ok: '[data-ok]'
    events:
      'click @ui.ok': 'on_click_auth'

    on_click_auth: ->
      @ok 'User auth'
