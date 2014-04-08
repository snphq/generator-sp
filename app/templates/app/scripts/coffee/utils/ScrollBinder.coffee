define [],->
  class ScrollBinder
    constructor:(@view)->
    bind:(listenViewScrollCallback)->
      unless !!@_bind then @_bind = true else return
      mousewheel = false
      unless @__hdl_mousewheel?
        @__hdl_mousewheel = (e)=>
          mousewheel = true
          listenViewScrollCallback.apply @view, arguments
          mousewheel = false
          true
      unless @__hdl_scroll?
        @__hdl_scroll = (e)=>
          return if mousewheel
          listenViewScrollCallback.apply @view, arguments
      @view.$el.on "mousewheel", @__hdl_mousewheel
      @view.$el.on "scroll", @__hdl_scroll

    unbind:->
      @_bind = false
      @view.$el.off "mousewheel",@__hdl_mousewheel
      @view.$el.off "scroll", @__hdl_scroll
