// npm i swfobject --save
import swfobject from 'swfobject';

export default class SWFConstructor {
  constructor(options = {}) {
    this.flashvars = options.flashvars || {};
    this.swfVersionStr = options.swfVersionStr || '11.3';
    this.params = _.defaults(options.params || {}, {
      quality: 'high',
      bgcolor: '#000000',
      play: 'true',
      loop: 'true',
      wmode: 'opaque',
      scale: 'noScale',
      menu: 'false',
      devicefont: 'false',
      salign: '',
      allowscriptaccess: 'always',
      allownetworking: 'all',
      allowFullscreen: 'true',
      allowScriptAccess: 'always',
    });
    this.attributes = _.defaults(options.attributes || {});
    this.xiSwfUrlStr = options.xiSwfUrlStr || '';
    swfobject.switchOffAutoHideShow();
  }
  initYoutube($el, youid, width, height, callback = () => {}) {
    const url = `http://www.youtube.com/v/${youid}?enablejsapi=1` +
          '&version=3&playerapiid=ytplayer&showinfo=0' +
          '&rel=0&autohide=1&loop=1&wmode=opaque&autoplay=1';
    return this.init($el, url, width, height, callback);
  }

  init($el, url, width, height, callback = () => {}) {
    const unique = new Date().getUTCMilliseconds();
    const id = `swf_${unique}`;
    $el.attr({id});
    const attributes = _.defaults(this.attributes, {id, name: id, align: id});
    swfobject.embedSWF(
      url,
      id,
      width,
      height,
      this.swfVersionStr,
      this.xiSwfUrlStr,
      this.flashvars,
      this.params,
      attributes,
      callback
    );
  }
}
