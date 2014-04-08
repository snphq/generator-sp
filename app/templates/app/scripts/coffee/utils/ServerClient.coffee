define ["jquery"],($)->

  class Lock
    constructor:(@accept_logs=false)->
      @_locks = {}

    trylock:(url, name)->
      key = @hash url, name
      if !!@_locks[key]
        console.warn "tryLock #{url} #{name}" if @accept_logs
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
        console.warn "unlock #{url} #{name}" if @accept_logs
        false

    hash:(url,name)->
      url or (url = "")
      name or (name = "")
      "#{name}#{url}"

  class ServerClient
    constructor:(options)->
      @lock = new Lock {accept_logs:options.accept_logs}
      @initialize.apply this, arguments

    initialize:->
      #for overwrite

    _isServer:-> true

    _ajax:(options, async)->
      lockname = options.lock
      url = options.url
      options.lock = null
      return unless @lock.trylock url, lockname
      options.stub = null
      $.ajax(options)
        .done (data)->
          if not data or data.result is "error"
            async.reject data
          else
            async.resolve data

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

    put:(options)->
      options or options = {}
      options.type = "PUT"
      @ajax options
