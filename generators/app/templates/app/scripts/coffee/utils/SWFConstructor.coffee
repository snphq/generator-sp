define ['swfobject', 'underscore'], (swfobject, _)->
  class SWFConstructor
    constructor: (options = {})->
      @flashvars = options.flashvars or {}
      @swfVersionStr = options.swfVersionStr or '11.3'
      @params = _.defaults options.params or {}, {
        quality: 'high'
        bgcolor: '#000000'
        play: 'true'
        loop: 'true'
        wmode: 'opaque'
        scale: 'noScale'
        menu: 'false'
        devicefont: 'false'
        salign: ''
        allowscriptaccess: 'always'
        allownetworking: 'all'
        allowFullscreen: 'true'
        allowScriptAccess: 'always'
      }
      @attributes = _.defaults options.attributes or {}
      @xiSwfUrlStr = options.xiSwfUrlStr or ''
      swfobject.switchOffAutoHideShow()

    initYoutube: ($el, youid, width, height, callback=->)->
      url = "http://www.youtube.com/v/#{youid}?enablejsapi=1\
            &version=3&playerapiid=ytplayer&showinfo=0\
            &rel=0&autohide=1&loop=1&wmode=opaque&autoplay=1"
      @init $el, url, width, height, callback

    init: ($el, url, width, height, callback=->)->
      el = $el[0]
      id = $el.id = _.unique('swf') unless(id = el.id)
      attributes = _.defaults @attributes, {id, name: id, align: id}

      swfobject.embedSWF(
        url,
        el,
        width,
        height,
        @swfVersionStr,
        @xiSwfUrlStr,
        @flashvars,
        @params,
        @attributes,
        callback
      )
