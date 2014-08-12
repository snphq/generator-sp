define (require, exports, module)->
  _Page = require "../_Page"
  AuthModal = require "view/modal/AuthModal/AuthModal"

  IndexPage = _Page.extend
    template:"#IndexPage"
    className:"index_page"

    events:
      "click":"onClick"

    onClick:->
     (new AuthModal).showModal()
