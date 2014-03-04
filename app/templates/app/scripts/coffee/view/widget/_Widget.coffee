define [
  "backbone"
  "backbone-mixin"
  "epoxy"
],(Backbone, MixinBackbone)->
  SuperClass = MixinBackbone(Backbone.Epoxy.View)
  Widget = SuperClass.extend {}
