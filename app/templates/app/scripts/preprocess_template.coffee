window.PREPROCESS = {}
# DEBUG PREPROCESS
###
// @ifdef DEBUG
###
window.PREPROCESS = {
  mode:"debug"
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
}
###
// @endif
###

