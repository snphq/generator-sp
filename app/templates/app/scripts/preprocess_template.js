window.PREPROCESS = {};

// @ifdef DEBUG
window.PREPROCESS = {
  mode: 'debug'
};
// @endif

// @ifdef DIST
window.PREPROCESS = {
  mode: 'testing'
};
// @endif


// @ifdef PROD
window.PREPROCESS = {
  mode: 'production'
};
// @endif
