VKApi = ($)->
  class VKApi
    constructor:(@appID)->
      @version = "5.20"
      @reset()
      @timeout = null
      @TIMEOUT_WAIT = 10000

    reset:->
      @user = null
      @isAuth = false

    _startWaitResponse:(callback)->
      @_stopWaitResponse()
      @timeout = setTimeout (=>
        callback()
        @timeout = null
      ),@TIMEOUT_WAIT

    _stopWaitResponse:->
      clearTimeout @timeout if @timeout?

    getVK:->
      async = $.Deferred()
      unless @_$_VK?
        setTimeout (->
          el = document.createElement "script"
          el.type = "text/javascript"
          el.src = "//vk.com/js/api/openapi.js"
          el.async = true
          document.getElementsByTagName("body")[0].appendChild el
        ), 0
        window.vkAsyncInit = =>
          window.vkAsyncInit = null
          @_$_VK = VK = window.VK
          VK.init apiId:@appID
          @_getStatus async, VK

      else if @isAuth
        async.resolve @_$_VK
      else
        @_getStatus async, VK
      async.promise()

    checkAuth:->
      async = $.Deferred()
      @getVK().always (data)=>
        if @isAuth
          async.resolve @isAuth
        else
          async.reject data
      async.promise()

    _getRoles:(VK)->
      VK.access.PHOTOS + 8192

    _getStatus:(async,VK)->
      @_startWaitResponse ->
        async.reject "not VK connect",VK

      VK.Auth.getLoginStatus (resp)=>
        if resp.session
          @isAuth = true
          async.resolve VK
        else
          @reset()
          async.reject "no auth VK", VK

    login:->
      async = $.Deferred()
      @getVK().always (authVK,notAuthVK)=>
        if(VK = notAuthVK) or (VK =authVK ) then VK.Auth.login ((resp)=>
          if resp.session
            @isAuth = true
            async.resolve VK
          else
            @reset()
            async.reject "no auth VK",VK
          ), @_getRoles(VK)
      async.promise()


    logout:(callback)->
      async = $.Deferred()
      @getVK()
        .done (VK)=>
          VK.Auth.logout (r)=>
            if !!r.error
              async.reject(r.error)
            else
              @reset()
              async.resolve(r.response)
        .fail (err)->
          async.reject(err)
      async.promise()

    getUser:->
      async = $.Deferred()
      if @user?
        async.resolve @user, VK
      else
        @getVK()
          .done (VK)=>
            VK.Api.call 'users.get',{
              v:@version
              fields:"photo_200_orig,photo_50,sex,bdate"
            },(r)=>
              if !!r.error then async.reject(r.error)
              else
                user = r?.response[0]
                gender = if user.sex is 1
                  "female"
                else if user.sex is 2
                  "male"
                try
                  rx = /(\d{1,2})\.(\d{1,2})\.(\d{4})/
                  rpl = '$3-$2-$1'
                  birthday = new Date user.bdate.replace(rx,rpl)
                @user =
                  id: user.id
                  first_name: user.first_name
                  last_name: user.last_name
                  username: "#{user.first_name} #{user.last_name}"
                  avatar_url: user['photo_200_orig']
                  avatar: user['photo_50']
                  gender: gender
                  birthday: birthday
                  soc_type: "vk"
              async.resolve @user,VK
          .fail (err,VK)->
            async.reject err
      async.promise()

    getAlbums:->
      async = $.Deferred()
      @getUser()
        .done (user,VK)->
          VK.Api.call "photos.getAlbums", {
            owner_id:user.id
            need_covers:1
            album_ids:true
            photo_sizes: 1
            v:@version
          }, (r)->
            if !!r.error then async.reject r.error
            else
              data = _.map r.response, (item)->
                item.album_id = item.aid
                item.thumb_src = (_.where item.sizes, type:"x")[0].src
              async.resolve r.response
        .fail (err)->
          async.reject err
      async.promise()

    postWall:(options)->
      { title, description, link, attachments } = _.defaults options, {
        title: ""
        description: ""
        link: ""
        attachments: ""
      }
      #link = encodeURIComponent(link)
      if !!link
        attachments += "," if !!attachments
        attachments += link
      async = $.Deferred()
      return async.reject("not openapi use") unless window.VK?
      if !@user or !@isAuth
        VK.Auth.login ((r)=>
          if r.session
            @isAuth = true
            @getUser().done (user,VK)->
              postWall(user)
          else
            @reset()
            async.reject "no auth VK",VK
          ), @_getRoles(VK)
      else
        VK.Api.call "wall.post",{
          owner_id:@user.id,
          message: "#{title} #{description}"
          attachments
          version:@version
        },(r)->
          return async.reject(r.error) if !!r.error
          if(post_id = r.response.post_id)
            async.resolve post_id
          else
            async.reject r
      async.promise()

    getPhotos:(album_id)->
      async = $.Deferred()
      @getUser()
        .done (user, VK)->
          VK.Api.call "photos.get", {
            owner_id:user.id
            album_id
            photo_sizes:1
            v:@version
          }, (r)->
            if !!r.error
              async.reject(r.error)
            else
              data = _.map r.response, (item)->
                item.picture =  (_.where item.sizes, type:"x")[0].src
                item.source = item.sizes[2].src

              async.resolve(r.response)
        .fail (err)->
          async.reject err
      async.promise()

if (typeof define is 'function') and (typeof define.amd is 'object') and define.amd
  define ["jquery"],($)-> VKApi($)
else
  window.VKApi = VKApi($)
