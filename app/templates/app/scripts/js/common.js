define(["jquery", "underscore", "preprocess","packages/social"], function($, _, preprocess,social) {
  var common, share, urlparams;
  urlparams = _.reduce(location.search.slice(1, location.search.length).split("&"), (function(memo, item) {
    var pair;
    pair = item.split("=");
    if (pair.length === 2) {
      memo[pair[0]] = pair[1];
    }
    return memo;
  }), {});
  share = function($el, type, server, text, image, ga_attr_name, options) {
    var app_id_fb, description, host, href, title, url_redirect, _ref, _ref1;
    if (ga_attr_name == null) {
      ga_attr_name = "";
    }
    if (options == null) {
      options = {};
    }
    title = description = text = encodeURIComponent(text);
    app_id_fb = (_ref = preprocess.social) != null ? (_ref1 = _ref.fb) != null ? _ref1.appID : void 0 : void 0;
    host = "" + window.location.protocol + "//" + window.location.host;
    server = server.replace(/#/g, "%23");
    href = type === "vk" ? "http://vk.com/share.php?url=" + server + "&image=" + image + "&title=" + title + "&noparse=true" : type === "fb" ? "https://www.facebook.com/dialog/feed?link=" + server + "&redirect_uri=https://www.facebook.com&app_id=" + app_id_fb + "&picture=" + image + "&name=" + title : type === "ok" ? (image = encodeURIComponent(image), url_redirect = encodeURIComponent(options.ok_url || host), "http://www.odnoklassniki.ru/dk?st.cmd=addShare&st._surl=" + url_redirect) : type === "tw" ? "https://twitter.com/intent/tweet?text=" + text + "&url=" + server + "&original_referer=" + server : "";
    $el.attr({
      href: href
    });
    if (!!ga_attr_name) {
      options.type = type;
      if (typeof JSON !== "undefined" && JSON !== null) {
        return $el.attr(ga_attr_name, JSON.stringify(options));
      }
    }
  };
  window.common = common = {
    app: null,
    router: null,
    urlparams: urlparams,
    images: null,
    async: function() {
      return $.Deferred();
    },
    share: share
  };
  if (window.PRELOADER != null) {
    common.images = new window.PRELOADER;
  }
  return common;
});
