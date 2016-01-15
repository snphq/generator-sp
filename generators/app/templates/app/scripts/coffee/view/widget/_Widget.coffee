define (require, exports, module)->
  Backbone = require 'backbone'
  BackboneMixin = require 'backbone-mixin'
  ViewMixin = require 'utils/ViewMixin'
  require 'epoxy'

  SuperClass = BackboneMixin(Backbone.Epoxy.View)
  Widget = SuperClass.extend {}
  ViewMixin Widget
