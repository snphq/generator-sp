define (require, exports, module)->
  Backbone = require "backbone"
  Router = require "Router"
  ServerApi = require "ServerAPI"
  preprocess = require "preprocess"
  Layout = require "view/layout"
  Modal = require "view/modal"
  Page = require "view/page"
  Widget = require "view/widget"

  #GAConstructor = require "sp-utils-gaconstructor"
  #UserModel = require "model/UserModel"
  #social = require "packages/social"

  $ = Backbone.$

  class Application
    constructor: (common)->
      common.router = new Router
      common.api = new ServerApi

      # Init UserModel
      #common.user = new UserModel

      # Init google analitics
      #common.ga = new GAConstructor preprocess.GA, Backbone, true


      #common.sapi = new social.SocialApi
      #  vk: new social.VKApi preprocess.social.vk.appID
      #  fb: new social.FBApi preprocess.social.fb.appID
      #  ok: new social.OKApi preprocess.social.ok.appID, preprocess.social.ok.appKey

    start:->
      layout = {}
      layout.header   = new Layout.HeaderLayout   el: "#header-layout"
      layout.content  = new Layout.ContentLayout  el: "#content-layout"
      layout.footer   = new Layout.FooterLayout   el: "#footer-layout"
      layout.modal    = new Layout.ModalLayout    el: "#modal-layout"
      for key, item of layout
        item.showCurrent()
        this[key] = item
      Backbone.history.start()
