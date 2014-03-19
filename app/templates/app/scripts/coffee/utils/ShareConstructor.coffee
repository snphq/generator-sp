define ["jquery","underscore"],($,_)->
  class ShareConstuctor
    _query = (params)->
      _.reduce params,((memo,v,k)->
        memo+="#{k}=#{v}&"
        memo
      ),""

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
    constructor:(options)->
      @options = {}
      @updateOptions options

    updateOptions:(opt)->
      host = "#{window.location.protocol}//#{window.location.host}"
      if opt.url? and not /^(http:\/\/|https:\/\/)/.test opt.url
        opt.url = host + opt.url
      if opt.image? and not /^(http:\/\/|https:\/\/)/.test opt.image
        opt.image = host + opt.image
      if opt.ok_url? and not /^(http:\/\/|https:\/\/)/.test opt.ok_url
        opt.ok_url = host + opt.ok_url

      opt.title = encodeURIComponent opt.title if opt.title?
      opt.description = encodeURIComponent opt.description if opt.description?
      opt.image = encodeURIComponent opt.image if opt.image?
      if opt.ok_url?
        opt.ok_url = encodeURIComponent (opt.ok_url or opt.url or host)
      _.extend @options, opt

    initElement:($el,soc_type)->
      if( href = this[soc_type]?() )
        $el.attr { href, target:"_blank"}

    vk:->
      params = _.pick @options, ["url","title","description","image"]
      params.noparse = true
      query = _query params
      "http://vk.com/share.php?#{query}"

    fb:->
      params = _.pick @options, ["url","title","description","image","fb_app_id"]
      _move params, "url", "link"
      _move params, "title", "name"
      _move params, "image", "picture"
      _move params, "fb_app_id", "app_id"
      params.redirect_uri = "https://www.facebook.com"
      params.display = "page"
      query = _query params
      "https://www.facebook.com/dialog/feed?#{query}"
    ok:->
      params = _.pick @options, ["ok_url"]
      _move params, "ok_url", "st._surl"
      params["st.cmd"]="addShare"
      query = _query params
      "http://www.odnoklassniki.ru/dk?#{query}"
    tw:->
      params = _.pick @options, ["url","title","description","hashtags"]
      _move params, "title", "text"
      if params.text? then params.text += " | " else params.text = ""
      if @options.description?
        params.text += @options.description
      if params.hashtags?
        params.hashtags = params.hashtags.join(",")
      params.original_referer = params.url
      query = _query params
      "https://twitter.com/intent/tweet?#{query}"
