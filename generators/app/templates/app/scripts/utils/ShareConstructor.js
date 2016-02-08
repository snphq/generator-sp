function is(object) {
  return (typeof object !== 'undefined' && object !== null);
}
export default class ShareConstuctor {
  _query(params) {
    return _.reduce(params, ((memo, v, k) => {
      return `${memo}${k}=${v}&`;
    }), '');
  }
  _move(params, from, to) {
    if (is(params[from])) {
      params[to] = params[from];
      delete params[from];
    }
    return params;
  }
  // options = {
  //  url, //vk, fb, tw
  //  okUrl, //ok
  //  image, //vk, fb
  //  title, //vk, fb, ok, tw
  //  description, //vk, fb
  //  fb_app_id, //fb
  //  hashtags, //tw
  // }
  constructor(options) {
    this.options = {};
    this.updateOptions(options);
  }
  updateOptions(_opt) {
    const opt = _.extend(this.options, _opt);
    const host = `${window.location.protocol}//${window.location.host}`;
    const rxHTTP = /^(http|https)(:\/\/|%3A%2F%2F)/;
    if (is(opt.url) && !rxHTTP.test(opt.url)) {
      opt.url = host + opt.url;
    }
    if (is(opt.image) && !rxHTTP.test(opt.image)) {
      opt.image = host + opt.image;
    }
    if (is(opt.okUrl) && !rxHTTP.test(opt.okUrl)) {
      opt.okUrl = host + opt.okUrl;
    }
    if (is(opt.title)) {
      opt.title = encodeURIComponent(opt.title);
    }
    if (is(opt.description)) {
      opt.description = encodeURIComponent(opt.description);
    }
    if (is(opt.image)) {
      opt.image = encodeURIComponent(opt.image);
    }
    if (is(opt.okUrl)) {
      opt.okUrl = opt.okUrl || opt.url || host;
    }
  }
  // socType = 'vk' / 'fb' / 'ok'
  initElement($el, socType, options = {}) {
    const href = this[socType](options);
    if (is(href)) {
      $el.attr({href, target: '_blank'});
    }
  }

  getOptions(options) {
    return _.extend({}, this.options, options);
  }

  initLink($el, socType) {
    const options = this.getOptions({});
    const url = options.okUrl;
    const comment = options.title;
    socType[0] = socType[0].toUpperCase();
    const href = this[`link${socType}`](url, comment);
    if (is(href)) {
      $el.attr({href, target: '_blank'});
    }
  }

  linkVk(...args) {
    return `http://vk.com/share.php?url=${args[0]}`;
  }
  linkFb(...args) {
    return `https://www.facebook.com/sharer/sharer.php?u=${args[0]}`;
  }
  linkOk(...args) {
    return `http://www.odnoklassniki.ru/dk?st._surl=${args[0]}&st.cmd=addShare&st.comments=${args[1]}`;
  }

  vk(options = {}) {
    const opts = this.getOptions(options);
    const params = _.pick(opts, ['url', 'title', 'description', 'image']);
    params.noparse = true;
    params.image = decodeURIComponent(params.image);
    params.url = encodeURIComponent(params.url);
    const query = this._query(params);
    return `http://vk.com/share.php?${query}`;
  }

  fb(options = {}) {
    const opts = this.getOptions(options);
    const params = _.pick(opts, ['url', 'title', 'description', 'image', 'fb_app_id']);
    if (is(params.url)) {
      params.url = encodeURIComponent(params.url);
    }
    if (is(params.image)) {
      params.image = decodeURIComponent(params.image);
    }
    this._move(params, 'url', 'link');
    this._move(params, 'title', 'name');
    this._move(params, 'image', 'picture');
    this._move(params, 'fb_app_id', 'app_id');
    params.redirectUri = 'https://www.facebook.com';
    params.display = 'page';
    const query = this._query(params);
    return `https://www.facebook.com/dialog/feed?${query}`;
  }
  ok(options = {}) {
    const opts = this.getOptions(options);
    const params = _.pick(opts, ['okUrl', 'title']);

    this._move(params, 'okUrl', 'st._surl');
    this._move(params, 'title', 'st.comments');
    params['st.cmd'] = 'addShare';
    const query = this._query(params);
    return `http://www.odnoklassniki.ru/dk?${query}`;
  }

  tw(options = {}) {
    const opts = this.getOptions(options);
    const params = _.pick(opts, ['url', 'title', 'hashtags']);
    this._move(params, 'title', 'text');
    if (is(params.text)) {
      params.text += `${params.text}. `;
    } else {
      params.text = '';
    }
    if (is(opts.description)) {
      params.text = `${params.text}${opts.description}`;
    }
    if (is(params.hashtags)) {
      params.hashtags = params.hashtags.join(',');
    }
    params.originalReferer = params.url;
    const query = this._query(params);
    return `https://twitter.com/intent/tweet?${query}`;
  }
}
