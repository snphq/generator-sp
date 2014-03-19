define [
  "jquery"
  "underscore"
  "localization/ru"
  "preprocess"
],($, _, Localization, preprocess)->
  urlparams = _.reduce location.search.slice(1,location.search.length).split("&"),((memo,item)->
      pair = item.split("=")
      if pair.length is 2
        memo[pair[0]] = pair[1]
      memo
    ),{}

  share=($el,type,server,text,image, ga_attr_name="", options={})->
    title = description = text = encodeURIComponent(text)
    app_id_fb  = preprocess.social?.fb?.appID
    host = "#{window.location.protocol}//#{window.location.host}"
    server = server.replace /#/g,"%23"
    href = if type is "vk"
      "http://vk.com/share.php?url=#{server}&image=#{image}&title=#{title}&noparse=true"
    else if type is "fb"
      "https://www.facebook.com/dialog/feed?link=#{server}&redirect_uri=https://www.facebook.com&app_id=#{app_id_fb}&picture=#{image}&name=#{title}"
    else if type is "ok"
      image = encodeURIComponent(image)
      url_redirect = encodeURIComponent(options.ok_url or host)
      "http://www.odnoklassniki.ru/dk?st.cmd=addShare&st._surl=#{url_redirect}"
    else if type is "tw"
      "https://twitter.com/intent/tweet?text=#{text}&url=#{server}&original_referer=#{server}"
    else
      ""
    $el.attr {href}
    if !!ga_attr_name
      options.type = type
      if JSON?
        $el.attr ga_attr_name, JSON.stringify(options)

  window.common = common = {
    app:null
    router:null
    urlparams:urlparams
    images: null
    async:-> $.Deferred()
    api:null
    sapi:null
    user:null
    share:share
    localization: new Localization
  }
  if window.PRELOADER?
    common.images = new window.PRELOADER

  common
