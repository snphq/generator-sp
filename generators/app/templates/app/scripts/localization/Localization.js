export default class Localization {

  LANG = {};

  get(path, ...args) {
    path = path.split('.');
    let iter = this.LANG;
    for (let i = 0, step; i < path.length; i++) {
      step = path[i];
      if (!(iter = iter[step])) {
        console.error(path);
        return '';
      }
    }
    if (_.isFunction(iter)) {
      return iter(...args);
    }
    return iter;
  }
}
