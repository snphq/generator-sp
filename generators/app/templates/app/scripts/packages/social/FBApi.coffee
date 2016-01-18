FBApi = ($, _)->
  class FBApi
    constructor: (@appId)->
      @reset()
      @appId = appId
      @timeout = null
      @TIMEOUT_WAIT = 10000

    reset: ->
      @isAuth = false
      @user = null

    _getRoles: (FB)-> ''

    _startWaitResponse: (callback)->
      @_stopWaitResponse()
      @timeout = setTimeout (=>
        callback()
        @timeout = null
      ), @TIMEOUT_WAIT

    _stopWaitResponse: ->
      clearTimeout @timeout if @timeout?

    _getStatus: (async, FB)->
      @_startWaitResponse ->
        async.reject 'not FB connect', FB

      FB.getLoginStatus (r)=>
        @_stopWaitResponse()
        if r.status is 'connected'
          @isAuth = true
          async.resolve FB
        else
          @reset()
          async.reject 'not auth FB', FB

    checkAuth: ->
      async = $.Deferred()
      @getFB().always (data)=>
        if @isAuth
          async.resolve @isAuth
        else
          async.reject data
      async.promise()

    login: ->
      async = $.Deferred()
      @getFB().always (authFB, notAuthFB)=>
        if(FB=notAuthFB)
          FB.login ((r)=>
            if r.status is 'connected'
              @isAuth = true
              async.resolve FB
            else
              @reset()
              async.reject 'not auth FB'
          ), scope: @_getRoles(FB)
        else
          async.resolve FB
      async.promise()

    logout: ->
      async = $.Deferred()
      @getFB()
        .done (FB)=>
          FB.logout (r)=>
            if r
              async.resolve FB
              @isAuth = false
            else
              @reset()
              async.reject FB
        .fail (err)->
          async.reject err
      async.promise()

    getFB: ->
      async = $.Deferred()
      unless @_$_FB?
        setTimeout (->
          el = document.createElement 'script'
          el.type = 'text/javascript'
          el.src = '//connect.facebook.net/ru_RU/all.js'
          el.async = true
          document.getElementsByTagName('body')[0].appendChild el
        ), 0
        window.fbAsyncInit = =>
          window.fbAsyncInit = null
          @_$_FB = FB = window.FB
          FB.init
            appId: @appId
            status: true
            cookie: true
            xfbml: true
            oauth: true
          @_getStatus async, FB
      else if @isAuth
        async.resolve @_$_FB
      else
        @_getStatus async, @_$_FB
      async.promise()

    getUser: ->
      async = $.Deferred()
      if @user?
        async.resolve @user, FB
      else
        @getFB()
          .done (FB)=>
            FB.api '/me?locale=en_EN', (r)=>
              if !!r.error then async.reject(r.error)
              else
                try
                  rx = /(\d{1,2})\/(\d{1,2})\/(\d{4})/
                  rpl = '$3-$1-$2'
                  birthday = new Date r.birthday.replace(rx, rpl)
                @user =
                  id: r.id
                  first_name: r.first_name
                  last_name: r.last_name
                  username: r.username
                  avatar_url: "https://graph.facebook.com/#{r.id}/picture?width=150&height=150"
                  avatar: "https://graph.facebook.com/#{r.id}/picture?type=square"
                  gender: r.gender
                  birthday: birthday
                  soc_type: 'fb'
                async.resolve @user, FB
          .fail (err)->
            async.reject err
      async.promise()

    postWall: (options)->
      { title, description, link, image } = _.defaults options, {
        title: ''
        description: ''
        link: ''
        image: ''
      }
      async = $.Deferred()
      @getFB()
        .done (FB)->
          FB.ui {
            method: 'feed'
            name: title
            caption: ''
            description: description
            link: link
            picture: image
          }, (r)->
            return async.reject('null responce') if !r
            return async.reject(r.error) if !!r.error
            async.resolve r.post_id
        .fail (err)->
          async.reject err
      async.promise()

    getAlbums: ->
      async = $.Deferred()
      @getFB()
        .done (FB)->
          FB.api 'me/albums?fields=created_time,name,updated_time,id,photos.limit(1),count', (response)->
            parsed = new Array()
            _ response.data
            .filter (i)-> i.photos?
            .each (value, index)->
              thumb = _.chain value.photos.data?[0].images
              .filter (item)-> item.height < 500 and item.width < 500
              .max (item)-> item.width
              .value()
              thumb_src = thumb.source
              parsed.push
                id: value.object_id
                title: value.name
                # owner_id: value.owner
                size: parseInt(value.count)
                thumb_id: value.photos.data?[0].id
                thumb_src: thumb_src
                created: new Date value.created_time
                updated: new Date value.updated_time
                #aid: value.aid
                aid: value.id
                album_id: value.id
                link: value.link
            async.resolve(parsed)
        .fail (err)->
          async.reject(err)
      async.promise()
    getPhotos: (album_id)->
      async = $.Deferred()
      @getFB()
        .done (FB)->
          FB.api "#{album_id}/photos", (r)->
            async.resolve r.data
        .fail (err)->
          async.reject(err)
      async.promise()

if (typeof define is 'function') and (typeof define.amd is 'object') and define.amd
  define ['jquery', 'underscore'], ($, _)-> FBApi($, _)
else
  window.FBApi = FBApi($, _)
