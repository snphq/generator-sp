define (require, exports, module)->
  _Page = require "../_Page"

  IndexPage = _Page.extend
    template:"#IndexPage"
    className:"index_page"
