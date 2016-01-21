let settings;

if (BUILD_MODE === 'DEBUG') {
  settings = {
    mode: 'debug',
    GA: 'UA-XXXXX-X',
    social: {
      fb: {appID: 0},
      vk: {appID: 0},
      ok: {
        appID: 0,
        appKey: 'CBAHGDCOABABABABA'
      }
    }
  };
}

if (BUILD_MODE === 'DIST') {
  settings = {
    mode: 'testing',
    GA: 'UA-XXXXX-X',
    social: {
      fb: {appID: 0},
      vk: {appID: 0},
      ok: {
        appID: 0,
        appKey: 'CBAHGDCOABABABABA'
      }
    }
  };
}

if (BUILD_MODE === 'PROD') {
  settings = {
    mode: 'production',
    GA: 'UA-XXXXX-X',
    social: {
      fb: {appID: 0},
      vk: {appID: 0},
      ok: {
        appID: 0,
        appKey: 'CBAHGDCOABABABABA'
      }
    }
  };
}

export default settings;
