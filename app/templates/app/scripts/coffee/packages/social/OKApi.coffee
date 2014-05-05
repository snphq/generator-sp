OKApi = ($, _, md5)->
  parametrize = (obj, join = false) ->
    arrayOfArrays = _.pairs(obj).sort()
    symbol = if join then '&' else ''
    sortedParams = ''
    _.each arrayOfArrays, (value) ->
      sortedParams += "#{_.first(value)}=#{_.last(value)}" + symbol
    sortedParams

  okSignature = (postData,sessionSecret,application_key) ->
    data = _.extend {application_key}, postData
    sortedParams = parametrize(data)
    md5(sortedParams + sessionSecret)

  class OKApi
    constructor:(@appId, @appKey)->
      @OK_COOKIE = "okas_#{@appId}"
      @OKSR_COOKIE = "oksr_#{@appId}"
      @reset()

    reset:->
      @isAuth = false
      @user = null

    _getRoles:->

    getOK:->
      async=$.Deferred()
      authData = $.cookie @OK_COOKIE
      @isAuth = !!authData
      if @isAuth
        data = authData.split ';'
        if data.length isnt 2
          data = authData.split '%3B'
        if data.length is 2
          async.resolve
            secret:data[0]
            token:data[1]
        else
          async.reject "not valid authData:#{authData}"
      else
        async.reject "no ok auth"
      async.promise()

    makeRequest: (session, method, postData)->
      unless session? then throw new Error("no session")
      sig = okSignature postData, session.secret, @appKey
      requestedData = _.extend {
        access_token: session.token
        application_key: @appKey
        sig
      }, postData

      $.ajax
        url: "/odnoklassniki/fb.do"
        type: method
        data: requestedData
        dataType: 'json'

    login:->
      async = $.Deferred()
      @getOK()
        .done ->
          async.resolve true
        .fail (err)->
          window.open "/users/auth/odnoklassniki", "ok_auth"
          window.callAuthSuccess = ->
            window.callAuthSuccess = null
            window.callAuthFail = null
            async.resolve true

          window.callAuthFail = ->
            window.callAuthSuccess = null
            window.callAuthFail = null
            async.reject err

      async.promise()

    checkAuth:-> @getOK()

    getUser:->
      async = $.Deferred()
      unless @user?
        @getOK()
          .done (session)=>
            requestAsync = @makeRequest session, 'GET',{
              method: 'users.getCurrentUser'
            }
            requestAsync
              .done (data)=>
                return async.reject data.error_msg if data.error_code?
                try
                  birthday = new Date r.birthday
                @user =
                  id:data.uid
                  first_name: data.first_name
                  last_name: data.last_name
                  username:data.name
                  gender: data.gender
                  avatar:data.pic_1
                  avatar_url: data.pic_2
                  birthday: birthday
                  soc_type: "ok"
                async.resolve @user
              .fail (err)->
                async.reject err
          .fail (err)->
            async.reject err
      else
        async.resolve @user
      async.promise()

    logout:->
      async = $.Deferred()
      $.removeCookie @OK_COOKIE
      $.removeCookie @OKSR_COOKIE
      @reset()
      async.resolve()
      async.promise()

    getAlbums:->
      async = $.Deferred()
      @getOK()
        .done (session)=>
          requestAsync = @makeRequest session, 'GET',
            method: 'photos.getAlbums'
            fields: 'album.aid,photo.pic128x128,photo.pic640x480'
          requestAsync
            .done (data)->
              data = _.map data['albums'], (item)->
                if item.main_photo?
                  thumb_src = item.main_photo.pic640x480 or item.main_photo.pic128x128
                else
                  thumb_src = item.pic640x480 or item.pic128x128
                item.album_id = item.aid
                item.thumb_src = thumb_src
                item.title = ""
                item
              async.resolve data
            .fail (err)->
              async.reject err
        .fail (err)->
          async.reject err
      async.promise()

    getPhotos:(album_id)->
      async = $.Deferred()
      @getOK()
        .done (session)=>
          requestAsync = @makeRequest session, 'GET',
            method: 'photos.getPhotos'
            aid: album_id
          requestAsync
            .done (data)->
              data = _.map data['photos'], (item)->
                item.picture = item.pic128x128
                item.source = item.pic640x480
                item
              async.resolve data
            .fail (err)->
              async.reject err
        .fail (err)->
          async.reject err
      async.promise()

if (typeof define is 'function') and (typeof define.amd is 'object') and define.amd
  define ["jquery","underscore","md5","jquery.cookie"],($, _, md5)-> OKApi($, _, md5)
else
  window.OKApi = OKApi($, _, md5)
