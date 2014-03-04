window.PREPROCESS = {}
# DEBUG PREPROCESS
###
// @ifdef DEBUG
###
window.PREPROCESS = {
  mode:"debug"
  GA:"UA-XXXXX-X"
}
###
// @endif
###


# DIST PREPROCESS
###
// @ifdef DIST
###
window.PREPROCESS = {
  mode:"testing"
  GA:"UA-XXXXX-X"
}
###
// @endif
###


# PROD PREPROCESS
###
// @ifdef PROD
###
window.PREPROCESS = {
  mode:"production"
  GA:"UA-XXXXX-X"
}
###
// @endif
###

