define [
  "backbone"
  "Router"
  "ServerApi"
  "preprocess"
  "view/layout"
  "view/modal"
  "view/page"
  "view/widget"
], (Backone, Router, ServerApi, preproces, Layout)->
  $ = Backone.$

  class Application
    constructor:(common, @_gaq)->
      #import models/UserModel
      #common.user = new UserModel
      common.router = new Router
      common.api = new ServerApi

      # Init google analitics
      # common.ga = new GAConstructor preprocess.GA, Backbone

      # import "packages/social"
      #common.sapi = new social.SocialApi
      #  vk: new social.VKApi preprocess.social.vk.appID
      #  fb: new social.FBApi preprocess.social.fb.appID
      #  ok: new social.OKApi preprocess.social.ok.appID, preprocess.social.ok.appKey

    start:->
      layout = {}
      layout.header   = new Layout.HeaderLayout   el:"#header-layout"
      layout.content  = new Layout.ContentLayout  el:"#content-layout"
      layout.footer   = new Layout.FooterLayout   el:"#footer-layout"
      layout.modal    = new Layout.ModalLayout    el:"#modal-layout"
      for key, item of layout
        item.showCurrent()
        this[key] = item
      Backone.history.start()
