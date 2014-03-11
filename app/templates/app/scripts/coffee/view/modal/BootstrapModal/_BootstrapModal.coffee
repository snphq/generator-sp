define (require, exports, module)->
  require 'epoxy'
  require "bootstrap"

  Backbone = require 'backbone'
  _ = require 'underscore'
  common = require "common"
  MixinBackbone = require 'backbone-mixin'

  SuperClass = MixinBackbone(Backbone.Epoxy.View)
  $ = Backbone.$


  BootstrapModal = SuperClass.extend
    initialize:->
      @async = $.Deferred()
      @async.promise().always => @remove()

      @$modalEl = @$el.find(".modal")
      @isShown = false
      @_bindModal()

    remove:->
      @_unbindModal()
      SuperClass::remove.apply this, arguments

    showAnimation:(callback)->
      return callback?() if @isShown is true
      @_bindModal()
      @$modalEl.one "shown.bs.modal", =>
        @isShown = true
        callback?()
      @$modalEl.modal "show"

    closeAnimation:(callback)->
      return callback?() if @isShown is false
      @_unbindModal()
      @$modalEl.one "hidden.bs.modal", =>
        @isShown = false
        callback?()
      @$modalEl.modal "hide"

    showModal:->
      common.app.modal.show this
      @async.promise()

    ok:(data={})->
      common.app.modal.close this, =>
        @async.resolve data
      @async.promise()

    cancel:(err="error")->
      common.app.modal.close this, =>
        @async.reject err
      @async.promise()

    _bindModal:->
      @_unbindModal()
      @$modalEl.on "hidden.bs.modal", =>
        @isShown = false
        @cancel "hide modal"

    _unbindModal:->
      @$modalEl.off "hidden.bs.modal"
