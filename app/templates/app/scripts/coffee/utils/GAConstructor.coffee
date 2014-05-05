define ["jquery"],($)->

  class GAConstructor
    constructor:(KEY, Backbone)->
      window._gaq = window._gaq || []
      _gaq.push ['_setAccount', KEY]
      ga = document.createElement("script")
      ga.type = "text/javascript"
      ga.async = true
      ga.src = ((if "https:" is document.location.protocol then "https://ssl" else "http://www")) + ".google-analytics.com/ga.js"
      s = document.getElementsByTagName("script")[0]
      s.parentNode.insertBefore ga, s
      if Backbone?
        Backbone.history.on "route",=> @trackPageView()
      else
        @trackPageView()

    initElementClick:($el,category,actions="",labels="")->
      return if $el.attr "data-ga-click"
      $el.click => @trackEvent category, actions, labels
      $el.attr "data-ga-click", "#{category};#{actions};#{labels}"
      $el

    unlinkElementClick:($el)->
      $el.off("click")
      $el.attr "data-ga-click",""

    trackPageView:->
      window._gaq.push ['_trackPageview', window.location.href]

    trackEvent:(category,actions="",labels="")->
      window._gaq.push ['_trackEvent',category, actions, labels]
