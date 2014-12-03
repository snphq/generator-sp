define (require, exports, module)->
  common = require "common"

  constructor = (SuperClass)->
    SuperClass.extend
      constructor: ->

        render = @render
        @render = ->
          result = render.apply this, arguments
          common.sblocks.init @$el
          @$el.addClass "view-mixin"
          result

        remove = @remove
        @remove = ->
          result = remove.apply this, arguments
          common.sblocks.destroy @$el
          result

        SuperClass::constructor.apply this, arguments
