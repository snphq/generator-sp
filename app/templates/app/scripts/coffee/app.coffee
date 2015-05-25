define (require, exports, module)->
  Backbone = require 'backbone'
  Router = require 'Router'
  ServerApi = require 'ServerAPI'
  preprocess = require 'preprocess'
  Layout = require 'view/layout'
  Modal = require 'view/modal'
  Page = require 'view/page'
  Widget = require 'view/widget'
  cookies = require 'cookies'
  # require 'utils/jqueryPatch'  # uncomment if You need touch-click support
  #GAConstructor = require 'sp-utils-gaconstructor'
  #UserModel = require 'model/UserModel'
  #social = require 'packages/social'

  $ = Backbone.$

  sblocks_components = [
    #simple-blocks implementation
    #https://github.com/lexich/simple-blocks
  ]

  $(document).ajaxSend (event, jqxhr, settings)->
    if settings.type != 'GET'
      jqxhr.setRequestHeader 'X-CSRF-Token', cookies.get('CSRF-Token')


  class Application
    constructor: (common)->
      common.router = new Router
      common.api = new ServerApi
      @$document = $ document

      # Init UserModel
      #common.user = new UserModel

      # Init google analitics
      #common.ga = new GAConstructor preprocess.GA, Backbone, true

      #common.sapi = new social.SocialApi
      #  vk: new social.VKApi preprocess.social.vk.appID
      #  fb: new social.FBApi preprocess.social.fb.appID
      #  ok: new social.OKApi preprocess.social.ok.appID, preprocess.social.ok.appKey

      @initPushstateLinks()

    start: ->
      for sblock in sblocks_components
        common.sblocks.add sblock
      common.sblocks.init $('body')
      layout = {}
      layout.header   = new Layout.HeaderLayout   el: '#header-layout'
      layout.content  = new Layout.ContentLayout  el: '#content-layout'
      layout.footer   = new Layout.FooterLayout   el: '#footer-layout'
      layout.modal    = new Layout.ModalLayout    el: '#modal-layout'
      for key, item of layout
        item.showCurrent()
        this[key] = item
      Backbone.history.start {
       pushState: Modernizr.history
      }

    initPushstateLinks: ->
      selector = "a:not([data-link]):not([href^='javascript:'])"
      @$document.on "click", selector, (evt)->
        $(".dropdown.open").removeClass("open")
        return if !!$(this).parents(".pluso-box").length
        href = $(this).attr("href") or ""
        protocol = @protocol + "//"
        if href.slice(0, protocol.length) isnt protocol
          evt.preventDefault()
          common.router.navigate href, true

