define [
  "backbone"
  "Router"
  "view/layout"
  "ServerApi"
  "preprocess"

], (Backone, Router, Layout, ServerApi, preproces)->
  $ = Backone.$

  class Application
    constructor:(common, @_gaq)->
      common.router = new Router
      common.api = new ServerApi

      # import "packages/social"
      #common.sapi = new social.SocialApi
      #  vk: new social.VKApi preprocess.social.vk.appID
      #  fb: new social.FBApi preprocess.social.fb.appID
      #  ok: new social.OKApi preprocess.social.ok.appID, preprocess.social.ok.appKey

      #import models/UserModel
      #common.user = new UserModel

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
