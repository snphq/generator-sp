define ['underscore'], (_)->
  class Localization

    LANG: {}

    get: (path, args...)->
      path = path.split '.'
      iter = @LANG
      for step in path
        unless(iter=iter[step])
          console.error path
          return ''
      if _.isFunction(iter)
        iter.apply null, args
      else
        iter
