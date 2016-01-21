
import Localization from './localization/ru';
import sblocks from 'simple-blocks';

const urlparams = _.reduce(location.search.slice(1, location.search.length).split('&'), ((memo, item) => {
  const pair = item.split('=');
  if (pair.length === 2) {
    memo[pair[0]] = pair[1];
  }
  return memo;
}
), {}
);

window.common = {
  app: null,
  router: null,
  urlparams,
  // ImagePreloader
  images: null,
  async() {
    /* eslint new-cap: 0*/
    return $.Deferred();
  },
  // ServerApi
  api: null,
  // SocialApi
  sapi: null,
  // UserModel
  user: null,
  // Google Analitics
  ga: null,
  localization: new Localization(),
  sblocks: sblocks()
};

export default window.common;
