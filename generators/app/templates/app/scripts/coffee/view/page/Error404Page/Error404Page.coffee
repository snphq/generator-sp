define (require, exports, module)->
  _Page = require '../_Page'

  Error404Page = _Page.extend
    template: '#Error404Page'
    className: 'error404_page'
