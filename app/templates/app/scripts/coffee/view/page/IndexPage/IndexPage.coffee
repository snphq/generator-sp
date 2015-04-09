define (require, exports, module)->
  _Page = require '../_Page'
  AuthModal = require 'view/modal/AuthModal/AuthModal'

  IndexPage = _Page.extend
    template: '#IndexPage'
    className: 'index_page'

    ui:
      auth: "[data-js='auth']"
    events:
      'click @ui.auth': 'onClick'

    onClick: ->
      (new AuthModal).showModal()
