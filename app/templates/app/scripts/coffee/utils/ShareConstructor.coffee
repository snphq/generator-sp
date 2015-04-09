define ['jquery', 'underscore'], ($, _)->
  class ShareConstuctor
    _query = (params)->
      _.reduce params, ((memo, v, k)->
        memo+="#{k}=#{v}&"
        memo
      ), ''

    _move = (params, from, to)->
      if params[from]?
        params[to] = params[from]
        delete params[from]
      params

    ###
    @var url
    @var title
    @var description
    @var image
    @var fb_app_id
    @val ok_url
    @val hashtags
    ###
    constructor: (options)->
      @options = {}
      @updateOptions options

    updateOptions: (_opt)->
      opt = _.extend @options, _opt
      host = "#{window.location.protocol}//#{window.location.host}"
      rxHTTP = /^(http|https)(:\/\/|%3A%2F%2F)/
      if opt.url? and not rxHTTP.test opt.url
        opt.url = host + opt.url
      if opt.image? and not rxHTTP.test opt.image
        opt.image = host + opt.image
      if opt.ok_url? and not rxHTTP.test opt.ok_url
        opt.ok_url = host + opt.ok_url

      opt.title = encodeURIComponent opt.title if opt.title?
      opt.description = encodeURIComponent opt.description if opt.description?
      opt.image = encodeURIComponent opt.image if opt.image?
      if opt.ok_url?
        opt.ok_url = opt.ok_url or opt.url or host

    initElement: ($el, soc_type, options={})->
      if( href = this[soc_type]?(options) )
        $el.attr { href, target: '_blank'}

    getOptions: (options)->
      _.extend {}, @options, options

    initLink: ($el, soc_type)->
      options = @getOptions({})
      url = options.ok_url
      comment = options.title
      if( href = this["link_#{soc_type}"]?(url, comment) )
        $el.attr { href, target: '_blank'}

    link_vk: (url, comment)->
      "http://vk.com/share.php?url=#{url}"
    link_fb: (url, comment)->
      "https://www.facebook.com/sharer/sharer.php?u=#{url}"
    link_ok: (url, comment)->
      "http://www.odnoklassniki.ru/dk?st._surl=#{url}&st.cmd=addShare&st.comments=#{comment}"

    vk: (options={})->
      opts = @getOptions(options)
      params = _.pick opts, ['url', 'title', 'description', 'image']
      params.noparse = true
      params.image = decodeURIComponent(params.image)
      params.url = encodeURIComponent(params.url)
      query = _query params
      "http://vk.com/share.php?#{query}"

    fb: (options={})->
      opts = @getOptions(options)
      params = _.pick opts, ['url', 'title', 'description', 'image', 'fb_app_id']
      params.url = encodeURIComponent(params.url) if params.url?
      params.image = decodeURIComponent(params.image) if params.image?
      _move params, 'url', 'link'
      _move params, 'title', 'name'
      _move params, 'image', 'picture'
      _move params, 'fb_app_id', 'app_id'
      params.redirect_uri = 'https://www.facebook.com'
      params.display = 'page'
      query = _query params
      "https://www.facebook.com/dialog/feed?#{query}"
    ok: (options={})->
      opts = @getOptions(options)
      params = _.pick opts, ['ok_url', 'title']

      _move params, 'ok_url', 'st._surl'
      _move params, 'title', 'st.comments'
      params['st.cmd']='addShare'
      query = _query params
      "http://www.odnoklassniki.ru/dk?#{query}"
    tw: (options={})->
      opts = @getOptions(options)
      params = _.pick opts, ['url', 'title', 'hashtags']
      _move params, 'title', 'text'
      if params.text? then params.text += '. ' else params.text = ''
      if opts.description?
        params.text += opts.description
      if params.hashtags?
        params.hashtags = params.hashtags.join(',')
      params.original_referer = params.url
      query = _query params
      "https://twitter.com/intent/tweet?#{query}"
