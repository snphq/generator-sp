define (require, exports, module)->
  Backbone = require "backbone"
  BackboneMixin = require "backbone-mixin"
  require "epoxy"
  ViewMixin = require "utils/ViewMixin"

  Layout = BackboneMixin(Backbone.View).extend {}
  ViewMixin Layout
