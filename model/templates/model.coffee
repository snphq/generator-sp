define [
  "backbone"
  "epoxy"
],(Backbone)->
  <%= normalize_name %> = Backbone.Epoxy.Model.extend
    defaults:
      field:"value"
    parse:(r)->
      r
