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

  window.common = common = {
    app:null  #Application
    router:null #Router
    urlparams:urlparams
    images: null #ImagePreloader
    async:-> $.Deferred()
    api:null #ServerApi
    sapi:null #SocialApi
    user:null #UserModel
    ga:null #Google Analitics
    localization: new Localization
  }
  if window.PRELOADER?
    common.images = new window.PRELOADER

  common
