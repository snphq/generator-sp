define [
  'backbone'
  'underscore'
  'backbone-mixin'
  "common"
  'epoxy'
  "boostrap"
],(Backbone, _, MixinBackbone,common)->
  SuperClass = MixinBackbone(Backbone.Epoxy.View)
  $ = Backbone.$
  Modal = SuperClass.extend
    initialize:->
      @async = $.Deferred()

    showModal:->
      common.app.modal.show this
      @_modal().modal("show")
      @async.promise()

    ok:(data={})->
      common.app.modal.close this
      @async.resolve data
      @async.promise()

    cancel:(err="error")->
      common.app.modal.close this
      @async.reject err
      @async.promise()
