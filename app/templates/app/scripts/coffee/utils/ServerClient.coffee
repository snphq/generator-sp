define ["jquery"],($)->

  class Lock
    constructor:->
      @_locks = {}
      @initialize.apply this, arguments

    initialize:->
      #for overwrite

    trylock:(url, name)->
      key = @hash url, name
      if !!@_locks[key]
        false
      else
        @_locks[key] = true
        true

    unlock:(url="", name="")->
      key = @hash url, name
      if !!@_locks[key]
        @_locks[key] = null
        true
      else
        false

    hash:(url,name)->
      url or (url = "")
      name or (name = "")
      "#{name}#{url}"

  class ServerClient
    constructor:->
      @lock = new Lock

    _isServer:-> true

    _ajax:(options, async)->
      lockname = options.lock
      url = options.url
      options.lock = null
      return unless @lock.trylock url, lockname
      options.stub = null
      $.ajax(options)
        .done (data)->
          unless data.result is "error"
            async.resolve data
          else
            async.reject data
        .fail (err)->
          async.reject err
        .always =>
          @lock.unlock url, lockname

    ajax:(options)->
      async = $.Deferred()
      options or options = {}

      if @_isServer()
        @_ajax options, async
      else
        if options.stub?
          options.stub? async
        else
          @_ajax options, async
      async.promise()

    get:(options)->
      options or options = {}
      options.type = "GET"
      @ajax options

    post:(options)->
      options or options = {}
      options.type = "POST"
      @ajax options
