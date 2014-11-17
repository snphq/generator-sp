define [
  "backbone"
  "backbone-mixin"
  "epoxy"
],(Backbone, MixinBackbone)->
  SuperClass = MixinBackbone(Backbone.Epoxy.View)
  Item = SuperClass.extend {}
