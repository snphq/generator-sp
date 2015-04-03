define (require, exports, module)->
  $ = require "jquery"
  if Modernizr.touch
    CLASSNAME = "touchHover"
    DATANAME = "notouch"
    touchstart = (e)->
      $(e.target).addClass CLASSNAME
    touchmove = (e)->
      $(e.target).removeClass(CLASSNAME).data(DATANAME,true)
    wrapTouchend = (method)->
      (e)->
        $el = $(e.target)
        $el.removeClass(CLASSNAME)
        if $el.data(DATANAME) then $el.removeData DATANAME
        else method.apply this, arguments
    rxClick = /click/g

    add = $.event.add
    $.event.add = (el, types, fn, data, one)->
      if types.indexOf("click") < 0
        add.apply this, arguments
      else
        t =
          touchstart: types.replace /click/g, "touchstart"
          touchmove: types.replace /click/g, "touchmove"
          touchend: types.replace /click/g, "touchend"

        add.call this, el, t.touchstart, touchstart, data, one
        add.call this, el, t.touchmove, touchmove, data, one
        add.call this, el, t.touchend, wrapTouchend(fn), data, one

    remove = $.event.remove
    $.event.remove = (el, types, handler, selector, mappedTypes)->
      if types.indexOf("click") < 0
        remove.apply this, arguments
      else
        t =
          touchstart: types.replace /click/g, "touchstart"
          touchmove: types.replace /click/g, "touchmove"
          touchend: types.replace /click/g, "touchend"
        remove.call this, el, t.touchstart, handler, selector, mappedTypes
        remove.call this, el, t.touchmove, handler, selector, mappedTypes
        remove.call this, el, t.touchend, handler, selector, mappedTypes
  $
