define [
  "backbone"
  "underscore"
  "backbone-mixin"
  "epoxy"
],(Backbone, _, MixinBackbone)->
  SuperClass = MixinBackbone(Backbone.Epoxy.View)
  <%= normalize_name %> = SuperClass.extend
    template:"#<%= normalize_name %>"
    className:"<%= css_classname %>"

