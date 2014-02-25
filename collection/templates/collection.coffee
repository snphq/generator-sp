define [
  "backbone"
  "model/<%= model_name %>"
],(Backbone )->
  <%= normalize_name %> = Backbone.Collection.extend
    model: <%= model_name %>
    # view:View

