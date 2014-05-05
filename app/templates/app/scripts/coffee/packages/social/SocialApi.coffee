SocialApi = ($)->
  class SocialApi
    constructor:(@social)->

    checkAuth:(name)->
      async = $.Deferred()
      if(api = @social[name])
        api.checkAuth()
          .done ->
            async.resolve name
          .fail ->
            async.reject false
      else
        async.reject "no provider #{name}"
      async.promise()

    getProvider:(name)->
      async = $.Deferred()
      if(api = @social[name])
        api.checkAuth()
          .done -> async.resolve api
          .fail =>
            @login(name)
              .done ->  async.resolve api
              .fail (err)->   async.reject err
      else
        async.reject "no available provider with name=#{name}"
      async.promise()

    isAuth:->
      @_get (async,self)->
        async.resolve self.isAuth

    login:(name)->
      async = $.Deferred()
      if(self = @social[name])
        self.login()
          .done (data)=>
            @currentSocial = $.Deferred()
            @currentSocial.resolve name
            async.resolve data
          .fail (err)->
            async.reject(err)
      else
        self.reject "no provider #{name}"
      async.promise()

    logout:->
      @_get (async, self)=>
        self.logout()
          .done (data)=>
            @currentSocial = $.Deferred()
            @currentSocial.reject "not auth"
            async.resolve data
          .fail (err)->
            async.reject(err)

    getUser:->
      @_get (async,self,name)=>
        self.getUser()
          .done (data)->
            data.soc_type = name
            async.resolve data
          .fail (err)=>
            @logout().always ->
              async.reject(err)

    postWall:(options)->
      @_get (async,self)->
        self.postWall(options)
          .done (data)-> async.resolve data
          .fail (err)-> async.reject(err)

    getAlbums:->
      @_get (async,self)->
        self.getAlbums()
          .done (data)->
            async.resolve data
          .fail (err)->
            async.reject(err)

    getPhotos:(album_id)->
      @_get (async,self)->
        self.getPhotos(album_id)
          .done (data)->
            async.resolve data
          .fail (err)->
            async.reject(err)

    _getCurrentSocial:->
      unless @currentSocial?
        @currentSocial = $.Deferred()
        names = _.keys(@social)
        currentName = null

        finishCheckStatus = _.after names.length,=>
          unless currentName?
            @currentSocial.reject("not auth")

        _.each names, (name)=>
          @checkAuth(name)
            .done (name)=>
              unless currentName?
                currentName = name
                @currentSocial.resolve name
              else
                @social[name].logout()
            .always ->
              finishCheckStatus(name)

      @currentSocial.promise()

    _get:(callback)->
      async = $.Deferred()
      @_getCurrentSocial()
        .done (name)=>
          if @social[name]?
            callback async, @social[name], name
          else
            async.reject "no provider #{name}"
        .fail (err)->
          async.reject err
      async.promise()

if (typeof define is 'function') and (typeof define.amd is 'object') and define.amd
  define ["jquery"],($)-> SocialApi($)
else
  window.SocialApi = SocialApi($)
