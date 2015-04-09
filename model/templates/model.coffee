define (require, exports, module)->
  Backbone = require 'backbone'
  require 'epoxy'

  <%= normalize_name %> = Backbone.Epoxy.Model.extend

    defaults:
      field: 'value'

    #parse:(r)->
    #  r
