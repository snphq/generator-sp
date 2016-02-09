import $ from 'jquery';

if (Modernizr.touchevents) {
  const CLASSNAME = 'touchHover';
  const DATANAME = 'notouch';
  const touchstart = e => {
    $(e.target).addClass(CLASSNAME);
  };

  const touchmove = e => {
    $(e.target).removeClass(CLASSNAME).data(DATANAME, true);
  };

  const wrapTouchend = method => {
    return e => {
      const $el = $(e.target);
      $el.removeClass(CLASSNAME);
      if ($el.data(DATANAME)) {
        $el.removeData(DATANAME);
      } else {
        Reflect.apply(method, this, arguments);
      }
    };
  };

  const rxClick = /click/g;
  const add = $.event.add;
  $.event.add = (elem, types, handler, data, selector) => {
    if (types.indexOf('click') < 0) {
      Reflect.apply(add, this, [elem, types, handler, data, selector]);
    } else {
      const t = {
        touchstart: types.replace(rxClick, 'touchstart'),
        touchmove: types.replace(rxClick, 'touchmove'),
        touchend: types.replace(rxClick, 'touchend'),
      };
      Reflect.apply(add, this, [elem, t.touchstart, touchstart, data, selector]);
      Reflect.apply(add, this, [elem, t.touchmove, touchmove, data, selector]);
      Reflect.apply(add, this, [elem, t.touchend, wrapTouchend(handler), data, selector]);
    }
  };

  const remove = $.event.remove;
  $.event.remove = (elem, types, handler, selector, mappedTypes) => {
    if (types.indexOf('click') < 0) {
      Reflect.apply(remove, this, [elem, types, handler, selector, mappedTypes]);
    } else {
      const t = {
        touchstart: types.replace(rxClick, 'touchstart'),
        touchmove: types.replace(rxClick, 'touchmove'),
        touchend: types.replace(rxClick, 'touchend'),
      };
      Reflect.apply(remove, [this, elem, t.touchstart, handler, selector, mappedTypes]);
      Reflect.apply(remove, [this, elem, t.touchmove, handler, selector, mappedTypes]);
      Reflect.apply(remove, [this, elem, t.touchend, handler, selector, mappedTypes]);
    }
  };
}
export default $;
