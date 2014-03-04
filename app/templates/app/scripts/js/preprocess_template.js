window.PREPROCESS = {};

// @ifdef DEBUG
window.PREPROCESS = {
  mode: 'debug',
  GA:'UA-XXXXX-X'
};
// @endif

// @ifdef DIST
window.PREPROCESS = {
  mode: 'testing',
  GA:'UA-XXXXX-X'
};
// @endif


// @ifdef PROD
window.PREPROCESS = {
  mode: 'production',
  GA:'UA-XXXXX-X'
};
// @endif
