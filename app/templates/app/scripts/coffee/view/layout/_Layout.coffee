define [
  'backbone'
  'underscore'
  'backbone-mixin'
],(Backbone, _, MixinBackbone)->

  Layout = MixinBackbone(Backbone.View).extend {}

