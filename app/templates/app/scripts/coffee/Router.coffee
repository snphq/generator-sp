define [
  "backbone"
  "sp-utils-middleware"
  "common"
  "view/page"
  "view/modal"
],(
  Backbone
  Middleware
  common
  Page
  Modal
)->

  showPage=(View,options={},callback)->
    common.app.content.show View, options, callback

  class MiddlewareRouter extends Middleware
    auth:(async,args)->
      async.resolve "auth"

  middleware = new MiddlewareRouter

  Router = Backbone.Router.extend

    routes:
      "":"index"
      "!/404": "error404"
      "*default":"default_router"

    index: middleware.wrap ->
      view = showPage Page.IndexPage

    error404: middleware.wrap ->
      showPage Page.Error404Page

    default_router:->
      @navigate "!/404", {trigger:true,replace:true}
