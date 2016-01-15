window.PREPROCESS = {}

# DEBUG PREPROCESS
###
// @ifdef DEBUG
###
window.PREPROCESS = {
  mode: 'debug'
  GA: 'UA-XXXXX-X'
  social:
    fb: appID: 0
    vk: appID: 0
    ok:
      appID: 0
      appKey: 'CBAHGDCOABABABABA'
}
###
// @endif
###


# DIST PREPROCESS
###
// @ifdef DIST
###
window.PREPROCESS = {
  mode: 'testing'
  GA: 'UA-XXXXX-X'
  social:
    fb: appID: 0
    vk: appID: 0
    ok:
      appID: 0
      appKey: 'CBAHGDCOABABABABA'
}
###
// @endif
###


# PROD PREPROCESS
###
// @ifdef PROD
###
window.PREPROCESS = {
  mode: 'production'
  GA: 'UA-XXXXX-X'
  social:
    fb: appID: 0
    vk: appID: 0
    ok:
      appID: 0
      appKey: 'CBAHGDCOABABABABA'
}
###
// @endif
###

