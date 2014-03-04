define [
  "backbone"
  "model/<%= model_name %>"
],(Backbone, <%= model_name %> )->
  <%= normalize_name %> = Backbone.Collection.extend
    model: <%= model_name %>
    # view:View

